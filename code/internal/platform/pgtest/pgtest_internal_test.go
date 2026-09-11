package pgtest

import "testing"

func TestReplaceDatabase(t *testing.T) {
	cases := []struct {
		in, db, want string
	}{
		{"postgres://u:p@host:5432/postgres", "ht_1", "postgres://u:p@host:5432/ht_1"},
		{"postgres://u:p@host:5432/postgres?sslmode=disable", "ht_1", "postgres://u:p@host:5432/ht_1?sslmode=disable"},
		{"postgres://host/db", "ht_2", "postgres://host/ht_2"},
	}
	for _, c := range cases {
		if got := replaceDatabase(c.in, c.db); got != c.want {
			t.Errorf("replaceDatabase(%q) = %q, want %q", c.in, got, c.want)
		}
	}
}

// Database names must stay inside PostgreSQL's 63-byte identifier limit even
// for deeply nested subtest names.
func TestUniqueDatabaseNameIsBoundedAndSafe(t *testing.T) {
	t.Run("a/very/long/subtest name with spaces and CAPS and more padding here", func(t *testing.T) {
		name := uniqueDatabaseName(t)
		if len(name) >= 63 {
			t.Fatalf("name %q is %d bytes, too long for an identifier", name, len(name))
		}
		for _, r := range name {
			if !(r >= 'a' && r <= 'z') && !(r >= '0' && r <= '9') && r != '_' {
				t.Fatalf("unsafe character %q in %q", r, name)
			}
		}
	})
}

func TestUniqueDatabaseNamesDiffer(t *testing.T) {
	if uniqueDatabaseName(t) == uniqueDatabaseName(t) {
		t.Fatal("consecutive names collided")
	}
}
