// Package cloudstore is the cloud side of the hospital edge (P0-13).
//
// It owns the platform_edge schema: the registry of enrolled nodes and the
// idempotent landing table for operations forwarded after a connectivity gap.
//
// The design point is that reconciliation is the cloud's job to make safe. The
// edge retries blindly — it cannot know whether an acknowledgement was lost —
// so the cloud must absorb a duplicate without a second side effect.
package cloudstore

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Node lifecycle states.
const (
	NodePending   = "pending"
	NodeEnrolled  = "enrolled"
	NodeSuspended = "suspended"
	NodeRevoked   = "revoked"
)

// Ingest outcomes.
const (
	OutcomeApplied   = "applied"
	OutcomeDuplicate = "duplicate"
	OutcomeRejected  = "rejected"
)

// Store adapts the edge registry onto PostgreSQL.
type Store struct {
	tx *pgtx.Manager
}

// New constructs a Store.
func New(tx *pgtx.Manager) *Store { return &Store{tx: tx} }

func (s *Store) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(s.tx.Querier(ctx))
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

// Node is an enrolled edge device.
type Node struct {
	ID          string
	TenantID    string
	FacilityID  string
	DisplayName string
	Status      string
	Version     int64
}

// RegisterNode creates a node in PENDING. It does not become usable until an
// enrollment token is redeemed, so registering one is not itself a grant.
func (s *Store) RegisterNode(ctx context.Context, scope authctx.TenantScope, nodeID, facilityID, displayName string, now time.Time) (Node, error) {
	if scope.IsZero() {
		return Node{}, rpcerr.Internal("EDGE_TENANT_SCOPE_MISSING", "tenant scope is required")
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return Node{}, rpcerr.Internal("EDGE_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	nodeUUID, err := uuid.Parse(nodeID)
	if err != nil {
		return Node{}, rpcerr.Internal("EDGE_NODE_ID_INVALID", "node_id must be a UUID").WithCause(err)
	}
	facilityUUID, err := uuid.Parse(facilityID)
	if err != nil {
		return Node{}, rpcerr.Invalid("EDGE_FACILITY_INVALID", "facility is not valid",
			rpcerr.FieldViolation{Field: "facility_id", Reason: "MUST_BE_UUID"})
	}

	if err := s.queries(ctx).InsertEdgeNode(ctx, sqlcgen.InsertEdgeNodeParams{
		NodeID:      nodeUUID,
		TenantID:    tenantUUID,
		FacilityID:  facilityUUID,
		DisplayName: displayName,
		Status:      NodePending,
		CreatedAt:   timestamptz(now),
		UpdatedAt:   timestamptz(now),
	}); err != nil {
		return Node{}, err
	}

	return Node{
		ID: nodeID, TenantID: scope.TenantID(), FacilityID: facilityID,
		DisplayName: displayName, Status: NodePending, Version: 1,
	}, nil
}

// ErrEnrollmentValidityTooLong reports a token that would stay redeemable for
// longer than a commissioning visit.
var ErrEnrollmentValidityTooLong = errors.New("edge: enrollment token validity exceeds the maximum")

// IssueEnrollmentToken stores the hash of a one-time token.
//
// Only the hash is persisted. A token readable from the database would be a
// credential for anyone with read access to it, including a backup.
//
// Takes an EnrollmentToken rather than a string, so the value is one this
// package minted from crypto/rand. The stored form is an unsalted SHA-256,
// which is the correct construction for a high-entropy random value and the
// wrong one for anything a human chose.
func (s *Store) IssueEnrollmentToken(ctx context.Context, scope authctx.TenantScope, nodeID string, token EnrollmentToken, expiresAt, now time.Time) error {
	if scope.IsZero() {
		return rpcerr.Internal("EDGE_TENANT_SCOPE_MISSING", "tenant scope is required")
	}
	if token.IsZero() {
		return ErrWeakEnrollmentToken
	}
	if !expiresAt.After(now) {
		return ErrEnrollmentRejected
	}
	if expiresAt.Sub(now) > MaxEnrollmentValidity {
		return ErrEnrollmentValidityTooLong
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return rpcerr.Internal("EDGE_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	nodeUUID, err := uuid.Parse(nodeID)
	if err != nil {
		return rpcerr.Internal("EDGE_NODE_ID_INVALID", "node_id must be a UUID").WithCause(err)
	}

	return s.queries(ctx).InsertEnrollmentToken(ctx, sqlcgen.InsertEnrollmentTokenParams{
		TokenHash: token.hash(),
		NodeID:    nodeUUID,
		TenantID:  tenantUUID,
		ExpiresAt: timestamptz(expiresAt),
		CreatedAt: timestamptz(now),
	})
}

// ErrEnrollmentRejected reports a token that cannot be redeemed.
var ErrEnrollmentRejected = errors.New("edge: enrollment rejected")

// RedeemEnrollmentToken consumes a one-time token and enrolls the node.
//
// The consume and the enrollment commit together, and the UPDATE only matches
// an unconsumed, unexpired token. Two nodes racing the same token therefore
// cannot both enrol: the second UPDATE matches nothing.
func (s *Store) RedeemEnrollmentToken(ctx context.Context, token EnrollmentToken,
	fingerprint PeerFingerprint, now time.Time) (Node, error) {

	if token.IsZero() {
		return Node{}, ErrEnrollmentRejected
	}
	// A node enrolled without a credential could never authenticate again, and
	// the row would sit in the registry looking enrolled.
	if fingerprint.IsZero() {
		return Node{}, ErrNoPeerCertificate
	}

	var node Node

	err := s.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := s.queries(ctx)

		rows, err := q.ConsumeEnrollmentToken(ctx, sqlcgen.ConsumeEnrollmentTokenParams{
			ConsumedAt: timestamptz(now),
			TokenHash:  token.hash(),
			Now:        timestamptz(now),
		})
		if err != nil {
			return err
		}
		if rows == 0 {
			// Unknown, already used or expired. The caller is told nothing
			// more: distinguishing them would help an attacker enumerate.
			return ErrEnrollmentRejected
		}

		row, err := q.GetEnrollmentTokenNode(ctx, token.hash())
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrEnrollmentRejected
		}
		if err != nil {
			return err
		}

		enrolled, err := q.EnrollEdgeNode(ctx, sqlcgen.EnrollEdgeNodeParams{
			CredentialFingerprint: fingerprint.String(),
			EnrolledAt:            timestamptz(now),
			UpdatedAt:             timestamptz(now),
			NodeID:                row.NodeID,
			TenantID:              row.TenantID,
		})
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrEnrollmentRejected
		}
		if err != nil {
			return err
		}

		node = Node{
			ID:          enrolled.NodeID.String(),
			TenantID:    enrolled.TenantID.String(),
			FacilityID:  enrolled.FacilityID.String(),
			DisplayName: enrolled.DisplayName,
			Status:      enrolled.Status,
			Version:     enrolled.Version,
		}
		return nil
	})
	if err != nil {
		return Node{}, err
	}
	return node, nil
}

// IngestResult reports what happened to a forwarded operation.
type IngestResult struct {
	Outcome string
	Reason  string
}

// ErrNodeNotAuthenticated reports a credential that matches no enrolled node.
var ErrNodeNotAuthenticated = errors.New("edge: node credential not recognised")

// AuthenticateNode resolves an enrolled node from the credential it presents.
//
// This is the check that makes credential_fingerprint a control rather than a
// decorative column. node_id and tenant_id are non-secret UUIDs that appear in
// logs and manifests; possession of the credential is the only thing that
// distinguishes the real node from anyone who has seen its identifiers.
//
// The fingerprint can only be constructed from a certificate the peer actually
// presented (see PeerFingerprint), so a transport that reached for a header or
// a request field instead would not compile. That mistake would turn node
// authentication into "tell us who you are", and it is exactly the mistake the
// non-secret identifiers in the request invite.
func (s *Store) AuthenticateNode(ctx context.Context, fingerprint PeerFingerprint) (Node, error) {
	if fingerprint.IsZero() {
		return Node{}, ErrNodeNotAuthenticated
	}

	row, err := s.queries(ctx).GetEdgeNodeByFingerprint(ctx, fingerprint.String())
	if errors.Is(err, pgx.ErrNoRows) {
		// Deliberately indistinguishable from a suspended or revoked node: a
		// caller probing credentials learns nothing either way.
		return Node{}, ErrNodeNotAuthenticated
	}
	if err != nil {
		return Node{}, err
	}

	return Node{
		ID:          row.NodeID.String(),
		TenantID:    row.TenantID.String(),
		FacilityID:  row.FacilityID.String(),
		DisplayName: row.DisplayName,
		Status:      row.Status,
		Version:     row.Version,
	}, nil
}

// IngestFromNode accepts an operation from a node authenticated by credential.
//
// This is the entry point the edge uplink transport must use. It derives both
// the node and the tenant from the presented credential, so a node cannot name
// a tenant it does not belong to — the identifiers in the request are never
// consulted for authorization.
func (s *Store) IngestFromNode(ctx context.Context, fingerprint PeerFingerprint,
	operationID, operationType string,
	payload json.RawMessage, occurredAt, now time.Time) (IngestResult, error) {

	node, err := s.AuthenticateNode(ctx, fingerprint)
	if err != nil {
		return IngestResult{}, err
	}

	scope := authctx.NewSession(authctx.Session{
		SubjectID: "edge-node:" + node.ID,
		TenantID:  node.TenantID,
	}).TenantScope()

	return s.Ingest(ctx, scope, node.ID, operationID, operationType, payload, occurredAt, now)
}

// Ingest accepts one operation forwarded from an edge node.
//
// It is idempotent on (node_id, operation_id): a redelivery is recorded as a
// duplicate and produces no second effect. This is what makes the edge's blind
// retry safe.
//
// The tenant comes from an authctx.TenantScope, not from the node's own claim.
// A node reports its identifiers; it does not get to name the tenant it writes
// into (ADR-W0-001).
//
// This method authenticates the *session* carrying the operation. A node
// forwarding on its own behalf must come through IngestFromNode, which
// authenticates the node's credential first and derives the tenant from it.
func (s *Store) Ingest(ctx context.Context, scope authctx.TenantScope,
	nodeID, operationID, operationType string,
	payload json.RawMessage, occurredAt, now time.Time) (IngestResult, error) {

	if scope.IsZero() {
		return IngestResult{}, rpcerr.Internal("EDGE_TENANT_SCOPE_MISSING", "tenant scope is required")
	}
	nodeUUID, err := uuid.Parse(nodeID)
	if err != nil {
		return IngestResult{}, rpcerr.Internal("EDGE_NODE_ID_INVALID", "node_id must be a UUID").WithCause(err)
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return IngestResult{}, rpcerr.Internal("EDGE_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	operationUUID, err := uuid.Parse(operationID)
	if err != nil {
		return IngestResult{}, rpcerr.Invalid("EDGE_OPERATION_INVALID", "operation is not valid",
			rpcerr.FieldViolation{Field: "operation_id", Reason: "MUST_BE_UUID"})
	}

	var result IngestResult
	err = s.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := s.queries(ctx)

		// An operation is only accepted from a node that is currently enrolled
		// for that tenant. A revoked node's queued backlog must not be able to
		// write after revocation.
		node, err := q.GetEdgeNode(ctx, sqlcgen.GetEdgeNodeParams{
			TenantID: tenantUUID,
			NodeID:   nodeUUID,
		})
		if errors.Is(err, pgx.ErrNoRows) {
			return rpcerr.PermissionDenied("EDGE_NODE_NOT_ENROLLED", "node is not enrolled")
		}
		if err != nil {
			return err
		}
		if node.Status != NodeEnrolled {
			result = IngestResult{Outcome: OutcomeRejected, Reason: "NODE_" + node.Status}
			return q.InsertForwardedOperation(ctx, sqlcgen.InsertForwardedOperationParams{
				NodeID:        nodeUUID,
				OperationID:   operationUUID,
				TenantID:      tenantUUID,
				OperationType: operationType,
				Payload:       payload,
				OccurredAt:    timestamptz(occurredAt),
				ReceivedAt:    timestamptz(now),
				Outcome:       OutcomeRejected,
				RejectReason:  result.Reason,
			})
		}

		if len(payload) == 0 {
			payload = json.RawMessage(`{}`)
		}

		rows, err := q.TryInsertForwardedOperation(ctx, sqlcgen.TryInsertForwardedOperationParams{
			NodeID:        nodeUUID,
			OperationID:   operationUUID,
			TenantID:      tenantUUID,
			OperationType: operationType,
			Payload:       payload,
			OccurredAt:    timestamptz(occurredAt),
			ReceivedAt:    timestamptz(now),
			Outcome:       OutcomeApplied,
		})
		if err != nil {
			return err
		}
		if rows == 0 {
			result = IngestResult{Outcome: OutcomeDuplicate}
			return nil
		}

		result = IngestResult{Outcome: OutcomeApplied}
		return q.TouchEdgeNode(ctx, sqlcgen.TouchEdgeNodeParams{
			LastSeenAt: timestamptz(now),
			NodeID:     nodeUUID,
			TenantID:   tenantUUID,
		})
	})
	if err != nil {
		return IngestResult{}, err
	}
	return result, nil
}

// RevokeNode disables a node. Its queued operations are refused from then on.
func (s *Store) RevokeNode(ctx context.Context, scope authctx.TenantScope, nodeID string, now time.Time) error {
	if scope.IsZero() {
		return rpcerr.Internal("EDGE_TENANT_SCOPE_MISSING", "tenant scope is required")
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return rpcerr.Internal("EDGE_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	nodeUUID, err := uuid.Parse(nodeID)
	if err != nil {
		return rpcerr.NotFound("EDGE_NODE_NOT_FOUND", "node not found")
	}

	rows, err := s.queries(ctx).SetEdgeNodeStatus(ctx, sqlcgen.SetEdgeNodeStatusParams{
		Status:    NodeRevoked,
		UpdatedAt: timestamptz(now),
		NodeID:    nodeUUID,
		TenantID:  tenantUUID,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.NotFound("EDGE_NODE_NOT_FOUND", "node not found")
	}
	return nil
}
