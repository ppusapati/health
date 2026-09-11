# Build image for the core-hospital deployable.
#
# Two properties matter beyond "it builds": the runtime image carries no shell
# or package manager to be exploited, and the binary is stamped with its own
# provenance so a running pod can name the artifact it came from during an
# incident (SRS-SRE-DEP).

FROM golang:1.24-bookworm AS build

WORKDIR /src

# Dependencies are copied first so a source-only change does not invalidate the
# module download layer.
COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG VERSION=dev
ARG COMMIT=unknown
ARG BUILT_AT=unknown

# CGO is disabled so the result is a static binary that runs on a distroless
# base with no libc to keep patched.
RUN CGO_ENABLED=0 GOOS=linux go build \
    -trimpath \
    -ldflags "-s -w \
      -X main.version=${VERSION} \
      -X main.commit=${COMMIT} \
      -X main.builtAt=${BUILT_AT}" \
    -o /out/core ./cmd/core

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=build /out/core /core

# Distroless nonroot is UID 65532; the manifests pin the same value so a
# mismatch fails at deploy time rather than at runtime.
USER 65532:65532

EXPOSE 8080

ENTRYPOINT ["/core"]
