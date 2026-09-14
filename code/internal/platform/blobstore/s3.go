package blobstore

import (
	"bytes"
	"context"
	"encoding/xml"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// S3 stores objects in an S3-compatible object store.
//
// "S3-compatible" is the requirement, not "AWS S3". The same code addresses
// AWS, MinIO in the hospital's own rack and Ceph RADOS Gateway, because all
// three speak the same three requests and the same signature. A deployment
// picks its endpoint and whether the bucket is addressed by path or by
// virtual host, and nothing above this file changes.
type S3 struct {
	name      string
	endpoint  *url.URL
	bucket    string
	region    string
	pathStyle bool
	creds     credentials
	sse       string
	kms       string
	limit     int64
	client    *http.Client
	now       func() time.Time
}

// S3Options configures an S3-compatible backend.
type S3Options struct {
	// Name is the identifier recorded in references. Required, and permanent
	// for the life of the objects written under it.
	Name string
	// Endpoint is the service URL, for example https://s3.ap-south-1.amazonaws.com
	// or http://minio.storage.svc:9000.
	Endpoint string
	Bucket   string
	Region   string
	// PathStyle addresses the bucket as a path segment rather than a subdomain.
	// Required by MinIO and Ceph; AWS accepts it for older buckets and rejects
	// it for newer ones, so it is configuration rather than a guess.
	PathStyle bool

	AccessKeyID     string
	SecretAccessKey string
	SessionToken    string

	// KMSKeyAlias requests SSE-KMS under that key. Empty with
	// ServerSideEncryption "AES256" requests SSE-S3; empty with neither set
	// means the bucket's own default applies, which a deployment should only
	// choose when the bucket has a default encryption policy.
	KMSKeyAlias          string
	ServerSideEncryption string

	// MaxBytes refuses larger objects. Zero means the class limits are the
	// only ceiling.
	MaxBytes int64

	// Client overrides the HTTP client. Left nil, a client with a timeout is
	// used: the default http.Client has none, and a hung object store would
	// otherwise hold a request goroutine until the process restarted.
	Client *http.Client
	// Now overrides the clock, for tests that pin a signature.
	Now func() time.Time
}

// NewS3 prepares an S3-compatible backend.
func NewS3(opts S3Options) (*S3, error) {
	switch {
	case strings.TrimSpace(opts.Name) == "":
		return nil, errors.New("blobstore: an s3 backend needs a name")
	case strings.TrimSpace(opts.Endpoint) == "":
		return nil, errors.New("blobstore: an s3 backend needs an endpoint")
	case strings.TrimSpace(opts.Bucket) == "":
		return nil, errors.New("blobstore: an s3 backend needs a bucket")
	case strings.TrimSpace(opts.Region) == "":
		return nil, errors.New("blobstore: an s3 backend needs a region; it is part of the signature")
	case strings.TrimSpace(opts.AccessKeyID) == "" || strings.TrimSpace(opts.SecretAccessKey) == "":
		return nil, errors.New("blobstore: an s3 backend needs credentials")
	}

	endpoint, err := url.Parse(opts.Endpoint)
	if err != nil {
		return nil, fmt.Errorf("blobstore: parsing endpoint %q: %w", opts.Endpoint, err)
	}
	if endpoint.Host == "" {
		return nil, fmt.Errorf("blobstore: endpoint %q has no host", opts.Endpoint)
	}

	sse := strings.TrimSpace(opts.ServerSideEncryption)
	if opts.KMSKeyAlias != "" {
		sse = "aws:kms"
	}

	client := opts.Client
	if client == nil {
		client = &http.Client{Timeout: 30 * time.Second}
	}
	now := opts.Now
	if now == nil {
		now = time.Now
	}

	return &S3{
		name: opts.Name, endpoint: endpoint, bucket: opts.Bucket,
		region: opts.Region, pathStyle: opts.PathStyle,
		creds: credentials{
			AccessKeyID:     opts.AccessKeyID,
			SecretAccessKey: opts.SecretAccessKey,
			SessionToken:    opts.SessionToken,
		},
		sse: sse, kms: opts.KMSKeyAlias, limit: opts.MaxBytes,
		client: client, now: now,
	}, nil
}

// Name identifies the backend in references.
func (s *S3) Name() string { return s.name }

// KMSKeyAlias names the managed key objects are encrypted under.
func (s *S3) KMSKeyAlias() string { return s.kms }

// MaxBytes implements Limiter.
func (s *S3) MaxBytes() int64 { return s.limit }

// Put writes the object.
func (s *S3) Put(ctx context.Context, key, contentType string, content []byte) error {
	if s.limit > 0 && int64(len(content)) > s.limit {
		return fmt.Errorf("%w: %d bytes exceeds the %d backend %q accepts",
			ErrTooLarge, len(content), s.limit, s.name)
	}
	req, err := s.request(ctx, http.MethodPut, key, content)
	if err != nil {
		return err
	}
	if contentType != "" {
		req.Header.Set("Content-Type", contentType)
	}
	switch s.sse {
	case "aws:kms":
		req.Header.Set("X-Amz-Server-Side-Encryption", "aws:kms")
		if s.kms != "" {
			req.Header.Set("X-Amz-Server-Side-Encryption-Aws-Kms-Key-Id", s.kms)
		}
	case "":
		// The bucket's own default applies.
	default:
		req.Header.Set("X-Amz-Server-Side-Encryption", s.sse)
	}

	// Signed last: the encryption headers are part of what is signed, so a
	// proxy that stripped them to store the object in the clear would produce
	// a signature mismatch rather than a silently unencrypted object.
	payload := hashHex(content)
	req.Header.Set("X-Amz-Content-Sha256", payload)
	signV4(req, s.creds, s.region, "s3", payload, s.now())

	resp, err := s.client.Do(req)
	if err != nil {
		return fmt.Errorf("blobstore: putting %q: %w", key, err)
	}
	defer resp.Body.Close()
	if resp.StatusCode/100 != 2 {
		return s.responseError(resp, key)
	}
	_, _ = io.Copy(io.Discard, resp.Body)
	return nil
}

// Get reads the object.
func (s *S3) Get(ctx context.Context, key string) ([]byte, error) {
	req, err := s.request(ctx, http.MethodGet, key, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("X-Amz-Content-Sha256", emptyPayloadSHA256)
	signV4(req, s.creds, s.region, "s3", emptyPayloadSHA256, s.now())

	resp, err := s.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("blobstore: getting %q: %w", key, err)
	}
	defer resp.Body.Close()
	if resp.StatusCode/100 != 2 {
		return nil, s.responseError(resp, key)
	}
	// Bounded: an object store that answered with an unbounded stream would
	// otherwise be able to exhaust this process's memory, and nothing this
	// package stores is legitimately larger than MaxInlineBytes.
	content, err := io.ReadAll(io.LimitReader(resp.Body, MaxInlineBytes+1))
	if err != nil {
		return nil, fmt.Errorf("blobstore: reading %q: %w", key, err)
	}
	if int64(len(content)) > MaxInlineBytes {
		return nil, fmt.Errorf("%w: %q is larger than %d bytes", ErrInvalidObject, key, MaxInlineBytes)
	}
	return content, nil
}

// Delete removes the object.
//
// S3 answers 204 whether or not the key was there, which is the idempotence
// the port asks for and costs nothing to rely on.
func (s *S3) Delete(ctx context.Context, key string) error {
	req, err := s.request(ctx, http.MethodDelete, key, nil)
	if err != nil {
		return err
	}
	req.Header.Set("X-Amz-Content-Sha256", emptyPayloadSHA256)
	signV4(req, s.creds, s.region, "s3", emptyPayloadSHA256, s.now())

	resp, err := s.client.Do(req)
	if err != nil {
		return fmt.Errorf("blobstore: deleting %q: %w", key, err)
	}
	defer resp.Body.Close()
	if resp.StatusCode/100 != 2 && resp.StatusCode != http.StatusNotFound {
		return s.responseError(resp, key)
	}
	_, _ = io.Copy(io.Discard, resp.Body)
	return nil
}

// request builds the HTTP request for a key.
func (s *S3) request(ctx context.Context, method, key string, body []byte) (*http.Request, error) {
	target := *s.endpoint
	if s.pathStyle {
		target.Path = "/" + s.bucket + "/" + key
	} else {
		target.Host = s.bucket + "." + target.Host
		target.Path = "/" + key
	}

	var reader io.Reader
	if body != nil {
		reader = bytes.NewReader(body)
	}
	req, err := http.NewRequestWithContext(ctx, method, target.String(), reader)
	if err != nil {
		return nil, fmt.Errorf("blobstore: building a request for %q: %w", key, err)
	}
	if body != nil {
		req.ContentLength = int64(len(body))
	}
	return req, nil
}

// s3Error is the error document every S3-compatible store returns.
type s3Error struct {
	XMLName xml.Name `xml:"Error"`
	Code    string   `xml:"Code"`
	Message string   `xml:"Message"`
}

// responseError turns a non-2xx response into an error, mapping the absent
// object onto ErrNotFound so callers do not have to know HTTP.
//
// The body is read with a small bound and never logged wholesale: an error
// document echoes the key, and the key is a reference to a patient's
// photograph.
func (s *S3) responseError(resp *http.Response, key string) error {
	body, _ := io.ReadAll(io.LimitReader(resp.Body, 8<<10))

	var parsed s3Error
	_ = xml.Unmarshal(body, &parsed)

	if resp.StatusCode == http.StatusNotFound || parsed.Code == "NoSuchKey" || parsed.Code == "NoSuchBucket" {
		return fmt.Errorf("%w: %s", ErrNotFound, key)
	}
	code := parsed.Code
	if code == "" {
		code = resp.Status
	}
	return fmt.Errorf("blobstore: object store refused %s on %q: %s", resp.Request.Method, key, code)
}

var (
	_ Backend = (*S3)(nil)
	_ Limiter = (*S3)(nil)
)
