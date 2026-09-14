package blobstore

import (
	"context"
	"errors"
	"fmt"
	"sort"
	"strings"

	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// ClassPolicy is what configuration says about one content class.
type ClassPolicy struct {
	// Backend names the backend this class is written to. Empty takes the
	// configured default.
	Backend string
	// MaxBytes refuses content larger than this. Zero takes the class default
	// from defaultPolicy — never "unlimited", because the bytes arrive from a
	// ward tablet over a network and an unbounded upload is a denial of
	// service with a clinical excuse.
	MaxBytes int64
	// ContentTypes is the allowlist. Empty takes the class default. An
	// allowlist rather than a denylist: the interesting content types are the
	// ones nobody thought of.
	ContentTypes []string
}

// Config is the whole of this package's deployment configuration.
type Config struct {
	// DefaultBackend answers for any class configuration does not route.
	DefaultBackend string
	// Classes routes per content class.
	Classes map[Class]ClassPolicy
	// TenantBackends pins a tenant's objects to a named backend whatever the
	// class says.
	//
	// This exists for data residency, and residency wins: a tenant whose
	// contract says its records stay in one jurisdiction cannot have one class
	// of them quietly written somewhere else because a class default changed.
	TenantBackends map[string]string
}

// Object is what Put hands back for the record to store.
type Object struct {
	// Reference is the opaque string the owning record keeps.
	Reference   string
	Class       Class
	ContentType string
	SizeBytes   int64
	// Digest is the hex SHA-256, also carried inside the reference. Returned
	// separately because most owning tables already have a digest column and
	// a reader with the digest to hand can check it without parsing.
	Digest string
	// KMSKeyAlias records which managed key encrypted the object, or "" for a
	// backend that does not encrypt at rest (SRS-SEC-002).
	KMSKeyAlias string
}

// Limiter is an optional Backend capability: a hard ceiling on object size.
//
// Declared rather than discovered so a misconfiguration is a boot failure. A
// class routed to a backend that cannot hold objects of that class's size is
// not a runtime surprise for whoever uploads the first large one.
type Limiter interface {
	MaxBytes() int64
}

// Vault routes content to backends and is what application code holds.
type Vault struct {
	cfg      Config
	backends map[string]Backend
}

// defaultPolicy is the built-in answer for a class configuration says nothing
// about beyond which backend to use.
//
// Sizes are deliberately per class rather than one global limit. A signature is
// kilobytes and a two-megabyte one is a bug or an attack; an outside hospital's
// scanned discharge summary is legitimately several megabytes and refusing it
// means the clinician keeps the paper.
func defaultPolicy(c Class) ClassPolicy {
	switch c {
	case ClassPatientPhoto:
		return ClassPolicy{
			MaxBytes:     2 << 20,
			ContentTypes: []string{"image/jpeg", "image/png", "image/webp"},
		}
	case ClassWoundImage:
		return ClassPolicy{
			MaxBytes:     8 << 20,
			ContentTypes: []string{"image/jpeg", "image/png", "image/webp"},
		}
	case ClassClinicalAttachment:
		return ClassPolicy{
			MaxBytes: 8 << 20,
			ContentTypes: []string{
				"application/pdf", "image/jpeg", "image/png", "image/tiff",
				"text/plain",
			},
		}
	case ClassSignature:
		// 64 KiB, matching what the inline Postgres backend accepts. A
		// handwritten signature is comfortably inside it, and the alignment is
		// deliberate: this is the one class whose whole reason for existing is
		// that it can live beside the record it signs, and a default that did
		// not fit there would make the intended configuration fail to start.
		return ClassPolicy{
			MaxBytes:     64 << 10,
			ContentTypes: []string{"image/png", "image/svg+xml"},
		}
	default:
		return ClassPolicy{}
	}
}

// NewVault validates the configuration against the backends it was given.
//
// Every check here is one a deployment would otherwise fail at the first
// upload — at which point the failure is a clinician who cannot photograph a
// wound, reported as an application bug, hours after the configuration change
// that caused it. Failing to start is a much cheaper way to learn the same
// thing.
func NewVault(cfg Config, backends ...Backend) (*Vault, error) {
	byName := make(map[string]Backend, len(backends))
	for _, b := range backends {
		if b == nil {
			return nil, errors.New("blobstore: a nil backend was configured")
		}
		name := b.Name()
		if strings.TrimSpace(name) == "" {
			return nil, errors.New("blobstore: a backend must have a name")
		}
		if strings.Contains(name, referenceSeparator) || strings.ContainsAny(name, `/\`) {
			// The name goes into every reference. One containing a separator
			// would produce references that parse back into something else.
			return nil, fmt.Errorf("blobstore: backend name %q may not contain %q, %q or %q",
				name, referenceSeparator, "/", `\`)
		}
		if _, clash := byName[name]; clash {
			return nil, fmt.Errorf("blobstore: two backends are both named %q", name)
		}
		byName[name] = b
	}
	if len(byName) == 0 {
		return nil, errors.New("blobstore: at least one backend is required")
	}

	if strings.TrimSpace(cfg.DefaultBackend) == "" {
		if len(byName) != 1 {
			return nil, errors.New("blobstore: more than one backend is configured, " +
				"so a default backend must be named")
		}
		for name := range byName {
			cfg.DefaultBackend = name
		}
	}
	if _, ok := byName[cfg.DefaultBackend]; !ok {
		return nil, fmt.Errorf("blobstore: default backend %q is not configured", cfg.DefaultBackend)
	}

	for class, policy := range cfg.Classes {
		if !class.Known() {
			return nil, fmt.Errorf("blobstore: %q is not a content class", class)
		}
		if policy.Backend != "" {
			if _, ok := byName[policy.Backend]; !ok {
				return nil, fmt.Errorf("blobstore: class %q routes to backend %q, which is not configured",
					class, policy.Backend)
			}
		}
	}
	for tenantID, name := range cfg.TenantBackends {
		if strings.TrimSpace(tenantID) == "" {
			return nil, errors.New("blobstore: a tenant override needs a tenant id")
		}
		if _, ok := byName[name]; !ok {
			return nil, fmt.Errorf("blobstore: tenant %q is pinned to backend %q, which is not configured",
				tenantID, name)
		}
	}

	v := &Vault{cfg: cfg, backends: byName}

	// Every route a class can take, checked against what the backend on the
	// far end will actually accept. The tenant overrides are part of this: a
	// tenant pinned to the small-object backend is exactly the case where an
	// eight-megabyte attachment stops working and nobody connects it to the
	// residency setting somebody added last month.
	for _, class := range Classes() {
		limit := v.policy(class).MaxBytes
		routes := map[string]bool{v.classBackend(class): true}
		for _, name := range cfg.TenantBackends {
			routes[name] = true
		}
		for name := range routes {
			limiter, ok := byName[name].(Limiter)
			if !ok {
				continue
			}
			if max := limiter.MaxBytes(); max > 0 && max < limit {
				return nil, fmt.Errorf(
					"blobstore: class %q allows %d bytes but backend %q accepts at most %d; "+
						"lower the class limit or route the class elsewhere",
					class, limit, name, max)
			}
		}
	}
	return v, nil
}

// policy returns the effective policy for a class.
func (v *Vault) policy(c Class) ClassPolicy {
	configured := v.cfg.Classes[c]
	fallback := defaultPolicy(c)
	if configured.MaxBytes <= 0 {
		configured.MaxBytes = fallback.MaxBytes
	}
	if len(configured.ContentTypes) == 0 {
		configured.ContentTypes = fallback.ContentTypes
	}
	return configured
}

// classBackend is where a class goes absent a tenant override.
func (v *Vault) classBackend(c Class) string {
	if name := v.cfg.Classes[c].Backend; name != "" {
		return name
	}
	return v.cfg.DefaultBackend
}

// Route reports which backend would hold new content of this class for this
// tenant.
//
// Exported because "where do this hospital's wound photographs go" is a
// question an operator asks during an incident, and answering it by reading
// four environment variables and this file's precedence rules is how the wrong
// answer gets acted on.
func (v *Vault) Route(scope authctx.TenantScope, class Class) (string, error) {
	tenantID, err := tenantOf(scope)
	if err != nil {
		return "", err
	}
	if name, pinned := v.cfg.TenantBackends[tenantID]; pinned {
		return name, nil
	}
	return v.classBackend(class), nil
}

// Put stores content and returns the reference the record should keep.
func (v *Vault) Put(ctx context.Context, scope authctx.TenantScope, class Class,
	contentType string, content []byte) (Object, error) {

	if err := ctx.Err(); err != nil {
		return Object{}, err
	}
	tenantID, err := tenantOf(scope)
	if err != nil {
		return Object{}, err
	}
	if !class.Known() {
		return Object{}, fmt.Errorf("%w: %q is not a content class", ErrInvalidObject, class)
	}
	if len(content) == 0 {
		return Object{}, fmt.Errorf("%w: there is nothing to store", ErrInvalidObject)
	}

	policy := v.policy(class)
	contentType = normaliseContentType(contentType)
	if !allowed(policy.ContentTypes, contentType) {
		return Object{}, fmt.Errorf("%w: %q is not a content type the %q class accepts",
			ErrUnsupportedContentType, contentType, class)
	}
	if int64(len(content)) > policy.MaxBytes {
		return Object{}, fmt.Errorf("%w: %d bytes exceeds the %d the %q class accepts",
			ErrTooLarge, len(content), policy.MaxBytes, class)
	}

	name, err := v.Route(scope, class)
	if err != nil {
		return Object{}, err
	}
	backend, ok := v.backends[name]
	if !ok {
		return Object{}, fmt.Errorf("%w: %q", ErrNoBackend, name)
	}
	if limiter, ok := backend.(Limiter); ok {
		if max := limiter.MaxBytes(); max > 0 && int64(len(content)) > max {
			return Object{}, fmt.Errorf("%w: %d bytes exceeds the %d backend %q accepts",
				ErrTooLarge, len(content), max, name)
		}
	}

	ref, err := newReference(name, tenantID, class, content)
	if err != nil {
		return Object{}, err
	}
	if err := backend.Put(ctx, ref.BackendKey(), contentType, content); err != nil {
		return Object{}, err
	}
	return Object{
		Reference:   ref.String(),
		Class:       class,
		ContentType: contentType,
		SizeBytes:   int64(len(content)),
		Digest:      ref.Digest,
		KMSKeyAlias: backend.KMSKeyAlias(),
	}, nil
}

// Get reads content back and checks it against the digest in the reference.
//
// A digest mismatch is returned as an error with no bytes. That is the whole
// point of carrying the digest in the reference: a caller cannot accidentally
// use content the store returned but cannot vouch for, because it never gets
// hold of it.
func (v *Vault) Get(ctx context.Context, scope authctx.TenantScope, reference string) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	ref, backend, err := v.resolve(scope, reference)
	if err != nil {
		return nil, err
	}
	content, err := backend.Get(ctx, ref.BackendKey())
	if err != nil {
		return nil, err
	}
	if got := Digest(content); got != ref.Digest {
		return nil, fmt.Errorf("%w: reference records %s, store returned %s",
			ErrDigestMismatch, ref.Digest, got)
	}
	return content, nil
}

// Delete removes the content.
//
// Idempotent, because the callers are consent withdrawals and rejected
// uploads: one that failed because the object was already gone would leave a
// withdrawal that can never be completed.
func (v *Vault) Delete(ctx context.Context, scope authctx.TenantScope, reference string) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	ref, backend, err := v.resolve(scope, reference)
	if err != nil {
		return err
	}
	return backend.Delete(ctx, ref.BackendKey())
}

// resolve parses a reference, checks it belongs to the caller's tenant and
// finds the backend that holds it.
//
// The backend comes from the reference rather than from configuration. An
// object written while the class pointed at the filesystem is still on the
// filesystem after the class is repointed at S3, and a deployment that reads
// from wherever today's configuration says would report every one of those
// objects as missing while the bytes sat untouched on disk.
func (v *Vault) resolve(scope authctx.TenantScope, reference string) (Reference, Backend, error) {
	tenantID, err := tenantOf(scope)
	if err != nil {
		return Reference{}, nil, err
	}
	ref, err := ParseReference(reference)
	if err != nil {
		return Reference{}, nil, err
	}
	if ref.TenantID != tenantID {
		// Not found rather than forbidden: a probe must not be able to confirm
		// that a reference exists in another tenant. Belt and braces behind the
		// repository's own scoping — a store that served any reference it was
		// handed would turn one leaked row into cross-tenant access.
		return Reference{}, nil, fmt.Errorf("%w: %s", ErrNotFound, ref.ObjectID)
	}
	backend, ok := v.backends[ref.Backend]
	if !ok {
		return Reference{}, nil, fmt.Errorf("%w: %q holds this object but is not configured",
			ErrNoBackend, ref.Backend)
	}
	return ref, backend, nil
}

// Describe renders the routing table, for a startup log line and for the
// runbook question "where does this end up".
func (v *Vault) Describe() []string {
	out := make([]string, 0, len(Classes())+len(v.cfg.TenantBackends))
	for _, class := range Classes() {
		policy := v.policy(class)
		out = append(out, fmt.Sprintf("class %s -> backend %s (max %d bytes)",
			class, v.classBackend(class), policy.MaxBytes))
	}
	tenants := make([]string, 0, len(v.cfg.TenantBackends))
	for tenantID := range v.cfg.TenantBackends {
		tenants = append(tenants, tenantID)
	}
	sort.Strings(tenants)
	for _, tenantID := range tenants {
		out = append(out, fmt.Sprintf("tenant %s -> backend %s (all classes)",
			tenantID, v.cfg.TenantBackends[tenantID]))
	}
	return out
}

// normaliseContentType drops parameters and lowercases.
//
// "image/jpeg" and "image/jpeg; charset=binary" are the same format, and a
// allowlist match that failed on the parameter would reject a perfectly good
// photograph because of what some client library appended.
func normaliseContentType(s string) string {
	if i := strings.IndexByte(s, ';'); i >= 0 {
		s = s[:i]
	}
	return strings.ToLower(strings.TrimSpace(s))
}

func allowed(list []string, contentType string) bool {
	for _, candidate := range list {
		if normaliseContentType(candidate) == contentType {
			return true
		}
	}
	return false
}
