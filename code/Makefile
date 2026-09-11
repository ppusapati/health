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

.PHONY: manifests-validate
manifests-validate: ## Render and schema-validate every overlay
	@for env in dev preprod prod; do \
		printf '%-9s ' "$$env"; \
		kustomize build infra/k8s/overlays/$$env | \
			kubeconform -strict -summary -schema-location default || exit 1; \
	done

.PHONY: test-migrations
test-migrations: ## Schema change invariants (expand/contract, notes, partitioning)
	go test ./tools/migrations/ -count=1

.PHONY: test-security
test-security: ## Security registers: risk acceptances, threat model actions, pentest gate
	go test ./tools/security/ -count=1

.PHONY: release-gate
release-gate: ## Production release gate, including the penetration test check
	RELEASE_CHANNEL=production go test ./tools/security/ -count=1 -v

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

.PHONY: web-check
web-check: ## Type-check the web workspace
	cd apps/web && npm run check

.PHONY: web-test
web-test: ## Run web workspace tests
	cd apps/web && npm test

.PHONY: mobile-get
mobile-get: ## Install Flutter workspace dependencies
	cd apps/mobile && flutter pub get

.PHONY: mobile-analyze
mobile-analyze: ## Analyze the Flutter workspace
	cd apps/mobile && flutter analyze

.PHONY: mobile-test
mobile-test: ## Run Flutter unit and widget tests
	cd apps/mobile && flutter test

.PHONY: ci
ci: lint test-fitness test-infra test-security test-migrations test ## Everything CI runs
