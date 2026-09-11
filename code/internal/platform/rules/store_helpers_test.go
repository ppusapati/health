package rules_test

import (
	"context"
	"encoding/json"
)

// The tamper test needs raw SQL, which is the point: it simulates a change no
// application path permits.

func jsonMarshal(v any) ([]byte, error) { return json.Marshal(v) }

func (f storeFixture) exec(ctx context.Context, sql string, args ...any) (int64, error) {
	tag, err := f.pool.Exec(ctx, sql, args...)
	if err != nil {
		return 0, err
	}
	return tag.RowsAffected(), nil
}
