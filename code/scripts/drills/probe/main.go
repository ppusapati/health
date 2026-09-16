// A load generator for the rollout drill.
//
// Runs inside the cluster so the Service's virtual IP does the load balancing.
// A kubectl port-forward cannot be used: it binds to one Pod and dies with it,
// so it measures kubectl's behaviour during a rollout rather than the
// cluster's.
package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

func main() {
	target := os.Getenv("TARGET")
	seconds, _ := strconv.Atoi(os.Getenv("SECONDS"))
	if seconds == 0 {
		seconds = 60
	}

	// Authenticated, because the unauthenticated bucket is 2 requests a second
	// with a burst of 10 and this asks ten times that. An unauthenticated probe
	// measures the rate limiter, not the rollout — which is the same trap
	// DRILL-2026-001 fell into, where its "401 failures" were all 429s.
	token := os.Getenv("TOKEN")

	client := &http.Client{Timeout: 5 * time.Second}
	counts := map[string]int{}
	deadline := time.Now().Add(time.Duration(seconds) * time.Second)

	for time.Now().Before(deadline) {
		// A real request, not the readiness probe. /readyz is *supposed* to
		// answer 503 while a pod drains, so polling it would count the drain
		// working as the drain failing. This is the work a caller actually
		// asks for, and it must succeed for as long as the pod serves.
		req, reqErr := http.NewRequest(http.MethodPost, target,
			strings.NewReader("{}"))
		if reqErr != nil {
			counts["request-error"]++
			continue
		}
		req.Header.Set("Content-Type", "application/json")
		if token != "" {
			req.Header.Set("Authorization", "Bearer "+token)
		}
		resp, err := client.Do(req)
		switch {
		case err != nil:
			// Every transport failure is counted separately from an HTTP
			// error: a refused connection during a rollout is endpoint
			// removal getting it wrong, and a 503 is the application saying
			// so honestly. They are different defects.
			counts["transport-error"]++
		default:
			counts[strconv.Itoa(resp.StatusCode)]++
			resp.Body.Close()
		}
		time.Sleep(100 * time.Millisecond)
	}

	total := 0
	for _, n := range counts {
		total += n
	}
	// 429 is reported on its own line below rather than folded into the
	// failures: the platform refusing a caller that asked too fast is the rate
	// limiter working, and counting it as a dropped request would mark a
	// healthy rollout as a failure.
	fmt.Printf("RESULTS total=%d", total)
	for code, n := range counts {
		fmt.Printf(" %s=%d", code, n)
	}
	fmt.Println()
}
