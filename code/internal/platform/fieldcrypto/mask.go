package fieldcrypto

import (
	"strings"
	"unicode/utf8"
)

// Masking (SRS-DAT-012).
//
// Encryption and masking answer different questions. Encryption asks "may this
// system hold the value at all?"; masking asks "may this *viewer* see it?" —
// a receptionist confirming the last four digits of an identifier, a support
// engineer reading a log, an analyst looking at a sample.
//
// Every function here is one-way. A masked value must never be reversible by
// the code that displays it, or the mask is a display convention rather than a
// control, and someone will eventually unmask "just for debugging".

// MaskTail keeps the last n characters and replaces the rest.
//
// The common case: "confirm the last four digits". Counting runes rather than
// bytes matters because identifiers in this programme are not all ASCII, and a
// byte slice through a multi-byte character produces mojibake in the UI and,
// worse, a mask whose length leaks the original encoding.
func MaskTail(value string, n int) string {
	if value == "" {
		return ""
	}
	length := utf8.RuneCountInString(value)
	if n <= 0 || length <= n {
		// Never reveal the whole value because it happens to be short. A
		// three-character value masked to itself is not masked.
		return strings.Repeat("•", length)
	}
	runes := []rune(value)
	return strings.Repeat("•", length-n) + string(runes[length-n:])
}

// MaskEmail keeps the first character of the local part and the domain.
//
// The domain stays because it is usually the useful part for support ("is this
// the hospital address or their personal one?") and rarely identifies a person
// on its own. The local part does identify, so only its first character shows.
func MaskEmail(value string) string {
	local, domain, found := strings.Cut(value, "@")
	if !found || local == "" || domain == "" {
		// Not an address; mask it entirely rather than guessing at structure.
		return MaskTail(value, 0)
	}
	runes := []rune(local)
	return string(runes[0]) + strings.Repeat("•", len(runes)-1) + "@" + domain
}

// MaskName keeps initials.
//
// "Priya Ramaswamy" becomes "P• R•". Enough for a clinician to recognise a
// record they already have open, not enough to identify someone from a list.
func MaskName(value string) string {
	parts := strings.Fields(value)
	if len(parts) == 0 {
		return ""
	}
	masked := make([]string, 0, len(parts))
	for _, part := range parts {
		runes := []rune(part)
		masked = append(masked, string(runes[0])+strings.Repeat("•", len(runes)-1))
	}
	return strings.Join(masked, " ")
}

// Redact replaces a value entirely, keeping only whether it was present.
//
// For logs and traces. The distinction between "absent" and "present but
// hidden" is worth keeping: it is often the whole question during an incident,
// and it reveals nothing about the value itself.
func Redact(value string) string {
	if value == "" {
		return ""
	}
	return "[redacted]"
}
