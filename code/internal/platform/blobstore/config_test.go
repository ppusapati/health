package blobstore_test

import (
	"context"
	"path/filepath"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/blobstore"
)

func envLookup(pairs map[string]string) func(string) string {
	return func(name string) string { return pairs[name] }
}

// The configuration in the package documentation, assembled and then asked
// where things go. Documentation that is not executed is documentation that
// drifts, and this is the example an operator will copy.
func TestTheDocumentedConfigurationAssembles(t *testing.T) {
	root := t.TempDir()
	vault, err := blobstore.Build(envLookup(map[string]string{
		"BLOB_BACKENDS":                          "objects, local",
		"BLOB_DEFAULT_BACKEND":                   "objects",
		"BLOB_BACKEND_OBJECTS_KIND":              "s3",
		"BLOB_BACKEND_OBJECTS_ENDPOINT":          "https://s3.ap-south-1.example.invalid",
		"BLOB_BACKEND_OBJECTS_BUCKET":            "health-prod-objects",
		"BLOB_BACKEND_OBJECTS_REGION":            "ap-south-1",
		"BLOB_BACKEND_OBJECTS_KMS_KEY_ALIAS":     "alias/healthcare/prod/object-store",
		"BLOB_BACKEND_OBJECTS_ACCESS_KEY_ID":     "AK",
		"BLOB_BACKEND_OBJECTS_SECRET_ACCESS_KEY": "secret",
		"BLOB_BACKEND_LOCAL_KIND":                "filesystem",
		"BLOB_BACKEND_LOCAL_ROOT":                filepath.Join(root, "local"),
		"BLOB_CLASS_SIGNATURE_BACKEND":           "local",
		"BLOB_CLASS_PATIENT_PHOTO_MAX_BYTES":     "1048576",
		"BLOB_TENANT_BACKENDS":                   "tenant-in-india=local",
	}), nil)
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	if vault == nil {
		t.Fatal("Build returned no vault")
	}

	described := strings.Join(vault.Describe(), "\n")
	for _, want := range []string{
		"class patient-photo -> backend objects (max 1048576 bytes)",
		"class signature -> backend local",
		"tenant tenant-in-india -> backend local",
	} {
		if !strings.Contains(described, want) {
			t.Errorf("configuration did not produce %q:\n%s", want, described)
		}
	}
}

// A deployment that stores no binary content is a real one. Inventing a
// temporary directory for it would give it a store that works until the pod
// restarts, which is worse than refusing to capture a photograph at all.
func TestNoBackendsConfiguredIsNotAnError(t *testing.T) {
	vault, err := blobstore.Build(envLookup(map[string]string{}), nil)
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	if vault != nil {
		t.Fatal("a vault was invented for a deployment that configured none")
	}
}

func TestBadConfigurationIsRefusedAtStartup(t *testing.T) {
	root := t.TempDir()
	base := map[string]string{
		"BLOB_BACKENDS":           "local",
		"BLOB_BACKEND_LOCAL_KIND": "filesystem",
		"BLOB_BACKEND_LOCAL_ROOT": filepath.Join(root, "local"),
	}
	cases := map[string]map[string]string{
		"a backend with no kind":         {"BLOB_BACKENDS": "local,other"},
		"a backend with an unknown kind": {"BLOB_BACKENDS": "local,other", "BLOB_BACKEND_OTHER_KIND": "tape"},
		"a filesystem backend with no root": {
			"BLOB_BACKENDS": "local,other", "BLOB_BACKEND_OTHER_KIND": "filesystem",
		},
		"a size that is not a number":      {"BLOB_BACKEND_LOCAL_MAX_BYTES": "64K"},
		"a negative size":                  {"BLOB_BACKEND_LOCAL_MAX_BYTES": "-1"},
		"a class routed nowhere":           {"BLOB_CLASS_WOUND_IMAGE_BACKEND": "missing"},
		"a tenant override without a name": {"BLOB_TENANT_BACKENDS": "tenant-a"},
		"a tenant override with no tenant": {"BLOB_TENANT_BACKENDS": "=local"},
		"a postgres backend with no database": {
			"BLOB_BACKENDS": "local,inline", "BLOB_BACKEND_INLINE_KIND": "postgres",
		},
	}
	for name, overrides := range cases {
		t.Run(name, func(t *testing.T) {
			env := map[string]string{}
			for k, v := range base {
				env[k] = v
			}
			for k, v := range overrides {
				env[k] = v
			}
			if _, err := blobstore.Build(envLookup(env), nil); err == nil {
				t.Fatal("the configuration was accepted")
			}
		})
	}
}

// Configured limits have to be the ones that apply, or the environment
// variable is decoration.
func TestConfiguredLimitsAreTheOnesEnforced(t *testing.T) {
	vault, err := blobstore.Build(envLookup(map[string]string{
		"BLOB_BACKENDS":                          "local",
		"BLOB_BACKEND_LOCAL_KIND":                "filesystem",
		"BLOB_BACKEND_LOCAL_ROOT":                filepath.Join(t.TempDir(), "local"),
		"BLOB_CLASS_PATIENT_PHOTO_MAX_BYTES":     "16",
		"BLOB_CLASS_PATIENT_PHOTO_CONTENT_TYPES": "image/heic",
	}), nil)
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/heic", photo); err == nil {
		t.Error("content larger than the configured limit was accepted")
	}
	// The configured allowlist replaces the built-in one rather than adding to
	// it: a deployment that names its formats means those and not those plus
	// whatever this package shipped with.
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", []byte("small")); err == nil {
		t.Error("a content type outside the configured allowlist was accepted")
	}
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/heic", []byte("small")); err != nil {
		t.Errorf("the configured content type was refused: %v", err)
	}
}
