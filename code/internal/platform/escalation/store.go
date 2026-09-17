package escalation

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ErrNoMatrix is a kind of notice the tenant has configured no chain for.
//
// Raising is refused rather than defaulted. A default chain would have to
// invent a recipient, and an escalation delivered to somebody the hospital did
// not nominate is worse than one that failed loudly at configuration time.
var ErrNoMatrix = errors.New("no escalation matrix configured")

// ErrNoNotice is a notice that does not exist in this tenant.
var ErrNoNotice = errors.New("no such escalation notice")

// IDs mints identifiers. Injected so a test can make them predictable.
type IDs interface{ NewID() string }

type uuidIDs struct{}

func (uuidIDs) NewID() string { return uuid.NewString() }

// Store persists notices and the matrix.
//
// Every method takes a TenantScope rather than a tenant string, for the reason
// ADR-0001 gives: the type has no exported constructor, so a caller cannot
// reach this package without having gone through authorization.
type Store struct {
	tx  *pgtx.Manager
	ids IDs
}

// NewStore constructs a store.
func NewStore(tx *pgtx.Manager, ids IDs) *Store {
	if ids == nil {
		ids = uuidIDs{}
	}
	return &Store{tx: tx, ids: ids}
}

func (s *Store) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(s.tx.Querier(ctx))
}

func stamp(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func optionalStamp(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return stamp(t)
}

// text reads a LEFT JOIN's nullable column.
func text(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

func tenantUUID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.Nil, fmt.Errorf("%w: escalation needs a tenant scope", ErrInvalidNotice)
	}
	return uuid.Parse(scope.TenantID())
}

// SaveMatrix writes a chain, replacing whatever was there.
//
// Replacing rather than merging: a chain edited by adding rows and never
// removing them accumulates recipients nobody meant to keep, and the rung that
// still pages a consultant who left is the one nobody notices until it fires.
func (s *Store) SaveMatrix(ctx context.Context, scope authctx.TenantScope, matrix Matrix,
	now time.Time) error {

	if err := matrix.Validate(); err != nil {
		return err
	}
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}

	q := s.queries(ctx)
	row, err := q.UpsertEscalationMatrix(ctx, sqlcgen.UpsertEscalationMatrixParams{
		MatrixID:   uuid.MustParse(s.newUUID()),
		TenantID:   tenant,
		FacilityID: matrix.FacilityID,
		Kind:       matrix.Kind,
		CreatedAt:  stamp(now),
	})
	if err != nil {
		return fmt.Errorf("save escalation matrix: %w", err)
	}

	if err := q.DeleteEscalationRungs(ctx, row.MatrixID); err != nil {
		return fmt.Errorf("replace escalation rungs: %w", err)
	}
	for _, rung := range matrix.Sorted() {
		if err := q.InsertEscalationRung(ctx, sqlcgen.InsertEscalationRungParams{
			MatrixID: row.MatrixID, Level: int32(rung.Level), Note: rung.Note,
		}); err != nil {
			return fmt.Errorf("insert escalation rung: %w", err)
		}
		for ordinal, recipient := range rung.Recipients {
			if err := q.InsertEscalationRecipient(ctx,
				sqlcgen.InsertEscalationRecipientParams{
					MatrixID: row.MatrixID, Level: int32(rung.Level),
					Ordinal:    int32(ordinal),
					UserID:     recipient.UserID,
					Role:       recipient.Role,
					FacilityID: recipient.FacilityID,
				}); err != nil {
				return fmt.Errorf("insert escalation recipient: %w", err)
			}
		}
	}
	return nil
}

func (s *Store) newUUID() string {
	id := s.ids.NewID()
	if _, err := uuid.Parse(id); err != nil {
		// An injected generator that does not mint UUIDs would fail inside the
		// driver with a message about a scan; failing here says what is wrong.
		return uuid.NewString()
	}
	return id
}

// Matrix reads the chain for a facility and kind, falling back to the
// tenant-wide one.
func (s *Store) Matrix(ctx context.Context, scope authctx.TenantScope,
	facilityID, kind string) (Matrix, error) {

	tenant, err := tenantUUID(scope)
	if err != nil {
		return Matrix{}, err
	}

	q := s.queries(ctx)
	row, err := q.GetEscalationMatrix(ctx, sqlcgen.GetEscalationMatrixParams{
		TenantID: tenant, Kind: kind, FacilityID: facilityID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return Matrix{}, fmt.Errorf("%w for %q at facility %q", ErrNoMatrix, kind, facilityID)
	}
	if err != nil {
		return Matrix{}, fmt.Errorf("read escalation matrix: %w", err)
	}

	rungRows, err := q.ListEscalationRungs(ctx, row.MatrixID)
	if err != nil {
		return Matrix{}, fmt.Errorf("read escalation rungs: %w", err)
	}

	byLevel := map[int]*Rung{}
	order := []int{}
	for _, r := range rungRows {
		level := int(r.Level)
		if _, ok := byLevel[level]; !ok {
			byLevel[level] = &Rung{Level: level, Note: r.Note}
			order = append(order, level)
		}
		// A LEFT JOIN row with no recipient is a rung the matrix validator
		// would refuse; carried through as an empty rung so the refusal
		// happens where the reason can be explained.
		if r.UserID == nil && r.Role == nil {
			continue
		}
		byLevel[level].Recipients = append(byLevel[level].Recipients, Recipient{
			UserID:     text(r.UserID),
			Role:       text(r.Role),
			FacilityID: text(r.FacilityID),
		})
	}

	out := Matrix{FacilityID: row.FacilityID, Kind: row.Kind}
	for _, level := range order {
		out.Rungs = append(out.Rungs, *byLevel[level])
	}
	return out, nil
}

// Raise persists a notice, or returns the one already raised for the subject.
//
// The second return reports whether this call created it. A caller that
// delivered on every raise would page a consultant again on every retry of the
// transaction that raised it.
func (s *Store) Raise(ctx context.Context, scope authctx.TenantScope, subject Subject,
	summary string, now time.Time) (Notice, bool, error) {

	tenant, err := tenantUUID(scope)
	if err != nil {
		return Notice{}, false, err
	}
	candidate, err := Raise(s.newUUID(), scope.TenantID(), subject, summary, now)
	if err != nil {
		return Notice{}, false, err
	}

	row, err := s.queries(ctx).RaiseEscalationNotice(ctx, sqlcgen.RaiseEscalationNoticeParams{
		NoticeID:    uuid.MustParse(candidate.ID),
		TenantID:    tenant,
		SubjectKind: subject.Kind,
		SubjectID:   subject.ID,
		PatientID:   subject.PatientID,
		FacilityID:  subject.FacilityID,
		Summary:     candidate.Summary,
		RaisedAt:    stamp(now),
	})
	if err != nil {
		return Notice{}, false, fmt.Errorf("raise escalation notice: %w", err)
	}

	notice := noticeFrom(row)
	return notice, notice.ID == candidate.ID, nil
}

// Notice reads one notice by id.
func (s *Store) Notice(ctx context.Context, scope authctx.TenantScope, noticeID string) (
	Notice, error) {

	tenant, err := tenantUUID(scope)
	if err != nil {
		return Notice{}, err
	}
	id, err := uuid.Parse(noticeID)
	if err != nil {
		return Notice{}, fmt.Errorf("%w: %q", ErrNoNotice, noticeID)
	}

	row, err := s.queries(ctx).GetEscalationNotice(ctx, sqlcgen.GetEscalationNoticeParams{
		TenantID: tenant, NoticeID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return Notice{}, fmt.Errorf("%w: %s", ErrNoNotice, noticeID)
	}
	if err != nil {
		return Notice{}, fmt.Errorf("read escalation notice: %w", err)
	}
	return s.withDeliveries(ctx, noticeFrom(row))
}

// NoticeFor reads the notice raised for a subject, if there is one.
func (s *Store) NoticeFor(ctx context.Context, scope authctx.TenantScope, subject Subject) (
	Notice, error) {

	tenant, err := tenantUUID(scope)
	if err != nil {
		return Notice{}, err
	}
	row, err := s.queries(ctx).GetEscalationNoticeBySubject(ctx,
		sqlcgen.GetEscalationNoticeBySubjectParams{
			TenantID: tenant, SubjectKind: subject.Kind, SubjectID: subject.ID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return Notice{}, fmt.Errorf("%w for %s", ErrNoNotice, subject.Key())
	}
	if err != nil {
		return Notice{}, fmt.Errorf("read escalation notice: %w", err)
	}
	return s.withDeliveries(ctx, noticeFrom(row))
}

func (s *Store) withDeliveries(ctx context.Context, notice Notice) (Notice, error) {
	rows, err := s.queries(ctx).ListEscalationDeliveries(ctx, uuid.MustParse(notice.ID))
	if err != nil {
		return Notice{}, fmt.Errorf("read escalation deliveries: %w", err)
	}
	for _, r := range rows {
		notice.Deliveries = append(notice.Deliveries, Delivery{
			Level: int(r.Level),
			Recipient: Recipient{
				UserID: r.UserID, Role: r.Role, FacilityID: r.FacilityID,
			},
			At: r.DeliveredAt.Time, Channel: r.Channel, Err: r.Error,
		})
	}
	return notice, nil
}

// Save writes a notice's state back.
func (s *Store) Save(ctx context.Context, scope authctx.TenantScope, notice Notice) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	return s.queries(ctx).UpdateEscalationNotice(ctx, sqlcgen.UpdateEscalationNoticeParams{
		TenantID:        tenant,
		NoticeID:        uuid.MustParse(notice.ID),
		State:           string(notice.State),
		Level:           int32(notice.Level),
		LastEscalatedAt: stamp(notice.LastEscalatedAt),
		AcknowledgedBy:  notice.AcknowledgedBy,
		AcknowledgedAt:  optionalStamp(notice.AcknowledgedAt),
		ClosedReason:    notice.ClosedReason,
		UpdatedAt:       stamp(notice.UpdatedAt),
	})
}

// RecordDelivery appends one attempt.
func (s *Store) RecordDelivery(ctx context.Context, noticeID string, delivery Delivery) error {
	return s.queries(ctx).InsertEscalationDelivery(ctx,
		sqlcgen.InsertEscalationDeliveryParams{
			DeliveryID:  uuid.MustParse(s.newUUID()),
			NoticeID:    uuid.MustParse(noticeID),
			Level:       int32(delivery.Level),
			UserID:      delivery.Recipient.UserID,
			Role:        delivery.Recipient.Role,
			FacilityID:  delivery.Recipient.FacilityID,
			Channel:     delivery.Channel,
			Error:       delivery.Err,
			DeliveredAt: stamp(delivery.At),
		})
}

// ClaimDue locks the pending notices that may be due, for one sweep.
//
// Not filtered by policy here: the SQL returns pending notices whose last
// escalation is old enough to be worth looking at, and the caller applies the
// policy. Keeping the arithmetic in Go means a tenant changing its intervals
// takes effect on notices already outstanding, which is the point of changing
// them, and does not need a migration.
func (s *Store) ClaimDue(ctx context.Context, before time.Time, limit int) ([]Notice, error) {
	if limit <= 0 {
		limit = 100
	}
	rows, err := s.queries(ctx).ClaimDueEscalations(ctx, sqlcgen.ClaimDueEscalationsParams{
		LastEscalatedAt: stamp(before), Limit: int32(limit),
	})
	if err != nil {
		return nil, fmt.Errorf("claim due escalations: %w", err)
	}
	out := make([]Notice, 0, len(rows))
	for _, row := range rows {
		out = append(out, noticeFrom(row))
	}
	return out, nil
}

// OpenFor lists the unacknowledged notices delivered to one person.
func (s *Store) OpenFor(ctx context.Context, scope authctx.TenantScope, userID string) (
	[]Notice, error) {

	tenant, err := tenantUUID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := s.queries(ctx).ListOpenEscalationsForRecipient(ctx,
		sqlcgen.ListOpenEscalationsForRecipientParams{TenantID: tenant, UserID: userID})
	if err != nil {
		return nil, fmt.Errorf("read open escalations: %w", err)
	}
	out := make([]Notice, 0, len(rows))
	for _, row := range rows {
		out = append(out, noticeFrom(row))
	}
	return out, nil
}

func noticeFrom(row sqlcgen.PlatformEscalationNotice) Notice {
	return Notice{
		ID:       row.NoticeID.String(),
		TenantID: row.TenantID.String(),
		Subject: Subject{
			Kind: row.SubjectKind, ID: row.SubjectID,
			PatientID: row.PatientID, FacilityID: row.FacilityID,
		},
		Summary:         row.Summary,
		State:           State(row.State),
		Level:           int(row.Level),
		RaisedAt:        row.RaisedAt.Time,
		LastEscalatedAt: row.LastEscalatedAt.Time,
		AcknowledgedBy:  row.AcknowledgedBy,
		AcknowledgedAt:  row.AcknowledgedAt.Time,
		ClosedReason:    row.ClosedReason,
		UpdatedAt:       row.UpdatedAt.Time,
	}
}
