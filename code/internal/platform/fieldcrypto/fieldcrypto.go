// Package fieldcrypto encrypts individual column values.
//
// SRS-DAT-012: "sensitive fields support encryption/masking strategy where the
// threat model requires", verified by an authorised application being able to
// use the data while database and operator exposure is minimised.
//
// Storage-level encryption (SRS-DAT-002) protects a stolen disk or a leaked
// backup. It does not protect against the threat the Wave-0 threat model names
// under TM-0011: an operator with a database session sees plaintext, because
// the storage layer decrypts for anyone the database lets in. Field-level
// encryption moves the boundary — the ciphertext is opaque to the database, so
// a SELECT returns bytes that mean nothing without the key, which lives in KMS
// and is reached only by the application.
//
// What that costs, stated plainly because it decides where this is used: an
// encrypted column cannot be indexed, matched with LIKE, sorted, or joined.
// Apply it to values that are read by primary key and never searched — a
// national identifier, a bank account, a contact detail — and not to a name
// somebody has to look a patient up by.
package fieldcrypto

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"strings"
)

// Errors returned by this package.
var (
	// ErrInvalidCiphertext reports a value that cannot be decrypted. It does
	// not distinguish "wrong key" from "tampered with" from "truncated": a
	// caller can do nothing different about each, and an attacker probing for
	// the difference learns something from a more specific answer.
	ErrInvalidCiphertext = errors.New("fieldcrypto: value could not be decrypted")
	// ErrKeyUnavailable reports a key the provider could not supply.
	ErrKeyUnavailable = errors.New("fieldcrypto: data key unavailable")
)

// envelopePrefix tags a stored value so a reader can tell ciphertext from a
// legacy plaintext value during the migration window. Encrypting a column is an
// expand/contract change: new writes are encrypted while old rows are not yet,
// and a reader that cannot tell them apart either breaks or, worse, returns
// base64 noise as if it were a national identifier.
const envelopePrefix = "enc:v1:"

// KeyProvider supplies data keys. The interface is deliberately narrow so the
// KMS client stays outside this package and outside its tests.
type KeyProvider interface {
	// DataKey returns the 32-byte key for a key id. Implementations are
	// expected to cache: a KMS round trip per row would make encryption a
	// latency decision rather than a security one.
	DataKey(keyID string) ([]byte, error)
	// CurrentKeyID names the key new values should be written under. It
	// changes when keys rotate; old values keep decrypting under the key id
	// stored alongside them.
	CurrentKeyID() string
}

// Cipher encrypts and decrypts individual values.
type Cipher struct {
	keys KeyProvider
}

// New constructs a Cipher over a key provider.
func New(keys KeyProvider) *Cipher { return &Cipher{keys: keys} }

// Encrypt seals a value for storage.
//
// The stored form is "enc:v1:<keyID>:<base64(nonce||ciphertext)>". The key id
// travels with the value rather than being configured globally, which is what
// makes rotation possible without rewriting every row at once: a new key
// encrypts new writes while old rows still decrypt under theirs.
//
// The tenant id is bound in as additional authenticated data. Moving a
// ciphertext from one tenant's row to another's then fails to decrypt rather
// than silently succeeding, so a database-level row copy cannot smuggle a value
// across the tenant boundary.
func (c *Cipher) Encrypt(tenantID, plaintext string) (string, error) {
	if plaintext == "" {
		// An empty value carries no information and encrypting it would only
		// make "field absent" distinguishable from "field empty" by length.
		return "", nil
	}

	keyID := c.keys.CurrentKeyID()
	aead, err := c.aead(keyID)
	if err != nil {
		return "", err
	}

	nonce := make([]byte, aead.NonceSize())
	if _, err := rand.Read(nonce); err != nil {
		return "", fmt.Errorf("fieldcrypto: nonce: %w", err)
	}

	sealed := aead.Seal(nonce, nonce, []byte(plaintext), []byte(tenantID))
	return envelopePrefix + keyID + ":" + base64.RawStdEncoding.EncodeToString(sealed), nil
}

// Decrypt opens a stored value.
//
// A value with no envelope prefix is returned unchanged. That is required
// during the migration window, when a column holds both forms; it also means a
// caller cannot tell from the return type whether a value was protected, which
// is why Encrypted exists for code that needs to know.
func (c *Cipher) Decrypt(tenantID, stored string) (string, error) {
	if stored == "" {
		return "", nil
	}
	if !Encrypted(stored) {
		return stored, nil
	}

	rest := strings.TrimPrefix(stored, envelopePrefix)
	keyID, encoded, found := strings.Cut(rest, ":")
	if !found || keyID == "" {
		return "", ErrInvalidCiphertext
	}

	aead, err := c.aead(keyID)
	if err != nil {
		return "", err
	}

	sealed, err := base64.RawStdEncoding.DecodeString(encoded)
	if err != nil {
		return "", ErrInvalidCiphertext
	}
	if len(sealed) < aead.NonceSize() {
		return "", ErrInvalidCiphertext
	}

	nonce, body := sealed[:aead.NonceSize()], sealed[aead.NonceSize():]
	plaintext, err := aead.Open(nil, nonce, body, []byte(tenantID))
	if err != nil {
		return "", ErrInvalidCiphertext
	}
	return string(plaintext), nil
}

// Encrypted reports whether a stored value is in envelope form.
func Encrypted(stored string) bool { return strings.HasPrefix(stored, envelopePrefix) }

// KeyIDOf returns the key a stored value was encrypted under, so a rotation job
// can find rows still on an old key without decrypting them.
func KeyIDOf(stored string) (string, bool) {
	if !Encrypted(stored) {
		return "", false
	}
	keyID, _, found := strings.Cut(strings.TrimPrefix(stored, envelopePrefix), ":")
	if !found || keyID == "" {
		return "", false
	}
	return keyID, true
}

func (c *Cipher) aead(keyID string) (cipher.AEAD, error) {
	key, err := c.keys.DataKey(keyID)
	if err != nil {
		return nil, fmt.Errorf("%w: %s", ErrKeyUnavailable, keyID)
	}
	if len(key) != 32 {
		return nil, fmt.Errorf("%w: %s is %d bytes, want 32", ErrKeyUnavailable, keyID, len(key))
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrKeyUnavailable, err)
	}
	// GCM rather than CBC: authentication is not optional here. An operator who
	// can write to the database can flip bits in an unauthenticated ciphertext,
	// and the application would decrypt the result and act on it.
	return cipher.NewGCM(block)
}
