package blobstore_test

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/blobstore"
)

// fakeS3 is enough of an S3-compatible store to hold objects and to be strict
// about the requests it accepts.
//
// Strict on purpose. A test double that accepts anything proves the client
// compiles; this one fails the same way a real store fails — a missing payload
// hash, an unsigned encryption header, a body that does not match what the
// request claimed — so the test catches the mistakes that otherwise surface as
// a 403 in an environment nobody can debug from a laptop.
type fakeS3 struct {
	mu      sync.Mutex
	objects map[string][]byte
	types   map[string]string
	headers map[string]http.Header
	t       *testing.T
}

func newFakeS3(t *testing.T) *fakeS3 {
	return &fakeS3{
		objects: map[string][]byte{},
		types:   map[string]string{},
		headers: map[string]http.Header{},
		t:       t,
	}
}

func (f *fakeS3) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)

	authorization := r.Header.Get("Authorization")
	if !strings.HasPrefix(authorization, "AWS4-HMAC-SHA256 Credential=") {
		f.t.Errorf("%s %s: unsigned request", r.Method, r.URL.Path)
		w.WriteHeader(http.StatusForbidden)
		return
	}
	sum := sha256.Sum256(body)
	if got, want := r.Header.Get("X-Amz-Content-Sha256"), hex.EncodeToString(sum[:]); got != want {
		f.t.Errorf("%s %s: payload hash %s does not describe the body (%s)",
			r.Method, r.URL.Path, got, want)
		w.WriteHeader(http.StatusForbidden)
		return
	}
	if !strings.Contains(authorization, "x-amz-content-sha256") {
		f.t.Errorf("%s %s: the payload hash is sent but not signed", r.Method, r.URL.Path)
	}

	// Path style: /bucket/key...
	key := strings.TrimPrefix(r.URL.Path, "/")
	bucket, key, _ := strings.Cut(key, "/")
	if bucket != "objects" {
		f.t.Errorf("request addressed bucket %q", bucket)
	}

	f.mu.Lock()
	defer f.mu.Unlock()

	switch r.Method {
	case http.MethodPut:
		f.objects[key] = body
		f.types[key] = r.Header.Get("Content-Type")
		f.headers[key] = r.Header.Clone()
		w.WriteHeader(http.StatusOK)
	case http.MethodGet:
		content, ok := f.objects[key]
		if !ok {
			w.Header().Set("Content-Type", "application/xml")
			w.WriteHeader(http.StatusNotFound)
			_, _ = w.Write([]byte(`<?xml version="1.0"?><Error><Code>NoSuchKey</Code>` +
				`<Message>The specified key does not exist.</Message></Error>`))
			return
		}
		_, _ = w.Write(content)
	case http.MethodDelete:
		delete(f.objects, key)
		w.WriteHeader(http.StatusNoContent)
	default:
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}

func s3Vault(t *testing.T, server *httptest.Server, kms string) *blobstore.Vault {
	t.Helper()
	backend, err := blobstore.NewS3(blobstore.S3Options{
		Name:            "objects",
		Endpoint:        server.URL,
		Bucket:          "objects",
		Region:          "ap-south-1",
		PathStyle:       true,
		AccessKeyID:     "AKIDEXAMPLE",
		SecretAccessKey: "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
		KMSKeyAlias:     kms,
		Client:          server.Client(),
	})
	if err != nil {
		t.Fatalf("NewS3: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	return vault
}

func TestAnObjectRoundTripsThroughAnS3CompatibleStore(t *testing.T) {
	store := newFakeS3(t)
	server := httptest.NewServer(store)
	defer server.Close()

	vault := s3Vault(t, server, "alias/healthcare/prod/object-store")
	ctx, scope := context.Background(), scopeFor("tenant-a")

	object, err := vault.Put(ctx, scope, blobstore.ClassWoundImage, "image/png", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	if object.KMSKeyAlias != "alias/healthcare/prod/object-store" {
		t.Errorf("KMSKeyAlias = %q; a rotation cannot find what to re-wrap", object.KMSKeyAlias)
	}

	got, err := vault.Get(ctx, scope, object.Reference)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if !bytes.Equal(got, photo) {
		t.Fatal("the bytes that came back are not the bytes that went in")
	}

	if err := vault.Delete(ctx, scope, object.Reference); err != nil {
		t.Fatalf("Delete: %v", err)
	}
	if _, err := vault.Get(ctx, scope, object.Reference); !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("want ErrNotFound after deletion, got %v", err)
	}
	// And deleting again is not an error, because a consent withdrawal is
	// retried after ambiguous failures.
	if err := vault.Delete(ctx, scope, object.Reference); err != nil {
		t.Fatalf("Delete again: %v", err)
	}
}

// The encryption headers decide whether the object lands encrypted, so an
// intermediary that stripped them must invalidate the signature rather than
// quietly store a patient's wound photograph in the clear.
func TestEncryptionHeadersAreSentAndSigned(t *testing.T) {
	store := newFakeS3(t)
	server := httptest.NewServer(store)
	defer server.Close()

	vault := s3Vault(t, server, "alias/healthcare/prod/object-store")
	object, err := vault.Put(context.Background(), scopeFor("tenant-a"),
		blobstore.ClassWoundImage, "image/png", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}

	ref, err := blobstore.ParseReference(object.Reference)
	if err != nil {
		t.Fatalf("ParseReference: %v", err)
	}
	sent := store.headers[ref.BackendKey()]
	if got := sent.Get("X-Amz-Server-Side-Encryption"); got != "aws:kms" {
		t.Errorf("server-side encryption header = %q, want aws:kms", got)
	}
	if got := sent.Get("X-Amz-Server-Side-Encryption-Aws-Kms-Key-Id"); got != "alias/healthcare/prod/object-store" {
		t.Errorf("kms key header = %q", got)
	}
	authorization := sent.Get("Authorization")
	for _, header := range []string{
		"x-amz-server-side-encryption",
		"x-amz-server-side-encryption-aws-kms-key-id",
		"content-type",
		"host",
	} {
		if !strings.Contains(authorization, header) {
			t.Errorf("%s is sent but not signed: %s", header, authorization)
		}
	}
	if got := store.types[ref.BackendKey()]; got != "image/png" {
		t.Errorf("content type stored as %q", got)
	}
}

// recordingTransport answers every request without a network, so the address
// the client would have dialled can be asserted.
type recordingTransport struct{ last *http.Request }

func (r *recordingTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	r.last = req
	return &http.Response{
		StatusCode: http.StatusOK,
		Body:       io.NopCloser(strings.NewReader("")),
		Header:     http.Header{},
		Request:    req,
	}, nil
}

// AWS rejects path-style addressing for buckets created since 2020; MinIO and
// Ceph require it. Getting this wrong produces a 403 or a 404 depending on
// which way round, and neither says which setting caused it — so both are
// configuration and both are tested.
func TestBucketAddressingFollowsConfiguration(t *testing.T) {
	cases := map[bool]string{
		true:  "/objects/tenant-a/",
		false: "/tenant-a/",
	}
	for pathStyle, wantPrefix := range cases {
		transport := &recordingTransport{}
		backend, err := blobstore.NewS3(blobstore.S3Options{
			Name:            "objects",
			Endpoint:        "https://s3.ap-south-1.example.invalid",
			Bucket:          "objects",
			Region:          "ap-south-1",
			PathStyle:       pathStyle,
			AccessKeyID:     "AK",
			SecretAccessKey: "secret",
			Client:          &http.Client{Transport: transport},
		})
		if err != nil {
			t.Fatalf("NewS3: %v", err)
		}
		vault, err := blobstore.NewVault(blobstore.Config{}, backend)
		if err != nil {
			t.Fatalf("NewVault: %v", err)
		}
		if _, err := vault.Put(context.Background(), scopeFor("tenant-a"),
			blobstore.ClassWoundImage, "image/png", photo); err != nil {
			t.Fatalf("Put (pathStyle=%v): %v", pathStyle, err)
		}

		request := transport.last
		if !strings.HasPrefix(request.URL.Path, wantPrefix) {
			t.Errorf("pathStyle=%v produced path %q, want prefix %q",
				pathStyle, request.URL.Path, wantPrefix)
		}
		wantHost := "s3.ap-south-1.example.invalid"
		if !pathStyle {
			wantHost = "objects." + wantHost
		}
		if request.URL.Host != wantHost {
			t.Errorf("pathStyle=%v addressed host %q, want %q", pathStyle, request.URL.Host, wantHost)
		}
		// The host is what the signature commits to, so it has to be the host
		// that was actually addressed rather than the endpoint as configured.
		if !strings.Contains(request.Header.Get("Authorization"), "host") {
			t.Errorf("pathStyle=%v: host is not signed", pathStyle)
		}
	}
}

// A store that answered with an unbounded stream could exhaust this process's
// memory, and nothing here is legitimately larger than MaxInlineBytes.
func TestAnOverlongResponseIsRefused(t *testing.T) {
	huge := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusOK)
			return
		}
		chunk := bytes.Repeat([]byte("x"), 1<<20)
		for written := 0; written <= blobstore.MaxInlineBytes; written += len(chunk) {
			if _, err := w.Write(chunk); err != nil {
				return
			}
		}
	}))
	defer huge.Close()

	backend, err := blobstore.NewS3(blobstore.S3Options{
		Name: "objects", Endpoint: huge.URL, Bucket: "objects", Region: "ap-south-1",
		PathStyle: true, AccessKeyID: "AK", SecretAccessKey: "secret", Client: huge.Client(),
	})
	if err != nil {
		t.Fatalf("NewS3: %v", err)
	}
	_, err = backend.Get(context.Background(), "tenant-a/wound-image/abc/"+strings.Repeat("0", 64))
	if !errors.Is(err, blobstore.ErrInvalidObject) {
		t.Fatalf("want ErrInvalidObject for an overlong response, got %v", err)
	}
}

// A misconfigured S3 backend fails at construction. Every one of these is
// otherwise a runtime 403 whose cause is not in the error.
func TestAMisconfiguredS3BackendRefusesToStart(t *testing.T) {
	complete := blobstore.S3Options{
		Name: "objects", Endpoint: "https://s3.example.invalid", Bucket: "objects",
		Region: "ap-south-1", AccessKeyID: "AK", SecretAccessKey: "secret",
	}
	cases := map[string]func(*blobstore.S3Options){
		"no name":       func(o *blobstore.S3Options) { o.Name = "" },
		"no endpoint":   func(o *blobstore.S3Options) { o.Endpoint = "" },
		"no bucket":     func(o *blobstore.S3Options) { o.Bucket = "" },
		"no region":     func(o *blobstore.S3Options) { o.Region = "" },
		"no access key": func(o *blobstore.S3Options) { o.AccessKeyID = "" },
		"no secret":     func(o *blobstore.S3Options) { o.SecretAccessKey = "" },
		"no host":       func(o *blobstore.S3Options) { o.Endpoint = "not-a-url" },
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			opts := complete
			mutate(&opts)
			if _, err := blobstore.NewS3(opts); err == nil {
				t.Fatal("the backend was constructed")
			}
		})
	}
	if _, err := blobstore.NewS3(complete); err != nil {
		t.Fatalf("complete options were refused: %v", err)
	}
}
