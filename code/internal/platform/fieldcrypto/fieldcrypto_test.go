package fieldcrypto_test

import (
	"errors"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/fieldcrypto"
)

// stubKeys stands in for KMS. Fixed keys, so a test failure is about the
// cipher's behaviour rather than about key derivation.
type stubKeys struct {
	current string
	keys    map[string][]byte
}

func newKeys() *stubKeys {
	return &stubKeys{
		current: "k1",
		keys: map[string][]byte{
			"k1": []byte("0123456789abcdef0123456789abcdef"),
			"k2": []byte("fedcba9876543210fedcba9876543210"),
		},
	}
}

func (s *stubKeys) CurrentKeyID() string { return s.current }
func (s *stubKeys) DataKey(id string) ([]byte, error) {
	key, ok := s.keys[id]
	if !ok {
		return nil, errors.New("no such key")
	}
	return key, nil
}

func TestRoundTrip(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	const tenant = "tenant-a"
	const value = "ABCDE1234F"

	sealed, err := c.Encrypt(tenant, value)
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}
	if strings.Contains(sealed, value) {
		t.Fatalf("the plaintext is visible in the stored value: %s", sealed)
	}
	if !fieldcrypto.Encrypted(sealed) {
		t.Fatal("the stored value carries no envelope prefix")
	}

	got, err := c.Decrypt(tenant, sealed)
	if err != nil {
		t.Fatalf("Decrypt: %v", err)
	}
	if got != value {
		t.Fatalf("round trip returned %q, want %q", got, value)
	}
}

// Encrypting the same value twice must produce different ciphertext, or the
// database learns which rows share a value — which for a national identifier
// is most of what an attacker wanted.
func TestEncryptionIsNotDeterministic(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	first, err := c.Encrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}
	second, err := c.Encrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}
	if first == second {
		t.Fatal("the same plaintext produced identical ciphertext; equal rows are now linkable")
	}
}

// The tenant is authenticated data, so lifting a ciphertext into another
// tenant's row fails rather than silently decrypting.
func TestCiphertextIsBoundToItsTenant(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	sealed, err := c.Encrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}
	if _, err := c.Decrypt("tenant-b", sealed); !errors.Is(err, fieldcrypto.ErrInvalidCiphertext) {
		t.Fatalf("another tenant decrypted the value: %v", err)
	}
}

// An operator with database write access can flip bits. GCM's authentication
// is what stops the application decrypting the result and acting on it.
func TestTamperingIsDetected(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	sealed, err := c.Encrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}

	// Corrupt a character in the middle of the encoded body. Not the last one:
	// unpadded base64 carries unused trailing bits, so flipping the final
	// character can decode to the identical bytes — the same ciphertext, not a
	// modified one, and the test would pass or fail depending on the nonce.
	body := strings.LastIndex(sealed, ":") + 1
	corrupted := []byte(sealed)
	middle := body + (len(sealed)-body)/2
	if corrupted[middle] == 'A' {
		corrupted[middle] = 'B'
	} else {
		corrupted[middle] = 'A'
	}
	if _, err := c.Decrypt("tenant-a", string(corrupted)); !errors.Is(err, fieldcrypto.ErrInvalidCiphertext) {
		t.Fatalf("a modified ciphertext decrypted: %v", err)
	}

	for _, bad := range []string{
		"enc:v1:",                // no key id
		"enc:v1:k1:",             // no body
		"enc:v1:k1:not-base64!!", // undecodable
		"enc:v1:k1:c2hvcnQ",      // shorter than a nonce
	} {
		if _, err := c.Decrypt("tenant-a", bad); !errors.Is(err, fieldcrypto.ErrInvalidCiphertext) {
			t.Errorf("Decrypt(%q) returned %v, want ErrInvalidCiphertext", bad, err)
		}
	}
}

// Rotation: new writes use the new key, old rows keep decrypting under theirs.
// Without this, rotating a key would mean rewriting every row in one
// transaction, which nobody does and so keys never rotate.
func TestRotationLeavesOldValuesReadable(t *testing.T) {
	keys := newKeys()
	c := fieldcrypto.New(keys)

	old, err := c.Encrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}
	if id, _ := fieldcrypto.KeyIDOf(old); id != "k1" {
		t.Fatalf("stored under %s, want k1", id)
	}

	keys.current = "k2"
	fresh, err := c.Encrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Encrypt after rotation: %v", err)
	}
	if id, _ := fieldcrypto.KeyIDOf(fresh); id != "k2" {
		t.Fatalf("new write stored under %s, want k2", id)
	}

	// The pre-rotation row still opens.
	got, err := c.Decrypt("tenant-a", old)
	if err != nil {
		t.Fatalf("Decrypt of a pre-rotation value: %v", err)
	}
	if got != "ABCDE1234F" {
		t.Fatalf("got %q", got)
	}
}

// During the expand phase a column holds both plaintext and ciphertext. A
// reader that could not tell them apart would return base64 noise as if it
// were a national identifier.
func TestPlaintextPassesThroughDuringMigration(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	got, err := c.Decrypt("tenant-a", "ABCDE1234F")
	if err != nil {
		t.Fatalf("Decrypt: %v", err)
	}
	if got != "ABCDE1234F" {
		t.Fatalf("a legacy plaintext value came back as %q", got)
	}
	if fieldcrypto.Encrypted("ABCDE1234F") {
		t.Fatal("a plaintext value was reported as encrypted")
	}
}

func TestEmptyValuesAreNotEncrypted(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	sealed, err := c.Encrypt("tenant-a", "")
	if err != nil {
		t.Fatalf("Encrypt: %v", err)
	}
	if sealed != "" {
		t.Fatalf("an empty value produced %q", sealed)
	}
}

func TestMissingKeyIsReportedDistinctly(t *testing.T) {
	c := fieldcrypto.New(newKeys())
	// A value written under a key that is no longer available — a deleted KMS
	// key, say. That is an operational problem, not a tampering one, and the
	// two need different responses.
	if _, err := c.Decrypt("tenant-a", "enc:v1:k9:AAAAAAAAAAAAAAAAAAAAAAAA"); !errors.Is(err, fieldcrypto.ErrKeyUnavailable) {
		t.Fatalf("want ErrKeyUnavailable, got %v", err)
	}
}

func TestMasking(t *testing.T) {
	cases := []struct {
		name string
		got  string
		want string
	}{
		{"tail", fieldcrypto.MaskTail("ABCDE1234F", 4), "••••••234F"},
		{"tail shorter than n", fieldcrypto.MaskTail("AB", 4), "••"},
		{"tail n zero", fieldcrypto.MaskTail("ABCDE", 0), "•••••"},
		{"email", fieldcrypto.MaskEmail("priya@hospital.example"), "p••••@hospital.example"},
		{"not an email", fieldcrypto.MaskEmail("priya"), "•••••"},
		{"name", fieldcrypto.MaskName("Priya Ramaswamy"), "P•••• R••••••••"},
		{"redact", fieldcrypto.Redact("anything"), "[redacted]"},
		{"redact empty", fieldcrypto.Redact(""), ""},
	}
	for _, tc := range cases {
		if tc.got != tc.want {
			t.Errorf("%s: got %q, want %q", tc.name, tc.got, tc.want)
		}
	}
}

// Masking counts runes, not bytes. A byte slice through a multi-byte character
// produces mojibake and a mask whose length leaks the encoding.
func TestMaskingIsRuneSafe(t *testing.T) {
	const value = "राजेश1234"
	masked := fieldcrypto.MaskTail(value, 4)
	if !strings.HasSuffix(masked, "1234") {
		t.Fatalf("MaskTail lost the visible tail: %q", masked)
	}
	if strings.Contains(masked, "�") {
		t.Fatalf("MaskTail produced a replacement character: %q", masked)
	}
	if strings.Contains(masked, "राजेश") {
		t.Fatalf("MaskTail revealed the masked portion: %q", masked)
	}
}

// A short value must not be revealed just because it is short.
func TestShortValuesAreFullyMasked(t *testing.T) {
	if got := fieldcrypto.MaskTail("123", 4); strings.Contains(got, "1") {
		t.Fatalf("a short value was returned unmasked: %q", got)
	}
}
