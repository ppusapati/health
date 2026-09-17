package escalation

import (
	"context"
	"fmt"
	"log/slog"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// Channel delivers a notice to one recipient.
//
// The seam. Wave 2 has exactly one implementation — the in-platform task inbox
// — and outbound channels arrive with SRS-PAT-ENG in Wave 5. A channel that
// cannot deliver returns an error; it must never return nil for a message it
// did not send, because the whole mechanism is built on the difference.
type Channel interface {
	// Name identifies the channel in the delivery record.
	Name() string
	// Deliver tells one recipient about one notice.
	Deliver(ctx context.Context, notice Notice, to Recipient) error
}

// Roster resolves a duty role to the people on it now (SRS-FAC-012).
//
// "Critical incident can resolve active escalation recipients" is a statement
// about time: the answer at three in the morning is not the answer at noon, so
// a matrix stores the role and this resolves it at the moment of escalation.
type Roster interface {
	// OnDuty returns the users holding a role at a facility. An empty result
	// is not an error — it is a rota with a hole in it, which the driver
	// records as a failed delivery so the chain moves on rather than stalling.
	OnDuty(ctx context.Context, scope authctx.TenantScope, role, facilityID string) (
		[]string, error)
}

// Policies supplies the timing for a tenant and kind.
type Policies interface {
	Policy(ctx context.Context, scope authctx.TenantScope, kind string) (Policy, error)
}

// StaticPolicies answers with one policy for everything.
type StaticPolicies struct{ P Policy }

// Policy implements Policies.
func (s StaticPolicies) Policy(context.Context, authctx.TenantScope, string) (Policy, error) {
	if s.P.After <= 0 {
		return DefaultPolicy(), nil
	}
	return s.P, nil
}

// DriverReportInterval throttles the repeated-failure log, as the outbox
// publisher does: a channel that is down produces one failure per notice per
// sweep, and an unthrottled log turns an outage into a second outage.
const DriverReportInterval = 30 * time.Second

// Driver advances due escalations.
//
// This is what makes SRS-OPSNFR-003's acceptance criterion true. The notice is
// a row; the driver is stateless; a restart loses a sweep in progress and
// nothing else, because the next sweep reads the same rows and the escalation
// arithmetic is a function of `last_escalated_at` rather than of anything the
// process was holding.
type Driver struct {
	tx       *pgtx.Manager
	store    *Store
	channels []Channel
	roster   Roster
	policies Policies
	now      func() time.Time
	log      *slog.Logger

	// Failure reporting state, local to one driver.
	failingSince time.Time
	failures     int
	reportedErr  string
	reportedAt   time.Time
}

// DriverOptions configures a driver.
type DriverOptions struct {
	Transactions *pgtx.Manager
	Store        *Store
	// Channels are tried in order until one delivers. Ordered rather than all
	// at once: telling a registrar twice through two channels is how an
	// escalation becomes something people mute.
	Channels []Channel
	Roster   Roster
	Policies Policies
	Now      func() time.Time
	Logger   *slog.Logger
}

// NewDriver constructs a driver.
func NewDriver(opts DriverOptions) (*Driver, error) {
	if opts.Transactions == nil || opts.Store == nil {
		return nil, fmt.Errorf("%w: a driver needs transactions and a store", ErrInvalidNotice)
	}
	if len(opts.Channels) == 0 {
		return nil, fmt.Errorf("%w: a driver with no channel delivers nothing", ErrInvalidNotice)
	}
	if opts.Policies == nil {
		opts.Policies = StaticPolicies{P: DefaultPolicy()}
	}
	if opts.Now == nil {
		opts.Now = time.Now
	}
	if opts.Logger == nil {
		opts.Logger = slog.Default()
	}
	return &Driver{
		tx: opts.Transactions, store: opts.Store, channels: opts.Channels,
		roster: opts.Roster, policies: opts.Policies, now: opts.Now, log: opts.Logger,
	}, nil
}

// Deliver sends a freshly raised notice to its level-zero rung.
//
// Called after the raising transaction commits, for the reason the outbox
// exists: a consultant woken for a transaction that then rolled back is a
// consultant who stops answering.
func (d *Driver) Deliver(ctx context.Context, scope authctx.TenantScope, notice Notice) error {
	matrix, err := d.store.Matrix(ctx, scope, notice.Subject.FacilityID, notice.Subject.Kind)
	if err != nil {
		return err
	}
	recipients, level, ok := matrix.At(notice.Level)
	if !ok {
		return fmt.Errorf("%w: level %d is past the top rung", ErrInvalidMatrix, notice.Level)
	}
	return d.deliverTo(ctx, scope, notice, recipients, level)
}

// Sweep advances every notice that is due.
//
// Returns how many escalated. Each notice is handled in its own transaction:
// one whose channel throws must not roll back the others, and a sweep that
// took a single transaction over a hundred notices would hold locks for as
// long as the slowest channel.
func (d *Driver) Sweep(ctx context.Context, limit int) (int, error) {
	now := d.now()

	var claimed []Claimed
	err := d.tx.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		// Everything pending is a candidate; the policy decides. The cheap
		// SQL-side filter is `last_escalated_at <= now`, which cannot be
		// wrong in the dangerous direction — it over-selects and the
		// arithmetic below discards.
		claimed, err = d.store.ClaimDue(ctx, now, limit)
		return err
	})
	if err != nil {
		return 0, err
	}

	escalated := 0
	for _, item := range claimed {
		notice := item.Notice
		// The sweep has no caller. See authctx.SystemScope: this grants the
		// tenant scope the row already names, never permission, and
		// everything it reaches is a mechanism rather than a clinical
		// decision.
		scope := authctx.SystemScope(notice.TenantID)

		// A notice nobody has ever been told about is delivered at its
		// current rung rather than escalated past it. This is the window
		// between the raising transaction committing and the delivery that
		// follows it: a process that dies in there must not cost the first
		// notification, which is the thing SRS-OPSNFR-003 is about.
		if !item.Delivered {
			if err := d.Deliver(ctx, scope, notice); err != nil {
				d.report(err)
			}
			continue
		}

		policy, err := d.policies.Policy(ctx, scope, notice.Subject.Kind)
		if err != nil {
			d.report(err)
			continue
		}
		if !notice.Due(policy, now) {
			continue
		}
		if err := d.escalateOne(ctx, scope, notice, policy, now); err != nil {
			d.report(err)
			continue
		}
		escalated++
	}

	if escalated > 0 || len(claimed) > 0 {
		d.recovered()
	}
	return escalated, nil
}

func (d *Driver) escalateOne(ctx context.Context, scope authctx.TenantScope, notice Notice,
	policy Policy, now time.Time) error {

	matrix, err := d.store.Matrix(ctx, scope, notice.Subject.FacilityID, notice.Subject.Kind)
	if err != nil {
		return err
	}

	recipients, level, err := notice.Escalate(matrix, policy, now)
	if err != nil {
		return err
	}

	// An exhausted chain still has to be written back, or the driver picks it
	// up again on the next sweep and every sweep after that.
	if err := d.tx.WithinTx(ctx, func(ctx context.Context) error {
		return d.store.Save(ctx, scope, notice)
	}); err != nil {
		return err
	}
	if len(recipients) == 0 {
		d.log.WarnContext(ctx, "escalation chain exhausted",
			"notice_id", notice.ID, "kind", notice.Subject.Kind, "level", notice.Level)
		return nil
	}
	return d.deliverTo(ctx, scope, notice, recipients, level)
}

// deliverTo resolves and delivers one rung, recording every attempt.
func (d *Driver) deliverTo(ctx context.Context, scope authctx.TenantScope, notice Notice,
	recipients []Recipient, level int) error {

	for _, recipient := range recipients {
		for _, resolved := range d.resolve(ctx, scope, recipient) {
			d.attempt(ctx, notice, resolved, level)
		}
	}
	return nil
}

// resolve turns a rung's recipient into the people to tell now.
//
// A role with nobody on duty resolves to the role itself with no user, which
// the attempt below records as a failed delivery. That is deliberate: a rota
// with a hole in it must show up in the record as a rung that reached nobody,
// not as a rung that was skipped.
func (d *Driver) resolve(ctx context.Context, scope authctx.TenantScope,
	recipient Recipient) []Recipient {

	if recipient.Named() || d.roster == nil {
		return []Recipient{recipient}
	}
	users, err := d.roster.OnDuty(ctx, scope, recipient.Role, recipient.FacilityID)
	if err != nil || len(users) == 0 {
		return []Recipient{recipient}
	}
	out := make([]Recipient, 0, len(users))
	for _, user := range users {
		out = append(out, Recipient{UserID: user, FacilityID: recipient.FacilityID})
	}
	return out
}

// attempt tries each channel in turn and records what happened.
func (d *Driver) attempt(ctx context.Context, notice Notice, to Recipient, level int) {
	now := d.now()

	if !to.Named() {
		d.record(ctx, notice, Delivery{
			Level: level, Recipient: to, At: now, Channel: "none",
			Err: fmt.Sprintf("no user on duty for role %q", to.Role),
		})
		return
	}

	var lastErr error
	for _, channel := range d.channels {
		err := channel.Deliver(ctx, notice, to)
		delivery := Delivery{
			Level: level, Recipient: to, At: now, Channel: channel.Name(),
		}
		if err != nil {
			delivery.Err = err.Error()
			lastErr = err
		}
		d.record(ctx, notice, delivery)
		if err == nil {
			return
		}
	}
	if lastErr != nil {
		d.report(lastErr)
	}
}

func (d *Driver) record(ctx context.Context, notice Notice, delivery Delivery) {
	if err := d.tx.WithinTx(ctx, func(ctx context.Context) error {
		return d.store.RecordDelivery(ctx, notice.ID, delivery)
	}); err != nil {
		// A delivery that happened and was not recorded is worse than one that
		// did not happen, because the next sweep cannot tell.
		d.log.ErrorContext(ctx, "escalation delivery not recorded",
			"notice_id", notice.ID, "error", err.Error())
	}
}

// report logs the first failure, then throttles repeats of the same message.
//
// The pattern the outbox publisher settled on after the same lesson: a channel
// that is down produces one failure per notice per sweep, and a line per
// failure buries the incident in its own logs.
func (d *Driver) report(err error) {
	now := d.now()
	d.failures++
	if d.failingSince.IsZero() {
		d.failingSince = now
	}

	message := err.Error()
	changed := message != d.reportedErr
	if !changed && now.Sub(d.reportedAt) < DriverReportInterval {
		return
	}

	d.log.Error("escalation driver failing",
		"error", message,
		"failures", d.failures,
		"failing_for", now.Sub(d.failingSince).String())
	d.reportedErr = message
	d.reportedAt = now
}

func (d *Driver) recovered() {
	if d.failures == 0 {
		return
	}
	d.log.Info("escalation driver recovered",
		"failures", d.failures, "failing_for", d.now().Sub(d.failingSince).String())
	d.failures = 0
	d.failingSince = time.Time{}
	d.reportedErr = ""
	d.reportedAt = time.Time{}
}

// DefaultSweepInterval is how often the driver looks for work.
//
// Ten seconds against a fifteen-minute escalation interval: the sweep is not
// what decides when a notice escalates, only how promptly the decision is
// acted on. Making it much longer adds latency to every rung; making it much
// shorter buys nothing, because the interval that matters is the policy's.
const DefaultSweepInterval = 10 * time.Second

// Run sweeps until the context is cancelled.
//
// Returns the context's error on a clean shutdown, so a caller can tell "we
// were asked to stop" from "the driver died". It never returns on a sweep
// failure: a database blip must not take escalation down for the rest of the
// process's life, and the failure is reported through the throttled log
// instead.
func (d *Driver) Run(ctx context.Context, interval time.Duration) error {
	if interval <= 0 {
		interval = DefaultSweepInterval
	}
	ticker := time.NewTicker(interval)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
			if _, err := d.Sweep(ctx, 0); err != nil {
				d.report(err)
			}
		}
	}
}
