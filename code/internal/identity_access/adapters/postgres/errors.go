package postgres

import (
	"errors"

	"github.com/jackc/pgx/v5/pgconn"
)

// uniqueViolation is the SQLSTATE for a unique index rejection. Several
// indexes in this schema are controls rather than optimisations — one
// federation per issuer above all — so their rejection has to be translated
// into a specific error rather than surfacing as "database error".
const uniqueViolation = "23505"

func isUniqueViolation(err error) bool {
	var pgErr *pgconn.PgError
	return errors.As(err, &pgErr) && pgErr.Code == uniqueViolation
}
