package escalation

import (
	"context"
	"fmt"
	"strings"
)

// TaskInbox delivers a notice to a clinician's task list inside the platform.
//
// The only channel Wave 2 has, and a real one rather than a placeholder: the
// delivery row the driver writes is the inbox entry, and
// Store.OpenFor reads it back. There is no queue in between and nothing to go
// wrong after this returns, which is why it can honestly report success.
//
// What it cannot do is reach somebody who is not looking at a screen. That is
// the gap outbound channels close, and it is why the escalation chain exists:
// a rung that nobody read escalates to a rung somebody might.
type TaskInbox struct{}

// Name implements Channel.
func (TaskInbox) Name() string { return "task" }

// Deliver implements Channel.
func (TaskInbox) Deliver(_ context.Context, notice Notice, to Recipient) error {
	if strings.TrimSpace(to.UserID) == "" {
		// The driver resolves roles before it gets here, so an unnamed
		// recipient at this point is a rota with nobody on it.
		return fmt.Errorf("no user to place the task against")
	}
	if strings.TrimSpace(notice.Summary) == "" {
		return fmt.Errorf("a task with no summary is a row with a timestamp")
	}
	return nil
}

// Unavailable is a channel a deployment has configured and this build cannot
// serve.
//
// It refuses every delivery, loudly and by name. The alternative — omitting the
// channel from the driver — would let a hospital configure SMS escalation for
// its ICU, see no errors, and discover at an incident review that nothing was
// ever sent. A channel that is not built must fail, not be absent.
//
// Outbound channels arrive with SRS-PAT-ENG in Wave 5.
type Unavailable struct {
	// Channel is the name the deployment configured — "sms", "pager".
	Channel string
	// Owner names where the implementation is coming from, so the error says
	// what to do rather than only what went wrong.
	Owner string
}

// Name implements Channel.
func (u Unavailable) Name() string {
	if strings.TrimSpace(u.Channel) == "" {
		return "unavailable"
	}
	return u.Channel
}

// Deliver implements Channel.
func (u Unavailable) Deliver(context.Context, Notice, Recipient) error {
	owner := u.Owner
	if strings.TrimSpace(owner) == "" {
		owner = "a later wave"
	}
	return fmt.Errorf(
		"the %q escalation channel is configured but not implemented in this build; "+
			"it arrives with %s", u.Name(), owner)
}
