// This is a generated file - do not edit.
//
// Generated from healthcare/materials/v1/materials.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How finely one item is identified (SRS-MAT-005, SRS-MAT-007).
class Tracking extends $pb.ProtobufEnum {
  static const Tracking TRACKING_UNSPECIFIED =
      Tracking._(0, _omitEnumNames ? '' : 'TRACKING_UNSPECIFIED');

  /// Counted. A recall on this item reaches all of it or none.
  static const Tracking TRACKING_QUANTITY =
      Tracking._(1, _omitEnumNames ? '' : 'TRACKING_QUANTITY');

  /// A manufacturing lot, which is what a supplier recall names and what an
  /// expiry belongs to.
  static const Tracking TRACKING_BATCH =
      Tracking._(2, _omitEnumNames ? '' : 'TRACKING_BATCH');

  /// One physical object. Required for an implant: a recall on one runs to a
  /// person.
  static const Tracking TRACKING_SERIAL =
      Tracking._(3, _omitEnumNames ? '' : 'TRACKING_SERIAL');

  static const $core.List<Tracking> values = <Tracking>[
    TRACKING_UNSPECIFIED,
    TRACKING_QUANTITY,
    TRACKING_BATCH,
    TRACKING_SERIAL,
  ];

  static final $core.List<Tracking?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Tracking? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Tracking._(super.value, super.name);
}

/// The order stock is recommended in (SRS-MAT-009).
class PickPolicy extends $pb.ProtobufEnum {
  static const PickPolicy PICK_POLICY_UNSPECIFIED =
      PickPolicy._(0, _omitEnumNames ? '' : 'PICK_POLICY_UNSPECIFIED');

  /// Earliest expiry first. The default for anything perishable, because the
  /// alternative throws away stock somebody could have used.
  static const PickPolicy PICK_POLICY_FEFO =
      PickPolicy._(1, _omitEnumNames ? '' : 'PICK_POLICY_FEFO');

  /// Earliest received first, for items that do not expire but deteriorate.
  static const PickPolicy PICK_POLICY_FIFO =
      PickPolicy._(2, _omitEnumNames ? '' : 'PICK_POLICY_FIFO');

  /// Chosen one at a time by a person, where the recommendation is advice.
  static const PickPolicy PICK_POLICY_SERIAL =
      PickPolicy._(3, _omitEnumNames ? '' : 'PICK_POLICY_SERIAL');

  static const $core.List<PickPolicy> values = <PickPolicy>[
    PICK_POLICY_UNSPECIFIED,
    PICK_POLICY_FEFO,
    PICK_POLICY_FIFO,
    PICK_POLICY_SERIAL,
  ];

  static final $core.List<PickPolicy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PickPolicy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PickPolicy._(super.value, super.name);
}

/// Who owns stock on the hospital's shelf (SRS-MAT-016).
class Ownership extends $pb.ProtobufEnum {
  static const Ownership OWNERSHIP_UNSPECIFIED =
      Ownership._(0, _omitEnumNames ? '' : 'OWNERSHIP_UNSPECIFIED');
  static const Ownership OWNERSHIP_HOSPITAL =
      Ownership._(1, _omitEnumNames ? '' : 'OWNERSHIP_HOSPITAL');

  /// The supplier's, held here unpaid. It becomes the hospital's at
  /// consumption, which is when the contract says a charge and a liability
  /// arise.
  static const Ownership OWNERSHIP_CONSIGNMENT =
      Ownership._(2, _omitEnumNames ? '' : 'OWNERSHIP_CONSIGNMENT');

  static const $core.List<Ownership> values = <Ownership>[
    OWNERSHIP_UNSPECIFIED,
    OWNERSHIP_HOSPITAL,
    OWNERSHIP_CONSIGNMENT,
  ];

  static final $core.List<Ownership?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Ownership? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Ownership._(super.value, super.name);
}

/// What stock in a location may be used for (SRS-MAT-006, SRS-MAT-010).
class StockStatus extends $pb.ProtobufEnum {
  static const StockStatus STOCK_STATUS_UNSPECIFIED =
      StockStatus._(0, _omitEnumNames ? '' : 'STOCK_STATUS_UNSPECIFIED');

  /// Received and not yet accepted. Counted, and never issuable.
  static const StockStatus STOCK_STATUS_QUARANTINE =
      StockStatus._(1, _omitEnumNames ? '' : 'STOCK_STATUS_QUARANTINE');
  static const StockStatus STOCK_STATUS_AVAILABLE =
      StockStatus._(2, _omitEnumNames ? '' : 'STOCK_STATUS_AVAILABLE');

  /// Left one store and not arrived at the next. A status rather than a flag,
  /// so nothing is ever nowhere.
  static const StockStatus STOCK_STATUS_IN_TRANSIT =
      StockStatus._(3, _omitEnumNames ? '' : 'STOCK_STATUS_IN_TRANSIT');

  /// Failed inspection, awaiting return or disposal. Counted, never issuable.
  static const StockStatus STOCK_STATUS_REJECTED =
      StockStatus._(4, _omitEnumNames ? '' : 'STOCK_STATUS_REJECTED');

  static const $core.List<StockStatus> values = <StockStatus>[
    STOCK_STATUS_UNSPECIFIED,
    STOCK_STATUS_QUARANTINE,
    STOCK_STATUS_AVAILABLE,
    STOCK_STATUS_IN_TRANSIT,
    STOCK_STATUS_REJECTED,
  ];

  static final $core.List<StockStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static StockStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StockStatus._(super.value, super.name);
}

/// Why stock moved (SRS-MAT-007).
class MovementKind extends $pb.ProtobufEnum {
  static const MovementKind MOVEMENT_KIND_UNSPECIFIED =
      MovementKind._(0, _omitEnumNames ? '' : 'MOVEMENT_KIND_UNSPECIFIED');
  static const MovementKind MOVEMENT_KIND_RECEIPT =
      MovementKind._(1, _omitEnumNames ? '' : 'MOVEMENT_KIND_RECEIPT');
  static const MovementKind MOVEMENT_KIND_ACCEPT =
      MovementKind._(2, _omitEnumNames ? '' : 'MOVEMENT_KIND_ACCEPT');
  static const MovementKind MOVEMENT_KIND_REJECT =
      MovementKind._(3, _omitEnumNames ? '' : 'MOVEMENT_KIND_REJECT');
  static const MovementKind MOVEMENT_KIND_ISSUE =
      MovementKind._(4, _omitEnumNames ? '' : 'MOVEMENT_KIND_ISSUE');
  static const MovementKind MOVEMENT_KIND_RETURN =
      MovementKind._(5, _omitEnumNames ? '' : 'MOVEMENT_KIND_RETURN');
  static const MovementKind MOVEMENT_KIND_TRANSFER_OUT =
      MovementKind._(6, _omitEnumNames ? '' : 'MOVEMENT_KIND_TRANSFER_OUT');
  static const MovementKind MOVEMENT_KIND_TRANSFER_IN =
      MovementKind._(7, _omitEnumNames ? '' : 'MOVEMENT_KIND_TRANSFER_IN');

  /// The only kind that creates or destroys stock without a physical event,
  /// which is why it needs an approval and a reason.
  static const MovementKind MOVEMENT_KIND_ADJUSTMENT =
      MovementKind._(8, _omitEnumNames ? '' : 'MOVEMENT_KIND_ADJUSTMENT');
  static const MovementKind MOVEMENT_KIND_CONSUMPTION =
      MovementKind._(9, _omitEnumNames ? '' : 'MOVEMENT_KIND_CONSUMPTION');
  static const MovementKind MOVEMENT_KIND_DISPOSAL =
      MovementKind._(10, _omitEnumNames ? '' : 'MOVEMENT_KIND_DISPOSAL');

  static const $core.List<MovementKind> values = <MovementKind>[
    MOVEMENT_KIND_UNSPECIFIED,
    MOVEMENT_KIND_RECEIPT,
    MOVEMENT_KIND_ACCEPT,
    MOVEMENT_KIND_REJECT,
    MOVEMENT_KIND_ISSUE,
    MOVEMENT_KIND_RETURN,
    MOVEMENT_KIND_TRANSFER_OUT,
    MOVEMENT_KIND_TRANSFER_IN,
    MOVEMENT_KIND_ADJUSTMENT,
    MOVEMENT_KIND_CONSUMPTION,
    MOVEMENT_KIND_DISPOSAL,
  ];

  static final $core.List<MovementKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static MovementKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MovementKind._(super.value, super.name);
}

/// What raised a request (SRS-MAT-001).
class RequisitionSource extends $pb.ProtobufEnum {
  static const RequisitionSource REQUISITION_SOURCE_UNSPECIFIED =
      RequisitionSource._(
          0, _omitEnumNames ? '' : 'REQUISITION_SOURCE_UNSPECIFIED');
  static const RequisitionSource REQUISITION_SOURCE_MANUAL =
      RequisitionSource._(1, _omitEnumNames ? '' : 'REQUISITION_SOURCE_MANUAL');
  static const RequisitionSource REQUISITION_SOURCE_MIN_MAX =
      RequisitionSource._(
          2, _omitEnumNames ? '' : 'REQUISITION_SOURCE_MIN_MAX');
  static const RequisitionSource REQUISITION_SOURCE_PROCEDURE =
      RequisitionSource._(
          3, _omitEnumNames ? '' : 'REQUISITION_SOURCE_PROCEDURE');
  static const RequisitionSource REQUISITION_SOURCE_REPLENISHMENT =
      RequisitionSource._(
          4, _omitEnumNames ? '' : 'REQUISITION_SOURCE_REPLENISHMENT');

  static const $core.List<RequisitionSource> values = <RequisitionSource>[
    REQUISITION_SOURCE_UNSPECIFIED,
    REQUISITION_SOURCE_MANUAL,
    REQUISITION_SOURCE_MIN_MAX,
    REQUISITION_SOURCE_PROCEDURE,
    REQUISITION_SOURCE_REPLENISHMENT,
  ];

  static final $core.List<RequisitionSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RequisitionSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RequisitionSource._(super.value, super.name);
}

/// Where a request has got to.
class RequisitionState extends $pb.ProtobufEnum {
  static const RequisitionState REQUISITION_STATE_UNSPECIFIED =
      RequisitionState._(
          0, _omitEnumNames ? '' : 'REQUISITION_STATE_UNSPECIFIED');
  static const RequisitionState REQUISITION_STATE_DRAFT =
      RequisitionState._(1, _omitEnumNames ? '' : 'REQUISITION_STATE_DRAFT');
  static const RequisitionState REQUISITION_STATE_PENDING_APPROVAL =
      RequisitionState._(
          2, _omitEnumNames ? '' : 'REQUISITION_STATE_PENDING_APPROVAL');
  static const RequisitionState REQUISITION_STATE_APPROVED =
      RequisitionState._(3, _omitEnumNames ? '' : 'REQUISITION_STATE_APPROVED');
  static const RequisitionState REQUISITION_STATE_REJECTED =
      RequisitionState._(4, _omitEnumNames ? '' : 'REQUISITION_STATE_REJECTED');
  static const RequisitionState REQUISITION_STATE_ORDERED =
      RequisitionState._(5, _omitEnumNames ? '' : 'REQUISITION_STATE_ORDERED');
  static const RequisitionState REQUISITION_STATE_CANCELLED =
      RequisitionState._(
          6, _omitEnumNames ? '' : 'REQUISITION_STATE_CANCELLED');

  static const $core.List<RequisitionState> values = <RequisitionState>[
    REQUISITION_STATE_UNSPECIFIED,
    REQUISITION_STATE_DRAFT,
    REQUISITION_STATE_PENDING_APPROVAL,
    REQUISITION_STATE_APPROVED,
    REQUISITION_STATE_REJECTED,
    REQUISITION_STATE_ORDERED,
    REQUISITION_STATE_CANCELLED,
  ];

  static final $core.List<RequisitionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static RequisitionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RequisitionState._(super.value, super.name);
}

/// What an approver said (SRS-MAT-002).
class ApprovalDecision extends $pb.ProtobufEnum {
  static const ApprovalDecision APPROVAL_DECISION_UNSPECIFIED =
      ApprovalDecision._(
          0, _omitEnumNames ? '' : 'APPROVAL_DECISION_UNSPECIFIED');
  static const ApprovalDecision APPROVAL_DECISION_APPROVED =
      ApprovalDecision._(1, _omitEnumNames ? '' : 'APPROVAL_DECISION_APPROVED');
  static const ApprovalDecision APPROVAL_DECISION_REJECTED =
      ApprovalDecision._(2, _omitEnumNames ? '' : 'APPROVAL_DECISION_REJECTED');

  static const $core.List<ApprovalDecision> values = <ApprovalDecision>[
    APPROVAL_DECISION_UNSPECIFIED,
    APPROVAL_DECISION_APPROVED,
    APPROVAL_DECISION_REJECTED,
  ];

  static final $core.List<ApprovalDecision?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ApprovalDecision? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ApprovalDecision._(super.value, super.name);
}

/// Where a purchase order has got to (SRS-MAT-004).
class PurchaseOrderState extends $pb.ProtobufEnum {
  static const PurchaseOrderState PURCHASE_ORDER_STATE_UNSPECIFIED =
      PurchaseOrderState._(
          0, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_UNSPECIFIED');
  static const PurchaseOrderState PURCHASE_ORDER_STATE_DRAFT =
      PurchaseOrderState._(
          1, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_DRAFT');
  static const PurchaseOrderState PURCHASE_ORDER_STATE_ISSUED =
      PurchaseOrderState._(
          2, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_ISSUED');
  static const PurchaseOrderState PURCHASE_ORDER_STATE_PARTLY_RECEIVED =
      PurchaseOrderState._(
          3, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_PARTLY_RECEIVED');
  static const PurchaseOrderState PURCHASE_ORDER_STATE_RECEIVED =
      PurchaseOrderState._(
          4, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_RECEIVED');
  static const PurchaseOrderState PURCHASE_ORDER_STATE_CLOSED =
      PurchaseOrderState._(
          5, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_CLOSED');
  static const PurchaseOrderState PURCHASE_ORDER_STATE_CANCELLED =
      PurchaseOrderState._(
          6, _omitEnumNames ? '' : 'PURCHASE_ORDER_STATE_CANCELLED');

  static const $core.List<PurchaseOrderState> values = <PurchaseOrderState>[
    PURCHASE_ORDER_STATE_UNSPECIFIED,
    PURCHASE_ORDER_STATE_DRAFT,
    PURCHASE_ORDER_STATE_ISSUED,
    PURCHASE_ORDER_STATE_PARTLY_RECEIVED,
    PURCHASE_ORDER_STATE_RECEIVED,
    PURCHASE_ORDER_STATE_CLOSED,
    PURCHASE_ORDER_STATE_CANCELLED,
  ];

  static final $core.List<PurchaseOrderState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PurchaseOrderState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PurchaseOrderState._(super.value, super.name);
}

/// Where a transfer has got to (SRS-MAT-010).
class TransferState extends $pb.ProtobufEnum {
  static const TransferState TRANSFER_STATE_UNSPECIFIED =
      TransferState._(0, _omitEnumNames ? '' : 'TRANSFER_STATE_UNSPECIFIED');
  static const TransferState TRANSFER_STATE_IN_TRANSIT =
      TransferState._(1, _omitEnumNames ? '' : 'TRANSFER_STATE_IN_TRANSIT');
  static const TransferState TRANSFER_STATE_RECEIVED =
      TransferState._(2, _omitEnumNames ? '' : 'TRANSFER_STATE_RECEIVED');
  static const TransferState TRANSFER_STATE_CANCELLED =
      TransferState._(3, _omitEnumNames ? '' : 'TRANSFER_STATE_CANCELLED');

  static const $core.List<TransferState> values = <TransferState>[
    TRANSFER_STATE_UNSPECIFIED,
    TRANSFER_STATE_IN_TRANSIT,
    TRANSFER_STATE_RECEIVED,
    TRANSFER_STATE_CANCELLED,
  ];

  static final $core.List<TransferState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TransferState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TransferState._(super.value, super.name);
}

/// Where a stocktake has got to (SRS-MAT-011).
class CountState extends $pb.ProtobufEnum {
  static const CountState COUNT_STATE_UNSPECIFIED =
      CountState._(0, _omitEnumNames ? '' : 'COUNT_STATE_UNSPECIFIED');
  static const CountState COUNT_STATE_OPEN =
      CountState._(1, _omitEnumNames ? '' : 'COUNT_STATE_OPEN');
  static const CountState COUNT_STATE_COUNTED =
      CountState._(2, _omitEnumNames ? '' : 'COUNT_STATE_COUNTED');
  static const CountState COUNT_STATE_APPROVED =
      CountState._(3, _omitEnumNames ? '' : 'COUNT_STATE_APPROVED');
  static const CountState COUNT_STATE_REJECTED =
      CountState._(4, _omitEnumNames ? '' : 'COUNT_STATE_REJECTED');

  static const $core.List<CountState> values = <CountState>[
    COUNT_STATE_UNSPECIFIED,
    COUNT_STATE_OPEN,
    COUNT_STATE_COUNTED,
    COUNT_STATE_APPROVED,
    COUNT_STATE_REJECTED,
  ];

  static final $core.List<CountState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CountState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CountState._(super.value, super.name);
}

/// What needs attention (SRS-MAT-012).
class AlertKind extends $pb.ProtobufEnum {
  static const AlertKind ALERT_KIND_UNSPECIFIED =
      AlertKind._(0, _omitEnumNames ? '' : 'ALERT_KIND_UNSPECIFIED');
  static const AlertKind ALERT_KIND_STOCKOUT =
      AlertKind._(1, _omitEnumNames ? '' : 'ALERT_KIND_STOCKOUT');
  static const AlertKind ALERT_KIND_BELOW_MINIMUM =
      AlertKind._(2, _omitEnumNames ? '' : 'ALERT_KIND_BELOW_MINIMUM');
  static const AlertKind ALERT_KIND_EXPIRING_SOON =
      AlertKind._(3, _omitEnumNames ? '' : 'ALERT_KIND_EXPIRING_SOON');
  static const AlertKind ALERT_KIND_EXPIRED =
      AlertKind._(4, _omitEnumNames ? '' : 'ALERT_KIND_EXPIRED');

  static const $core.List<AlertKind> values = <AlertKind>[
    ALERT_KIND_UNSPECIFIED,
    ALERT_KIND_STOCKOUT,
    ALERT_KIND_BELOW_MINIMUM,
    ALERT_KIND_EXPIRING_SOON,
    ALERT_KIND_EXPIRED,
  ];

  static final $core.List<AlertKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AlertKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlertKind._(super.value, super.name);
}

/// What a three-way match found (SRS-MAT-014).
class MatchStatus extends $pb.ProtobufEnum {
  static const MatchStatus MATCH_STATUS_UNSPECIFIED =
      MatchStatus._(0, _omitEnumNames ? '' : 'MATCH_STATUS_UNSPECIFIED');
  static const MatchStatus MATCH_STATUS_MATCHED =
      MatchStatus._(1, _omitEnumNames ? '' : 'MATCH_STATUS_MATCHED');
  static const MatchStatus MATCH_STATUS_QUANTITY_MISMATCH =
      MatchStatus._(2, _omitEnumNames ? '' : 'MATCH_STATUS_QUANTITY_MISMATCH');
  static const MatchStatus MATCH_STATUS_PRICE_MISMATCH =
      MatchStatus._(3, _omitEnumNames ? '' : 'MATCH_STATUS_PRICE_MISMATCH');

  /// An invoice line with no receipt, or a receipt with no invoice. The
  /// commonest fraud and the commonest typo.
  static const MatchStatus MATCH_STATUS_MISSING_DOCUMENT =
      MatchStatus._(4, _omitEnumNames ? '' : 'MATCH_STATUS_MISSING_DOCUMENT');

  static const $core.List<MatchStatus> values = <MatchStatus>[
    MATCH_STATUS_UNSPECIFIED,
    MATCH_STATUS_MATCHED,
    MATCH_STATUS_QUANTITY_MISMATCH,
    MATCH_STATUS_PRICE_MISMATCH,
    MATCH_STATUS_MISSING_DOCUMENT,
  ];

  static final $core.List<MatchStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MatchStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MatchStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
