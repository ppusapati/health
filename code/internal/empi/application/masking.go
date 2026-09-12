package application

import (
	"strings"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

// Field-level masking (SRS-EMPI-003, SRS-EMPI-014).
//
// "Potential duplicates are shown with confidence and protected fields masked
// by role" is a requirement about a specific, awkward screen: to decide whether
// two records are the same person, a clerk has to be shown enough of somebody
// else's record to compare it — and that somebody has not consented to being
// looked at. Masking is what makes the comparison possible without making the
// screen a directory lookup.
//
// So the masked form keeps discriminating power and removes usable detail. A
// partial phone number lets a clerk confirm the one the patient just read out;
// it does not let them call anybody. A birth year distinguishes two people with
// one name; it does not identify anybody on its own.
//
// Masking is applied in the application layer rather than the transport because
// the transport is not the place a security control may live: a second
// transport, or a background job, would not have it.

// maskedMarker replaces a hidden portion. Visible rather than blank, because a
// blank field reads as "not recorded" and a clerk would then ask the patient
// for something the system already holds.
const maskedMarker = "•••"

// maskFor returns the patient as this caller may see them.
//
// Returns a copy when masking applies, so the caller cannot accidentally write
// the masked form back over the record.
func maskFor(p *domain.Patient, unrestricted bool) (*domain.Patient, bool) {
	if unrestricted {
		return p, false
	}

	masked := *p
	masked.Demographics = maskDemographics(p.Demographics)
	return domain.Restore(p.ID(), masked), true
}

func maskDemographics(d domain.Demographics) domain.Demographics {
	out := domain.Demographics{
		// The name stays. It is what the clerk is comparing, and a masked name
		// makes the duplicate screen useless — which would push the clerk to
		// open the full record instead, disclosing more rather than less.
		Name: d.Name,
		Sex:  d.Sex,
	}

	// The birth date narrows to its year. Enough to tell two people with one
	// name apart; not enough to be an answer to a security question.
	if !d.BirthDate.IsZero() {
		out.BirthDate = domain.BirthDate{
			Date:      d.BirthDate.Date,
			Precision: domain.PrecisionYear,
		}
	}

	for _, phone := range d.Phones {
		out.Phones = append(out.Phones, domain.ContactPoint{
			System: phone.System, Use: phone.Use, Value: maskTail(phone.Value, 4),
		})
	}
	for _, email := range d.Emails {
		out.Emails = append(out.Emails, domain.ContactPoint{
			System: email.System, Use: email.Use, Value: maskEmail(email.Value),
		})
	}
	// Addresses narrow to the settlement. A street address is the field most
	// often misused, and the city is what a clerk needs to ask "is this the
	// Meera Iyer from Whitefield?".
	for _, address := range d.Addresses {
		out.Addresses = append(out.Addresses, domain.Address{
			City: address.City, District: address.District,
			State: address.State, Country: address.Country,
		})
	}
	return out
}

// maskTail keeps the last n characters, which is the part a person reads out
// to confirm a number they already know.
func maskTail(value string, n int) string {
	runes := []rune(value)
	if len(runes) <= n {
		return maskedMarker
	}
	return maskedMarker + string(runes[len(runes)-n:])
}

// maskEmail keeps the domain and the first character of the local part.
//
// The domain is what distinguishes a work address from a personal one, which
// is the comparison a clerk is making; the local part is the half that
// identifies the person.
func maskEmail(value string) string {
	at := strings.LastIndex(value, "@")
	if at <= 0 {
		return maskedMarker
	}
	local, domainPart := value[:at], value[at:]
	first := []rune(local)[:1]
	return string(first) + maskedMarker + domainPart
}
