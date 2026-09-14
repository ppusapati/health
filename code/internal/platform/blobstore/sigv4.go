package blobstore

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"net/http"
	"sort"
	"strings"
	"time"
)

// This file implements AWS Signature Version 4 over net/http.
//
// Written out rather than taken from an SDK on purpose. The SDK brings a large
// dependency tree, its own retry, credential-chain and endpoint-resolution
// behaviour, and a release cadence — for a client that issues exactly three
// requests (PUT, GET, DELETE of one object) against an endpoint the deployment
// names. The signing algorithm is small, stable since 2012, published with
// test vectors, and pinned here by one of those vectors so a mistake in it is
// a failing test rather than a 403 in production.
//
// It is also what makes MinIO, Ceph RADOS Gateway and any other S3-compatible
// store work identically to AWS, which matters for a system that has to run in
// a hospital's own rack as readily as in a cloud region.

const (
	sigv4Algorithm  = "AWS4-HMAC-SHA256"
	sigv4Terminator = "aws4_request"
	// emptyPayloadSHA256 is sha256(""), the payload hash for a body-less
	// request. Written out because computing it at every call site is how one
	// call site ends up computing it over something else.
	emptyPayloadSHA256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
)

// credentials are what a request is signed with.
type credentials struct {
	AccessKeyID     string
	SecretAccessKey string
	// SessionToken is set when the credentials came from STS — an assumed
	// role, or the pod identity a Kubernetes deployment uses. It is sent as a
	// signed header, so a token swapped in transit invalidates the signature.
	SessionToken string
}

// signV4 signs req in place for the given service and region.
//
// payloadHash is the hex SHA-256 of the body. Passed in rather than computed
// here because the caller already has the bytes and because a signer that
// consumed the body would leave nothing to send. The caller also sets any
// x-amz-content-sha256 header its service expects: that header is an S3
// convention rather than part of the signing algorithm, and setting it here
// would make this signer disagree with the published test vectors for every
// other service.
func signV4(req *http.Request, creds credentials, region, service, payloadHash string, now time.Time) {
	now = now.UTC()
	amzDate := now.Format("20060102T150405Z")
	dateStamp := now.Format("20060102")

	req.Header.Set("X-Amz-Date", amzDate)
	if creds.SessionToken != "" {
		req.Header.Set("X-Amz-Security-Token", creds.SessionToken)
	}

	names, canonicalHeaders := canonicalHeaders(req)
	signedHeaders := strings.Join(names, ";")

	canonicalRequest := strings.Join([]string{
		req.Method,
		canonicalURIPath(req.URL.EscapedPath()),
		canonicalQuery(req),
		canonicalHeaders,
		signedHeaders,
		payloadHash,
	}, "\n")

	scope := strings.Join([]string{dateStamp, region, service, sigv4Terminator}, "/")
	stringToSign := strings.Join([]string{
		sigv4Algorithm,
		amzDate,
		scope,
		hashHex([]byte(canonicalRequest)),
	}, "\n")

	signing := signingKey(creds.SecretAccessKey, dateStamp, region, service)
	signature := hex.EncodeToString(hmacSHA256(signing, []byte(stringToSign)))

	req.Header.Set("Authorization", sigv4Algorithm+
		" Credential="+creds.AccessKeyID+"/"+scope+
		", SignedHeaders="+signedHeaders+
		", Signature="+signature)
}

// canonicalHeaders returns the sorted signed header names and the canonical
// header block.
//
// Host is signed always: without it a signed request is portable to a
// different endpoint, which is the whole of the attack. Content-Type and every
// x-amz-* header are signed because they change what the request means — the
// server-side-encryption headers in particular decide whether the object lands
// encrypted, and an unsigned one can be stripped in transit.
func canonicalHeaders(req *http.Request) ([]string, string) {
	values := map[string]string{}

	host := req.Host
	if host == "" {
		host = req.URL.Host
	}
	values["host"] = host

	for name, vals := range req.Header {
		lower := strings.ToLower(name)
		if lower != "content-type" && !strings.HasPrefix(lower, "x-amz-") {
			continue
		}
		trimmed := make([]string, 0, len(vals))
		for _, v := range vals {
			trimmed = append(trimmed, trimHeaderValue(v))
		}
		values[lower] = strings.Join(trimmed, ",")
	}

	names := make([]string, 0, len(values))
	for name := range values {
		names = append(names, name)
	}
	sort.Strings(names)

	var block strings.Builder
	for _, name := range names {
		block.WriteString(name)
		block.WriteByte(':')
		block.WriteString(values[name])
		block.WriteByte('\n')
	}
	return names, block.String()
}

// trimHeaderValue collapses internal runs of whitespace and trims the ends,
// as the canonicalisation rules require.
func trimHeaderValue(v string) string {
	return strings.Join(strings.Fields(v), " ")
}

// canonicalQuery renders the query string in canonical form.
func canonicalQuery(req *http.Request) string {
	query := req.URL.Query()
	keys := make([]string, 0, len(query))
	for key := range query {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	var parts []string
	for _, key := range keys {
		values := append([]string(nil), query[key]...)
		sort.Strings(values)
		for _, value := range values {
			parts = append(parts, uriEncode(key, false)+"="+uriEncode(value, false))
		}
	}
	return strings.Join(parts, "&")
}

// canonicalURIPath encodes a path for the canonical request.
//
// Already-escaped input: the caller built the URL from a key this package
// minted, so the path arrives percent-encoded by net/url. Re-encoding it as
// though it were raw would double-escape every percent, so the segments are
// decoded first and encoded under the stricter AWS rules — net/url's escaping
// leaves some characters AWS expects encoded, and vice versa.
func canonicalURIPath(escaped string) string {
	if escaped == "" {
		return "/"
	}
	segments := strings.Split(escaped, "/")
	for i, segment := range segments {
		segments[i] = uriEncode(unescapeSegment(segment), false)
	}
	joined := strings.Join(segments, "/")
	if !strings.HasPrefix(joined, "/") {
		joined = "/" + joined
	}
	return joined
}

func unescapeSegment(s string) string {
	var out strings.Builder
	for i := 0; i < len(s); i++ {
		if s[i] == '%' && i+2 < len(s) {
			if b, err := hex.DecodeString(s[i+1 : i+3]); err == nil {
				out.WriteByte(b[0])
				i += 2
				continue
			}
		}
		out.WriteByte(s[i])
	}
	return out.String()
}

// uriEncode percent-encodes under the SigV4 rules.
//
// Unreserved is A-Z a-z 0-9 - _ . ~ and nothing else; in particular '+' and
// '*' are encoded, which is where an encoder borrowed from form handling goes
// wrong. encodeSlash is false for path segments, which are joined afterwards.
func uriEncode(s string, encodeSlash bool) string {
	const upperhex = "0123456789ABCDEF"
	var out strings.Builder
	for i := 0; i < len(s); i++ {
		c := s[i]
		switch {
		case (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
			(c >= '0' && c <= '9') || c == '-' || c == '_' || c == '.' || c == '~':
			out.WriteByte(c)
		case c == '/' && !encodeSlash:
			out.WriteByte(c)
		default:
			out.WriteByte('%')
			out.WriteByte(upperhex[c>>4])
			out.WriteByte(upperhex[c&0x0f])
		}
	}
	return out.String()
}

func signingKey(secret, dateStamp, region, service string) []byte {
	key := hmacSHA256([]byte("AWS4"+secret), []byte(dateStamp))
	key = hmacSHA256(key, []byte(region))
	key = hmacSHA256(key, []byte(service))
	return hmacSHA256(key, []byte(sigv4Terminator))
}

func hmacSHA256(key, data []byte) []byte {
	mac := hmac.New(sha256.New, key)
	mac.Write(data)
	return mac.Sum(nil)
}

func hashHex(b []byte) string {
	sum := sha256.Sum256(b)
	return hex.EncodeToString(sum[:])
}
