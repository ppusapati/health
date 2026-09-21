package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// IngredientQuantity is how much of one ingredient a portion uses
// (SRS-DIET-008).
//
// Grams, as an integer. A recipe in kilograms to two decimal places is a
// recipe whose hundred-portion forecast is out by a few hundred grams for no
// reason anybody can find.
type IngredientQuantity struct {
	Code  string
	Name  string
	Grams int
}

// Recipe is one dish and what it takes (SRS-DIET-008).
type Recipe struct {
	Code        string
	Name        string
	Ingredients []IngredientQuantity
}

// MenuItem assigns a recipe to the trays it appears on (SRS-DIET-008).
//
// Keyed on cycle and texture, because a pureed lunch and a normal lunch are
// different dishes with different ingredients, and a forecast that ignored
// texture would order the wrong things for the patients least able to eat
// them.
type MenuItem struct {
	Cycle       MealCycle
	TextureCode string
	Recipe      Recipe
	// Portions is how many of this recipe each tray gets, which is usually
	// one and occasionally two.
	Portions int
}

// IngredientDemand is one ingredient's forecast and what was used
// (SRS-DIET-008).
//
// Two numbers, never one. SRS-DIET-008's acceptance is that the forecast is
// separable from actual consumption, and a single "variance" figure is a
// number that cannot answer whether the kitchen over-ordered or over-served.
type IngredientDemand struct {
	Code string
	Name string
	// ForecastG is what the frozen census implies.
	ForecastG int
	// ActualG is what the kitchen recorded using. Zero with
	// ActualRecorded false means nobody has counted yet, which is not the
	// same as having used none.
	ActualG        int
	ActualRecorded bool
}

// WastageG is forecast minus actual, and it is only meaningful once somebody
// has counted.
//
// Reported through a method rather than stored, so a forecast with no count
// behind it cannot read as a kitchen that wasted everything it ordered.
func (d IngredientDemand) WastageG() (int, bool) {
	if !d.ActualRecorded {
		return 0, false
	}
	return d.ForecastG - d.ActualG, true
}

// Forecast is what one service is expected to consume (SRS-DIET-008).
type Forecast struct {
	CensusID string
	// CensusVersion pins which version of the census this was computed from.
	// A reissued census changes the count, and a forecast that did not say
	// which version it came from cannot be reconciled with either.
	CensusVersion int
	Cycle         MealCycle
	ServiceDate   time.Time
	Trays         int
	Demand        []IngredientDemand
	// Unpriced counts census lines no menu item covered. Reported rather
	// than dropped: a forecast that silently ignored forty pureed trays is a
	// kitchen that runs out.
	Uncovered int
}

// ForecastIngredients works out what a frozen census will consume
// (SRS-DIET-008).
//
// Computed from the frozen census rather than the live orders, because the
// forecast has to match what the kitchen was told to cook. A forecast against
// a moving count is a purchase order nobody can check.
func ForecastIngredients(census MealCensus, menu []MenuItem) (Forecast, error) {
	if census.State == CensusDraft {
		return Forecast{}, fmt.Errorf(
			"%w: forecast from a frozen census, not a draft one",
			ErrInvalidDietetics)
	}

	byTexture := map[string][]MenuItem{}
	for _, item := range menu {
		if item.Cycle != census.Cycle {
			continue
		}
		key := strings.ToLower(strings.TrimSpace(item.TextureCode))
		byTexture[key] = append(byTexture[key], item)
	}

	totals := map[string]*IngredientDemand{}
	out := Forecast{
		CensusID: census.ID, CensusVersion: census.Version,
		Cycle: census.Cycle, ServiceDate: census.ServiceDate,
		Trays: len(census.Lines),
	}

	for _, line := range census.Lines {
		items := byTexture[strings.ToLower(strings.TrimSpace(line.TextureCode))]
		if len(items) == 0 {
			out.Uncovered++
			continue
		}
		for _, item := range items {
			portions := item.Portions
			if portions <= 0 {
				portions = 1
			}
			for _, ingredient := range item.Recipe.Ingredients {
				key := strings.ToLower(strings.TrimSpace(ingredient.Code))
				if key == "" {
					continue
				}
				if totals[key] == nil {
					totals[key] = &IngredientDemand{
						Code: ingredient.Code, Name: ingredient.Name,
					}
				}
				totals[key].ForecastG += ingredient.Grams * portions
			}
		}
	}

	for _, demand := range totals {
		out.Demand = append(out.Demand, *demand)
	}
	sort.Slice(out.Demand, func(a, b int) bool {
		return out.Demand[a].Code < out.Demand[b].Code
	})
	return out, nil
}

// Consumption is what the kitchen actually used (SRS-DIET-008).
//
// Recorded separately from the forecast and never merged into it. The two
// numbers side by side are what tells a catering manager whether the menu is
// wrong or the portioning is, and a single net figure tells them neither.
type Consumption struct {
	ID       string
	TenantID string
	CensusID string

	IngredientCode string
	ActualG        int
	Note           string

	RecordedAt time.Time
	RecordedBy string
}

// RecordConsumption counts what one ingredient actually used
// (SRS-DIET-008).
func RecordConsumption(id, tenantID, censusID, ingredientCode string,
	actualG int, note, by string, now time.Time) (Consumption, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Consumption{}, fmt.Errorf("%w: a count needs an id",
			ErrInvalidDietetics)
	case strings.TrimSpace(censusID) == "":
		return Consumption{}, fmt.Errorf(
			"%w: a count names the service it belongs to",
			ErrInvalidDietetics)
	case strings.TrimSpace(ingredientCode) == "":
		return Consumption{}, fmt.Errorf("%w: a count names its ingredient",
			ErrInvalidDietetics)
	case actualG < 0:
		return Consumption{}, fmt.Errorf("%w: a count cannot be negative",
			ErrInvalidDietetics)
	case strings.TrimSpace(by) == "":
		return Consumption{}, fmt.Errorf("%w: a count names who took it",
			ErrInvalidDietetics)
	}

	return Consumption{
		ID: id, TenantID: tenantID, CensusID: censusID,
		IngredientCode: strings.TrimSpace(ingredientCode),
		ActualG:        actualG, Note: strings.TrimSpace(note),
		RecordedAt: now.UTC(), RecordedBy: by,
	}, nil
}

// ApplyConsumption puts the counts beside the forecast (SRS-DIET-008).
//
// An ingredient counted but not forecast is added rather than dropped: it
// means the kitchen used something the menu does not know about, which is
// exactly the finding the report exists to surface.
func ApplyConsumption(forecast Forecast, counts []Consumption) Forecast {
	index := map[string]int{}
	for i, demand := range forecast.Demand {
		index[strings.ToLower(demand.Code)] = i
	}

	for _, count := range counts {
		if count.CensusID != forecast.CensusID {
			continue
		}
		key := strings.ToLower(count.IngredientCode)
		if at, known := index[key]; known {
			forecast.Demand[at].ActualG += count.ActualG
			forecast.Demand[at].ActualRecorded = true
			continue
		}
		forecast.Demand = append(forecast.Demand, IngredientDemand{
			Code: count.IngredientCode, Name: count.IngredientCode,
			ActualG: count.ActualG, ActualRecorded: true,
		})
		index[key] = len(forecast.Demand) - 1
	}

	sort.Slice(forecast.Demand, func(a, b int) bool {
		return forecast.Demand[a].Code < forecast.Demand[b].Code
	})
	return forecast
}
