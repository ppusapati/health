package blobstore

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// Build assembles a Vault from environment configuration.
//
// It returns (nil, nil) when BLOB_BACKENDS is unset. A deployment that stores
// no binary content at all is a real one — an appointment-only clinic, a test
// environment — and it should refuse to capture a photograph rather than write
// a row pointing at nothing. Silently inventing a temporary directory instead
// would give that deployment a store that works until the pod restarts.
//
// The environment variables, with a worked example:
//
//	BLOB_BACKENDS=objects,inline
//	BLOB_DEFAULT_BACKEND=objects
//
//	BLOB_BACKEND_OBJECTS_KIND=s3
//	BLOB_BACKEND_OBJECTS_ENDPOINT=https://s3.ap-south-1.amazonaws.com
//	BLOB_BACKEND_OBJECTS_BUCKET=health-prod-objects
//	BLOB_BACKEND_OBJECTS_REGION=ap-south-1
//	BLOB_BACKEND_OBJECTS_KMS_KEY_ALIAS=alias/healthcare/prod/object-store
//	BLOB_BACKEND_OBJECTS_ACCESS_KEY_ID=...
//	BLOB_BACKEND_OBJECTS_SECRET_ACCESS_KEY=...
//
//	BLOB_BACKEND_INLINE_KIND=postgres
//	BLOB_BACKEND_INLINE_MAX_BYTES=65536
//
//	BLOB_CLASS_SIGNATURE_BACKEND=inline
//	BLOB_TENANT_BACKENDS=3f2a...=objects
//
// A filesystem backend is BLOB_BACKEND_<NAME>_KIND=filesystem with _ROOT.
//
// Every name is uppercased with hyphens turned into underscores, so the class
// "patient-photo" configures as BLOB_CLASS_PATIENT_PHOTO_*.
func Build(lookup func(string) string, transactions *pgtx.Manager) (*Vault, error) {
	names := splitList(lookup("BLOB_BACKENDS"))
	if len(names) == 0 {
		return nil, nil
	}

	backends := make([]Backend, 0, len(names))
	for _, name := range names {
		backend, err := buildBackend(lookup, name, transactions)
		if err != nil {
			return nil, err
		}
		backends = append(backends, backend)
	}

	cfg := Config{
		DefaultBackend: strings.TrimSpace(lookup("BLOB_DEFAULT_BACKEND")),
		Classes:        map[Class]ClassPolicy{},
		TenantBackends: map[string]string{},
	}

	for _, class := range Classes() {
		prefix := "BLOB_CLASS_" + envFragment(string(class)) + "_"
		policy := ClassPolicy{
			Backend:      strings.TrimSpace(lookup(prefix + "BACKEND")),
			ContentTypes: splitList(lookup(prefix + "CONTENT_TYPES")),
		}
		max, err := parseBytes(lookup(prefix+"MAX_BYTES"), prefix+"MAX_BYTES")
		if err != nil {
			return nil, err
		}
		policy.MaxBytes = max
		if policy.Backend != "" || policy.MaxBytes > 0 || len(policy.ContentTypes) > 0 {
			cfg.Classes[class] = policy
		}
	}

	// Tenant overrides as one variable rather than one per tenant: the key is a
	// tenant UUID, and a scheme that put it in the variable name would produce
	// BLOB_TENANT_3F2A1B9C_..._BACKEND, which nothing can be templated against.
	for _, pair := range splitList(lookup("BLOB_TENANT_BACKENDS")) {
		tenantID, backend, found := strings.Cut(pair, "=")
		if !found {
			return nil, fmt.Errorf("blobstore: BLOB_TENANT_BACKENDS entry %q is not tenant=backend", pair)
		}
		tenantID, backend = strings.TrimSpace(tenantID), strings.TrimSpace(backend)
		if tenantID == "" || backend == "" {
			return nil, fmt.Errorf("blobstore: BLOB_TENANT_BACKENDS entry %q is not tenant=backend", pair)
		}
		cfg.TenantBackends[tenantID] = backend
	}

	return NewVault(cfg, backends...)
}

// buildBackend constructs one named backend.
func buildBackend(lookup func(string) string, name string, transactions *pgtx.Manager) (Backend, error) {
	prefix := "BLOB_BACKEND_" + envFragment(name) + "_"
	kind := strings.ToLower(strings.TrimSpace(lookup(prefix + "KIND")))

	max, err := parseBytes(lookup(prefix+"MAX_BYTES"), prefix+"MAX_BYTES")
	if err != nil {
		return nil, err
	}
	kms := strings.TrimSpace(lookup(prefix + "KMS_KEY_ALIAS"))

	switch kind {
	case "filesystem":
		return NewFilesystem(FilesystemOptions{
			Name:        name,
			Root:        strings.TrimSpace(lookup(prefix + "ROOT")),
			KMSKeyAlias: kms,
			MaxBytes:    max,
		})
	case "s3":
		return NewS3(S3Options{
			Name:                 name,
			Endpoint:             strings.TrimSpace(lookup(prefix + "ENDPOINT")),
			Bucket:               strings.TrimSpace(lookup(prefix + "BUCKET")),
			Region:               strings.TrimSpace(lookup(prefix + "REGION")),
			PathStyle:            strings.EqualFold(strings.TrimSpace(lookup(prefix+"PATH_STYLE")), "true"),
			AccessKeyID:          strings.TrimSpace(lookup(prefix + "ACCESS_KEY_ID")),
			SecretAccessKey:      lookup(prefix + "SECRET_ACCESS_KEY"),
			SessionToken:         lookup(prefix + "SESSION_TOKEN"),
			KMSKeyAlias:          kms,
			ServerSideEncryption: strings.TrimSpace(lookup(prefix + "SSE")),
			MaxBytes:             max,
		})
	case "postgres":
		if transactions == nil {
			return nil, fmt.Errorf("blobstore: backend %q is postgres, but no database is configured", name)
		}
		return NewPostgres(PostgresOptions{
			Name:         name,
			Transactions: transactions,
			KMSKeyAlias:  kms,
			MaxBytes:     max,
		})
	case "":
		return nil, fmt.Errorf("blobstore: backend %q has no %sKIND", name, prefix)
	default:
		return nil, fmt.Errorf("blobstore: backend %q has unknown kind %q; "+
			"expected filesystem, s3 or postgres", name, kind)
	}
}

// envFragment turns a backend or class name into the part of an environment
// variable that names it.
func envFragment(s string) string {
	return strings.ToUpper(strings.NewReplacer("-", "_", ".", "_").Replace(strings.TrimSpace(s)))
}

func splitList(raw string) []string {
	var out []string
	for _, part := range strings.Split(raw, ",") {
		if trimmed := strings.TrimSpace(part); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	return out
}

// parseBytes reads a size, refusing anything that is not a plain positive
// count of bytes.
//
// No "64K" suffixes. A size that can be written two ways is one that gets read
// wrong, and the one place it matters here — the inline cap — is a number a
// reviewer should be able to compare against the schema's CHECK at a glance.
func parseBytes(raw, name string) (int64, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return 0, nil
	}
	value, err := strconv.ParseInt(raw, 10, 64)
	if err != nil || value <= 0 {
		return 0, fmt.Errorf("blobstore: %s must be a positive number of bytes, got %q", name, raw)
	}
	return value, nil
}
