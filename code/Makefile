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
	buf breaking --against '.git#branch=main,subdir=code'

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

.PHONY: ci
ci: lint test-fitness test ## Everything CI runs
