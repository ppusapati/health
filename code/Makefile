# Unified Healthcare SaaS — implementation monorepo.
#
# Every target here is also what CI runs, so a green local run means a green
# pipeline (Blueprint §17).

SHELL := /bin/bash
GOBIN ?= $(shell go env GOPATH)/bin
export PATH := $(GOBIN):$(PATH)

# Pinned tool versions. Codegen must be deterministic: an unpinned plugin
# silently changes generated output between machines.
BUF_VERSION            := v1.47.2
PROTOC_GEN_GO_VERSION  := v1.36.6
PROTOC_GEN_CONNECT_VER := v1.18.1
SQLC_VERSION           := v1.28.0
KUSTOMIZE_VERSION      := v5.5.0
KUBECONFORM_VERSION    := v0.6.7

TEST_DATABASE_URL ?= postgres://postgres@127.0.0.1:55432/postgres?sslmode=disable

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: tools
tools: ## Install pinned code-generation tools
	go install github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION)
	go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)
	go install connectrpc.com/connect/cmd/protoc-gen-connect-go@$(PROTOC_GEN_CONNECT_VER)
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@$(SQLC_VERSION)

.PHONY: infra-tools
infra-tools: ## Install pinned manifest tooling
	go install sigs.k8s.io/kustomize/kustomize/v5@$(KUSTOMIZE_VERSION)
	go install github.com/yannh/kubeconform/cmd/kubeconform@$(KUBECONFORM_VERSION)

.PHONY: generate
generate: ## Regenerate protobuf and sqlc code
	buf generate
	sqlc generate

.PHONY: generate-check
generate-check: generate ## Fail if generated code is stale
	@if [ -n "$$(git status --porcelain gen internal/platform/sqlcgen)" ]; then \
		echo "generated code is out of date; run 'make generate' and commit the result"; \
		git --no-pager diff --stat gen internal/platform/sqlcgen; \
		exit 1; \
	fi

.PHONY: proto-lint
proto-lint: ## Lint protobuf definitions
	buf lint

.PHONY: proto-breaking
proto-breaking: ## Check protobuf backward compatibility against main
	# ../.git, not .git: buf resolves the path from this directory and the
	# repository root is one level up. With the wrong path buf cannot clone, and
	# the compatibility gate silently never runs.
	buf breaking --against '../.git#branch=main,subdir=code'

.PHONY: fmt
fmt: ## Format Go sources
	gofmt -w $$(git ls-files '*.go' | grep -v '^gen/' | grep -v 'sqlcgen/')

.PHONY: fmt-check
fmt-check: ## Fail if Go sources are unformatted
	@unformatted=$$(gofmt -l $$(git ls-files '*.go' | grep -v '^gen/' | grep -v 'sqlcgen/')); \
	if [ -n "$$unformatted" ]; then echo "unformatted files:"; echo "$$unformatted"; exit 1; fi

.PHONY: vet
vet: ## Run go vet
	go vet ./...

.PHONY: lint
lint: fmt-check vet ## Run all static checks

.PHONY: test-unit
test-unit: ## Run tests that need no database
	go test ./... -short

.PHONY: test
test: ## Run the full suite including repository integration tests
	TEST_DATABASE_URL="$(TEST_DATABASE_URL)" go test ./... -race -count=1

.PHONY: test-fitness
test-fitness: ## Run architecture fitness tests (Gate A10)
	go test ./tools/fitness/ -v -count=1

.PHONY: manifests
manifests: ## Render every Kubernetes overlay
	@for env in dev preprod prod; do \
		echo "=== $$env ==="; \
		kustomize build infra/k8s/overlays/$$env; \
	done

# Custom resources kubeconform has no schema for. Listed explicitly rather than
# passing -ignore-missing-schemas, which would also swallow a misspelled core
# kind — the exact mistake this gate exists to catch. Every entry here is
# covered by a shape invariant in tools/infra instead.
CRD_KINDS := ExternalSecret,SecretStore,ClusterPolicy

.PHONY: manifests-validate
manifests-validate: ## Render and schema-validate every overlay
	@for env in dev preprod prod; do \
		printf '%-9s ' "$$env"; \
		kustomize build infra/k8s/overlays/$$env | \
			kubeconform -strict -summary -schema-location default -skip $(CRD_KINDS) || exit 1; \
	done

.PHONY: test-contract
test-contract: ## API contract semantics: permissions and error codes (SRS-API-013)
	TEST_DATABASE_URL="$(TEST_DATABASE_URL)" go test ./internal/app/ -run Contract -count=1 -v

.PHONY: test-migrations
test-migrations: ## Schema change invariants (expand/contract, notes, partitioning)
	go test ./tools/migrations/ -count=1

.PHONY: test-security
test-security: ## Security registers: risk acceptances, threat model actions, pentest and drill gates
	go test ./tools/security/ -count=1

.PHONY: manifests-admission
manifests-admission: ## Apply every overlay to a real API server and prove pod security enforces
	@# Needs a cluster (KUBECONFIG). Not in `ci` for that reason. This is the
	@# step kubeconform cannot do: it skips ExternalSecret, SecretStore and
	@# ClusterPolicy entirely, and it cannot run admission.
	./scripts/cluster/admission-check.sh

.PHONY: drills
drills: ## Run the operational drills (SRS-SEC-002, SRS-NFR-005, SRS-NFR-016)
	@# Not part of `ci`: each one starts real PostgreSQL instances and real
	@# service processes and takes minutes. Run them before changing a runbook,
	@# the backup script or the rate limiter, and quarterly per the runbooks.
	go build -o /tmp/drill-core ./cmd/core
	DRILL_BIN=/tmp/drill-core ./scripts/drills/rotation-drill.sh
	DRILL_BIN=/tmp/drill-core ./scripts/drills/backup-drill.sh
	DRILL_BIN=/tmp/drill-core ./scripts/drills/dr-drill.sh

.PHONY: release-gate
release-gate: ## Production release gate: penetration test and severity-1 defects
	RELEASE_CHANNEL=production go test ./tools/security/ -count=1 -v

.PHONY: web-a11y
web-a11y: ## Accessibility gate (WCAG 2.2 AA)
	cd apps/web && npm run test:a11y

.PHONY: web-browsers
web-browsers: ## Cross-browser smoke suite (SRS-NFR-014)
	cd apps/web && npm run test:browsers

.PHONY: test-infra
test-infra: ## Deployment manifest invariants (no cluster required)
	go test ./tools/infra/ -count=1

.PHONY: docker-build
docker-build: ## Build the core container image
	docker build -f infra/docker/core.Dockerfile \
		--build-arg VERSION=$$(git describe --tags --always --dirty) \
		--build-arg COMMIT=$$(git rev-parse HEAD) \
		--build-arg BUILT_AT=$$(date -u +%Y-%m-%dT%H:%M:%SZ) \
		-t ghcr.io/ppusapati/health/core:local .

.PHONY: build
build: ## Build the core deployable
	go build -o bin/core ./cmd/core

.PHONY: run
run: ## Run the core service against a local database
	AUTH_MODE=dev DATABASE_URL="$(TEST_DATABASE_URL)" go run ./cmd/core

.PHONY: db-start
db-start: ## Start a local PostgreSQL cluster for tests
	./scripts/dev-postgres.sh start

.PHONY: db-stop
db-stop: ## Stop the local PostgreSQL cluster
	./scripts/dev-postgres.sh stop

.PHONY: web-install
web-install: ## Install web workspace dependencies
	cd apps/web && npm install

.PHONY: web-generate
web-generate: ## Regenerate the TypeScript client from proto/
	cd apps/web && npm run generate

.PHONY: web-generate-check
web-generate-check: web-generate ## Fail if the TypeScript client is stale
	@if [ -n "$$(git status --porcelain apps/web/src/lib/gen)" ]; then \
		echo "the web client is out of date; run 'make web-generate' and commit the result"; \
		git --no-pager diff --stat apps/web/src/lib/gen; \
		exit 1; \
	fi

.PHONY: web-check
web-check: ## Type-check the web workspace
	cd apps/web && npm run check

.PHONY: web-test
web-test: ## Run web workspace tests
	cd apps/web && npm test

.PHONY: mobile-get
mobile-get: ## Install Flutter workspace dependencies
	cd apps/mobile && flutter pub get

.PHONY: mobile-generate
mobile-generate: ## Regenerate the Dart client from proto/
	cd apps/mobile && buf generate --template buf.gen.dart.yaml

.PHONY: mobile-generate-check
mobile-generate-check: mobile-generate ## Fail if the Dart client is stale
	@if [ -n "$$(git status --porcelain apps/mobile/lib/src/gen)" ]; then \
		echo "the Dart client is out of date; run 'make mobile-generate' and commit the result"; \
		git --no-pager diff --stat apps/mobile/lib/src/gen; \
		exit 1; \
	fi

.PHONY: mobile-analyze
mobile-analyze: ## Analyze the Flutter workspace
	cd apps/mobile && flutter analyze

.PHONY: mobile-test
mobile-test: ## Run Flutter unit and widget tests
	cd apps/mobile && flutter test

.PHONY: cluster-deploy
cluster-deploy: ## Deploy the manifests to a real cluster and prove the workload runs
	./scripts/cluster/deploy-check.sh

.PHONY: drill-rollout
drill-rollout: ## DRILL-2026-004: roll the deployment under load and count what was dropped
	./scripts/drills/rollout-drill.sh

.PHONY: parity
parity: ## Web/mobile behavioural parity for the rules both clients implement
	cd apps/web && npx vitest run src/lib/parity.runner.test.ts
	cd apps/mobile && flutter test test/parity_runner_test.dart
	python3 tools/parity/compare.py

.PHONY: traceability
traceability: ## Every requirement the status doc claims is named by a test
	python3 tools/parity/traceability.py

.PHONY: ci
ci: lint test-fitness test-infra test-security test-migrations test-contract test parity traceability ## Everything CI runs
