package blobstore

import (
	"net/http"
	"strings"
	"testing"
	"time"
)

// The published AWS Signature Version 4 example, verbatim.
//
// This test is the reason it is defensible to sign requests here rather than
// take an SDK. A signer checked only against itself — sign a request, verify
// it with the same code — passes while being wrong in the same way twice, and
// the first evidence is a 403 from the object store in an environment nobody
// can debug from the outside. Checked against a vector computed by somebody
// else, a mistake in canonicalisation, in the signing-key chain or in the
// string to sign is a red test on the machine that made it.
//
// Source: the AWS "Signature Version 4 test suite" example request
// (GET https://iam.amazonaws.com/?Action=ListUsers&Version=2010-05-08).
func TestSignV4MatchesThePublishedExample(t *testing.T) {
	req, err := http.NewRequest(http.MethodGet,
		"https://iam.amazonaws.com/?Action=ListUsers&Version=2010-05-08", nil)
	if err != nil {
		t.Fatalf("building the example request: %v", err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")

	creds := credentials{
		AccessKeyID:     "AKIDEXAMPLE",
		SecretAccessKey: "wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY",
	}
	at := time.Date(2015, 8, 30, 12, 36, 0, 0, time.UTC)

	signV4(req, creds, "us-east-1", "iam", emptyPayloadSHA256, at)

	const want = "AWS4-HMAC-SHA256 " +
		"Credential=AKIDEXAMPLE/20150830/us-east-1/iam/aws4_request, " +
		"SignedHeaders=content-type;host;x-amz-date, " +
		"Signature=5d672d79c15b13162d9279b0855cfba6789a8edb4c82c400e06b5924a6f2b5d7"
	if got := req.Header.Get("Authorization"); got != want {
		t.Errorf("Authorization mismatch\n got: %s\nwant: %s", got, want)
	}
}

// sha256("") appears as a constant, and a constant nobody checks is a constant
// that can be wrong.
func TestTheEmptyPayloadHashIsRight(t *testing.T) {
	if got := hashHex(nil); got != emptyPayloadSHA256 {
		t.Errorf("emptyPayloadSHA256 = %s, want %s", emptyPayloadSHA256, got)
	}
}

// The encoder is the part most often borrowed from form handling, where '+'
// means a space and '*' is left alone. Both are wrong here, and both fail as a
// signature mismatch that says nothing about which character caused it.
func TestURIEncodingFollowsTheSigningRules(t *testing.T) {
	cases := map[string]string{
		"abcXYZ091": "abcXYZ091",
		"-_.~":      "-_.~",
		"a b":       "a%20b",
		"a+b":       "a%2Bb",
		"a*b":       "a%2Ab",
		"a/b":       "a/b",
		"tilde~":    "tilde~",
		"café":      "caf%C3%A9",
		"100%":      "100%25",
		"a=b&c":     "a%3Db%26c",
	}
	for input, want := range cases {
		if got := uriEncode(input, false); got != want {
			t.Errorf("uriEncode(%q) = %q, want %q", input, got, want)
		}
	}
	if got := uriEncode("a/b", true); got != "a%2Fb" {
		t.Errorf("uriEncode with encodeSlash = %q, want a%%2Fb", got)
	}
}

// Keys reach the URL already escaped by net/url. Encoding them a second time
// as though they were raw turns every percent into %25 and every object into a
// 404 — silently, because the store is perfectly happy to report that a key
// nobody wrote does not exist.
func TestAnAlreadyEscapedPathIsNotEscapedTwice(t *testing.T) {
	req, err := http.NewRequest(http.MethodGet, "https://example.invalid/bucket/a%20b/c", nil)
	if err != nil {
		t.Fatalf("building: %v", err)
	}
	if got := canonicalURIPath(req.URL.EscapedPath()); got != "/bucket/a%20b/c" {
		t.Errorf("canonicalURIPath = %q, want /bucket/a%%20b/c", got)
	}
}

// Host is signed whether or not the caller thought to set it, because a signed
// request that does not commit to its destination can be replayed against a
// different one.
func TestHostIsAlwaysSigned(t *testing.T) {
	req, err := http.NewRequest(http.MethodPut, "https://bucket.s3.example.invalid/key", strings.NewReader("x"))
	if err != nil {
		t.Fatalf("building: %v", err)
	}
	signV4(req, credentials{AccessKeyID: "AK", SecretAccessKey: "secret"},
		"ap-south-1", "s3", hashHex([]byte("x")), time.Now())

	if !strings.Contains(req.Header.Get("Authorization"), "SignedHeaders=host;x-amz-date") {
		t.Errorf("host is not in the signed headers: %s", req.Header.Get("Authorization"))
	}
}

// A session token that is not signed can be swapped in transit for another
// principal's, which is the whole of the attack STS credentials invite.
func TestASessionTokenIsSigned(t *testing.T) {
	req, err := http.NewRequest(http.MethodGet, "https://bucket.s3.example.invalid/key", nil)
	if err != nil {
		t.Fatalf("building: %v", err)
	}
	signV4(req, credentials{AccessKeyID: "AK", SecretAccessKey: "secret", SessionToken: "tok"},
		"ap-south-1", "s3", emptyPayloadSHA256, time.Now())

	if req.Header.Get("X-Amz-Security-Token") != "tok" {
		t.Fatal("the session token was not sent")
	}
	if !strings.Contains(req.Header.Get("Authorization"), "x-amz-security-token") {
		t.Errorf("the session token is not signed: %s", req.Header.Get("Authorization"))
	}
}
