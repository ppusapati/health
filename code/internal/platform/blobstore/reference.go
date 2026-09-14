package blobstore

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"strings"
)

// Class names a kind of stored content.
//
// The unit of configuration. A deployment routes by class because the classes
// differ in exactly the ways that decide where bytes belong: how large they
// are, how often they are read, how long they are kept, and whether losing the
// object store would take the clinical record with it. It is not a MIME type
// and not a module name — "clinical attachment" covers a scanned referral and
// a photographed discharge summary alike, and both want the same answer.
type Class string

// The classes this system stores. Adding one means deciding where it goes by
// default, which is the point: a class that nobody routed falls back to the
// default backend visibly rather than being invented at a call site.
const (
	// ClassPatientPhoto is the identification photograph on the patient index
	// (SRS-EMPI-010).
	ClassPatientPhoto Class = "patient-photo"
	// ClassClinicalAttachment is a document attached to a clinical note —
	// scanned referrals, outside reports, consent forms (SRS-CLN-014).
	ClassClinicalAttachment Class = "clinical-attachment"
	// ClassWoundImage is a wound photograph in a nursing assessment
	// (SRS-NUR-012).
	ClassWoundImage Class = "wound-image"
	// ClassSignature is a captured handwritten signature — kilobytes, read
	// beside the record it signs, and worthless if it is not restored with it.
	ClassSignature Class = "signature"
)

// Classes lists every known class, in the order configuration documents them.
func Classes() []Class {
	return []Class{ClassPatientPhoto, ClassClinicalAttachment, ClassWoundImage, ClassSignature}
}

// Known reports whether c is a class this package routes.
func (c Class) Known() bool {
	for _, known := range Classes() {
		if c == known {
			return true
		}
	}
	return false
}

// referenceSeparator splits the backend name from the backend's own key.
//
// A colon rather than a slash so the backend name never becomes a path segment
// inside the bucket: the object layout in S3 is tenant/class/id and stays that
// way whether the backend is called "primary" or "mumbai".
const referenceSeparator = ":"

// Reference is what a record stores: enough to find the bytes again and to
// know whether they are still the bytes that were written.
//
// Callers treat it as opaque and round-trip it through their own tables as a
// string. It is deliberately not a patient identifier, a filename or anything
// else that would be a disclosure in a log line — the identifier segment is
// random, so a reference that leaks reveals nothing but its own existence.
type Reference struct {
	// Backend is the configured name of the backend holding the object.
	Backend string
	// TenantID is the first path segment, so a bucket policy can grant access
	// per tenant prefix — defence in depth behind the application's own
	// scoping, and the thing that makes a misconfigured client fail rather
	// than read somebody else's records.
	TenantID string
	Class    Class
	// ObjectID is 128 random bits. Unguessable, because a key that could be
	// enumerated would let anybody who can reach the store walk every
	// photograph in it, and derived from nothing, because a key computed from
	// the patient would leak the patient in every log line carrying it.
	ObjectID string
	// Digest is the hex SHA-256 of the content as written.
	Digest string
}

// newReference mints a reference for content about to be written.
func newReference(backend, tenantID string, class Class, content []byte) (Reference, error) {
	var raw [16]byte
	if _, err := rand.Read(raw[:]); err != nil {
		return Reference{}, fmt.Errorf("blobstore: generating an object id: %w", err)
	}
	return Reference{
		Backend:  backend,
		TenantID: tenantID,
		Class:    class,
		ObjectID: hex.EncodeToString(raw[:]),
		Digest:   Digest(content),
	}, nil
}

// String renders the reference for storage in a record.
func (r Reference) String() string {
	return r.Backend + referenceSeparator + r.BackendKey()
}

// BackendKey is the key the backend sees — the reference without the routing
// prefix.
func (r Reference) BackendKey() string {
	return r.TenantID + "/" + string(r.Class) + "/" + r.ObjectID + "/" + r.Digest
}

// ParseReference reads a reference back.
//
// Strict, because everything downstream of it is a lookup in a store: a
// reference is either exactly the five parts this package writes or it is not
// a reference, and a lenient parse here is what turns a corrupted row into a
// path traversal. Note in particular that no segment may contain a path
// element — "." and ".." are rejected outright rather than cleaned, since a
// cleaned path that still resolves is the bug, not the input.
func ParseReference(s string) (Reference, error) {
	backend, rest, found := strings.Cut(s, referenceSeparator)
	if !found {
		return Reference{}, fmt.Errorf("%w: %q names no backend", ErrInvalidObject, s)
	}
	parts := strings.Split(rest, "/")
	if len(parts) != 4 {
		return Reference{}, fmt.Errorf("%w: %q is not a blob reference", ErrInvalidObject, s)
	}
	ref := Reference{
		Backend:  backend,
		TenantID: parts[0],
		Class:    Class(parts[1]),
		ObjectID: parts[2],
		Digest:   parts[3],
	}
	for _, segment := range []string{ref.Backend, ref.TenantID, string(ref.Class), ref.ObjectID, ref.Digest} {
		if segment == "" || segment == "." || segment == ".." || strings.ContainsAny(segment, `/\`) {
			return Reference{}, fmt.Errorf("%w: %q has an unusable segment", ErrInvalidObject, s)
		}
	}
	if len(ref.Digest) != 64 || !isHex(ref.Digest) {
		// Without a digest in the reference there is nothing to verify a read
		// against, which is the one guarantee this package exists to make.
		return Reference{}, fmt.Errorf("%w: %q carries no sha256 digest", ErrInvalidObject, s)
	}
	if !isHex(ref.ObjectID) {
		return Reference{}, fmt.Errorf("%w: %q has a non-hex object id", ErrInvalidObject, s)
	}
	return ref, nil
}

func isHex(s string) bool {
	for i := 0; i < len(s); i++ {
		c := s[i]
		if (c < '0' || c > '9') && (c < 'a' || c > 'f') {
			return false
		}
	}
	return len(s) > 0
}
