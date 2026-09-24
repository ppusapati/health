// This is a generated file - do not edit.
//
// Generated from healthcare/materials/v1/materials.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pbjson.dart'
    as $0;

@$core.Deprecated('Use trackingDescriptor instead')
const Tracking$json = {
  '1': 'Tracking',
  '2': [
    {'1': 'TRACKING_UNSPECIFIED', '2': 0},
    {'1': 'TRACKING_QUANTITY', '2': 1},
    {'1': 'TRACKING_BATCH', '2': 2},
    {'1': 'TRACKING_SERIAL', '2': 3},
  ],
};

/// Descriptor for `Tracking`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackingDescriptor = $convert.base64Decode(
    'CghUcmFja2luZxIYChRUUkFDS0lOR19VTlNQRUNJRklFRBAAEhUKEVRSQUNLSU5HX1FVQU5USV'
    'RZEAESEgoOVFJBQ0tJTkdfQkFUQ0gQAhITCg9UUkFDS0lOR19TRVJJQUwQAw==');

@$core.Deprecated('Use pickPolicyDescriptor instead')
const PickPolicy$json = {
  '1': 'PickPolicy',
  '2': [
    {'1': 'PICK_POLICY_UNSPECIFIED', '2': 0},
    {'1': 'PICK_POLICY_FEFO', '2': 1},
    {'1': 'PICK_POLICY_FIFO', '2': 2},
    {'1': 'PICK_POLICY_SERIAL', '2': 3},
  ],
};

/// Descriptor for `PickPolicy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pickPolicyDescriptor = $convert.base64Decode(
    'CgpQaWNrUG9saWN5EhsKF1BJQ0tfUE9MSUNZX1VOU1BFQ0lGSUVEEAASFAoQUElDS19QT0xJQ1'
    'lfRkVGTxABEhQKEFBJQ0tfUE9MSUNZX0ZJRk8QAhIWChJQSUNLX1BPTElDWV9TRVJJQUwQAw==');

@$core.Deprecated('Use ownershipDescriptor instead')
const Ownership$json = {
  '1': 'Ownership',
  '2': [
    {'1': 'OWNERSHIP_UNSPECIFIED', '2': 0},
    {'1': 'OWNERSHIP_HOSPITAL', '2': 1},
    {'1': 'OWNERSHIP_CONSIGNMENT', '2': 2},
  ],
};

/// Descriptor for `Ownership`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ownershipDescriptor = $convert.base64Decode(
    'CglPd25lcnNoaXASGQoVT1dORVJTSElQX1VOU1BFQ0lGSUVEEAASFgoST1dORVJTSElQX0hPU1'
    'BJVEFMEAESGQoVT1dORVJTSElQX0NPTlNJR05NRU5UEAI=');

@$core.Deprecated('Use stockStatusDescriptor instead')
const StockStatus$json = {
  '1': 'StockStatus',
  '2': [
    {'1': 'STOCK_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'STOCK_STATUS_QUARANTINE', '2': 1},
    {'1': 'STOCK_STATUS_AVAILABLE', '2': 2},
    {'1': 'STOCK_STATUS_IN_TRANSIT', '2': 3},
    {'1': 'STOCK_STATUS_REJECTED', '2': 4},
  ],
};

/// Descriptor for `StockStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stockStatusDescriptor = $convert.base64Decode(
    'CgtTdG9ja1N0YXR1cxIcChhTVE9DS19TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdTVE9DS19TVE'
    'FUVVNfUVVBUkFOVElORRABEhoKFlNUT0NLX1NUQVRVU19BVkFJTEFCTEUQAhIbChdTVE9DS19T'
    'VEFUVVNfSU5fVFJBTlNJVBADEhkKFVNUT0NLX1NUQVRVU19SRUpFQ1RFRBAE');

@$core.Deprecated('Use movementKindDescriptor instead')
const MovementKind$json = {
  '1': 'MovementKind',
  '2': [
    {'1': 'MOVEMENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'MOVEMENT_KIND_RECEIPT', '2': 1},
    {'1': 'MOVEMENT_KIND_ACCEPT', '2': 2},
    {'1': 'MOVEMENT_KIND_REJECT', '2': 3},
    {'1': 'MOVEMENT_KIND_ISSUE', '2': 4},
    {'1': 'MOVEMENT_KIND_RETURN', '2': 5},
    {'1': 'MOVEMENT_KIND_TRANSFER_OUT', '2': 6},
    {'1': 'MOVEMENT_KIND_TRANSFER_IN', '2': 7},
    {'1': 'MOVEMENT_KIND_ADJUSTMENT', '2': 8},
    {'1': 'MOVEMENT_KIND_CONSUMPTION', '2': 9},
    {'1': 'MOVEMENT_KIND_DISPOSAL', '2': 10},
  ],
};

/// Descriptor for `MovementKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List movementKindDescriptor = $convert.base64Decode(
    'CgxNb3ZlbWVudEtpbmQSHQoZTU9WRU1FTlRfS0lORF9VTlNQRUNJRklFRBAAEhkKFU1PVkVNRU'
    '5UX0tJTkRfUkVDRUlQVBABEhgKFE1PVkVNRU5UX0tJTkRfQUNDRVBUEAISGAoUTU9WRU1FTlRf'
    'S0lORF9SRUpFQ1QQAxIXChNNT1ZFTUVOVF9LSU5EX0lTU1VFEAQSGAoUTU9WRU1FTlRfS0lORF'
    '9SRVRVUk4QBRIeChpNT1ZFTUVOVF9LSU5EX1RSQU5TRkVSX09VVBAGEh0KGU1PVkVNRU5UX0tJ'
    'TkRfVFJBTlNGRVJfSU4QBxIcChhNT1ZFTUVOVF9LSU5EX0FESlVTVE1FTlQQCBIdChlNT1ZFTU'
    'VOVF9LSU5EX0NPTlNVTVBUSU9OEAkSGgoWTU9WRU1FTlRfS0lORF9ESVNQT1NBTBAK');

@$core.Deprecated('Use requisitionSourceDescriptor instead')
const RequisitionSource$json = {
  '1': 'RequisitionSource',
  '2': [
    {'1': 'REQUISITION_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'REQUISITION_SOURCE_MANUAL', '2': 1},
    {'1': 'REQUISITION_SOURCE_MIN_MAX', '2': 2},
    {'1': 'REQUISITION_SOURCE_PROCEDURE', '2': 3},
    {'1': 'REQUISITION_SOURCE_REPLENISHMENT', '2': 4},
  ],
};

/// Descriptor for `RequisitionSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List requisitionSourceDescriptor = $convert.base64Decode(
    'ChFSZXF1aXNpdGlvblNvdXJjZRIiCh5SRVFVSVNJVElPTl9TT1VSQ0VfVU5TUEVDSUZJRUQQAB'
    'IdChlSRVFVSVNJVElPTl9TT1VSQ0VfTUFOVUFMEAESHgoaUkVRVUlTSVRJT05fU09VUkNFX01J'
    'Tl9NQVgQAhIgChxSRVFVSVNJVElPTl9TT1VSQ0VfUFJPQ0VEVVJFEAMSJAogUkVRVUlTSVRJT0'
    '5fU09VUkNFX1JFUExFTklTSE1FTlQQBA==');

@$core.Deprecated('Use requisitionStateDescriptor instead')
const RequisitionState$json = {
  '1': 'RequisitionState',
  '2': [
    {'1': 'REQUISITION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'REQUISITION_STATE_DRAFT', '2': 1},
    {'1': 'REQUISITION_STATE_PENDING_APPROVAL', '2': 2},
    {'1': 'REQUISITION_STATE_APPROVED', '2': 3},
    {'1': 'REQUISITION_STATE_REJECTED', '2': 4},
    {'1': 'REQUISITION_STATE_ORDERED', '2': 5},
    {'1': 'REQUISITION_STATE_CANCELLED', '2': 6},
  ],
};

/// Descriptor for `RequisitionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List requisitionStateDescriptor = $convert.base64Decode(
    'ChBSZXF1aXNpdGlvblN0YXRlEiEKHVJFUVVJU0lUSU9OX1NUQVRFX1VOU1BFQ0lGSUVEEAASGw'
    'oXUkVRVUlTSVRJT05fU1RBVEVfRFJBRlQQARImCiJSRVFVSVNJVElPTl9TVEFURV9QRU5ESU5H'
    'X0FQUFJPVkFMEAISHgoaUkVRVUlTSVRJT05fU1RBVEVfQVBQUk9WRUQQAxIeChpSRVFVSVNJVE'
    'lPTl9TVEFURV9SRUpFQ1RFRBAEEh0KGVJFUVVJU0lUSU9OX1NUQVRFX09SREVSRUQQBRIfChtS'
    'RVFVSVNJVElPTl9TVEFURV9DQU5DRUxMRUQQBg==');

@$core.Deprecated('Use approvalDecisionDescriptor instead')
const ApprovalDecision$json = {
  '1': 'ApprovalDecision',
  '2': [
    {'1': 'APPROVAL_DECISION_UNSPECIFIED', '2': 0},
    {'1': 'APPROVAL_DECISION_APPROVED', '2': 1},
    {'1': 'APPROVAL_DECISION_REJECTED', '2': 2},
  ],
};

/// Descriptor for `ApprovalDecision`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List approvalDecisionDescriptor = $convert.base64Decode(
    'ChBBcHByb3ZhbERlY2lzaW9uEiEKHUFQUFJPVkFMX0RFQ0lTSU9OX1VOU1BFQ0lGSUVEEAASHg'
    'oaQVBQUk9WQUxfREVDSVNJT05fQVBQUk9WRUQQARIeChpBUFBST1ZBTF9ERUNJU0lPTl9SRUpF'
    'Q1RFRBAC');

@$core.Deprecated('Use purchaseOrderStateDescriptor instead')
const PurchaseOrderState$json = {
  '1': 'PurchaseOrderState',
  '2': [
    {'1': 'PURCHASE_ORDER_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PURCHASE_ORDER_STATE_DRAFT', '2': 1},
    {'1': 'PURCHASE_ORDER_STATE_ISSUED', '2': 2},
    {'1': 'PURCHASE_ORDER_STATE_PARTLY_RECEIVED', '2': 3},
    {'1': 'PURCHASE_ORDER_STATE_RECEIVED', '2': 4},
    {'1': 'PURCHASE_ORDER_STATE_CLOSED', '2': 5},
    {'1': 'PURCHASE_ORDER_STATE_CANCELLED', '2': 6},
  ],
};

/// Descriptor for `PurchaseOrderState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List purchaseOrderStateDescriptor = $convert.base64Decode(
    'ChJQdXJjaGFzZU9yZGVyU3RhdGUSJAogUFVSQ0hBU0VfT1JERVJfU1RBVEVfVU5TUEVDSUZJRU'
    'QQABIeChpQVVJDSEFTRV9PUkRFUl9TVEFURV9EUkFGVBABEh8KG1BVUkNIQVNFX09SREVSX1NU'
    'QVRFX0lTU1VFRBACEigKJFBVUkNIQVNFX09SREVSX1NUQVRFX1BBUlRMWV9SRUNFSVZFRBADEi'
    'EKHVBVUkNIQVNFX09SREVSX1NUQVRFX1JFQ0VJVkVEEAQSHwobUFVSQ0hBU0VfT1JERVJfU1RB'
    'VEVfQ0xPU0VEEAUSIgoeUFVSQ0hBU0VfT1JERVJfU1RBVEVfQ0FOQ0VMTEVEEAY=');

@$core.Deprecated('Use transferStateDescriptor instead')
const TransferState$json = {
  '1': 'TransferState',
  '2': [
    {'1': 'TRANSFER_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TRANSFER_STATE_IN_TRANSIT', '2': 1},
    {'1': 'TRANSFER_STATE_RECEIVED', '2': 2},
    {'1': 'TRANSFER_STATE_CANCELLED', '2': 3},
  ],
};

/// Descriptor for `TransferState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transferStateDescriptor = $convert.base64Decode(
    'Cg1UcmFuc2ZlclN0YXRlEh4KGlRSQU5TRkVSX1NUQVRFX1VOU1BFQ0lGSUVEEAASHQoZVFJBTl'
    'NGRVJfU1RBVEVfSU5fVFJBTlNJVBABEhsKF1RSQU5TRkVSX1NUQVRFX1JFQ0VJVkVEEAISHAoY'
    'VFJBTlNGRVJfU1RBVEVfQ0FOQ0VMTEVEEAM=');

@$core.Deprecated('Use countStateDescriptor instead')
const CountState$json = {
  '1': 'CountState',
  '2': [
    {'1': 'COUNT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'COUNT_STATE_OPEN', '2': 1},
    {'1': 'COUNT_STATE_COUNTED', '2': 2},
    {'1': 'COUNT_STATE_APPROVED', '2': 3},
    {'1': 'COUNT_STATE_REJECTED', '2': 4},
  ],
};

/// Descriptor for `CountState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List countStateDescriptor = $convert.base64Decode(
    'CgpDb3VudFN0YXRlEhsKF0NPVU5UX1NUQVRFX1VOU1BFQ0lGSUVEEAASFAoQQ09VTlRfU1RBVE'
    'VfT1BFThABEhcKE0NPVU5UX1NUQVRFX0NPVU5URUQQAhIYChRDT1VOVF9TVEFURV9BUFBST1ZF'
    'RBADEhgKFENPVU5UX1NUQVRFX1JFSkVDVEVEEAQ=');

@$core.Deprecated('Use alertKindDescriptor instead')
const AlertKind$json = {
  '1': 'AlertKind',
  '2': [
    {'1': 'ALERT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ALERT_KIND_STOCKOUT', '2': 1},
    {'1': 'ALERT_KIND_BELOW_MINIMUM', '2': 2},
    {'1': 'ALERT_KIND_EXPIRING_SOON', '2': 3},
    {'1': 'ALERT_KIND_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `AlertKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alertKindDescriptor = $convert.base64Decode(
    'CglBbGVydEtpbmQSGgoWQUxFUlRfS0lORF9VTlNQRUNJRklFRBAAEhcKE0FMRVJUX0tJTkRfU1'
    'RPQ0tPVVQQARIcChhBTEVSVF9LSU5EX0JFTE9XX01JTklNVU0QAhIcChhBTEVSVF9LSU5EX0VY'
    'UElSSU5HX1NPT04QAxIWChJBTEVSVF9LSU5EX0VYUElSRUQQBA==');

@$core.Deprecated('Use matchStatusDescriptor instead')
const MatchStatus$json = {
  '1': 'MatchStatus',
  '2': [
    {'1': 'MATCH_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MATCH_STATUS_MATCHED', '2': 1},
    {'1': 'MATCH_STATUS_QUANTITY_MISMATCH', '2': 2},
    {'1': 'MATCH_STATUS_PRICE_MISMATCH', '2': 3},
    {'1': 'MATCH_STATUS_MISSING_DOCUMENT', '2': 4},
  ],
};

/// Descriptor for `MatchStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List matchStatusDescriptor = $convert.base64Decode(
    'CgtNYXRjaFN0YXR1cxIcChhNQVRDSF9TVEFUVVNfVU5TUEVDSUZJRUQQABIYChRNQVRDSF9TVE'
    'FUVVNfTUFUQ0hFRBABEiIKHk1BVENIX1NUQVRVU19RVUFOVElUWV9NSVNNQVRDSBACEh8KG01B'
    'VENIX1NUQVRVU19QUklDRV9NSVNNQVRDSBADEiEKHU1BVENIX1NUQVRVU19NSVNTSU5HX0RPQ1'
    'VNRU5UEAQ=');

@$core.Deprecated('Use moneyDescriptor instead')
const Money$json = {
  '1': 'Money',
  '2': [
    {'1': 'minor', '3': 1, '4': 1, '5': 3, '10': 'minor'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `Money`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyDescriptor = $convert.base64Decode(
    'CgVNb25leRIUCgVtaW5vchgBIAEoA1IFbWlub3ISGgoIY3VycmVuY3kYAiABKAlSCGN1cnJlbm'
    'N5');

@$core.Deprecated('Use bucketDescriptor instead')
const Bucket$json = {
  '1': 'Bucket',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.StockStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `Bucket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bucketDescriptor = $convert.base64Decode(
    'CgZCdWNrZXQSHwoLbG9jYXRpb25faWQYASABKAlSCmxvY2F0aW9uSWQSPAoGc3RhdHVzGAIgAS'
    'gOMiQuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuU3RvY2tTdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use itemDescriptor instead')
const Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
    {'1': 'category', '3': 4, '4': 1, '5': 9, '10': 'category'},
    {'1': 'uom', '3': 5, '4': 1, '5': 9, '10': 'uom'},
    {
      '1': 'tracking',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.Tracking',
      '10': 'tracking'
    },
    {
      '1': 'policy',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.PickPolicy',
      '10': 'policy'
    },
    {'1': 'perishable', '3': 8, '4': 1, '5': 8, '10': 'perishable'},
    {
      '1': 'inspect_on_receipt',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'inspectOnReceipt'
    },
    {'1': 'consignable', '3': 10, '4': 1, '5': 8, '10': 'consignable'},
    {'1': 'active', '3': 11, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 13, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDescriptor = $convert.base64Decode(
    'CgRJdGVtEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBISCgRjb2RlGAIgASgJUgRjb2RlEhgKB2'
    'Rpc3BsYXkYAyABKAlSB2Rpc3BsYXkSGgoIY2F0ZWdvcnkYBCABKAlSCGNhdGVnb3J5EhAKA3Vv'
    'bRgFIAEoCVIDdW9tEj0KCHRyYWNraW5nGAYgASgOMiEuaGVhbHRoY2FyZS5tYXRlcmlhbHMudj'
    'EuVHJhY2tpbmdSCHRyYWNraW5nEjsKBnBvbGljeRgHIAEoDjIjLmhlYWx0aGNhcmUubWF0ZXJp'
    'YWxzLnYxLlBpY2tQb2xpY3lSBnBvbGljeRIeCgpwZXJpc2hhYmxlGAggASgIUgpwZXJpc2hhYm'
    'xlEiwKEmluc3BlY3Rfb25fcmVjZWlwdBgJIAEoCFIQaW5zcGVjdE9uUmVjZWlwdBIgCgtjb25z'
    'aWduYWJsZRgKIAEoCFILY29uc2lnbmFibGUSFgoGYWN0aXZlGAsgASgIUgZhY3RpdmUSOQoKY3'
    'JlYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBId'
    'CgpjcmVhdGVkX2J5GA0gASgJUgljcmVhdGVkQnkSGAoHdmVyc2lvbhgOIAEoA1IHdmVyc2lvbg'
    '==');

@$core.Deprecated('Use supplierDescriptor instead')
const Supplier$json = {
  '1': 'Supplier',
  '2': [
    {'1': 'supplier_id', '3': 1, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
    {'1': 'approved', '3': 4, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'contact_email', '3': 5, '4': 1, '5': 9, '10': 'contactEmail'},
    {'1': 'contact_phone', '3': 6, '4': 1, '5': 9, '10': 'contactPhone'},
    {
      '1': 'payment_terms_days',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 10, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 11, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Supplier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List supplierDescriptor = $convert.base64Decode(
    'CghTdXBwbGllchIfCgtzdXBwbGllcl9pZBgBIAEoCVIKc3VwcGxpZXJJZBISCgRjb2RlGAIgAS'
    'gJUgRjb2RlEhgKB2Rpc3BsYXkYAyABKAlSB2Rpc3BsYXkSGgoIYXBwcm92ZWQYBCABKAhSCGFw'
    'cHJvdmVkEiMKDWNvbnRhY3RfZW1haWwYBSABKAlSDGNvbnRhY3RFbWFpbBIjCg1jb250YWN0X3'
    'Bob25lGAYgASgJUgxjb250YWN0UGhvbmUSLAoScGF5bWVudF90ZXJtc19kYXlzGAcgASgFUhBw'
    'YXltZW50VGVybXNEYXlzEhoKCGN1cnJlbmN5GAggASgJUghjdXJyZW5jeRI5CgpjcmVhdGVkX2'
    'F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0Eh0KCmNyZWF0'
    'ZWRfYnkYCiABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJzaW9uGAsgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use lotDescriptor instead')
const Lot$json = {
  '1': 'Lot',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'expiry',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiry'
    },
    {
      '1': 'received_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {
      '1': 'ownership',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.Ownership',
      '10': 'ownership'
    },
    {'1': 'supplier_id', '3': 7, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'blocked', '3': 8, '4': 1, '5': 8, '10': 'blocked'},
    {'1': 'blocked_reason', '3': 9, '4': 1, '5': 9, '10': 'blockedReason'},
    {
      '1': 'blocked_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'blockedAt'
    },
    {'1': 'blocked_by', '3': 11, '4': 1, '5': 9, '10': 'blockedBy'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
    {'1': 'issuable', '3': 13, '4': 1, '5': 8, '10': 'issuable'},
  ],
};

/// Descriptor for `Lot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lotDescriptor = $convert.base64Decode(
    'CgNMb3QSFQoGbG90X2lkGAEgASgJUgVsb3RJZBIXCgdpdGVtX2lkGAIgASgJUgZpdGVtSWQSEg'
    'oEY29kZRgDIAEoCVIEY29kZRIyCgZleHBpcnkYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgZleHBpcnkSOwoLcmVjZWl2ZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgpyZWNlaXZlZEF0EkAKCW93bmVyc2hpcBgGIAEoDjIiLmhlYWx0aGNhcmUubWF0'
    'ZXJpYWxzLnYxLk93bmVyc2hpcFIJb3duZXJzaGlwEh8KC3N1cHBsaWVyX2lkGAcgASgJUgpzdX'
    'BwbGllcklkEhgKB2Jsb2NrZWQYCCABKAhSB2Jsb2NrZWQSJQoOYmxvY2tlZF9yZWFzb24YCSAB'
    'KAlSDWJsb2NrZWRSZWFzb24SOQoKYmxvY2tlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCWJsb2NrZWRBdBIdCgpibG9ja2VkX2J5GAsgASgJUglibG9ja2VkQnkSGAoH'
    'dmVyc2lvbhgMIAEoA1IHdmVyc2lvbhIaCghpc3N1YWJsZRgNIAEoCFIIaXNzdWFibGU=');

@$core.Deprecated('Use movementDescriptor instead')
const Movement$json = {
  '1': 'Movement',
  '2': [
    {'1': 'movement_id', '3': 1, '4': 1, '5': 9, '10': 'movementId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'lot_id', '3': 3, '4': 1, '5': 9, '10': 'lotId'},
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Bucket',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Bucket',
      '10': 'to'
    },
    {'1': 'quantity', '3': 6, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'kind',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.MovementKind',
      '10': 'kind'
    },
    {'1': 'reference', '3': 8, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'cost_centre', '3': 10, '4': 1, '5': 9, '10': 'costCentre'},
    {'1': 'patient_id', '3': 11, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 12, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'occurred_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'recorded_by', '3': 14, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `Movement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List movementDescriptor = $convert.base64Decode(
    'CghNb3ZlbWVudBIfCgttb3ZlbWVudF9pZBgBIAEoCVIKbW92ZW1lbnRJZBIXCgdpdGVtX2lkGA'
    'IgASgJUgZpdGVtSWQSFQoGbG90X2lkGAMgASgJUgVsb3RJZBIzCgRmcm9tGAQgASgLMh8uaGVh'
    'bHRoY2FyZS5tYXRlcmlhbHMudjEuQnVja2V0UgRmcm9tEi8KAnRvGAUgASgLMh8uaGVhbHRoY2'
    'FyZS5tYXRlcmlhbHMudjEuQnVja2V0UgJ0bxIaCghxdWFudGl0eRgGIAEoBVIIcXVhbnRpdHkS'
    'OQoEa2luZBgHIAEoDjIlLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLk1vdmVtZW50S2luZFIEa2'
    'luZBIcCglyZWZlcmVuY2UYCCABKAlSCXJlZmVyZW5jZRIWCgZyZWFzb24YCSABKAlSBnJlYXNv'
    'bhIfCgtjb3N0X2NlbnRyZRgKIAEoCVIKY29zdENlbnRyZRIdCgpwYXRpZW50X2lkGAsgASgJUg'
    'lwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAwgASgJUgtlbmNvdW50ZXJJZBI7CgtvY2N1cnJl'
    'ZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQSHwoLcm'
    'Vjb3JkZWRfYnkYDiABKAlSCnJlY29yZGVkQnk=');

@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = {
  '1': 'Balance',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'lot_id', '3': 2, '4': 1, '5': 9, '10': 'lotId'},
    {
      '1': 'bucket',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Bucket',
      '10': 'bucket'
    },
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode(
    'CgdCYWxhbmNlEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIVCgZsb3RfaWQYAiABKAlSBWxvdE'
    'lkEjcKBmJ1Y2tldBgDIAEoCzIfLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkJ1Y2tldFIGYnVj'
    'a2V0EhoKCHF1YW50aXR5GAQgASgFUghxdWFudGl0eQ==');

@$core.Deprecated('Use stockLevelDescriptor instead')
const StockLevel$json = {
  '1': 'StockLevel',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'minimum', '3': 3, '4': 1, '5': 5, '10': 'minimum'},
    {'1': 'maximum', '3': 4, '4': 1, '5': 5, '10': 'maximum'},
    {'1': 'reorder_quantity', '3': 5, '4': 1, '5': 5, '10': 'reorderQuantity'},
  ],
};

/// Descriptor for `StockLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockLevelDescriptor = $convert.base64Decode(
    'CgpTdG9ja0xldmVsEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIfCgtsb2NhdGlvbl9pZBgCIA'
    'EoCVIKbG9jYXRpb25JZBIYCgdtaW5pbXVtGAMgASgFUgdtaW5pbXVtEhgKB21heGltdW0YBCAB'
    'KAVSB21heGltdW0SKQoQcmVvcmRlcl9xdWFudGl0eRgFIAEoBVIPcmVvcmRlclF1YW50aXR5');

@$core.Deprecated('Use requisitionLineDescriptor instead')
const RequisitionLine$json = {
  '1': 'RequisitionLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_code', '3': 2, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'uom', '3': 4, '4': 1, '5': 9, '10': 'uom'},
    {
      '1': 'estimated_unit_price',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Money',
      '10': 'estimatedUnitPrice'
    },
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RequisitionLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requisitionLineDescriptor = $convert.base64Decode(
    'Cg9SZXF1aXNpdGlvbkxpbmUSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhsKCWl0ZW1fY29kZR'
    'gCIAEoCVIIaXRlbUNvZGUSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5EhAKA3VvbRgEIAEo'
    'CVIDdW9tElAKFGVzdGltYXRlZF91bml0X3ByaWNlGAUgASgLMh4uaGVhbHRoY2FyZS5tYXRlcm'
    'lhbHMudjEuTW9uZXlSEmVzdGltYXRlZFVuaXRQcmljZRIUCgVub3RlcxgGIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use approvalStepDescriptor instead')
const ApprovalStep$json = {
  '1': 'ApprovalStep',
  '2': [
    {'1': 'approval_step_id', '3': 1, '4': 1, '5': 9, '10': 'approvalStepId'},
    {'1': 'level', '3': 2, '4': 1, '5': 5, '10': 'level'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {
      '1': 'decision',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.ApprovalDecision',
      '10': 'decision'
    },
    {'1': 'decider', '3': 5, '4': 1, '5': 9, '10': 'decider'},
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'decided_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'decidedAt'
    },
  ],
};

/// Descriptor for `ApprovalStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approvalStepDescriptor = $convert.base64Decode(
    'CgxBcHByb3ZhbFN0ZXASKAoQYXBwcm92YWxfc3RlcF9pZBgBIAEoCVIOYXBwcm92YWxTdGVwSW'
    'QSFAoFbGV2ZWwYAiABKAVSBWxldmVsEhIKBHJvbGUYAyABKAlSBHJvbGUSRQoIZGVjaXNpb24Y'
    'BCABKA4yKS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5BcHByb3ZhbERlY2lzaW9uUghkZWNpc2'
    'lvbhIYCgdkZWNpZGVyGAUgASgJUgdkZWNpZGVyEhIKBG5vdGUYBiABKAlSBG5vdGUSOQoKZGVj'
    'aWRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWRlY2lkZWRBdA==');

@$core.Deprecated('Use requisitionDescriptor instead')
const Requisition$json = {
  '1': 'Requisition',
  '2': [
    {'1': 'requisition_id', '3': 1, '4': 1, '5': 9, '10': 'requisitionId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'source',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.RequisitionSource',
      '10': 'source'
    },
    {
      '1': 'need_by',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'needBy'
    },
    {'1': 'cost_centre', '3': 6, '4': 1, '5': 9, '10': 'costCentre'},
    {'1': 'source_reference', '3': 7, '4': 1, '5': 9, '10': 'sourceReference'},
    {
      '1': 'lines',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.RequisitionLine',
      '10': 'lines'
    },
    {
      '1': 'state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.RequisitionState',
      '10': 'state'
    },
    {
      '1': 'approvals',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.ApprovalStep',
      '10': 'approvals'
    },
    {'1': 'justification', '3': 11, '4': 1, '5': 9, '10': 'justification'},
    {
      '1': 'raised_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 13, '4': 1, '5': 9, '10': 'raisedBy'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Requisition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requisitionDescriptor = $convert.base64Decode(
    'CgtSZXF1aXNpdGlvbhIlCg5yZXF1aXNpdGlvbl9pZBgBIAEoCVINcmVxdWlzaXRpb25JZBIWCg'
    'ZudW1iZXIYAiABKAlSBm51bWJlchIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBJC'
    'CgZzb3VyY2UYBCABKA4yKi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SZXF1aXNpdGlvblNvdX'
    'JjZVIGc291cmNlEjMKB25lZWRfYnkYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UgZuZWVkQnkSHwoLY29zdF9jZW50cmUYBiABKAlSCmNvc3RDZW50cmUSKQoQc291cmNlX3JlZm'
    'VyZW5jZRgHIAEoCVIPc291cmNlUmVmZXJlbmNlEj4KBWxpbmVzGAggAygLMiguaGVhbHRoY2Fy'
    'ZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb25MaW5lUgVsaW5lcxI/CgVzdGF0ZRgJIAEoDjIpLm'
    'hlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlJlcXVpc2l0aW9uU3RhdGVSBXN0YXRlEkMKCWFwcHJv'
    'dmFscxgKIAMoCzIlLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkFwcHJvdmFsU3RlcFIJYXBwcm'
    '92YWxzEiQKDWp1c3RpZmljYXRpb24YCyABKAlSDWp1c3RpZmljYXRpb24SNwoJcmFpc2VkX2F0'
    'GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcmFpc2VkQXQSGwoJcmFpc2VkX2'
    'J5GA0gASgJUghyYWlzZWRCeRIYCgd2ZXJzaW9uGA4gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use approvalRuleDescriptor instead')
const ApprovalRule$json = {
  '1': 'ApprovalRule',
  '2': [
    {'1': 'approval_rule_id', '3': 1, '4': 1, '5': 9, '10': 'approvalRuleId'},
    {'1': 'minimum_value', '3': 2, '4': 1, '5': 3, '10': 'minimumValue'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'category', '3': 4, '4': 1, '5': 9, '10': 'category'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'roles', '3': 6, '4': 3, '5': 9, '10': 'roles'},
  ],
};

/// Descriptor for `ApprovalRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approvalRuleDescriptor = $convert.base64Decode(
    'CgxBcHByb3ZhbFJ1bGUSKAoQYXBwcm92YWxfcnVsZV9pZBgBIAEoCVIOYXBwcm92YWxSdWxlSW'
    'QSIwoNbWluaW11bV92YWx1ZRgCIAEoA1IMbWluaW11bVZhbHVlEhoKCGN1cnJlbmN5GAMgASgJ'
    'UghjdXJyZW5jeRIaCghjYXRlZ29yeRgEIAEoCVIIY2F0ZWdvcnkSHwoLZmFjaWxpdHlfaWQYBS'
    'ABKAlSCmZhY2lsaXR5SWQSFAoFcm9sZXMYBiADKAlSBXJvbGVz');

@$core.Deprecated('Use bidLineDescriptor instead')
const BidLine$json = {
  '1': 'BidLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'unit_price',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Money',
      '10': 'unitPrice'
    },
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'pack_size', '3': 4, '4': 1, '5': 5, '10': 'packSize'},
  ],
};

/// Descriptor for `BidLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bidLineDescriptor = $convert.base64Decode(
    'CgdCaWRMaW5lEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBI9Cgp1bml0X3ByaWNlGAIgASgLMh'
    '4uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTW9uZXlSCXVuaXRQcmljZRIaCghxdWFudGl0eRgD'
    'IAEoBVIIcXVhbnRpdHkSGwoJcGFja19zaXplGAQgASgFUghwYWNrU2l6ZQ==');

@$core.Deprecated('Use bidDescriptor instead')
const Bid$json = {
  '1': 'Bid',
  '2': [
    {'1': 'bid_id', '3': 1, '4': 1, '5': 9, '10': 'bidId'},
    {'1': 'rfq_id', '3': 2, '4': 1, '5': 9, '10': 'rfqId'},
    {'1': 'supplier_id', '3': 3, '4': 1, '5': 9, '10': 'supplierId'},
    {
      '1': 'lines',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.BidLine',
      '10': 'lines'
    },
    {'1': 'lead_time_days', '3': 5, '4': 1, '5': 5, '10': 'leadTimeDays'},
    {'1': 'warranty_months', '3': 6, '4': 1, '5': 5, '10': 'warrantyMonths'},
    {
      '1': 'payment_terms_days',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'freight_minor', '3': 8, '4': 1, '5': 3, '10': 'freightMinor'},
    {'1': 'tax_minor', '3': 9, '4': 1, '5': 3, '10': 'taxMinor'},
    {'1': 'currency', '3': 10, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'notes', '3': 11, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'received_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'recorded_by', '3': 13, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `Bid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bidDescriptor = $convert.base64Decode(
    'CgNCaWQSFQoGYmlkX2lkGAEgASgJUgViaWRJZBIVCgZyZnFfaWQYAiABKAlSBXJmcUlkEh8KC3'
    'N1cHBsaWVyX2lkGAMgASgJUgpzdXBwbGllcklkEjYKBWxpbmVzGAQgAygLMiAuaGVhbHRoY2Fy'
    'ZS5tYXRlcmlhbHMudjEuQmlkTGluZVIFbGluZXMSJAoObGVhZF90aW1lX2RheXMYBSABKAVSDG'
    'xlYWRUaW1lRGF5cxInCg93YXJyYW50eV9tb250aHMYBiABKAVSDndhcnJhbnR5TW9udGhzEiwK'
    'EnBheW1lbnRfdGVybXNfZGF5cxgHIAEoBVIQcGF5bWVudFRlcm1zRGF5cxIjCg1mcmVpZ2h0X2'
    '1pbm9yGAggASgDUgxmcmVpZ2h0TWlub3ISGwoJdGF4X21pbm9yGAkgASgDUgh0YXhNaW5vchIa'
    'CghjdXJyZW5jeRgKIAEoCVIIY3VycmVuY3kSFAoFbm90ZXMYCyABKAlSBW5vdGVzEjsKC3JlY2'
    'VpdmVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjZWl2ZWRBdBIf'
    'CgtyZWNvcmRlZF9ieRgNIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use rfqDescriptor instead')
const Rfq$json = {
  '1': 'Rfq',
  '2': [
    {'1': 'rfq_id', '3': 1, '4': 1, '5': 9, '10': 'rfqId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'requisition_id', '3': 3, '4': 1, '5': 9, '10': 'requisitionId'},
    {'1': 'supplier_ids', '3': 4, '4': 3, '5': 9, '10': 'supplierIds'},
    {
      '1': 'lines',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.RequisitionLine',
      '10': 'lines'
    },
    {
      '1': 'closes_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closesAt'
    },
    {
      '1': 'issued_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'issued_by', '3': 8, '4': 1, '5': 9, '10': 'issuedBy'},
    {'1': 'version', '3': 9, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Rfq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rfqDescriptor = $convert.base64Decode(
    'CgNSZnESFQoGcmZxX2lkGAEgASgJUgVyZnFJZBIWCgZudW1iZXIYAiABKAlSBm51bWJlchIlCg'
    '5yZXF1aXNpdGlvbl9pZBgDIAEoCVINcmVxdWlzaXRpb25JZBIhCgxzdXBwbGllcl9pZHMYBCAD'
    'KAlSC3N1cHBsaWVySWRzEj4KBWxpbmVzGAUgAygLMiguaGVhbHRoY2FyZS5tYXRlcmlhbHMudj'
    'EuUmVxdWlzaXRpb25MaW5lUgVsaW5lcxI3CgljbG9zZXNfYXQYBiABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUghjbG9zZXNBdBI3Cglpc3N1ZWRfYXQYByABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUghpc3N1ZWRBdBIbCglpc3N1ZWRfYnkYCCABKAlSCGlzc3VlZEJ5'
    'EhgKB3ZlcnNpb24YCSABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use comparisonDescriptor instead')
const Comparison$json = {
  '1': 'Comparison',
  '2': [
    {'1': 'bid_id', '3': 1, '4': 1, '5': 9, '10': 'bidId'},
    {'1': 'supplier_id', '3': 2, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'landed_minor', '3': 3, '4': 1, '5': 3, '10': 'landedMinor'},
    {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'unit_minor', '3': 5, '4': 1, '5': 3, '10': 'unitMinor'},
    {'1': 'lead_time_days', '3': 6, '4': 1, '5': 5, '10': 'leadTimeDays'},
    {
      '1': 'payment_terms_days',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'warranty_months', '3': 8, '4': 1, '5': 5, '10': 'warrantyMonths'},
    {'1': 'incomparable', '3': 9, '4': 3, '5': 9, '10': 'incomparable'},
  ],
};

/// Descriptor for `Comparison`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List comparisonDescriptor = $convert.base64Decode(
    'CgpDb21wYXJpc29uEhUKBmJpZF9pZBgBIAEoCVIFYmlkSWQSHwoLc3VwcGxpZXJfaWQYAiABKA'
    'lSCnN1cHBsaWVySWQSIQoMbGFuZGVkX21pbm9yGAMgASgDUgtsYW5kZWRNaW5vchIaCghjdXJy'
    'ZW5jeRgEIAEoCVIIY3VycmVuY3kSHQoKdW5pdF9taW5vchgFIAEoA1IJdW5pdE1pbm9yEiQKDm'
    'xlYWRfdGltZV9kYXlzGAYgASgFUgxsZWFkVGltZURheXMSLAoScGF5bWVudF90ZXJtc19kYXlz'
    'GAcgASgFUhBwYXltZW50VGVybXNEYXlzEicKD3dhcnJhbnR5X21vbnRocxgIIAEoBVIOd2Fycm'
    'FudHlNb250aHMSIgoMaW5jb21wYXJhYmxlGAkgAygJUgxpbmNvbXBhcmFibGU=');

@$core.Deprecated('Use purchaseOrderLineDescriptor instead')
const PurchaseOrderLine$json = {
  '1': 'PurchaseOrderLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_code', '3': 2, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'pack_size', '3': 4, '4': 1, '5': 5, '10': 'packSize'},
    {'1': 'uom', '3': 5, '4': 1, '5': 9, '10': 'uom'},
    {
      '1': 'unit_price',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Money',
      '10': 'unitPrice'
    },
    {'1': 'tax_minor', '3': 7, '4': 1, '5': 3, '10': 'taxMinor'},
    {'1': 'discount_minor', '3': 8, '4': 1, '5': 3, '10': 'discountMinor'},
    {
      '1': 'deliver_by',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deliverBy'
    },
    {'1': 'notes', '3': 10, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `PurchaseOrderLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purchaseOrderLineDescriptor = $convert.base64Decode(
    'ChFQdXJjaGFzZU9yZGVyTGluZRIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSGwoJaXRlbV9jb2'
    'RlGAIgASgJUghpdGVtQ29kZRIaCghxdWFudGl0eRgDIAEoBVIIcXVhbnRpdHkSGwoJcGFja19z'
    'aXplGAQgASgFUghwYWNrU2l6ZRIQCgN1b20YBSABKAlSA3VvbRI9Cgp1bml0X3ByaWNlGAYgAS'
    'gLMh4uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTW9uZXlSCXVuaXRQcmljZRIbCgl0YXhfbWlu'
    'b3IYByABKANSCHRheE1pbm9yEiUKDmRpc2NvdW50X21pbm9yGAggASgDUg1kaXNjb3VudE1pbm'
    '9yEjkKCmRlbGl2ZXJfYnkYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglkZWxp'
    'dmVyQnkSFAoFbm90ZXMYCiABKAlSBW5vdGVz');

@$core.Deprecated('Use purchaseOrderDescriptor instead')
const PurchaseOrder$json = {
  '1': 'PurchaseOrder',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'supplier_id', '3': 4, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'requisition_id', '3': 5, '4': 1, '5': 9, '10': 'requisitionId'},
    {'1': 'bid_id', '3': 6, '4': 1, '5': 9, '10': 'bidId'},
    {'1': 'revision', '3': 7, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'chain_id', '3': 8, '4': 1, '5': 9, '10': 'chainId'},
    {'1': 'supersedes', '3': 9, '4': 1, '5': 9, '10': 'supersedes'},
    {'1': 'amendment_reason', '3': 10, '4': 1, '5': 9, '10': 'amendmentReason'},
    {
      '1': 'lines',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrderLine',
      '10': 'lines'
    },
    {
      '1': 'state',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.PurchaseOrderState',
      '10': 'state'
    },
    {'1': 'currency', '3': 13, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'payment_terms_days',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'delivery_terms', '3': 15, '4': 1, '5': 9, '10': 'deliveryTerms'},
    {
      '1': 'tolerance_over_percent',
      '3': 16,
      '4': 1,
      '5': 5,
      '10': 'toleranceOverPercent'
    },
    {
      '1': 'tolerance_short_percent',
      '3': 17,
      '4': 1,
      '5': 5,
      '10': 'toleranceShortPercent'
    },
    {
      '1': 'issued_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'issued_by', '3': 19, '4': 1, '5': 9, '10': 'issuedBy'},
    {
      '1': 'created_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 21, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 22, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'total',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Money',
      '10': 'total'
    },
  ],
};

/// Descriptor for `PurchaseOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purchaseOrderDescriptor = $convert.base64Decode(
    'Cg1QdXJjaGFzZU9yZGVyEioKEXB1cmNoYXNlX29yZGVyX2lkGAEgASgJUg9wdXJjaGFzZU9yZG'
    'VySWQSFgoGbnVtYmVyGAIgASgJUgZudW1iZXISHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2ls'
    'aXR5SWQSHwoLc3VwcGxpZXJfaWQYBCABKAlSCnN1cHBsaWVySWQSJQoOcmVxdWlzaXRpb25faW'
    'QYBSABKAlSDXJlcXVpc2l0aW9uSWQSFQoGYmlkX2lkGAYgASgJUgViaWRJZBIaCghyZXZpc2lv'
    'bhgHIAEoBVIIcmV2aXNpb24SGQoIY2hhaW5faWQYCCABKAlSB2NoYWluSWQSHgoKc3VwZXJzZW'
    'RlcxgJIAEoCVIKc3VwZXJzZWRlcxIpChBhbWVuZG1lbnRfcmVhc29uGAogASgJUg9hbWVuZG1l'
    'bnRSZWFzb24SQAoFbGluZXMYCyADKAsyKi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5QdXJjaG'
    'FzZU9yZGVyTGluZVIFbGluZXMSQQoFc3RhdGUYDCABKA4yKy5oZWFsdGhjYXJlLm1hdGVyaWFs'
    'cy52MS5QdXJjaGFzZU9yZGVyU3RhdGVSBXN0YXRlEhoKCGN1cnJlbmN5GA0gASgJUghjdXJyZW'
    '5jeRIsChJwYXltZW50X3Rlcm1zX2RheXMYDiABKAVSEHBheW1lbnRUZXJtc0RheXMSJQoOZGVs'
    'aXZlcnlfdGVybXMYDyABKAlSDWRlbGl2ZXJ5VGVybXMSNAoWdG9sZXJhbmNlX292ZXJfcGVyY2'
    'VudBgQIAEoBVIUdG9sZXJhbmNlT3ZlclBlcmNlbnQSNgoXdG9sZXJhbmNlX3Nob3J0X3BlcmNl'
    'bnQYESABKAVSFXRvbGVyYW5jZVNob3J0UGVyY2VudBI3Cglpc3N1ZWRfYXQYEiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUghpc3N1ZWRBdBIbCglpc3N1ZWRfYnkYEyABKAlSCGlz'
    'c3VlZEJ5EjkKCmNyZWF0ZWRfYXQYFCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'ljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgVIAEoCVIJY3JlYXRlZEJ5EhgKB3ZlcnNpb24YFiAB'
    'KANSB3ZlcnNpb24SNAoFdG90YWwYFyABKAsyHi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5Nb2'
    '5leVIFdG90YWw=');

@$core.Deprecated('Use receiptLineDescriptor instead')
const ReceiptLine$json = {
  '1': 'ReceiptLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_code', '3': 2, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'lot_code', '3': 3, '4': 1, '5': 9, '10': 'lotCode'},
    {
      '1': 'expiry',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiry'
    },
    {'1': 'quantity_ordered', '3': 5, '4': 1, '5': 5, '10': 'quantityOrdered'},
    {
      '1': 'quantity_received',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'quantityReceived'
    },
    {
      '1': 'ownership',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.Ownership',
      '10': 'ownership'
    },
    {'1': 'supplier_id', '3': 8, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'discrepancy', '3': 10, '4': 1, '5': 5, '10': 'discrepancy'},
  ],
};

/// Descriptor for `ReceiptLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiptLineDescriptor = $convert.base64Decode(
    'CgtSZWNlaXB0TGluZRIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSGwoJaXRlbV9jb2RlGAIgAS'
    'gJUghpdGVtQ29kZRIZCghsb3RfY29kZRgDIAEoCVIHbG90Q29kZRIyCgZleHBpcnkYBCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgZleHBpcnkSKQoQcXVhbnRpdHlfb3JkZXJlZB'
    'gFIAEoBVIPcXVhbnRpdHlPcmRlcmVkEisKEXF1YW50aXR5X3JlY2VpdmVkGAYgASgFUhBxdWFu'
    'dGl0eVJlY2VpdmVkEkAKCW93bmVyc2hpcBgHIAEoDjIiLmhlYWx0aGNhcmUubWF0ZXJpYWxzLn'
    'YxLk93bmVyc2hpcFIJb3duZXJzaGlwEh8KC3N1cHBsaWVyX2lkGAggASgJUgpzdXBwbGllcklk'
    'EhQKBW5vdGVzGAkgASgJUgVub3RlcxIgCgtkaXNjcmVwYW5jeRgKIAEoBVILZGlzY3JlcGFuY3'
    'k=');

@$core.Deprecated('Use receiptDescriptor instead')
const Receipt$json = {
  '1': 'Receipt',
  '2': [
    {'1': 'receipt_id', '3': 1, '4': 1, '5': 9, '10': 'receiptId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'purchase_order_id', '3': 3, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {'1': 'po_revision', '3': 4, '4': 1, '5': 5, '10': 'poRevision'},
    {'1': 'supplier_id', '3': 5, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'location_id', '3': 6, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'delivery_note', '3': 7, '4': 1, '5': 9, '10': 'deliveryNote'},
    {'1': 'invoice_ref', '3': 8, '4': 1, '5': 9, '10': 'invoiceRef'},
    {
      '1': 'lines',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.ReceiptLine',
      '10': 'lines'
    },
    {
      '1': 'received_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'received_by', '3': 11, '4': 1, '5': 9, '10': 'receivedBy'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Receipt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiptDescriptor = $convert.base64Decode(
    'CgdSZWNlaXB0Eh0KCnJlY2VpcHRfaWQYASABKAlSCXJlY2VpcHRJZBIWCgZudW1iZXIYAiABKA'
    'lSBm51bWJlchIqChFwdXJjaGFzZV9vcmRlcl9pZBgDIAEoCVIPcHVyY2hhc2VPcmRlcklkEh8K'
    'C3BvX3JldmlzaW9uGAQgASgFUgpwb1JldmlzaW9uEh8KC3N1cHBsaWVyX2lkGAUgASgJUgpzdX'
    'BwbGllcklkEh8KC2xvY2F0aW9uX2lkGAYgASgJUgpsb2NhdGlvbklkEiMKDWRlbGl2ZXJ5X25v'
    'dGUYByABKAlSDGRlbGl2ZXJ5Tm90ZRIfCgtpbnZvaWNlX3JlZhgIIAEoCVIKaW52b2ljZVJlZh'
    'I6CgVsaW5lcxgJIAMoCzIkLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlJlY2VpcHRMaW5lUgVs'
    'aW5lcxI7CgtyZWNlaXZlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCn'
    'JlY2VpdmVkQXQSHwoLcmVjZWl2ZWRfYnkYCyABKAlSCnJlY2VpdmVkQnkSGAoHdmVyc2lvbhgM'
    'IAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use pickLineDescriptor instead')
const PickLine$json = {
  '1': 'PickLine',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'lot_code', '3': 2, '4': 1, '5': 9, '10': 'lotCode'},
    {
      '1': 'bucket',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Bucket',
      '10': 'bucket'
    },
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'expiry',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiry'
    },
  ],
};

/// Descriptor for `PickLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickLineDescriptor = $convert.base64Decode(
    'CghQaWNrTGluZRIVCgZsb3RfaWQYASABKAlSBWxvdElkEhkKCGxvdF9jb2RlGAIgASgJUgdsb3'
    'RDb2RlEjcKBmJ1Y2tldBgDIAEoCzIfLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkJ1Y2tldFIG'
    'YnVja2V0EhoKCHF1YW50aXR5GAQgASgFUghxdWFudGl0eRIyCgZleHBpcnkYBSABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgZleHBpcnk=');

@$core.Deprecated('Use pickDescriptor instead')
const Pick$json = {
  '1': 'Pick',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'lines',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.PickLine',
      '10': 'lines'
    },
    {'1': 'short', '3': 3, '4': 1, '5': 5, '10': 'short'},
    {'1': 'skipped', '3': 4, '4': 3, '5': 9, '10': 'skipped'},
  ],
};

/// Descriptor for `Pick`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickDescriptor = $convert.base64Decode(
    'CgRQaWNrEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBI3CgVsaW5lcxgCIAMoCzIhLmhlYWx0aG'
    'NhcmUubWF0ZXJpYWxzLnYxLlBpY2tMaW5lUgVsaW5lcxIUCgVzaG9ydBgDIAEoBVIFc2hvcnQS'
    'GAoHc2tpcHBlZBgEIAMoCVIHc2tpcHBlZA==');

@$core.Deprecated('Use liabilityEventDescriptor instead')
const LiabilityEvent$json = {
  '1': 'LiabilityEvent',
  '2': [
    {
      '1': 'liability_event_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'liabilityEventId'
    },
    {'1': 'lot_id', '3': 2, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'item_id', '3': 3, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'supplier_id', '3': 4, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'patient_id', '3': 6, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 7, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'movement_id', '3': 8, '4': 1, '5': 9, '10': 'movementId'},
    {
      '1': 'occurred_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'recorded_by', '3': 10, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `LiabilityEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liabilityEventDescriptor = $convert.base64Decode(
    'Cg5MaWFiaWxpdHlFdmVudBIsChJsaWFiaWxpdHlfZXZlbnRfaWQYASABKAlSEGxpYWJpbGl0eU'
    'V2ZW50SWQSFQoGbG90X2lkGAIgASgJUgVsb3RJZBIXCgdpdGVtX2lkGAMgASgJUgZpdGVtSWQS'
    'HwoLc3VwcGxpZXJfaWQYBCABKAlSCnN1cHBsaWVySWQSGgoIcXVhbnRpdHkYBSABKAVSCHF1YW'
    '50aXR5Eh0KCnBhdGllbnRfaWQYBiABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYByAB'
    'KAlSC2VuY291bnRlcklkEh8KC21vdmVtZW50X2lkGAggASgJUgptb3ZlbWVudElkEjsKC29jY3'
    'VycmVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBIf'
    'CgtyZWNvcmRlZF9ieRgKIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use transferLineDescriptor instead')
const TransferLine$json = {
  '1': 'TransferLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'lot_id', '3': 2, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'quantity_received',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'quantityReceived'
    },
  ],
};

/// Descriptor for `TransferLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferLineDescriptor = $convert.base64Decode(
    'CgxUcmFuc2ZlckxpbmUSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhUKBmxvdF9pZBgCIAEoCV'
    'IFbG90SWQSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5EisKEXF1YW50aXR5X3JlY2VpdmVk'
    'GAQgASgFUhBxdWFudGl0eVJlY2VpdmVk');

@$core.Deprecated('Use transferDescriptor instead')
const Transfer$json = {
  '1': 'Transfer',
  '2': [
    {'1': 'transfer_id', '3': 1, '4': 1, '5': 9, '10': 'transferId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'from_location', '3': 3, '4': 1, '5': 9, '10': 'fromLocation'},
    {'1': 'to_location', '3': 4, '4': 1, '5': 9, '10': 'toLocation'},
    {
      '1': 'lines',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.TransferLine',
      '10': 'lines'
    },
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.TransferState',
      '10': 'state'
    },
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'dispatched_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dispatchedAt'
    },
    {'1': 'dispatched_by', '3': 9, '4': 1, '5': 9, '10': 'dispatchedBy'},
    {
      '1': 'received_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'received_by', '3': 11, '4': 1, '5': 9, '10': 'receivedBy'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Transfer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferDescriptor = $convert.base64Decode(
    'CghUcmFuc2ZlchIfCgt0cmFuc2Zlcl9pZBgBIAEoCVIKdHJhbnNmZXJJZBIWCgZudW1iZXIYAi'
    'ABKAlSBm51bWJlchIjCg1mcm9tX2xvY2F0aW9uGAMgASgJUgxmcm9tTG9jYXRpb24SHwoLdG9f'
    'bG9jYXRpb24YBCABKAlSCnRvTG9jYXRpb24SOwoFbGluZXMYBSADKAsyJS5oZWFsdGhjYXJlLm'
    '1hdGVyaWFscy52MS5UcmFuc2ZlckxpbmVSBWxpbmVzEjwKBXN0YXRlGAYgASgOMiYuaGVhbHRo'
    'Y2FyZS5tYXRlcmlhbHMudjEuVHJhbnNmZXJTdGF0ZVIFc3RhdGUSFgoGcmVhc29uGAcgASgJUg'
    'ZyZWFzb24SPwoNZGlzcGF0Y2hlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSDGRpc3BhdGNoZWRBdBIjCg1kaXNwYXRjaGVkX2J5GAkgASgJUgxkaXNwYXRjaGVkQnkSOw'
    'oLcmVjZWl2ZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNlaXZl'
    'ZEF0Eh8KC3JlY2VpdmVkX2J5GAsgASgJUgpyZWNlaXZlZEJ5EhgKB3ZlcnNpb24YDCABKANSB3'
    'ZlcnNpb24=');

@$core.Deprecated('Use countLineDescriptor instead')
const CountLine$json = {
  '1': 'CountLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'lot_id', '3': 2, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'expected', '3': 3, '4': 1, '5': 5, '10': 'expected'},
    {'1': 'counted', '3': 4, '4': 1, '5': 5, '10': 'counted'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'variance', '3': 6, '4': 1, '5': 5, '10': 'variance'},
  ],
};

/// Descriptor for `CountLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List countLineDescriptor = $convert.base64Decode(
    'CglDb3VudExpbmUSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhUKBmxvdF9pZBgCIAEoCVIFbG'
    '90SWQSGgoIZXhwZWN0ZWQYAyABKAVSCGV4cGVjdGVkEhgKB2NvdW50ZWQYBCABKAVSB2NvdW50'
    'ZWQSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SGgoIdmFyaWFuY2UYBiABKAVSCHZhcmlhbmNl');

@$core.Deprecated('Use countDescriptor instead')
const Count$json = {
  '1': 'Count',
  '2': [
    {'1': 'count_id', '3': 1, '4': 1, '5': 9, '10': 'countId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'cycle', '3': 4, '4': 1, '5': 8, '10': 'cycle'},
    {
      '1': 'lines',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.CountLine',
      '10': 'lines'
    },
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.CountState',
      '10': 'state'
    },
    {'1': 'approved_by', '3': 7, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {'1': 'approval_note', '3': 9, '4': 1, '5': 9, '10': 'approvalNote'},
    {
      '1': 'opened_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openedAt'
    },
    {'1': 'opened_by', '3': 11, '4': 1, '5': 9, '10': 'openedBy'},
    {
      '1': 'counted_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'countedAt'
    },
    {'1': 'counted_by', '3': 13, '4': 1, '5': 9, '10': 'countedBy'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Count`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List countDescriptor = $convert.base64Decode(
    'CgVDb3VudBIZCghjb3VudF9pZBgBIAEoCVIHY291bnRJZBIWCgZudW1iZXIYAiABKAlSBm51bW'
    'JlchIfCgtsb2NhdGlvbl9pZBgDIAEoCVIKbG9jYXRpb25JZBIUCgVjeWNsZRgEIAEoCFIFY3lj'
    'bGUSOAoFbGluZXMYBSADKAsyIi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5Db3VudExpbmVSBW'
    'xpbmVzEjkKBXN0YXRlGAYgASgOMiMuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuQ291bnRTdGF0'
    'ZVIFc3RhdGUSHwoLYXBwcm92ZWRfYnkYByABKAlSCmFwcHJvdmVkQnkSOwoLYXBwcm92ZWRfYX'
    'QYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0EiMKDWFwcHJv'
    'dmFsX25vdGUYCSABKAlSDGFwcHJvdmFsTm90ZRI3CglvcGVuZWRfYXQYCiABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUghvcGVuZWRBdBIbCglvcGVuZWRfYnkYCyABKAlSCG9wZW5l'
    'ZEJ5EjkKCmNvdW50ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljb3'
    'VudGVkQXQSHQoKY291bnRlZF9ieRgNIAEoCVIJY291bnRlZEJ5EhgKB3ZlcnNpb24YDiABKANS'
    'B3ZlcnNpb24=');

@$core.Deprecated('Use alertDescriptor instead')
const Alert$json = {
  '1': 'Alert',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.AlertKind',
      '10': 'kind'
    },
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'lot_id', '3': 4, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'available', '3': 5, '4': 1, '5': 5, '10': 'available'},
    {'1': 'minimum', '3': 6, '4': 1, '5': 5, '10': 'minimum'},
    {'1': 'suggested_order', '3': 7, '4': 1, '5': 5, '10': 'suggestedOrder'},
    {
      '1': 'expiry',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiry'
    },
    {'1': 'detail', '3': 9, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `Alert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertDescriptor = $convert.base64Decode(
    'CgVBbGVydBI2CgRraW5kGAEgASgOMiIuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuQWxlcnRLaW'
    '5kUgRraW5kEhcKB2l0ZW1faWQYAiABKAlSBml0ZW1JZBIfCgtsb2NhdGlvbl9pZBgDIAEoCVIK'
    'bG9jYXRpb25JZBIVCgZsb3RfaWQYBCABKAlSBWxvdElkEhwKCWF2YWlsYWJsZRgFIAEoBVIJYX'
    'ZhaWxhYmxlEhgKB21pbmltdW0YBiABKAVSB21pbmltdW0SJwoPc3VnZ2VzdGVkX29yZGVyGAcg'
    'ASgFUg5zdWdnZXN0ZWRPcmRlchIyCgZleHBpcnkYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgZleHBpcnkSFgoGZGV0YWlsGAkgASgJUgZkZXRhaWw=');

@$core.Deprecated('Use suggestedLineDescriptor instead')
const SuggestedLine$json = {
  '1': 'SuggestedLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_code', '3': 2, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'available', '3': 3, '4': 1, '5': 5, '10': 'available'},
    {'1': 'minimum', '3': 4, '4': 1, '5': 5, '10': 'minimum'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'stockout', '3': 6, '4': 1, '5': 8, '10': 'stockout'},
  ],
};

/// Descriptor for `SuggestedLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestedLineDescriptor = $convert.base64Decode(
    'Cg1TdWdnZXN0ZWRMaW5lEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIbCglpdGVtX2NvZGUYAi'
    'ABKAlSCGl0ZW1Db2RlEhwKCWF2YWlsYWJsZRgDIAEoBVIJYXZhaWxhYmxlEhgKB21pbmltdW0Y'
    'BCABKAVSB21pbmltdW0SGgoIcXVhbnRpdHkYBSABKAVSCHF1YW50aXR5EhoKCHN0b2Nrb3V0GA'
    'YgASgIUghzdG9ja291dA==');

@$core.Deprecated('Use invoiceLineDescriptor instead')
const InvoiceLine$json = {
  '1': 'InvoiceLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'unit_price',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Money',
      '10': 'unitPrice'
    },
    {'1': 'tax_minor', '3': 4, '4': 1, '5': 3, '10': 'taxMinor'},
  ],
};

/// Descriptor for `InvoiceLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceLineDescriptor = $convert.base64Decode(
    'CgtJbnZvaWNlTGluZRIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSGgoIcXVhbnRpdHkYAiABKA'
    'VSCHF1YW50aXR5Ej0KCnVuaXRfcHJpY2UYAyABKAsyHi5oZWFsdGhjYXJlLm1hdGVyaWFscy52'
    'MS5Nb25leVIJdW5pdFByaWNlEhsKCXRheF9taW5vchgEIAEoA1IIdGF4TWlub3I=');

@$core.Deprecated('Use invoiceDescriptor instead')
const Invoice$json = {
  '1': 'Invoice',
  '2': [
    {'1': 'invoice_id', '3': 1, '4': 1, '5': 9, '10': 'invoiceId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'supplier_id', '3': 3, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'purchase_order_id', '3': 4, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {
      '1': 'lines',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.InvoiceLine',
      '10': 'lines'
    },
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'received_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'recorded_by', '3': 8, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `Invoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceDescriptor = $convert.base64Decode(
    'CgdJbnZvaWNlEh0KCmludm9pY2VfaWQYASABKAlSCWludm9pY2VJZBIWCgZudW1iZXIYAiABKA'
    'lSBm51bWJlchIfCgtzdXBwbGllcl9pZBgDIAEoCVIKc3VwcGxpZXJJZBIqChFwdXJjaGFzZV9v'
    'cmRlcl9pZBgEIAEoCVIPcHVyY2hhc2VPcmRlcklkEjoKBWxpbmVzGAUgAygLMiQuaGVhbHRoY2'
    'FyZS5tYXRlcmlhbHMudjEuSW52b2ljZUxpbmVSBWxpbmVzEhoKCGN1cnJlbmN5GAYgASgJUghj'
    'dXJyZW5jeRI7CgtyZWNlaXZlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCnJlY2VpdmVkQXQSHwoLcmVjb3JkZWRfYnkYCCABKAlSCnJlY29yZGVkQnk=');

@$core.Deprecated('Use matchLineDescriptor instead')
const MatchLine$json = {
  '1': 'MatchLine',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.MatchStatus',
      '10': 'status'
    },
    {'1': 'ordered', '3': 3, '4': 1, '5': 5, '10': 'ordered'},
    {'1': 'received', '3': 4, '4': 1, '5': 5, '10': 'received'},
    {'1': 'invoiced', '3': 5, '4': 1, '5': 5, '10': 'invoiced'},
    {
      '1': 'ordered_unit_minor',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'orderedUnitMinor'
    },
    {
      '1': 'invoiced_unit_minor',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'invoicedUnitMinor'
    },
    {'1': 'detail', '3': 8, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `MatchLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchLineDescriptor = $convert.base64Decode(
    'CglNYXRjaExpbmUSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEjwKBnN0YXR1cxgCIAEoDjIkLm'
    'hlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLk1hdGNoU3RhdHVzUgZzdGF0dXMSGAoHb3JkZXJlZBgD'
    'IAEoBVIHb3JkZXJlZBIaCghyZWNlaXZlZBgEIAEoBVIIcmVjZWl2ZWQSGgoIaW52b2ljZWQYBS'
    'ABKAVSCGludm9pY2VkEiwKEm9yZGVyZWRfdW5pdF9taW5vchgGIAEoA1IQb3JkZXJlZFVuaXRN'
    'aW5vchIuChNpbnZvaWNlZF91bml0X21pbm9yGAcgASgDUhFpbnZvaWNlZFVuaXRNaW5vchIWCg'
    'ZkZXRhaWwYCCABKAlSBmRldGFpbA==');

@$core.Deprecated('Use matchResultDescriptor instead')
const MatchResult$json = {
  '1': 'MatchResult',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {'1': 'invoice_id', '3': 2, '4': 1, '5': 9, '10': 'invoiceId'},
    {
      '1': 'lines',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.MatchLine',
      '10': 'lines'
    },
    {'1': 'matched', '3': 4, '4': 1, '5': 8, '10': 'matched'},
  ],
};

/// Descriptor for `MatchResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchResultDescriptor = $convert.base64Decode(
    'CgtNYXRjaFJlc3VsdBIqChFwdXJjaGFzZV9vcmRlcl9pZBgBIAEoCVIPcHVyY2hhc2VPcmRlck'
    'lkEh0KCmludm9pY2VfaWQYAiABKAlSCWludm9pY2VJZBI4CgVsaW5lcxgDIAMoCzIiLmhlYWx0'
    'aGNhcmUubWF0ZXJpYWxzLnYxLk1hdGNoTGluZVIFbGluZXMSGAoHbWF0Y2hlZBgEIAEoCFIHbW'
    'F0Y2hlZA==');

@$core.Deprecated('Use recallListDescriptor instead')
const RecallList$json = {
  '1': 'RecallList',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'lot_code', '3': 2, '4': 1, '5': 9, '10': 'lotCode'},
    {'1': 'item_id', '3': 3, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'holdings',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Balance',
      '10': 'holdings'
    },
    {
      '1': 'consumptions',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Movement',
      '10': 'consumptions'
    },
    {'1': 'patients', '3': 7, '4': 3, '5': 9, '10': 'patients'},
  ],
};

/// Descriptor for `RecallList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recallListDescriptor = $convert.base64Decode(
    'CgpSZWNhbGxMaXN0EhUKBmxvdF9pZBgBIAEoCVIFbG90SWQSGQoIbG90X2NvZGUYAiABKAlSB2'
    'xvdENvZGUSFwoHaXRlbV9pZBgDIAEoCVIGaXRlbUlkEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29u'
    'EjwKCGhvbGRpbmdzGAUgAygLMiAuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuQmFsYW5jZVIIaG'
    '9sZGluZ3MSRQoMY29uc3VtcHRpb25zGAYgAygLMiEuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEu'
    'TW92ZW1lbnRSDGNvbnN1bXB0aW9ucxIaCghwYXRpZW50cxgHIAMoCVIIcGF0aWVudHM=');

@$core.Deprecated('Use metricsDescriptor instead')
const Metrics$json = {
  '1': 'Metrics',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'period_start',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
    {'1': 'consumed_units', '3': 5, '4': 1, '5': 5, '10': 'consumedUnits'},
    {'1': 'opening_on_hand', '3': 6, '4': 1, '5': 5, '10': 'openingOnHand'},
    {'1': 'closing_on_hand', '3': 7, '4': 1, '5': 5, '10': 'closingOnHand'},
    {'1': 'average_on_hand', '3': 8, '4': 1, '5': 5, '10': 'averageOnHand'},
    {'1': 'turns_per_year', '3': 9, '4': 1, '5': 1, '10': 'turnsPerYear'},
    {'1': 'days_on_hand', '3': 10, '4': 1, '5': 1, '10': 'daysOnHand'},
    {
      '1': 'expiry_exposure_units',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'expiryExposureUnits'
    },
    {'1': 'incomplete', '3': 12, '4': 3, '5': 9, '10': 'incomplete'},
  ],
};

/// Descriptor for `Metrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metricsDescriptor = $convert.base64Decode(
    'CgdNZXRyaWNzEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIfCgtsb2NhdGlvbl9pZBgCIAEoCV'
    'IKbG9jYXRpb25JZBI9CgxwZXJpb2Rfc3RhcnQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgtwZXJpb2RTdGFydBI5CgpwZXJpb2RfZW5kGAQgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJcGVyaW9kRW5kEiUKDmNvbnN1bWVkX3VuaXRzGAUgASgFUg1jb25zdW1l'
    'ZFVuaXRzEiYKD29wZW5pbmdfb25faGFuZBgGIAEoBVINb3BlbmluZ09uSGFuZBImCg9jbG9zaW'
    '5nX29uX2hhbmQYByABKAVSDWNsb3NpbmdPbkhhbmQSJgoPYXZlcmFnZV9vbl9oYW5kGAggASgF'
    'Ug1hdmVyYWdlT25IYW5kEiQKDnR1cm5zX3Blcl95ZWFyGAkgASgBUgx0dXJuc1BlclllYXISIA'
    'oMZGF5c19vbl9oYW5kGAogASgBUgpkYXlzT25IYW5kEjIKFWV4cGlyeV9leHBvc3VyZV91bml0'
    'cxgLIAEoBVITZXhwaXJ5RXhwb3N1cmVVbml0cxIeCgppbmNvbXBsZXRlGAwgAygJUgppbmNvbX'
    'BsZXRl');

@$core.Deprecated('Use supplierFillRateDescriptor instead')
const SupplierFillRate$json = {
  '1': 'SupplierFillRate',
  '2': [
    {'1': 'supplier_id', '3': 1, '4': 1, '5': 9, '10': 'supplierId'},
    {
      '1': 'period_start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
    {'1': 'ordered_units', '3': 4, '4': 1, '5': 5, '10': 'orderedUnits'},
    {'1': 'received_units', '3': 5, '4': 1, '5': 5, '10': 'receivedUnits'},
    {'1': 'fill_rate', '3': 6, '4': 1, '5': 1, '10': 'fillRate'},
    {'1': 'on_time_lines', '3': 7, '4': 1, '5': 5, '10': 'onTimeLines'},
    {'1': 'late_lines', '3': 8, '4': 1, '5': 5, '10': 'lateLines'},
    {'1': 'incomplete', '3': 9, '4': 3, '5': 9, '10': 'incomplete'},
  ],
};

/// Descriptor for `SupplierFillRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List supplierFillRateDescriptor = $convert.base64Decode(
    'ChBTdXBwbGllckZpbGxSYXRlEh8KC3N1cHBsaWVyX2lkGAEgASgJUgpzdXBwbGllcklkEj0KDH'
    'BlcmlvZF9zdGFydBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3BlcmlvZFN0'
    'YXJ0EjkKCnBlcmlvZF9lbmQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglwZX'
    'Jpb2RFbmQSIwoNb3JkZXJlZF91bml0cxgEIAEoBVIMb3JkZXJlZFVuaXRzEiUKDnJlY2VpdmVk'
    'X3VuaXRzGAUgASgFUg1yZWNlaXZlZFVuaXRzEhsKCWZpbGxfcmF0ZRgGIAEoAVIIZmlsbFJhdG'
    'USIgoNb25fdGltZV9saW5lcxgHIAEoBVILb25UaW1lTGluZXMSHQoKbGF0ZV9saW5lcxgIIAEo'
    'BVIJbGF0ZUxpbmVzEh4KCmluY29tcGxldGUYCSADKAlSCmluY29tcGxldGU=');

@$core.Deprecated('Use addItemRequestDescriptor instead')
const AddItemRequest$json = {
  '1': 'AddItemRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'uom', '3': 4, '4': 1, '5': 9, '10': 'uom'},
    {
      '1': 'tracking',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.Tracking',
      '10': 'tracking'
    },
    {
      '1': 'policy',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.PickPolicy',
      '10': 'policy'
    },
    {'1': 'perishable', '3': 7, '4': 1, '5': 8, '10': 'perishable'},
    {
      '1': 'inspect_on_receipt',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'inspectOnReceipt'
    },
    {'1': 'consignable', '3': 9, '4': 1, '5': 8, '10': 'consignable'},
  ],
};

/// Descriptor for `AddItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addItemRequestDescriptor = $convert.base64Decode(
    'Cg5BZGRJdGVtUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEhgKB2Rpc3BsYXkYAiABKAlSB2'
    'Rpc3BsYXkSGgoIY2F0ZWdvcnkYAyABKAlSCGNhdGVnb3J5EhAKA3VvbRgEIAEoCVIDdW9tEj0K'
    'CHRyYWNraW5nGAUgASgOMiEuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuVHJhY2tpbmdSCHRyYW'
    'NraW5nEjsKBnBvbGljeRgGIAEoDjIjLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlBpY2tQb2xp'
    'Y3lSBnBvbGljeRIeCgpwZXJpc2hhYmxlGAcgASgIUgpwZXJpc2hhYmxlEiwKEmluc3BlY3Rfb2'
    '5fcmVjZWlwdBgIIAEoCFIQaW5zcGVjdE9uUmVjZWlwdBIgCgtjb25zaWduYWJsZRgJIAEoCFIL'
    'Y29uc2lnbmFibGU=');

@$core.Deprecated('Use addItemResponseDescriptor instead')
const AddItemResponse$json = {
  '1': 'AddItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Item',
      '10': 'item'
    },
  ],
};

/// Descriptor for `AddItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addItemResponseDescriptor = $convert.base64Decode(
    'Cg9BZGRJdGVtUmVzcG9uc2USMQoEaXRlbRgBIAEoCzIdLmhlYWx0aGNhcmUubWF0ZXJpYWxzLn'
    'YxLkl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use reconfigureItemRequestDescriptor instead')
const ReconfigureItemRequest$json = {
  '1': 'ReconfigureItemRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'policy',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.PickPolicy',
      '10': 'policy'
    },
    {
      '1': 'inspect_on_receipt',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'inspectOnReceipt'
    },
    {'1': 'consignable', '3': 6, '4': 1, '5': 8, '10': 'consignable'},
    {'1': 'active', '3': 7, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `ReconfigureItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconfigureItemRequestDescriptor = $convert.base64Decode(
    'ChZSZWNvbmZpZ3VyZUl0ZW1SZXF1ZXN0EhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIYCgdkaX'
    'NwbGF5GAIgASgJUgdkaXNwbGF5EhoKCGNhdGVnb3J5GAMgASgJUghjYXRlZ29yeRI7CgZwb2xp'
    'Y3kYBCABKA4yIy5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5QaWNrUG9saWN5UgZwb2xpY3kSLA'
    'oSaW5zcGVjdF9vbl9yZWNlaXB0GAUgASgIUhBpbnNwZWN0T25SZWNlaXB0EiAKC2NvbnNpZ25h'
    'YmxlGAYgASgIUgtjb25zaWduYWJsZRIWCgZhY3RpdmUYByABKAhSBmFjdGl2ZQ==');

@$core.Deprecated('Use reconfigureItemResponseDescriptor instead')
const ReconfigureItemResponse$json = {
  '1': 'ReconfigureItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Item',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ReconfigureItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconfigureItemResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWNvbmZpZ3VyZUl0ZW1SZXNwb25zZRIxCgRpdGVtGAEgASgLMh0uaGVhbHRoY2FyZS5tYX'
        'RlcmlhbHMudjEuSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use getItemRequestDescriptor instead')
const GetItemRequest$json = {
  '1': 'GetItemRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `GetItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getItemRequestDescriptor = $convert
    .base64Decode('Cg5HZXRJdGVtUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQ=');

@$core.Deprecated('Use getItemResponseDescriptor instead')
const GetItemResponse$json = {
  '1': 'GetItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Item',
      '10': 'item'
    },
  ],
};

/// Descriptor for `GetItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getItemResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRJdGVtUmVzcG9uc2USMQoEaXRlbRgBIAEoCzIdLmhlYWx0aGNhcmUubWF0ZXJpYWxzLn'
    'YxLkl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use listItemsRequestDescriptor instead')
const ListItemsRequest$json = {
  '1': 'ListItemsRequest',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0SXRlbXNSZXF1ZXN0EhoKCGNhdGVnb3J5GAEgASgJUghjYXRlZ29yeRIfCgthY3Rpdm'
    'Vfb25seRgCIAEoCFIKYWN0aXZlT25seRIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listItemsResponseDescriptor instead')
const ListItemsResponse$json = {
  '1': 'ListItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Item',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0SXRlbXNSZXNwb25zZRIzCgVpdGVtcxgBIAMoCzIdLmhlYWx0aGNhcmUubWF0ZXJpYW'
    'xzLnYxLkl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use addSupplierRequestDescriptor instead')
const AddSupplierRequest$json = {
  '1': 'AddSupplierRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'contact_email', '3': 3, '4': 1, '5': 9, '10': 'contactEmail'},
    {'1': 'contact_phone', '3': 4, '4': 1, '5': 9, '10': 'contactPhone'},
    {
      '1': 'payment_terms_days',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'approved', '3': 7, '4': 1, '5': 8, '10': 'approved'},
  ],
};

/// Descriptor for `AddSupplierRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addSupplierRequestDescriptor = $convert.base64Decode(
    'ChJBZGRTdXBwbGllclJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRIYCgdkaXNwbGF5GAIgAS'
    'gJUgdkaXNwbGF5EiMKDWNvbnRhY3RfZW1haWwYAyABKAlSDGNvbnRhY3RFbWFpbBIjCg1jb250'
    'YWN0X3Bob25lGAQgASgJUgxjb250YWN0UGhvbmUSLAoScGF5bWVudF90ZXJtc19kYXlzGAUgAS'
    'gFUhBwYXltZW50VGVybXNEYXlzEhoKCGN1cnJlbmN5GAYgASgJUghjdXJyZW5jeRIaCghhcHBy'
    'b3ZlZBgHIAEoCFIIYXBwcm92ZWQ=');

@$core.Deprecated('Use addSupplierResponseDescriptor instead')
const AddSupplierResponse$json = {
  '1': 'AddSupplierResponse',
  '2': [
    {
      '1': 'supplier',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Supplier',
      '10': 'supplier'
    },
  ],
};

/// Descriptor for `AddSupplierResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addSupplierResponseDescriptor = $convert.base64Decode(
    'ChNBZGRTdXBwbGllclJlc3BvbnNlEj0KCHN1cHBsaWVyGAEgASgLMiEuaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuU3VwcGxpZXJSCHN1cHBsaWVy');

@$core.Deprecated('Use setSupplierApprovalRequestDescriptor instead')
const SetSupplierApprovalRequest$json = {
  '1': 'SetSupplierApprovalRequest',
  '2': [
    {'1': 'supplier_id', '3': 1, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'approved', '3': 2, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SetSupplierApprovalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSupplierApprovalRequestDescriptor =
    $convert.base64Decode(
        'ChpTZXRTdXBwbGllckFwcHJvdmFsUmVxdWVzdBIfCgtzdXBwbGllcl9pZBgBIAEoCVIKc3VwcG'
        'xpZXJJZBIaCghhcHByb3ZlZBgCIAEoCFIIYXBwcm92ZWQSFgoGcmVhc29uGAMgASgJUgZyZWFz'
        'b24=');

@$core.Deprecated('Use setSupplierApprovalResponseDescriptor instead')
const SetSupplierApprovalResponse$json = {
  '1': 'SetSupplierApprovalResponse',
  '2': [
    {
      '1': 'supplier',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Supplier',
      '10': 'supplier'
    },
  ],
};

/// Descriptor for `SetSupplierApprovalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSupplierApprovalResponseDescriptor =
    $convert.base64Decode(
        'ChtTZXRTdXBwbGllckFwcHJvdmFsUmVzcG9uc2USPQoIc3VwcGxpZXIYASABKAsyIS5oZWFsdG'
        'hjYXJlLm1hdGVyaWFscy52MS5TdXBwbGllclIIc3VwcGxpZXI=');

@$core.Deprecated('Use listSuppliersRequestDescriptor instead')
const ListSuppliersRequest$json = {
  '1': 'ListSuppliersRequest',
  '2': [
    {'1': 'approved_only', '3': 1, '4': 1, '5': 8, '10': 'approvedOnly'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListSuppliersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSuppliersRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0U3VwcGxpZXJzUmVxdWVzdBIjCg1hcHByb3ZlZF9vbmx5GAEgASgIUgxhcHByb3ZlZE'
    '9ubHkSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listSuppliersResponseDescriptor instead')
const ListSuppliersResponse$json = {
  '1': 'ListSuppliersResponse',
  '2': [
    {
      '1': 'suppliers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Supplier',
      '10': 'suppliers'
    },
  ],
};

/// Descriptor for `ListSuppliersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSuppliersResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0U3VwcGxpZXJzUmVzcG9uc2USPwoJc3VwcGxpZXJzGAEgAygLMiEuaGVhbHRoY2FyZS'
    '5tYXRlcmlhbHMudjEuU3VwcGxpZXJSCXN1cHBsaWVycw==');

@$core.Deprecated('Use setStockLevelRequestDescriptor instead')
const SetStockLevelRequest$json = {
  '1': 'SetStockLevelRequest',
  '2': [
    {
      '1': 'level',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.StockLevel',
      '10': 'level'
    },
  ],
};

/// Descriptor for `SetStockLevelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setStockLevelRequestDescriptor = $convert.base64Decode(
    'ChRTZXRTdG9ja0xldmVsUmVxdWVzdBI5CgVsZXZlbBgBIAEoCzIjLmhlYWx0aGNhcmUubWF0ZX'
    'JpYWxzLnYxLlN0b2NrTGV2ZWxSBWxldmVs');

@$core.Deprecated('Use setStockLevelResponseDescriptor instead')
const SetStockLevelResponse$json = {
  '1': 'SetStockLevelResponse',
};

/// Descriptor for `SetStockLevelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setStockLevelResponseDescriptor =
    $convert.base64Decode('ChVTZXRTdG9ja0xldmVsUmVzcG9uc2U=');

@$core.Deprecated('Use listStockLevelsRequestDescriptor instead')
const ListStockLevelsRequest$json = {
  '1': 'ListStockLevelsRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListStockLevelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStockLevelsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0U3RvY2tMZXZlbHNSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2NhdGlvbk'
        'lkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listStockLevelsResponseDescriptor instead')
const ListStockLevelsResponse$json = {
  '1': 'ListStockLevelsResponse',
  '2': [
    {
      '1': 'levels',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.StockLevel',
      '10': 'levels'
    },
  ],
};

/// Descriptor for `ListStockLevelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStockLevelsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0U3RvY2tMZXZlbHNSZXNwb25zZRI7CgZsZXZlbHMYASADKAsyIy5oZWFsdGhjYXJlLm'
        '1hdGVyaWFscy52MS5TdG9ja0xldmVsUgZsZXZlbHM=');

@$core.Deprecated('Use addApprovalRuleRequestDescriptor instead')
const AddApprovalRuleRequest$json = {
  '1': 'AddApprovalRuleRequest',
  '2': [
    {'1': 'minimum_value', '3': 1, '4': 1, '5': 3, '10': 'minimumValue'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'roles', '3': 5, '4': 3, '5': 9, '10': 'roles'},
  ],
};

/// Descriptor for `AddApprovalRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addApprovalRuleRequestDescriptor = $convert.base64Decode(
    'ChZBZGRBcHByb3ZhbFJ1bGVSZXF1ZXN0EiMKDW1pbmltdW1fdmFsdWUYASABKANSDG1pbmltdW'
    '1WYWx1ZRIaCghjdXJyZW5jeRgCIAEoCVIIY3VycmVuY3kSGgoIY2F0ZWdvcnkYAyABKAlSCGNh'
    'dGVnb3J5Eh8KC2ZhY2lsaXR5X2lkGAQgASgJUgpmYWNpbGl0eUlkEhQKBXJvbGVzGAUgAygJUg'
    'Vyb2xlcw==');

@$core.Deprecated('Use addApprovalRuleResponseDescriptor instead')
const AddApprovalRuleResponse$json = {
  '1': 'AddApprovalRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.ApprovalRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `AddApprovalRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addApprovalRuleResponseDescriptor =
    $convert.base64Decode(
        'ChdBZGRBcHByb3ZhbFJ1bGVSZXNwb25zZRI5CgRydWxlGAEgASgLMiUuaGVhbHRoY2FyZS5tYX'
        'RlcmlhbHMudjEuQXBwcm92YWxSdWxlUgRydWxl');

@$core.Deprecated('Use listApprovalRulesRequestDescriptor instead')
const ListApprovalRulesRequest$json = {
  '1': 'ListApprovalRulesRequest',
};

/// Descriptor for `ListApprovalRulesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listApprovalRulesRequestDescriptor =
    $convert.base64Decode('ChhMaXN0QXBwcm92YWxSdWxlc1JlcXVlc3Q=');

@$core.Deprecated('Use listApprovalRulesResponseDescriptor instead')
const ListApprovalRulesResponse$json = {
  '1': 'ListApprovalRulesResponse',
  '2': [
    {
      '1': 'rules',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.ApprovalRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `ListApprovalRulesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listApprovalRulesResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0QXBwcm92YWxSdWxlc1Jlc3BvbnNlEjsKBXJ1bGVzGAEgAygLMiUuaGVhbHRoY2FyZS'
        '5tYXRlcmlhbHMudjEuQXBwcm92YWxSdWxlUgVydWxlcw==');

@$core.Deprecated('Use removeApprovalRuleRequestDescriptor instead')
const RemoveApprovalRuleRequest$json = {
  '1': 'RemoveApprovalRuleRequest',
  '2': [
    {'1': 'approval_rule_id', '3': 1, '4': 1, '5': 9, '10': 'approvalRuleId'},
  ],
};

/// Descriptor for `RemoveApprovalRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeApprovalRuleRequestDescriptor =
    $convert.base64Decode(
        'ChlSZW1vdmVBcHByb3ZhbFJ1bGVSZXF1ZXN0EigKEGFwcHJvdmFsX3J1bGVfaWQYASABKAlSDm'
        'FwcHJvdmFsUnVsZUlk');

@$core.Deprecated('Use removeApprovalRuleResponseDescriptor instead')
const RemoveApprovalRuleResponse$json = {
  '1': 'RemoveApprovalRuleResponse',
};

/// Descriptor for `RemoveApprovalRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeApprovalRuleResponseDescriptor =
    $convert.base64Decode('ChpSZW1vdmVBcHByb3ZhbFJ1bGVSZXNwb25zZQ==');

@$core.Deprecated('Use raiseRequisitionRequestDescriptor instead')
const RaiseRequisitionRequest$json = {
  '1': 'RaiseRequisitionRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'source',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.RequisitionSource',
      '10': 'source'
    },
    {
      '1': 'need_by',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'needBy'
    },
    {'1': 'cost_centre', '3': 5, '4': 1, '5': 9, '10': 'costCentre'},
    {'1': 'source_reference', '3': 6, '4': 1, '5': 9, '10': 'sourceReference'},
    {
      '1': 'lines',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.RequisitionLine',
      '10': 'lines'
    },
    {'1': 'justification', '3': 8, '4': 1, '5': 9, '10': 'justification'},
  ],
};

/// Descriptor for `RaiseRequisitionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseRequisitionRequestDescriptor = $convert.base64Decode(
    'ChdSYWlzZVJlcXVpc2l0aW9uUmVxdWVzdBIWCgZudW1iZXIYASABKAlSBm51bWJlchIfCgtmYW'
    'NpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBJCCgZzb3VyY2UYAyABKA4yKi5oZWFsdGhjYXJl'
    'Lm1hdGVyaWFscy52MS5SZXF1aXNpdGlvblNvdXJjZVIGc291cmNlEjMKB25lZWRfYnkYBCABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgZuZWVkQnkSHwoLY29zdF9jZW50cmUYBSAB'
    'KAlSCmNvc3RDZW50cmUSKQoQc291cmNlX3JlZmVyZW5jZRgGIAEoCVIPc291cmNlUmVmZXJlbm'
    'NlEj4KBWxpbmVzGAcgAygLMiguaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb25M'
    'aW5lUgVsaW5lcxIkCg1qdXN0aWZpY2F0aW9uGAggASgJUg1qdXN0aWZpY2F0aW9u');

@$core.Deprecated('Use raiseRequisitionResponseDescriptor instead')
const RaiseRequisitionResponse$json = {
  '1': 'RaiseRequisitionResponse',
  '2': [
    {
      '1': 'requisition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Requisition',
      '10': 'requisition'
    },
  ],
};

/// Descriptor for `RaiseRequisitionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseRequisitionResponseDescriptor =
    $convert.base64Decode(
        'ChhSYWlzZVJlcXVpc2l0aW9uUmVzcG9uc2USRgoLcmVxdWlzaXRpb24YASABKAsyJC5oZWFsdG'
        'hjYXJlLm1hdGVyaWFscy52MS5SZXF1aXNpdGlvblILcmVxdWlzaXRpb24=');

@$core.Deprecated('Use getApprovalRouteRequestDescriptor instead')
const GetApprovalRouteRequest$json = {
  '1': 'GetApprovalRouteRequest',
  '2': [
    {'1': 'requisition_id', '3': 1, '4': 1, '5': 9, '10': 'requisitionId'},
  ],
};

/// Descriptor for `GetApprovalRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getApprovalRouteRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRBcHByb3ZhbFJvdXRlUmVxdWVzdBIlCg5yZXF1aXNpdGlvbl9pZBgBIAEoCVINcmVxdW'
        'lzaXRpb25JZA==');

@$core.Deprecated('Use getApprovalRouteResponseDescriptor instead')
const GetApprovalRouteResponse$json = {
  '1': 'GetApprovalRouteResponse',
  '2': [
    {'1': 'roles', '3': 1, '4': 3, '5': 9, '10': 'roles'},
  ],
};

/// Descriptor for `GetApprovalRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getApprovalRouteResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRBcHByb3ZhbFJvdXRlUmVzcG9uc2USFAoFcm9sZXMYASADKAlSBXJvbGVz');

@$core.Deprecated('Use submitRequisitionRequestDescriptor instead')
const SubmitRequisitionRequest$json = {
  '1': 'SubmitRequisitionRequest',
  '2': [
    {'1': 'requisition_id', '3': 1, '4': 1, '5': 9, '10': 'requisitionId'},
  ],
};

/// Descriptor for `SubmitRequisitionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitRequisitionRequestDescriptor =
    $convert.base64Decode(
        'ChhTdWJtaXRSZXF1aXNpdGlvblJlcXVlc3QSJQoOcmVxdWlzaXRpb25faWQYASABKAlSDXJlcX'
        'Vpc2l0aW9uSWQ=');

@$core.Deprecated('Use submitRequisitionResponseDescriptor instead')
const SubmitRequisitionResponse$json = {
  '1': 'SubmitRequisitionResponse',
  '2': [
    {
      '1': 'requisition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Requisition',
      '10': 'requisition'
    },
    {'1': 'route', '3': 2, '4': 3, '5': 9, '10': 'route'},
  ],
};

/// Descriptor for `SubmitRequisitionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitRequisitionResponseDescriptor = $convert.base64Decode(
    'ChlTdWJtaXRSZXF1aXNpdGlvblJlc3BvbnNlEkYKC3JlcXVpc2l0aW9uGAEgASgLMiQuaGVhbH'
    'RoY2FyZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb25SC3JlcXVpc2l0aW9uEhQKBXJvdXRlGAIg'
    'AygJUgVyb3V0ZQ==');

@$core.Deprecated('Use decideRequisitionRequestDescriptor instead')
const DecideRequisitionRequest$json = {
  '1': 'DecideRequisitionRequest',
  '2': [
    {'1': 'requisition_id', '3': 1, '4': 1, '5': 9, '10': 'requisitionId'},
    {
      '1': 'decision',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.materials.v1.ApprovalDecision',
      '10': 'decision'
    },
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `DecideRequisitionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decideRequisitionRequestDescriptor = $convert.base64Decode(
    'ChhEZWNpZGVSZXF1aXNpdGlvblJlcXVlc3QSJQoOcmVxdWlzaXRpb25faWQYASABKAlSDXJlcX'
    'Vpc2l0aW9uSWQSRQoIZGVjaXNpb24YAiABKA4yKS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5B'
    'cHByb3ZhbERlY2lzaW9uUghkZWNpc2lvbhISCgRyb2xlGAMgASgJUgRyb2xlEhIKBG5vdGUYBC'
    'ABKAlSBG5vdGU=');

@$core.Deprecated('Use decideRequisitionResponseDescriptor instead')
const DecideRequisitionResponse$json = {
  '1': 'DecideRequisitionResponse',
  '2': [
    {
      '1': 'requisition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Requisition',
      '10': 'requisition'
    },
    {
      '1': 'step',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.ApprovalStep',
      '10': 'step'
    },
  ],
};

/// Descriptor for `DecideRequisitionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decideRequisitionResponseDescriptor = $convert.base64Decode(
    'ChlEZWNpZGVSZXF1aXNpdGlvblJlc3BvbnNlEkYKC3JlcXVpc2l0aW9uGAEgASgLMiQuaGVhbH'
    'RoY2FyZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb25SC3JlcXVpc2l0aW9uEjkKBHN0ZXAYAiAB'
    'KAsyJS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5BcHByb3ZhbFN0ZXBSBHN0ZXA=');

@$core.Deprecated('Use getRequisitionRequestDescriptor instead')
const GetRequisitionRequest$json = {
  '1': 'GetRequisitionRequest',
  '2': [
    {'1': 'requisition_id', '3': 1, '4': 1, '5': 9, '10': 'requisitionId'},
  ],
};

/// Descriptor for `GetRequisitionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequisitionRequestDescriptor = $convert.base64Decode(
    'ChVHZXRSZXF1aXNpdGlvblJlcXVlc3QSJQoOcmVxdWlzaXRpb25faWQYASABKAlSDXJlcXVpc2'
    'l0aW9uSWQ=');

@$core.Deprecated('Use getRequisitionResponseDescriptor instead')
const GetRequisitionResponse$json = {
  '1': 'GetRequisitionResponse',
  '2': [
    {
      '1': 'requisition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Requisition',
      '10': 'requisition'
    },
  ],
};

/// Descriptor for `GetRequisitionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequisitionResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRSZXF1aXNpdGlvblJlc3BvbnNlEkYKC3JlcXVpc2l0aW9uGAEgASgLMiQuaGVhbHRoY2'
        'FyZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb25SC3JlcXVpc2l0aW9u');

@$core.Deprecated('Use listRequisitionsRequestDescriptor instead')
const ListRequisitionsRequest$json = {
  '1': 'ListRequisitionsRequest',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 9, '10': 'state'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListRequisitionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequisitionsRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UmVxdWlzaXRpb25zUmVxdWVzdBIUCgVzdGF0ZRgBIAEoCVIFc3RhdGUSGwoJcGFnZV'
        '9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listRequisitionsResponseDescriptor instead')
const ListRequisitionsResponse$json = {
  '1': 'ListRequisitionsResponse',
  '2': [
    {
      '1': 'requisitions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Requisition',
      '10': 'requisitions'
    },
  ],
};

/// Descriptor for `ListRequisitionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequisitionsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0UmVxdWlzaXRpb25zUmVzcG9uc2USSAoMcmVxdWlzaXRpb25zGAEgAygLMiQuaGVhbH'
        'RoY2FyZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb25SDHJlcXVpc2l0aW9ucw==');

@$core.Deprecated('Use openRfqRequestDescriptor instead')
const OpenRfqRequest$json = {
  '1': 'OpenRfqRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'requisition_id', '3': 2, '4': 1, '5': 9, '10': 'requisitionId'},
    {'1': 'supplier_ids', '3': 3, '4': 3, '5': 9, '10': 'supplierIds'},
    {
      '1': 'lines',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.RequisitionLine',
      '10': 'lines'
    },
    {
      '1': 'closes_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closesAt'
    },
  ],
};

/// Descriptor for `OpenRfqRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openRfqRequestDescriptor = $convert.base64Decode(
    'Cg5PcGVuUmZxUmVxdWVzdBIWCgZudW1iZXIYASABKAlSBm51bWJlchIlCg5yZXF1aXNpdGlvbl'
    '9pZBgCIAEoCVINcmVxdWlzaXRpb25JZBIhCgxzdXBwbGllcl9pZHMYAyADKAlSC3N1cHBsaWVy'
    'SWRzEj4KBWxpbmVzGAQgAygLMiguaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmVxdWlzaXRpb2'
    '5MaW5lUgVsaW5lcxI3CgljbG9zZXNfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUghjbG9zZXNBdA==');

@$core.Deprecated('Use openRfqResponseDescriptor instead')
const OpenRfqResponse$json = {
  '1': 'OpenRfqResponse',
  '2': [
    {
      '1': 'rfq',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Rfq',
      '10': 'rfq'
    },
  ],
};

/// Descriptor for `OpenRfqResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openRfqResponseDescriptor = $convert.base64Decode(
    'Cg9PcGVuUmZxUmVzcG9uc2USLgoDcmZxGAEgASgLMhwuaGVhbHRoY2FyZS5tYXRlcmlhbHMudj'
    'EuUmZxUgNyZnE=');

@$core.Deprecated('Use recordBidRequestDescriptor instead')
const RecordBidRequest$json = {
  '1': 'RecordBidRequest',
  '2': [
    {'1': 'rfq_id', '3': 1, '4': 1, '5': 9, '10': 'rfqId'},
    {'1': 'supplier_id', '3': 2, '4': 1, '5': 9, '10': 'supplierId'},
    {
      '1': 'lines',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.BidLine',
      '10': 'lines'
    },
    {'1': 'lead_time_days', '3': 4, '4': 1, '5': 5, '10': 'leadTimeDays'},
    {'1': 'warranty_months', '3': 5, '4': 1, '5': 5, '10': 'warrantyMonths'},
    {
      '1': 'payment_terms_days',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'freight_minor', '3': 7, '4': 1, '5': 3, '10': 'freightMinor'},
    {'1': 'tax_minor', '3': 8, '4': 1, '5': 3, '10': 'taxMinor'},
    {'1': 'currency', '3': 9, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'notes', '3': 10, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RecordBidRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordBidRequestDescriptor = $convert.base64Decode(
    'ChBSZWNvcmRCaWRSZXF1ZXN0EhUKBnJmcV9pZBgBIAEoCVIFcmZxSWQSHwoLc3VwcGxpZXJfaW'
    'QYAiABKAlSCnN1cHBsaWVySWQSNgoFbGluZXMYAyADKAsyIC5oZWFsdGhjYXJlLm1hdGVyaWFs'
    'cy52MS5CaWRMaW5lUgVsaW5lcxIkCg5sZWFkX3RpbWVfZGF5cxgEIAEoBVIMbGVhZFRpbWVEYX'
    'lzEicKD3dhcnJhbnR5X21vbnRocxgFIAEoBVIOd2FycmFudHlNb250aHMSLAoScGF5bWVudF90'
    'ZXJtc19kYXlzGAYgASgFUhBwYXltZW50VGVybXNEYXlzEiMKDWZyZWlnaHRfbWlub3IYByABKA'
    'NSDGZyZWlnaHRNaW5vchIbCgl0YXhfbWlub3IYCCABKANSCHRheE1pbm9yEhoKCGN1cnJlbmN5'
    'GAkgASgJUghjdXJyZW5jeRIUCgVub3RlcxgKIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use recordBidResponseDescriptor instead')
const RecordBidResponse$json = {
  '1': 'RecordBidResponse',
  '2': [
    {
      '1': 'bid',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Bid',
      '10': 'bid'
    },
  ],
};

/// Descriptor for `RecordBidResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordBidResponseDescriptor = $convert.base64Decode(
    'ChFSZWNvcmRCaWRSZXNwb25zZRIuCgNiaWQYASABKAsyHC5oZWFsdGhjYXJlLm1hdGVyaWFscy'
    '52MS5CaWRSA2JpZA==');

@$core.Deprecated('Use compareBidsRequestDescriptor instead')
const CompareBidsRequest$json = {
  '1': 'CompareBidsRequest',
  '2': [
    {'1': 'rfq_id', '3': 1, '4': 1, '5': 9, '10': 'rfqId'},
  ],
};

/// Descriptor for `CompareBidsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareBidsRequestDescriptor =
    $convert.base64Decode(
        'ChJDb21wYXJlQmlkc1JlcXVlc3QSFQoGcmZxX2lkGAEgASgJUgVyZnFJZA==');

@$core.Deprecated('Use compareBidsResponseDescriptor instead')
const CompareBidsResponse$json = {
  '1': 'CompareBidsResponse',
  '2': [
    {
      '1': 'comparisons',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Comparison',
      '10': 'comparisons'
    },
  ],
};

/// Descriptor for `CompareBidsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareBidsResponseDescriptor = $convert.base64Decode(
    'ChNDb21wYXJlQmlkc1Jlc3BvbnNlEkUKC2NvbXBhcmlzb25zGAEgAygLMiMuaGVhbHRoY2FyZS'
    '5tYXRlcmlhbHMudjEuQ29tcGFyaXNvblILY29tcGFyaXNvbnM=');

@$core.Deprecated('Use getRfqRequestDescriptor instead')
const GetRfqRequest$json = {
  '1': 'GetRfqRequest',
  '2': [
    {'1': 'rfq_id', '3': 1, '4': 1, '5': 9, '10': 'rfqId'},
  ],
};

/// Descriptor for `GetRfqRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRfqRequestDescriptor = $convert
    .base64Decode('Cg1HZXRSZnFSZXF1ZXN0EhUKBnJmcV9pZBgBIAEoCVIFcmZxSWQ=');

@$core.Deprecated('Use getRfqResponseDescriptor instead')
const GetRfqResponse$json = {
  '1': 'GetRfqResponse',
  '2': [
    {
      '1': 'rfq',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Rfq',
      '10': 'rfq'
    },
  ],
};

/// Descriptor for `GetRfqResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRfqResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRSZnFSZXNwb25zZRIuCgNyZnEYASABKAsyHC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS'
    '5SZnFSA3JmcQ==');

@$core.Deprecated('Use listRfqsRequestDescriptor instead')
const ListRfqsRequest$json = {
  '1': 'ListRfqsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListRfqsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRfqsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0UmZxc1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listRfqsResponseDescriptor instead')
const ListRfqsResponse$json = {
  '1': 'ListRfqsResponse',
  '2': [
    {
      '1': 'rfqs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Rfq',
      '10': 'rfqs'
    },
  ],
};

/// Descriptor for `ListRfqsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRfqsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0UmZxc1Jlc3BvbnNlEjAKBHJmcXMYASADKAsyHC5oZWFsdGhjYXJlLm1hdGVyaWFscy'
    '52MS5SZnFSBHJmcXM=');

@$core.Deprecated('Use placeOrderRequestDescriptor instead')
const PlaceOrderRequest$json = {
  '1': 'PlaceOrderRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'supplier_id', '3': 3, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'requisition_id', '3': 4, '4': 1, '5': 9, '10': 'requisitionId'},
    {'1': 'bid_id', '3': 5, '4': 1, '5': 9, '10': 'bidId'},
    {
      '1': 'lines',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrderLine',
      '10': 'lines'
    },
    {'1': 'currency', '3': 7, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'payment_terms_days',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'paymentTermsDays'
    },
    {'1': 'delivery_terms', '3': 9, '4': 1, '5': 9, '10': 'deliveryTerms'},
    {
      '1': 'tolerance_over_percent',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'toleranceOverPercent'
    },
    {
      '1': 'tolerance_short_percent',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'toleranceShortPercent'
    },
  ],
};

/// Descriptor for `PlaceOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeOrderRequestDescriptor = $convert.base64Decode(
    'ChFQbGFjZU9yZGVyUmVxdWVzdBIWCgZudW1iZXIYASABKAlSBm51bWJlchIfCgtmYWNpbGl0eV'
    '9pZBgCIAEoCVIKZmFjaWxpdHlJZBIfCgtzdXBwbGllcl9pZBgDIAEoCVIKc3VwcGxpZXJJZBIl'
    'Cg5yZXF1aXNpdGlvbl9pZBgEIAEoCVINcmVxdWlzaXRpb25JZBIVCgZiaWRfaWQYBSABKAlSBW'
    'JpZElkEkAKBWxpbmVzGAYgAygLMiouaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUHVyY2hhc2VP'
    'cmRlckxpbmVSBWxpbmVzEhoKCGN1cnJlbmN5GAcgASgJUghjdXJyZW5jeRIsChJwYXltZW50X3'
    'Rlcm1zX2RheXMYCCABKAVSEHBheW1lbnRUZXJtc0RheXMSJQoOZGVsaXZlcnlfdGVybXMYCSAB'
    'KAlSDWRlbGl2ZXJ5VGVybXMSNAoWdG9sZXJhbmNlX292ZXJfcGVyY2VudBgKIAEoBVIUdG9sZX'
    'JhbmNlT3ZlclBlcmNlbnQSNgoXdG9sZXJhbmNlX3Nob3J0X3BlcmNlbnQYCyABKAVSFXRvbGVy'
    'YW5jZVNob3J0UGVyY2VudA==');

@$core.Deprecated('Use placeOrderResponseDescriptor instead')
const PlaceOrderResponse$json = {
  '1': 'PlaceOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `PlaceOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeOrderResponseDescriptor = $convert.base64Decode(
    'ChJQbGFjZU9yZGVyUmVzcG9uc2USPAoFb3JkZXIYASABKAsyJi5oZWFsdGhjYXJlLm1hdGVyaW'
    'Fscy52MS5QdXJjaGFzZU9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use issueOrderRequestDescriptor instead')
const IssueOrderRequest$json = {
  '1': 'IssueOrderRequest',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
  ],
};

/// Descriptor for `IssueOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueOrderRequestDescriptor = $convert.base64Decode(
    'ChFJc3N1ZU9yZGVyUmVxdWVzdBIqChFwdXJjaGFzZV9vcmRlcl9pZBgBIAEoCVIPcHVyY2hhc2'
    'VPcmRlcklk');

@$core.Deprecated('Use issueOrderResponseDescriptor instead')
const IssueOrderResponse$json = {
  '1': 'IssueOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `IssueOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueOrderResponseDescriptor = $convert.base64Decode(
    'ChJJc3N1ZU9yZGVyUmVzcG9uc2USPAoFb3JkZXIYASABKAsyJi5oZWFsdGhjYXJlLm1hdGVyaW'
    'Fscy52MS5QdXJjaGFzZU9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use amendOrderRequestDescriptor instead')
const AmendOrderRequest$json = {
  '1': 'AmendOrderRequest',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {
      '1': 'lines',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrderLine',
      '10': 'lines'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AmendOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendOrderRequestDescriptor = $convert.base64Decode(
    'ChFBbWVuZE9yZGVyUmVxdWVzdBIqChFwdXJjaGFzZV9vcmRlcl9pZBgBIAEoCVIPcHVyY2hhc2'
    'VPcmRlcklkEkAKBWxpbmVzGAIgAygLMiouaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUHVyY2hh'
    'c2VPcmRlckxpbmVSBWxpbmVzEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use amendOrderResponseDescriptor instead')
const AmendOrderResponse$json = {
  '1': 'AmendOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `AmendOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendOrderResponseDescriptor = $convert.base64Decode(
    'ChJBbWVuZE9yZGVyUmVzcG9uc2USPAoFb3JkZXIYASABKAsyJi5oZWFsdGhjYXJlLm1hdGVyaW'
    'Fscy52MS5QdXJjaGFzZU9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use getPurchaseOrderRequestDescriptor instead')
const GetPurchaseOrderRequest$json = {
  '1': 'GetPurchaseOrderRequest',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
  ],
};

/// Descriptor for `GetPurchaseOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPurchaseOrderRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRQdXJjaGFzZU9yZGVyUmVxdWVzdBIqChFwdXJjaGFzZV9vcmRlcl9pZBgBIAEoCVIPcH'
        'VyY2hhc2VPcmRlcklk');

@$core.Deprecated('Use getPurchaseOrderResponseDescriptor instead')
const GetPurchaseOrderResponse$json = {
  '1': 'GetPurchaseOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `GetPurchaseOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPurchaseOrderResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRQdXJjaGFzZU9yZGVyUmVzcG9uc2USPAoFb3JkZXIYASABKAsyJi5oZWFsdGhjYXJlLm'
        '1hdGVyaWFscy52MS5QdXJjaGFzZU9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use listOrderRevisionsRequestDescriptor instead')
const ListOrderRevisionsRequest$json = {
  '1': 'ListOrderRevisionsRequest',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
  ],
};

/// Descriptor for `ListOrderRevisionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOrderRevisionsRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0T3JkZXJSZXZpc2lvbnNSZXF1ZXN0EioKEXB1cmNoYXNlX29yZGVyX2lkGAEgASgJUg'
        '9wdXJjaGFzZU9yZGVySWQ=');

@$core.Deprecated('Use listOrderRevisionsResponseDescriptor instead')
const ListOrderRevisionsResponse$json = {
  '1': 'ListOrderRevisionsResponse',
  '2': [
    {
      '1': 'revisions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrder',
      '10': 'revisions'
    },
  ],
};

/// Descriptor for `ListOrderRevisionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOrderRevisionsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0T3JkZXJSZXZpc2lvbnNSZXNwb25zZRJECglyZXZpc2lvbnMYASADKAsyJi5oZWFsdG'
        'hjYXJlLm1hdGVyaWFscy52MS5QdXJjaGFzZU9yZGVyUglyZXZpc2lvbnM=');

@$core.Deprecated('Use listPurchaseOrdersRequestDescriptor instead')
const ListPurchaseOrdersRequest$json = {
  '1': 'ListPurchaseOrdersRequest',
  '2': [
    {'1': 'supplier_id', '3': 1, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'state', '3': 2, '4': 1, '5': 9, '10': 'state'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPurchaseOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPurchaseOrdersRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0UHVyY2hhc2VPcmRlcnNSZXF1ZXN0Eh8KC3N1cHBsaWVyX2lkGAEgASgJUgpzdXBwbG'
    'llcklkEhQKBXN0YXRlGAIgASgJUgVzdGF0ZRIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listPurchaseOrdersResponseDescriptor instead')
const ListPurchaseOrdersResponse$json = {
  '1': 'ListPurchaseOrdersResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.PurchaseOrder',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `ListPurchaseOrdersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPurchaseOrdersResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0UHVyY2hhc2VPcmRlcnNSZXNwb25zZRI+CgZvcmRlcnMYASADKAsyJi5oZWFsdGhjYX'
        'JlLm1hdGVyaWFscy52MS5QdXJjaGFzZU9yZGVyUgZvcmRlcnM=');

@$core.Deprecated('Use receiveGoodsRequestDescriptor instead')
const ReceiveGoodsRequest$json = {
  '1': 'ReceiveGoodsRequest',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'delivery_note', '3': 4, '4': 1, '5': 9, '10': 'deliveryNote'},
    {'1': 'invoice_ref', '3': 5, '4': 1, '5': 9, '10': 'invoiceRef'},
    {
      '1': 'lines',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.ReceiptLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `ReceiveGoodsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveGoodsRequestDescriptor = $convert.base64Decode(
    'ChNSZWNlaXZlR29vZHNSZXF1ZXN0EioKEXB1cmNoYXNlX29yZGVyX2lkGAEgASgJUg9wdXJjaG'
    'FzZU9yZGVySWQSFgoGbnVtYmVyGAIgASgJUgZudW1iZXISHwoLbG9jYXRpb25faWQYAyABKAlS'
    'CmxvY2F0aW9uSWQSIwoNZGVsaXZlcnlfbm90ZRgEIAEoCVIMZGVsaXZlcnlOb3RlEh8KC2ludm'
    '9pY2VfcmVmGAUgASgJUgppbnZvaWNlUmVmEjoKBWxpbmVzGAYgAygLMiQuaGVhbHRoY2FyZS5t'
    'YXRlcmlhbHMudjEuUmVjZWlwdExpbmVSBWxpbmVz');

@$core.Deprecated('Use receiveGoodsResponseDescriptor instead')
const ReceiveGoodsResponse$json = {
  '1': 'ReceiveGoodsResponse',
  '2': [
    {
      '1': 'receipt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Receipt',
      '10': 'receipt'
    },
    {'1': 'short', '3': 2, '4': 3, '5': 9, '10': 'short'},
    {'1': 'quarantined', '3': 3, '4': 3, '5': 9, '10': 'quarantined'},
  ],
};

/// Descriptor for `ReceiveGoodsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveGoodsResponseDescriptor = $convert.base64Decode(
    'ChRSZWNlaXZlR29vZHNSZXNwb25zZRI6CgdyZWNlaXB0GAEgASgLMiAuaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuUmVjZWlwdFIHcmVjZWlwdBIUCgVzaG9ydBgCIAMoCVIFc2hvcnQSIAoLcXVh'
    'cmFudGluZWQYAyADKAlSC3F1YXJhbnRpbmVk');

@$core.Deprecated('Use inspectRequestDescriptor instead')
const InspectRequest$json = {
  '1': 'InspectRequest',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'accept', '3': 4, '4': 1, '5': 8, '10': 'accept'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `InspectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inspectRequestDescriptor = $convert.base64Decode(
    'Cg5JbnNwZWN0UmVxdWVzdBIVCgZsb3RfaWQYASABKAlSBWxvdElkEh8KC2xvY2F0aW9uX2lkGA'
    'IgASgJUgpsb2NhdGlvbklkEhoKCHF1YW50aXR5GAMgASgFUghxdWFudGl0eRIWCgZhY2NlcHQY'
    'BCABKAhSBmFjY2VwdBIWCgZyZWFzb24YBSABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use inspectResponseDescriptor instead')
const InspectResponse$json = {
  '1': 'InspectResponse',
  '2': [
    {
      '1': 'movement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Movement',
      '10': 'movement'
    },
  ],
};

/// Descriptor for `InspectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inspectResponseDescriptor = $convert.base64Decode(
    'Cg9JbnNwZWN0UmVzcG9uc2USPQoIbW92ZW1lbnQYASABKAsyIS5oZWFsdGhjYXJlLm1hdGVyaW'
    'Fscy52MS5Nb3ZlbWVudFIIbW92ZW1lbnQ=');

@$core.Deprecated('Use getReceiptRequestDescriptor instead')
const GetReceiptRequest$json = {
  '1': 'GetReceiptRequest',
  '2': [
    {'1': 'receipt_id', '3': 1, '4': 1, '5': 9, '10': 'receiptId'},
  ],
};

/// Descriptor for `GetReceiptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReceiptRequestDescriptor = $convert.base64Decode(
    'ChFHZXRSZWNlaXB0UmVxdWVzdBIdCgpyZWNlaXB0X2lkGAEgASgJUglyZWNlaXB0SWQ=');

@$core.Deprecated('Use getReceiptResponseDescriptor instead')
const GetReceiptResponse$json = {
  '1': 'GetReceiptResponse',
  '2': [
    {
      '1': 'receipt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Receipt',
      '10': 'receipt'
    },
  ],
};

/// Descriptor for `GetReceiptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReceiptResponseDescriptor = $convert.base64Decode(
    'ChJHZXRSZWNlaXB0UmVzcG9uc2USOgoHcmVjZWlwdBgBIAEoCzIgLmhlYWx0aGNhcmUubWF0ZX'
    'JpYWxzLnYxLlJlY2VpcHRSB3JlY2VpcHQ=');

@$core.Deprecated('Use listReceiptsRequestDescriptor instead')
const ListReceiptsRequest$json = {
  '1': 'ListReceiptsRequest',
  '2': [
    {'1': 'purchase_order_id', '3': 1, '4': 1, '5': 9, '10': 'purchaseOrderId'},
  ],
};

/// Descriptor for `ListReceiptsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReceiptsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVjZWlwdHNSZXF1ZXN0EioKEXB1cmNoYXNlX29yZGVyX2lkGAEgASgJUg9wdXJjaG'
    'FzZU9yZGVySWQ=');

@$core.Deprecated('Use listReceiptsResponseDescriptor instead')
const ListReceiptsResponse$json = {
  '1': 'ListReceiptsResponse',
  '2': [
    {
      '1': 'receipts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Receipt',
      '10': 'receipts'
    },
  ],
};

/// Descriptor for `ListReceiptsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReceiptsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVjZWlwdHNSZXNwb25zZRI8CghyZWNlaXB0cxgBIAMoCzIgLmhlYWx0aGNhcmUubW'
    'F0ZXJpYWxzLnYxLlJlY2VpcHRSCHJlY2VpcHRz');

@$core.Deprecated('Use recommendPickRequestDescriptor instead')
const RecommendPickRequest$json = {
  '1': 'RecommendPickRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `RecommendPickRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recommendPickRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvbW1lbmRQaWNrUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSHwoLbG9jYX'
    'Rpb25faWQYAiABKAlSCmxvY2F0aW9uSWQSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5');

@$core.Deprecated('Use recommendPickResponseDescriptor instead')
const RecommendPickResponse$json = {
  '1': 'RecommendPickResponse',
  '2': [
    {
      '1': 'pick',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Pick',
      '10': 'pick'
    },
  ],
};

/// Descriptor for `RecommendPickResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recommendPickResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvbW1lbmRQaWNrUmVzcG9uc2USMQoEcGljaxgBIAEoCzIdLmhlYWx0aGNhcmUubWF0ZX'
    'JpYWxzLnYxLlBpY2tSBHBpY2s=');

@$core.Deprecated('Use issueStockRequestDescriptor instead')
const IssueStockRequest$json = {
  '1': 'IssueStockRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'lot_id', '3': 2, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'from_location', '3': 3, '4': 1, '5': 9, '10': 'fromLocation'},
    {'1': 'to_location', '3': 4, '4': 1, '5': 9, '10': 'toLocation'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'cost_centre', '3': 6, '4': 1, '5': 9, '10': 'costCentre'},
    {'1': 'patient_id', '3': 7, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 8, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'reference', '3': 9, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'reason', '3': 10, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `IssueStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueStockRequestDescriptor = $convert.base64Decode(
    'ChFJc3N1ZVN0b2NrUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSFQoGbG90X2lkGA'
    'IgASgJUgVsb3RJZBIjCg1mcm9tX2xvY2F0aW9uGAMgASgJUgxmcm9tTG9jYXRpb24SHwoLdG9f'
    'bG9jYXRpb24YBCABKAlSCnRvTG9jYXRpb24SGgoIcXVhbnRpdHkYBSABKAVSCHF1YW50aXR5Eh'
    '8KC2Nvc3RfY2VudHJlGAYgASgJUgpjb3N0Q2VudHJlEh0KCnBhdGllbnRfaWQYByABKAlSCXBh'
    'dGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYCCABKAlSC2VuY291bnRlcklkEhwKCXJlZmVyZW5jZR'
    'gJIAEoCVIJcmVmZXJlbmNlEhYKBnJlYXNvbhgKIAEoCVIGcmVhc29u');

@$core.Deprecated('Use issueStockResponseDescriptor instead')
const IssueStockResponse$json = {
  '1': 'IssueStockResponse',
  '2': [
    {
      '1': 'movements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Movement',
      '10': 'movements'
    },
    {'1': 'short', '3': 2, '4': 1, '5': 5, '10': 'short'},
    {'1': 'skipped', '3': 3, '4': 3, '5': 9, '10': 'skipped'},
    {'1': 'charge_id', '3': 4, '4': 1, '5': 9, '10': 'chargeId'},
    {
      '1': 'liabilities',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.LiabilityEvent',
      '10': 'liabilities'
    },
  ],
};

/// Descriptor for `IssueStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueStockResponseDescriptor = $convert.base64Decode(
    'ChJJc3N1ZVN0b2NrUmVzcG9uc2USPwoJbW92ZW1lbnRzGAEgAygLMiEuaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuTW92ZW1lbnRSCW1vdmVtZW50cxIUCgVzaG9ydBgCIAEoBVIFc2hvcnQSGAoH'
    'c2tpcHBlZBgDIAMoCVIHc2tpcHBlZBIbCgljaGFyZ2VfaWQYBCABKAlSCGNoYXJnZUlkEkkKC2'
    'xpYWJpbGl0aWVzGAUgAygLMicuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlhYmlsaXR5RXZl'
    'bnRSC2xpYWJpbGl0aWVz');

@$core.Deprecated('Use returnStockRequestDescriptor instead')
const ReturnStockRequest$json = {
  '1': 'ReturnStockRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'lot_id', '3': 2, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'from_location', '3': 3, '4': 1, '5': 9, '10': 'fromLocation'},
    {'1': 'to_location', '3': 4, '4': 1, '5': 9, '10': 'toLocation'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'cost_centre', '3': 6, '4': 1, '5': 9, '10': 'costCentre'},
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReturnStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnStockRequestDescriptor = $convert.base64Decode(
    'ChJSZXR1cm5TdG9ja1JlcXVlc3QSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhUKBmxvdF9pZB'
    'gCIAEoCVIFbG90SWQSIwoNZnJvbV9sb2NhdGlvbhgDIAEoCVIMZnJvbUxvY2F0aW9uEh8KC3Rv'
    'X2xvY2F0aW9uGAQgASgJUgp0b0xvY2F0aW9uEhoKCHF1YW50aXR5GAUgASgFUghxdWFudGl0eR'
    'IfCgtjb3N0X2NlbnRyZRgGIAEoCVIKY29zdENlbnRyZRIWCgZyZWFzb24YByABKAlSBnJlYXNv'
    'bg==');

@$core.Deprecated('Use returnStockResponseDescriptor instead')
const ReturnStockResponse$json = {
  '1': 'ReturnStockResponse',
  '2': [
    {
      '1': 'movement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Movement',
      '10': 'movement'
    },
  ],
};

/// Descriptor for `ReturnStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnStockResponseDescriptor = $convert.base64Decode(
    'ChNSZXR1cm5TdG9ja1Jlc3BvbnNlEj0KCG1vdmVtZW50GAEgASgLMiEuaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuTW92ZW1lbnRSCG1vdmVtZW50');

@$core.Deprecated('Use listBalancesRequestDescriptor instead')
const ListBalancesRequest$json = {
  '1': 'ListBalancesRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListBalancesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBalancesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0QmFsYW5jZXNSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2NhdGlvbklkEh'
    'cKB2l0ZW1faWQYAiABKAlSBml0ZW1JZBIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listBalancesResponseDescriptor instead')
const ListBalancesResponse$json = {
  '1': 'ListBalancesResponse',
  '2': [
    {
      '1': 'balances',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Balance',
      '10': 'balances'
    },
  ],
};

/// Descriptor for `ListBalancesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBalancesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QmFsYW5jZXNSZXNwb25zZRI8CghiYWxhbmNlcxgBIAMoCzIgLmhlYWx0aGNhcmUubW'
    'F0ZXJpYWxzLnYxLkJhbGFuY2VSCGJhbGFuY2Vz');

@$core.Deprecated('Use getAvailableRequestDescriptor instead')
const GetAvailableRequest$json = {
  '1': 'GetAvailableRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
  ],
};

/// Descriptor for `GetAvailableRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAvailableRequestDescriptor = $convert.base64Decode(
    'ChNHZXRBdmFpbGFibGVSZXF1ZXN0EhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIfCgtsb2NhdG'
    'lvbl9pZBgCIAEoCVIKbG9jYXRpb25JZA==');

@$core.Deprecated('Use getAvailableResponseDescriptor instead')
const GetAvailableResponse$json = {
  '1': 'GetAvailableResponse',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 5, '10': 'available'},
  ],
};

/// Descriptor for `GetAvailableResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAvailableResponseDescriptor = $convert.base64Decode(
    'ChRHZXRBdmFpbGFibGVSZXNwb25zZRIcCglhdmFpbGFibGUYASABKAVSCWF2YWlsYWJsZQ==');

@$core.Deprecated('Use listMovementsRequestDescriptor instead')
const ListMovementsRequest$json = {
  '1': 'ListMovementsRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'period_start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListMovementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMovementsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0TW92ZW1lbnRzUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSPQoMcGVyaW'
    '9kX3N0YXJ0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcGVyaW9kU3RhcnQS'
    'OQoKcGVyaW9kX2VuZBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXBlcmlvZE'
    'VuZBIbCglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listMovementsResponseDescriptor instead')
const ListMovementsResponse$json = {
  '1': 'ListMovementsResponse',
  '2': [
    {
      '1': 'movements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Movement',
      '10': 'movements'
    },
  ],
};

/// Descriptor for `ListMovementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMovementsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0TW92ZW1lbnRzUmVzcG9uc2USPwoJbW92ZW1lbnRzGAEgAygLMiEuaGVhbHRoY2FyZS'
    '5tYXRlcmlhbHMudjEuTW92ZW1lbnRSCW1vdmVtZW50cw==');

@$core.Deprecated('Use dispatchTransferRequestDescriptor instead')
const DispatchTransferRequest$json = {
  '1': 'DispatchTransferRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'from_location', '3': 2, '4': 1, '5': 9, '10': 'fromLocation'},
    {'1': 'to_location', '3': 3, '4': 1, '5': 9, '10': 'toLocation'},
    {
      '1': 'lines',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.TransferLine',
      '10': 'lines'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `DispatchTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispatchTransferRequestDescriptor = $convert.base64Decode(
    'ChdEaXNwYXRjaFRyYW5zZmVyUmVxdWVzdBIWCgZudW1iZXIYASABKAlSBm51bWJlchIjCg1mcm'
    '9tX2xvY2F0aW9uGAIgASgJUgxmcm9tTG9jYXRpb24SHwoLdG9fbG9jYXRpb24YAyABKAlSCnRv'
    'TG9jYXRpb24SOwoFbGluZXMYBCADKAsyJS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5UcmFuc2'
    'ZlckxpbmVSBWxpbmVzEhYKBnJlYXNvbhgFIAEoCVIGcmVhc29u');

@$core.Deprecated('Use dispatchTransferResponseDescriptor instead')
const DispatchTransferResponse$json = {
  '1': 'DispatchTransferResponse',
  '2': [
    {
      '1': 'transfer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Transfer',
      '10': 'transfer'
    },
  ],
};

/// Descriptor for `DispatchTransferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispatchTransferResponseDescriptor =
    $convert.base64Decode(
        'ChhEaXNwYXRjaFRyYW5zZmVyUmVzcG9uc2USPQoIdHJhbnNmZXIYASABKAsyIS5oZWFsdGhjYX'
        'JlLm1hdGVyaWFscy52MS5UcmFuc2ZlclIIdHJhbnNmZXI=');

@$core.Deprecated('Use receiveTransferRequestDescriptor instead')
const ReceiveTransferRequest$json = {
  '1': 'ReceiveTransferRequest',
  '2': [
    {'1': 'transfer_id', '3': 1, '4': 1, '5': 9, '10': 'transferId'},
    {
      '1': 'counted',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.ReceiveTransferRequest.CountedEntry',
      '10': 'counted'
    },
  ],
  '3': [ReceiveTransferRequest_CountedEntry$json],
};

@$core.Deprecated('Use receiveTransferRequestDescriptor instead')
const ReceiveTransferRequest_CountedEntry$json = {
  '1': 'CountedEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ReceiveTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveTransferRequestDescriptor = $convert.base64Decode(
    'ChZSZWNlaXZlVHJhbnNmZXJSZXF1ZXN0Eh8KC3RyYW5zZmVyX2lkGAEgASgJUgp0cmFuc2Zlck'
    'lkElYKB2NvdW50ZWQYAiADKAsyPC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SZWNlaXZlVHJh'
    'bnNmZXJSZXF1ZXN0LkNvdW50ZWRFbnRyeVIHY291bnRlZBo6CgxDb3VudGVkRW50cnkSEAoDa2'
    'V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use receiveTransferResponseDescriptor instead')
const ReceiveTransferResponse$json = {
  '1': 'ReceiveTransferResponse',
  '2': [
    {
      '1': 'transfer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Transfer',
      '10': 'transfer'
    },
    {'1': 'short', '3': 2, '4': 3, '5': 9, '10': 'short'},
  ],
};

/// Descriptor for `ReceiveTransferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveTransferResponseDescriptor = $convert.base64Decode(
    'ChdSZWNlaXZlVHJhbnNmZXJSZXNwb25zZRI9Cgh0cmFuc2ZlchgBIAEoCzIhLmhlYWx0aGNhcm'
    'UubWF0ZXJpYWxzLnYxLlRyYW5zZmVyUgh0cmFuc2ZlchIUCgVzaG9ydBgCIAMoCVIFc2hvcnQ=');

@$core.Deprecated('Use listTransfersInTransitRequestDescriptor instead')
const ListTransfersInTransitRequest$json = {
  '1': 'ListTransfersInTransitRequest',
  '2': [
    {'1': 'to_location', '3': 1, '4': 1, '5': 9, '10': 'toLocation'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListTransfersInTransitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransfersInTransitRequestDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0VHJhbnNmZXJzSW5UcmFuc2l0UmVxdWVzdBIfCgt0b19sb2NhdGlvbhgBIAEoCVIKdG'
        '9Mb2NhdGlvbhIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listTransfersInTransitResponseDescriptor instead')
const ListTransfersInTransitResponse$json = {
  '1': 'ListTransfersInTransitResponse',
  '2': [
    {
      '1': 'transfers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Transfer',
      '10': 'transfers'
    },
  ],
};

/// Descriptor for `ListTransfersInTransitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransfersInTransitResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0VHJhbnNmZXJzSW5UcmFuc2l0UmVzcG9uc2USPwoJdHJhbnNmZXJzGAEgAygLMiEuaG'
        'VhbHRoY2FyZS5tYXRlcmlhbHMudjEuVHJhbnNmZXJSCXRyYW5zZmVycw==');

@$core.Deprecated('Use openCountRequestDescriptor instead')
const OpenCountRequest$json = {
  '1': 'OpenCountRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'cycle', '3': 3, '4': 1, '5': 8, '10': 'cycle'},
    {'1': 'item_ids', '3': 4, '4': 3, '5': 9, '10': 'itemIds'},
  ],
};

/// Descriptor for `OpenCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCountRequestDescriptor = $convert.base64Decode(
    'ChBPcGVuQ291bnRSZXF1ZXN0EhYKBm51bWJlchgBIAEoCVIGbnVtYmVyEh8KC2xvY2F0aW9uX2'
    'lkGAIgASgJUgpsb2NhdGlvbklkEhQKBWN5Y2xlGAMgASgIUgVjeWNsZRIZCghpdGVtX2lkcxgE'
    'IAMoCVIHaXRlbUlkcw==');

@$core.Deprecated('Use openCountResponseDescriptor instead')
const OpenCountResponse$json = {
  '1': 'OpenCountResponse',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Count',
      '10': 'count'
    },
  ],
};

/// Descriptor for `OpenCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCountResponseDescriptor = $convert.base64Decode(
    'ChFPcGVuQ291bnRSZXNwb25zZRI0CgVjb3VudBgBIAEoCzIeLmhlYWx0aGNhcmUubWF0ZXJpYW'
    'xzLnYxLkNvdW50UgVjb3VudA==');

@$core.Deprecated('Use recordCountRequestDescriptor instead')
const RecordCountRequest$json = {
  '1': 'RecordCountRequest',
  '2': [
    {'1': 'count_id', '3': 1, '4': 1, '5': 9, '10': 'countId'},
    {
      '1': 'lines',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.CountLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `RecordCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCountRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRDb3VudFJlcXVlc3QSGQoIY291bnRfaWQYASABKAlSB2NvdW50SWQSOAoFbGluZX'
    'MYAiADKAsyIi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5Db3VudExpbmVSBWxpbmVz');

@$core.Deprecated('Use recordCountResponseDescriptor instead')
const RecordCountResponse$json = {
  '1': 'RecordCountResponse',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Count',
      '10': 'count'
    },
  ],
};

/// Descriptor for `RecordCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCountResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRDb3VudFJlc3BvbnNlEjQKBWNvdW50GAEgASgLMh4uaGVhbHRoY2FyZS5tYXRlcm'
    'lhbHMudjEuQ291bnRSBWNvdW50');

@$core.Deprecated('Use approveCountRequestDescriptor instead')
const ApproveCountRequest$json = {
  '1': 'ApproveCountRequest',
  '2': [
    {'1': 'count_id', '3': 1, '4': 1, '5': 9, '10': 'countId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ApproveCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveCountRequestDescriptor = $convert.base64Decode(
    'ChNBcHByb3ZlQ291bnRSZXF1ZXN0EhkKCGNvdW50X2lkGAEgASgJUgdjb3VudElkEhIKBG5vdG'
    'UYAiABKAlSBG5vdGU=');

@$core.Deprecated('Use approveCountResponseDescriptor instead')
const ApproveCountResponse$json = {
  '1': 'ApproveCountResponse',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Count',
      '10': 'count'
    },
    {
      '1': 'adjustments',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Movement',
      '10': 'adjustments'
    },
  ],
};

/// Descriptor for `ApproveCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveCountResponseDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlQ291bnRSZXNwb25zZRI0CgVjb3VudBgBIAEoCzIeLmhlYWx0aGNhcmUubWF0ZX'
    'JpYWxzLnYxLkNvdW50UgVjb3VudBJDCgthZGp1c3RtZW50cxgCIAMoCzIhLmhlYWx0aGNhcmUu'
    'bWF0ZXJpYWxzLnYxLk1vdmVtZW50UgthZGp1c3RtZW50cw==');

@$core.Deprecated('Use rejectCountRequestDescriptor instead')
const RejectCountRequest$json = {
  '1': 'RejectCountRequest',
  '2': [
    {'1': 'count_id', '3': 1, '4': 1, '5': 9, '10': 'countId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RejectCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectCountRequestDescriptor = $convert.base64Decode(
    'ChJSZWplY3RDb3VudFJlcXVlc3QSGQoIY291bnRfaWQYASABKAlSB2NvdW50SWQSEgoEbm90ZR'
    'gCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use rejectCountResponseDescriptor instead')
const RejectCountResponse$json = {
  '1': 'RejectCountResponse',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Count',
      '10': 'count'
    },
  ],
};

/// Descriptor for `RejectCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectCountResponseDescriptor = $convert.base64Decode(
    'ChNSZWplY3RDb3VudFJlc3BvbnNlEjQKBWNvdW50GAEgASgLMh4uaGVhbHRoY2FyZS5tYXRlcm'
    'lhbHMudjEuQ291bnRSBWNvdW50');

@$core.Deprecated('Use getCountRequestDescriptor instead')
const GetCountRequest$json = {
  '1': 'GetCountRequest',
  '2': [
    {'1': 'count_id', '3': 1, '4': 1, '5': 9, '10': 'countId'},
  ],
};

/// Descriptor for `GetCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCountRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRDb3VudFJlcXVlc3QSGQoIY291bnRfaWQYASABKAlSB2NvdW50SWQ=');

@$core.Deprecated('Use getCountResponseDescriptor instead')
const GetCountResponse$json = {
  '1': 'GetCountResponse',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Count',
      '10': 'count'
    },
  ],
};

/// Descriptor for `GetCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCountResponseDescriptor = $convert.base64Decode(
    'ChBHZXRDb3VudFJlc3BvbnNlEjQKBWNvdW50GAEgASgLMh4uaGVhbHRoY2FyZS5tYXRlcmlhbH'
    'MudjEuQ291bnRSBWNvdW50');

@$core.Deprecated('Use listCountsRequestDescriptor instead')
const ListCountsRequest$json = {
  '1': 'ListCountsRequest',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 9, '10': 'state'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListCountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCountsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0Q291bnRzUmVxdWVzdBIUCgVzdGF0ZRgBIAEoCVIFc3RhdGUSGwoJcGFnZV9zaXplGA'
    'IgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listCountsResponseDescriptor instead')
const ListCountsResponse$json = {
  '1': 'ListCountsResponse',
  '2': [
    {
      '1': 'counts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Count',
      '10': 'counts'
    },
  ],
};

/// Descriptor for `ListCountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCountsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0Q291bnRzUmVzcG9uc2USNgoGY291bnRzGAEgAygLMh4uaGVhbHRoY2FyZS5tYXRlcm'
    'lhbHMudjEuQ291bnRSBmNvdW50cw==');

@$core.Deprecated('Use blockLotRequestDescriptor instead')
const BlockLotRequest$json = {
  '1': 'BlockLotRequest',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BlockLotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockLotRequestDescriptor = $convert.base64Decode(
    'Cg9CbG9ja0xvdFJlcXVlc3QSFQoGbG90X2lkGAEgASgJUgVsb3RJZBIWCgZyZWFzb24YAiABKA'
    'lSBnJlYXNvbg==');

@$core.Deprecated('Use blockLotResponseDescriptor instead')
const BlockLotResponse$json = {
  '1': 'BlockLotResponse',
  '2': [
    {
      '1': 'lot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Lot',
      '10': 'lot'
    },
    {
      '1': 'recall',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.RecallList',
      '10': 'recall'
    },
  ],
};

/// Descriptor for `BlockLotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockLotResponseDescriptor = $convert.base64Decode(
    'ChBCbG9ja0xvdFJlc3BvbnNlEi4KA2xvdBgBIAEoCzIcLmhlYWx0aGNhcmUubWF0ZXJpYWxzLn'
    'YxLkxvdFIDbG90EjsKBnJlY2FsbBgCIAEoCzIjLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlJl'
    'Y2FsbExpc3RSBnJlY2FsbA==');

@$core.Deprecated('Use releaseLotRequestDescriptor instead')
const ReleaseLotRequest$json = {
  '1': 'ReleaseLotRequest',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ReleaseLotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseLotRequestDescriptor = $convert.base64Decode(
    'ChFSZWxlYXNlTG90UmVxdWVzdBIVCgZsb3RfaWQYASABKAlSBWxvdElkEhIKBG5vdGUYAiABKA'
    'lSBG5vdGU=');

@$core.Deprecated('Use releaseLotResponseDescriptor instead')
const ReleaseLotResponse$json = {
  '1': 'ReleaseLotResponse',
  '2': [
    {
      '1': 'lot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Lot',
      '10': 'lot'
    },
  ],
};

/// Descriptor for `ReleaseLotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseLotResponseDescriptor = $convert.base64Decode(
    'ChJSZWxlYXNlTG90UmVzcG9uc2USLgoDbG90GAEgASgLMhwuaGVhbHRoY2FyZS5tYXRlcmlhbH'
    'MudjEuTG90UgNsb3Q=');

@$core.Deprecated('Use getRecallListRequestDescriptor instead')
const GetRecallListRequest$json = {
  '1': 'GetRecallListRequest',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
  ],
};

/// Descriptor for `GetRecallListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecallListRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRSZWNhbGxMaXN0UmVxdWVzdBIVCgZsb3RfaWQYASABKAlSBWxvdElk');

@$core.Deprecated('Use getRecallListResponseDescriptor instead')
const GetRecallListResponse$json = {
  '1': 'GetRecallListResponse',
  '2': [
    {
      '1': 'recall',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.RecallList',
      '10': 'recall'
    },
  ],
};

/// Descriptor for `GetRecallListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecallListResponseDescriptor = $convert.base64Decode(
    'ChVHZXRSZWNhbGxMaXN0UmVzcG9uc2USOwoGcmVjYWxsGAEgASgLMiMuaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuUmVjYWxsTGlzdFIGcmVjYWxs');

@$core.Deprecated('Use listBlockedLotsRequestDescriptor instead')
const ListBlockedLotsRequest$json = {
  '1': 'ListBlockedLotsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListBlockedLotsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBlockedLotsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QmxvY2tlZExvdHNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listBlockedLotsResponseDescriptor instead')
const ListBlockedLotsResponse$json = {
  '1': 'ListBlockedLotsResponse',
  '2': [
    {
      '1': 'lots',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Lot',
      '10': 'lots'
    },
  ],
};

/// Descriptor for `ListBlockedLotsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBlockedLotsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0QmxvY2tlZExvdHNSZXNwb25zZRIwCgRsb3RzGAEgAygLMhwuaGVhbHRoY2FyZS5tYX'
        'RlcmlhbHMudjEuTG90UgRsb3Rz');

@$core.Deprecated('Use getLotRequestDescriptor instead')
const GetLotRequest$json = {
  '1': 'GetLotRequest',
  '2': [
    {'1': 'lot_id', '3': 1, '4': 1, '5': 9, '10': 'lotId'},
  ],
};

/// Descriptor for `GetLotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLotRequestDescriptor = $convert
    .base64Decode('Cg1HZXRMb3RSZXF1ZXN0EhUKBmxvdF9pZBgBIAEoCVIFbG90SWQ=');

@$core.Deprecated('Use getLotResponseDescriptor instead')
const GetLotResponse$json = {
  '1': 'GetLotResponse',
  '2': [
    {
      '1': 'lot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Lot',
      '10': 'lot'
    },
  ],
};

/// Descriptor for `GetLotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLotResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRMb3RSZXNwb25zZRIuCgNsb3QYASABKAsyHC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS'
    '5Mb3RSA2xvdA==');

@$core.Deprecated('Use listLotsRequestDescriptor instead')
const ListLotsRequest$json = {
  '1': 'ListLotsRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListLotsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLotsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0TG90c1JlcXVlc3QSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhsKCXBhZ2Vfc2l6ZR'
    'gCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listLotsResponseDescriptor instead')
const ListLotsResponse$json = {
  '1': 'ListLotsResponse',
  '2': [
    {
      '1': 'lots',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Lot',
      '10': 'lots'
    },
  ],
};

/// Descriptor for `ListLotsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLotsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0TG90c1Jlc3BvbnNlEjAKBGxvdHMYASADKAsyHC5oZWFsdGhjYXJlLm1hdGVyaWFscy'
    '52MS5Mb3RSBGxvdHM=');

@$core.Deprecated('Use listAlertsRequestDescriptor instead')
const ListAlertsRequest$json = {
  '1': 'ListAlertsRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAlertsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlertsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QWxlcnRzUmVxdWVzdBIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG9jYXRpb25JZBIbCg'
    'lwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listAlertsResponseDescriptor instead')
const ListAlertsResponse$json = {
  '1': 'ListAlertsResponse',
  '2': [
    {
      '1': 'alerts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.Alert',
      '10': 'alerts'
    },
  ],
};

/// Descriptor for `ListAlertsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlertsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWxlcnRzUmVzcG9uc2USNgoGYWxlcnRzGAEgAygLMh4uaGVhbHRoY2FyZS5tYXRlcm'
    'lhbHMudjEuQWxlcnRSBmFsZXJ0cw==');

@$core.Deprecated('Use suggestOrderRequestDescriptor instead')
const SuggestOrderRequest$json = {
  '1': 'SuggestOrderRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
  ],
};

/// Descriptor for `SuggestOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestOrderRequestDescriptor = $convert.base64Decode(
    'ChNTdWdnZXN0T3JkZXJSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2NhdGlvbklk');

@$core.Deprecated('Use suggestOrderResponseDescriptor instead')
const SuggestOrderResponse$json = {
  '1': 'SuggestOrderResponse',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'lines',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.SuggestedLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `SuggestOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestOrderResponseDescriptor = $convert.base64Decode(
    'ChRTdWdnZXN0T3JkZXJSZXNwb25zZRIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG9jYXRpb25JZB'
    'I8CgVsaW5lcxgCIAMoCzImLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlN1Z2dlc3RlZExpbmVS'
    'BWxpbmVz');

@$core.Deprecated('Use recordInvoiceRequestDescriptor instead')
const RecordInvoiceRequest$json = {
  '1': 'RecordInvoiceRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'supplier_id', '3': 2, '4': 1, '5': 9, '10': 'supplierId'},
    {'1': 'purchase_order_id', '3': 3, '4': 1, '5': 9, '10': 'purchaseOrderId'},
    {
      '1': 'lines',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.InvoiceLine',
      '10': 'lines'
    },
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `RecordInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordInvoiceRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRJbnZvaWNlUmVxdWVzdBIWCgZudW1iZXIYASABKAlSBm51bWJlchIfCgtzdXBwbG'
    'llcl9pZBgCIAEoCVIKc3VwcGxpZXJJZBIqChFwdXJjaGFzZV9vcmRlcl9pZBgDIAEoCVIPcHVy'
    'Y2hhc2VPcmRlcklkEjoKBWxpbmVzGAQgAygLMiQuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuSW'
    '52b2ljZUxpbmVSBWxpbmVzEhoKCGN1cnJlbmN5GAUgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use recordInvoiceResponseDescriptor instead')
const RecordInvoiceResponse$json = {
  '1': 'RecordInvoiceResponse',
  '2': [
    {
      '1': 'invoice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Invoice',
      '10': 'invoice'
    },
  ],
};

/// Descriptor for `RecordInvoiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordInvoiceResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRJbnZvaWNlUmVzcG9uc2USOgoHaW52b2ljZRgBIAEoCzIgLmhlYWx0aGNhcmUubW'
    'F0ZXJpYWxzLnYxLkludm9pY2VSB2ludm9pY2U=');

@$core.Deprecated('Use matchInvoiceRequestDescriptor instead')
const MatchInvoiceRequest$json = {
  '1': 'MatchInvoiceRequest',
  '2': [
    {'1': 'invoice_id', '3': 1, '4': 1, '5': 9, '10': 'invoiceId'},
  ],
};

/// Descriptor for `MatchInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchInvoiceRequestDescriptor = $convert.base64Decode(
    'ChNNYXRjaEludm9pY2VSZXF1ZXN0Eh0KCmludm9pY2VfaWQYASABKAlSCWludm9pY2VJZA==');

@$core.Deprecated('Use matchInvoiceResponseDescriptor instead')
const MatchInvoiceResponse$json = {
  '1': 'MatchInvoiceResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.MatchResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `MatchInvoiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchInvoiceResponseDescriptor = $convert.base64Decode(
    'ChRNYXRjaEludm9pY2VSZXNwb25zZRI8CgZyZXN1bHQYASABKAsyJC5oZWFsdGhjYXJlLm1hdG'
    'VyaWFscy52MS5NYXRjaFJlc3VsdFIGcmVzdWx0');

@$core.Deprecated('Use getMetricsRequestDescriptor instead')
const GetMetricsRequest$json = {
  '1': 'GetMetricsRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'period_start',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
  ],
};

/// Descriptor for `GetMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMetricsRequestDescriptor = $convert.base64Decode(
    'ChFHZXRNZXRyaWNzUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSHwoLbG9jYXRpb2'
    '5faWQYAiABKAlSCmxvY2F0aW9uSWQSPQoMcGVyaW9kX3N0YXJ0GAMgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFILcGVyaW9kU3RhcnQSOQoKcGVyaW9kX2VuZBgEIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXBlcmlvZEVuZA==');

@$core.Deprecated('Use getMetricsResponseDescriptor instead')
const GetMetricsResponse$json = {
  '1': 'GetMetricsResponse',
  '2': [
    {
      '1': 'metrics',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.Metrics',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `GetMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMetricsResponseDescriptor = $convert.base64Decode(
    'ChJHZXRNZXRyaWNzUmVzcG9uc2USOgoHbWV0cmljcxgBIAEoCzIgLmhlYWx0aGNhcmUubWF0ZX'
    'JpYWxzLnYxLk1ldHJpY3NSB21ldHJpY3M=');

@$core.Deprecated('Use getFillRateRequestDescriptor instead')
const GetFillRateRequest$json = {
  '1': 'GetFillRateRequest',
  '2': [
    {'1': 'supplier_id', '3': 1, '4': 1, '5': 9, '10': 'supplierId'},
    {
      '1': 'period_start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
  ],
};

/// Descriptor for `GetFillRateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFillRateRequestDescriptor = $convert.base64Decode(
    'ChJHZXRGaWxsUmF0ZVJlcXVlc3QSHwoLc3VwcGxpZXJfaWQYASABKAlSCnN1cHBsaWVySWQSPQ'
    'oMcGVyaW9kX3N0YXJ0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcGVyaW9k'
    'U3RhcnQSOQoKcGVyaW9kX2VuZBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCX'
    'BlcmlvZEVuZA==');

@$core.Deprecated('Use getFillRateResponseDescriptor instead')
const GetFillRateResponse$json = {
  '1': 'GetFillRateResponse',
  '2': [
    {
      '1': 'fill_rate',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.materials.v1.SupplierFillRate',
      '10': 'fillRate'
    },
  ],
};

/// Descriptor for `GetFillRateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFillRateResponseDescriptor = $convert.base64Decode(
    'ChNHZXRGaWxsUmF0ZVJlc3BvbnNlEkYKCWZpbGxfcmF0ZRgBIAEoCzIpLmhlYWx0aGNhcmUubW'
    'F0ZXJpYWxzLnYxLlN1cHBsaWVyRmlsbFJhdGVSCGZpbGxSYXRl');

@$core.Deprecated('Use listLiabilitiesRequestDescriptor instead')
const ListLiabilitiesRequest$json = {
  '1': 'ListLiabilitiesRequest',
  '2': [
    {'1': 'supplier_id', '3': 1, '4': 1, '5': 9, '10': 'supplierId'},
    {
      '1': 'period_start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListLiabilitiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLiabilitiesRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0TGlhYmlsaXRpZXNSZXF1ZXN0Eh8KC3N1cHBsaWVyX2lkGAEgASgJUgpzdXBwbGllck'
    'lkEj0KDHBlcmlvZF9zdGFydBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3Bl'
    'cmlvZFN0YXJ0EjkKCnBlcmlvZF9lbmQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUglwZXJpb2RFbmQSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listLiabilitiesResponseDescriptor instead')
const ListLiabilitiesResponse$json = {
  '1': 'ListLiabilitiesResponse',
  '2': [
    {
      '1': 'liabilities',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.materials.v1.LiabilityEvent',
      '10': 'liabilities'
    },
  ],
};

/// Descriptor for `ListLiabilitiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLiabilitiesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0TGlhYmlsaXRpZXNSZXNwb25zZRJJCgtsaWFiaWxpdGllcxgBIAMoCzInLmhlYWx0aG'
        'NhcmUubWF0ZXJpYWxzLnYxLkxpYWJpbGl0eUV2ZW50UgtsaWFiaWxpdGllcw==');

const $core.Map<$core.String, $core.dynamic> MaterialsServiceBase$json = {
  '1': 'MaterialsService',
  '2': [
    {
      '1': 'AddItem',
      '2': '.healthcare.materials.v1.AddItemRequest',
      '3': '.healthcare.materials.v1.AddItemResponse'
    },
    {
      '1': 'ReconfigureItem',
      '2': '.healthcare.materials.v1.ReconfigureItemRequest',
      '3': '.healthcare.materials.v1.ReconfigureItemResponse'
    },
    {
      '1': 'GetItem',
      '2': '.healthcare.materials.v1.GetItemRequest',
      '3': '.healthcare.materials.v1.GetItemResponse'
    },
    {
      '1': 'ListItems',
      '2': '.healthcare.materials.v1.ListItemsRequest',
      '3': '.healthcare.materials.v1.ListItemsResponse'
    },
    {
      '1': 'AddSupplier',
      '2': '.healthcare.materials.v1.AddSupplierRequest',
      '3': '.healthcare.materials.v1.AddSupplierResponse'
    },
    {
      '1': 'SetSupplierApproval',
      '2': '.healthcare.materials.v1.SetSupplierApprovalRequest',
      '3': '.healthcare.materials.v1.SetSupplierApprovalResponse'
    },
    {
      '1': 'ListSuppliers',
      '2': '.healthcare.materials.v1.ListSuppliersRequest',
      '3': '.healthcare.materials.v1.ListSuppliersResponse'
    },
    {
      '1': 'SetStockLevel',
      '2': '.healthcare.materials.v1.SetStockLevelRequest',
      '3': '.healthcare.materials.v1.SetStockLevelResponse'
    },
    {
      '1': 'ListStockLevels',
      '2': '.healthcare.materials.v1.ListStockLevelsRequest',
      '3': '.healthcare.materials.v1.ListStockLevelsResponse'
    },
    {
      '1': 'AddApprovalRule',
      '2': '.healthcare.materials.v1.AddApprovalRuleRequest',
      '3': '.healthcare.materials.v1.AddApprovalRuleResponse'
    },
    {
      '1': 'ListApprovalRules',
      '2': '.healthcare.materials.v1.ListApprovalRulesRequest',
      '3': '.healthcare.materials.v1.ListApprovalRulesResponse'
    },
    {
      '1': 'RemoveApprovalRule',
      '2': '.healthcare.materials.v1.RemoveApprovalRuleRequest',
      '3': '.healthcare.materials.v1.RemoveApprovalRuleResponse'
    },
    {
      '1': 'RaiseRequisition',
      '2': '.healthcare.materials.v1.RaiseRequisitionRequest',
      '3': '.healthcare.materials.v1.RaiseRequisitionResponse'
    },
    {
      '1': 'GetApprovalRoute',
      '2': '.healthcare.materials.v1.GetApprovalRouteRequest',
      '3': '.healthcare.materials.v1.GetApprovalRouteResponse'
    },
    {
      '1': 'SubmitRequisition',
      '2': '.healthcare.materials.v1.SubmitRequisitionRequest',
      '3': '.healthcare.materials.v1.SubmitRequisitionResponse'
    },
    {
      '1': 'DecideRequisition',
      '2': '.healthcare.materials.v1.DecideRequisitionRequest',
      '3': '.healthcare.materials.v1.DecideRequisitionResponse'
    },
    {
      '1': 'GetRequisition',
      '2': '.healthcare.materials.v1.GetRequisitionRequest',
      '3': '.healthcare.materials.v1.GetRequisitionResponse'
    },
    {
      '1': 'ListRequisitions',
      '2': '.healthcare.materials.v1.ListRequisitionsRequest',
      '3': '.healthcare.materials.v1.ListRequisitionsResponse'
    },
    {
      '1': 'OpenRfq',
      '2': '.healthcare.materials.v1.OpenRfqRequest',
      '3': '.healthcare.materials.v1.OpenRfqResponse'
    },
    {
      '1': 'RecordBid',
      '2': '.healthcare.materials.v1.RecordBidRequest',
      '3': '.healthcare.materials.v1.RecordBidResponse'
    },
    {
      '1': 'CompareBids',
      '2': '.healthcare.materials.v1.CompareBidsRequest',
      '3': '.healthcare.materials.v1.CompareBidsResponse'
    },
    {
      '1': 'GetRfq',
      '2': '.healthcare.materials.v1.GetRfqRequest',
      '3': '.healthcare.materials.v1.GetRfqResponse'
    },
    {
      '1': 'ListRfqs',
      '2': '.healthcare.materials.v1.ListRfqsRequest',
      '3': '.healthcare.materials.v1.ListRfqsResponse'
    },
    {
      '1': 'PlaceOrder',
      '2': '.healthcare.materials.v1.PlaceOrderRequest',
      '3': '.healthcare.materials.v1.PlaceOrderResponse'
    },
    {
      '1': 'IssueOrder',
      '2': '.healthcare.materials.v1.IssueOrderRequest',
      '3': '.healthcare.materials.v1.IssueOrderResponse'
    },
    {
      '1': 'AmendOrder',
      '2': '.healthcare.materials.v1.AmendOrderRequest',
      '3': '.healthcare.materials.v1.AmendOrderResponse'
    },
    {
      '1': 'GetPurchaseOrder',
      '2': '.healthcare.materials.v1.GetPurchaseOrderRequest',
      '3': '.healthcare.materials.v1.GetPurchaseOrderResponse'
    },
    {
      '1': 'ListOrderRevisions',
      '2': '.healthcare.materials.v1.ListOrderRevisionsRequest',
      '3': '.healthcare.materials.v1.ListOrderRevisionsResponse'
    },
    {
      '1': 'ListPurchaseOrders',
      '2': '.healthcare.materials.v1.ListPurchaseOrdersRequest',
      '3': '.healthcare.materials.v1.ListPurchaseOrdersResponse'
    },
    {
      '1': 'ReceiveGoods',
      '2': '.healthcare.materials.v1.ReceiveGoodsRequest',
      '3': '.healthcare.materials.v1.ReceiveGoodsResponse'
    },
    {
      '1': 'Inspect',
      '2': '.healthcare.materials.v1.InspectRequest',
      '3': '.healthcare.materials.v1.InspectResponse'
    },
    {
      '1': 'GetReceipt',
      '2': '.healthcare.materials.v1.GetReceiptRequest',
      '3': '.healthcare.materials.v1.GetReceiptResponse'
    },
    {
      '1': 'ListReceipts',
      '2': '.healthcare.materials.v1.ListReceiptsRequest',
      '3': '.healthcare.materials.v1.ListReceiptsResponse'
    },
    {
      '1': 'RecommendPick',
      '2': '.healthcare.materials.v1.RecommendPickRequest',
      '3': '.healthcare.materials.v1.RecommendPickResponse'
    },
    {
      '1': 'IssueStock',
      '2': '.healthcare.materials.v1.IssueStockRequest',
      '3': '.healthcare.materials.v1.IssueStockResponse'
    },
    {
      '1': 'ReturnStock',
      '2': '.healthcare.materials.v1.ReturnStockRequest',
      '3': '.healthcare.materials.v1.ReturnStockResponse'
    },
    {
      '1': 'ListBalances',
      '2': '.healthcare.materials.v1.ListBalancesRequest',
      '3': '.healthcare.materials.v1.ListBalancesResponse'
    },
    {
      '1': 'GetAvailable',
      '2': '.healthcare.materials.v1.GetAvailableRequest',
      '3': '.healthcare.materials.v1.GetAvailableResponse'
    },
    {
      '1': 'ListMovements',
      '2': '.healthcare.materials.v1.ListMovementsRequest',
      '3': '.healthcare.materials.v1.ListMovementsResponse'
    },
    {
      '1': 'DispatchTransfer',
      '2': '.healthcare.materials.v1.DispatchTransferRequest',
      '3': '.healthcare.materials.v1.DispatchTransferResponse'
    },
    {
      '1': 'ReceiveTransfer',
      '2': '.healthcare.materials.v1.ReceiveTransferRequest',
      '3': '.healthcare.materials.v1.ReceiveTransferResponse'
    },
    {
      '1': 'ListTransfersInTransit',
      '2': '.healthcare.materials.v1.ListTransfersInTransitRequest',
      '3': '.healthcare.materials.v1.ListTransfersInTransitResponse'
    },
    {
      '1': 'OpenCount',
      '2': '.healthcare.materials.v1.OpenCountRequest',
      '3': '.healthcare.materials.v1.OpenCountResponse'
    },
    {
      '1': 'RecordCount',
      '2': '.healthcare.materials.v1.RecordCountRequest',
      '3': '.healthcare.materials.v1.RecordCountResponse'
    },
    {
      '1': 'ApproveCount',
      '2': '.healthcare.materials.v1.ApproveCountRequest',
      '3': '.healthcare.materials.v1.ApproveCountResponse'
    },
    {
      '1': 'RejectCount',
      '2': '.healthcare.materials.v1.RejectCountRequest',
      '3': '.healthcare.materials.v1.RejectCountResponse'
    },
    {
      '1': 'GetCount',
      '2': '.healthcare.materials.v1.GetCountRequest',
      '3': '.healthcare.materials.v1.GetCountResponse'
    },
    {
      '1': 'ListCounts',
      '2': '.healthcare.materials.v1.ListCountsRequest',
      '3': '.healthcare.materials.v1.ListCountsResponse'
    },
    {
      '1': 'BlockLot',
      '2': '.healthcare.materials.v1.BlockLotRequest',
      '3': '.healthcare.materials.v1.BlockLotResponse'
    },
    {
      '1': 'ReleaseLot',
      '2': '.healthcare.materials.v1.ReleaseLotRequest',
      '3': '.healthcare.materials.v1.ReleaseLotResponse'
    },
    {
      '1': 'GetRecallList',
      '2': '.healthcare.materials.v1.GetRecallListRequest',
      '3': '.healthcare.materials.v1.GetRecallListResponse'
    },
    {
      '1': 'ListBlockedLots',
      '2': '.healthcare.materials.v1.ListBlockedLotsRequest',
      '3': '.healthcare.materials.v1.ListBlockedLotsResponse'
    },
    {
      '1': 'GetLot',
      '2': '.healthcare.materials.v1.GetLotRequest',
      '3': '.healthcare.materials.v1.GetLotResponse'
    },
    {
      '1': 'ListLots',
      '2': '.healthcare.materials.v1.ListLotsRequest',
      '3': '.healthcare.materials.v1.ListLotsResponse'
    },
    {
      '1': 'ListAlerts',
      '2': '.healthcare.materials.v1.ListAlertsRequest',
      '3': '.healthcare.materials.v1.ListAlertsResponse'
    },
    {
      '1': 'SuggestOrder',
      '2': '.healthcare.materials.v1.SuggestOrderRequest',
      '3': '.healthcare.materials.v1.SuggestOrderResponse'
    },
    {
      '1': 'RecordInvoice',
      '2': '.healthcare.materials.v1.RecordInvoiceRequest',
      '3': '.healthcare.materials.v1.RecordInvoiceResponse'
    },
    {
      '1': 'MatchInvoice',
      '2': '.healthcare.materials.v1.MatchInvoiceRequest',
      '3': '.healthcare.materials.v1.MatchInvoiceResponse'
    },
    {
      '1': 'GetMetrics',
      '2': '.healthcare.materials.v1.GetMetricsRequest',
      '3': '.healthcare.materials.v1.GetMetricsResponse'
    },
    {
      '1': 'GetFillRate',
      '2': '.healthcare.materials.v1.GetFillRateRequest',
      '3': '.healthcare.materials.v1.GetFillRateResponse'
    },
    {
      '1': 'ListLiabilities',
      '2': '.healthcare.materials.v1.ListLiabilitiesRequest',
      '3': '.healthcare.materials.v1.ListLiabilitiesResponse'
    },
  ],
};

@$core.Deprecated('Use materialsServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MaterialsServiceBase$messageJson = {
  '.healthcare.materials.v1.AddItemRequest': AddItemRequest$json,
  '.healthcare.materials.v1.AddItemResponse': AddItemResponse$json,
  '.healthcare.materials.v1.Item': Item$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.materials.v1.ReconfigureItemRequest':
      ReconfigureItemRequest$json,
  '.healthcare.materials.v1.ReconfigureItemResponse':
      ReconfigureItemResponse$json,
  '.healthcare.materials.v1.GetItemRequest': GetItemRequest$json,
  '.healthcare.materials.v1.GetItemResponse': GetItemResponse$json,
  '.healthcare.materials.v1.ListItemsRequest': ListItemsRequest$json,
  '.healthcare.materials.v1.ListItemsResponse': ListItemsResponse$json,
  '.healthcare.materials.v1.AddSupplierRequest': AddSupplierRequest$json,
  '.healthcare.materials.v1.AddSupplierResponse': AddSupplierResponse$json,
  '.healthcare.materials.v1.Supplier': Supplier$json,
  '.healthcare.materials.v1.SetSupplierApprovalRequest':
      SetSupplierApprovalRequest$json,
  '.healthcare.materials.v1.SetSupplierApprovalResponse':
      SetSupplierApprovalResponse$json,
  '.healthcare.materials.v1.ListSuppliersRequest': ListSuppliersRequest$json,
  '.healthcare.materials.v1.ListSuppliersResponse': ListSuppliersResponse$json,
  '.healthcare.materials.v1.SetStockLevelRequest': SetStockLevelRequest$json,
  '.healthcare.materials.v1.StockLevel': StockLevel$json,
  '.healthcare.materials.v1.SetStockLevelResponse': SetStockLevelResponse$json,
  '.healthcare.materials.v1.ListStockLevelsRequest':
      ListStockLevelsRequest$json,
  '.healthcare.materials.v1.ListStockLevelsResponse':
      ListStockLevelsResponse$json,
  '.healthcare.materials.v1.AddApprovalRuleRequest':
      AddApprovalRuleRequest$json,
  '.healthcare.materials.v1.AddApprovalRuleResponse':
      AddApprovalRuleResponse$json,
  '.healthcare.materials.v1.ApprovalRule': ApprovalRule$json,
  '.healthcare.materials.v1.ListApprovalRulesRequest':
      ListApprovalRulesRequest$json,
  '.healthcare.materials.v1.ListApprovalRulesResponse':
      ListApprovalRulesResponse$json,
  '.healthcare.materials.v1.RemoveApprovalRuleRequest':
      RemoveApprovalRuleRequest$json,
  '.healthcare.materials.v1.RemoveApprovalRuleResponse':
      RemoveApprovalRuleResponse$json,
  '.healthcare.materials.v1.RaiseRequisitionRequest':
      RaiseRequisitionRequest$json,
  '.healthcare.materials.v1.RequisitionLine': RequisitionLine$json,
  '.healthcare.materials.v1.Money': Money$json,
  '.healthcare.materials.v1.RaiseRequisitionResponse':
      RaiseRequisitionResponse$json,
  '.healthcare.materials.v1.Requisition': Requisition$json,
  '.healthcare.materials.v1.ApprovalStep': ApprovalStep$json,
  '.healthcare.materials.v1.GetApprovalRouteRequest':
      GetApprovalRouteRequest$json,
  '.healthcare.materials.v1.GetApprovalRouteResponse':
      GetApprovalRouteResponse$json,
  '.healthcare.materials.v1.SubmitRequisitionRequest':
      SubmitRequisitionRequest$json,
  '.healthcare.materials.v1.SubmitRequisitionResponse':
      SubmitRequisitionResponse$json,
  '.healthcare.materials.v1.DecideRequisitionRequest':
      DecideRequisitionRequest$json,
  '.healthcare.materials.v1.DecideRequisitionResponse':
      DecideRequisitionResponse$json,
  '.healthcare.materials.v1.GetRequisitionRequest': GetRequisitionRequest$json,
  '.healthcare.materials.v1.GetRequisitionResponse':
      GetRequisitionResponse$json,
  '.healthcare.materials.v1.ListRequisitionsRequest':
      ListRequisitionsRequest$json,
  '.healthcare.materials.v1.ListRequisitionsResponse':
      ListRequisitionsResponse$json,
  '.healthcare.materials.v1.OpenRfqRequest': OpenRfqRequest$json,
  '.healthcare.materials.v1.OpenRfqResponse': OpenRfqResponse$json,
  '.healthcare.materials.v1.Rfq': Rfq$json,
  '.healthcare.materials.v1.RecordBidRequest': RecordBidRequest$json,
  '.healthcare.materials.v1.BidLine': BidLine$json,
  '.healthcare.materials.v1.RecordBidResponse': RecordBidResponse$json,
  '.healthcare.materials.v1.Bid': Bid$json,
  '.healthcare.materials.v1.CompareBidsRequest': CompareBidsRequest$json,
  '.healthcare.materials.v1.CompareBidsResponse': CompareBidsResponse$json,
  '.healthcare.materials.v1.Comparison': Comparison$json,
  '.healthcare.materials.v1.GetRfqRequest': GetRfqRequest$json,
  '.healthcare.materials.v1.GetRfqResponse': GetRfqResponse$json,
  '.healthcare.materials.v1.ListRfqsRequest': ListRfqsRequest$json,
  '.healthcare.materials.v1.ListRfqsResponse': ListRfqsResponse$json,
  '.healthcare.materials.v1.PlaceOrderRequest': PlaceOrderRequest$json,
  '.healthcare.materials.v1.PurchaseOrderLine': PurchaseOrderLine$json,
  '.healthcare.materials.v1.PlaceOrderResponse': PlaceOrderResponse$json,
  '.healthcare.materials.v1.PurchaseOrder': PurchaseOrder$json,
  '.healthcare.materials.v1.IssueOrderRequest': IssueOrderRequest$json,
  '.healthcare.materials.v1.IssueOrderResponse': IssueOrderResponse$json,
  '.healthcare.materials.v1.AmendOrderRequest': AmendOrderRequest$json,
  '.healthcare.materials.v1.AmendOrderResponse': AmendOrderResponse$json,
  '.healthcare.materials.v1.GetPurchaseOrderRequest':
      GetPurchaseOrderRequest$json,
  '.healthcare.materials.v1.GetPurchaseOrderResponse':
      GetPurchaseOrderResponse$json,
  '.healthcare.materials.v1.ListOrderRevisionsRequest':
      ListOrderRevisionsRequest$json,
  '.healthcare.materials.v1.ListOrderRevisionsResponse':
      ListOrderRevisionsResponse$json,
  '.healthcare.materials.v1.ListPurchaseOrdersRequest':
      ListPurchaseOrdersRequest$json,
  '.healthcare.materials.v1.ListPurchaseOrdersResponse':
      ListPurchaseOrdersResponse$json,
  '.healthcare.materials.v1.ReceiveGoodsRequest': ReceiveGoodsRequest$json,
  '.healthcare.materials.v1.ReceiptLine': ReceiptLine$json,
  '.healthcare.materials.v1.ReceiveGoodsResponse': ReceiveGoodsResponse$json,
  '.healthcare.materials.v1.Receipt': Receipt$json,
  '.healthcare.materials.v1.InspectRequest': InspectRequest$json,
  '.healthcare.materials.v1.InspectResponse': InspectResponse$json,
  '.healthcare.materials.v1.Movement': Movement$json,
  '.healthcare.materials.v1.Bucket': Bucket$json,
  '.healthcare.materials.v1.GetReceiptRequest': GetReceiptRequest$json,
  '.healthcare.materials.v1.GetReceiptResponse': GetReceiptResponse$json,
  '.healthcare.materials.v1.ListReceiptsRequest': ListReceiptsRequest$json,
  '.healthcare.materials.v1.ListReceiptsResponse': ListReceiptsResponse$json,
  '.healthcare.materials.v1.RecommendPickRequest': RecommendPickRequest$json,
  '.healthcare.materials.v1.RecommendPickResponse': RecommendPickResponse$json,
  '.healthcare.materials.v1.Pick': Pick$json,
  '.healthcare.materials.v1.PickLine': PickLine$json,
  '.healthcare.materials.v1.IssueStockRequest': IssueStockRequest$json,
  '.healthcare.materials.v1.IssueStockResponse': IssueStockResponse$json,
  '.healthcare.materials.v1.LiabilityEvent': LiabilityEvent$json,
  '.healthcare.materials.v1.ReturnStockRequest': ReturnStockRequest$json,
  '.healthcare.materials.v1.ReturnStockResponse': ReturnStockResponse$json,
  '.healthcare.materials.v1.ListBalancesRequest': ListBalancesRequest$json,
  '.healthcare.materials.v1.ListBalancesResponse': ListBalancesResponse$json,
  '.healthcare.materials.v1.Balance': Balance$json,
  '.healthcare.materials.v1.GetAvailableRequest': GetAvailableRequest$json,
  '.healthcare.materials.v1.GetAvailableResponse': GetAvailableResponse$json,
  '.healthcare.materials.v1.ListMovementsRequest': ListMovementsRequest$json,
  '.healthcare.materials.v1.ListMovementsResponse': ListMovementsResponse$json,
  '.healthcare.materials.v1.DispatchTransferRequest':
      DispatchTransferRequest$json,
  '.healthcare.materials.v1.TransferLine': TransferLine$json,
  '.healthcare.materials.v1.DispatchTransferResponse':
      DispatchTransferResponse$json,
  '.healthcare.materials.v1.Transfer': Transfer$json,
  '.healthcare.materials.v1.ReceiveTransferRequest':
      ReceiveTransferRequest$json,
  '.healthcare.materials.v1.ReceiveTransferRequest.CountedEntry':
      ReceiveTransferRequest_CountedEntry$json,
  '.healthcare.materials.v1.ReceiveTransferResponse':
      ReceiveTransferResponse$json,
  '.healthcare.materials.v1.ListTransfersInTransitRequest':
      ListTransfersInTransitRequest$json,
  '.healthcare.materials.v1.ListTransfersInTransitResponse':
      ListTransfersInTransitResponse$json,
  '.healthcare.materials.v1.OpenCountRequest': OpenCountRequest$json,
  '.healthcare.materials.v1.OpenCountResponse': OpenCountResponse$json,
  '.healthcare.materials.v1.Count': Count$json,
  '.healthcare.materials.v1.CountLine': CountLine$json,
  '.healthcare.materials.v1.RecordCountRequest': RecordCountRequest$json,
  '.healthcare.materials.v1.RecordCountResponse': RecordCountResponse$json,
  '.healthcare.materials.v1.ApproveCountRequest': ApproveCountRequest$json,
  '.healthcare.materials.v1.ApproveCountResponse': ApproveCountResponse$json,
  '.healthcare.materials.v1.RejectCountRequest': RejectCountRequest$json,
  '.healthcare.materials.v1.RejectCountResponse': RejectCountResponse$json,
  '.healthcare.materials.v1.GetCountRequest': GetCountRequest$json,
  '.healthcare.materials.v1.GetCountResponse': GetCountResponse$json,
  '.healthcare.materials.v1.ListCountsRequest': ListCountsRequest$json,
  '.healthcare.materials.v1.ListCountsResponse': ListCountsResponse$json,
  '.healthcare.materials.v1.BlockLotRequest': BlockLotRequest$json,
  '.healthcare.materials.v1.BlockLotResponse': BlockLotResponse$json,
  '.healthcare.materials.v1.Lot': Lot$json,
  '.healthcare.materials.v1.RecallList': RecallList$json,
  '.healthcare.materials.v1.ReleaseLotRequest': ReleaseLotRequest$json,
  '.healthcare.materials.v1.ReleaseLotResponse': ReleaseLotResponse$json,
  '.healthcare.materials.v1.GetRecallListRequest': GetRecallListRequest$json,
  '.healthcare.materials.v1.GetRecallListResponse': GetRecallListResponse$json,
  '.healthcare.materials.v1.ListBlockedLotsRequest':
      ListBlockedLotsRequest$json,
  '.healthcare.materials.v1.ListBlockedLotsResponse':
      ListBlockedLotsResponse$json,
  '.healthcare.materials.v1.GetLotRequest': GetLotRequest$json,
  '.healthcare.materials.v1.GetLotResponse': GetLotResponse$json,
  '.healthcare.materials.v1.ListLotsRequest': ListLotsRequest$json,
  '.healthcare.materials.v1.ListLotsResponse': ListLotsResponse$json,
  '.healthcare.materials.v1.ListAlertsRequest': ListAlertsRequest$json,
  '.healthcare.materials.v1.ListAlertsResponse': ListAlertsResponse$json,
  '.healthcare.materials.v1.Alert': Alert$json,
  '.healthcare.materials.v1.SuggestOrderRequest': SuggestOrderRequest$json,
  '.healthcare.materials.v1.SuggestOrderResponse': SuggestOrderResponse$json,
  '.healthcare.materials.v1.SuggestedLine': SuggestedLine$json,
  '.healthcare.materials.v1.RecordInvoiceRequest': RecordInvoiceRequest$json,
  '.healthcare.materials.v1.InvoiceLine': InvoiceLine$json,
  '.healthcare.materials.v1.RecordInvoiceResponse': RecordInvoiceResponse$json,
  '.healthcare.materials.v1.Invoice': Invoice$json,
  '.healthcare.materials.v1.MatchInvoiceRequest': MatchInvoiceRequest$json,
  '.healthcare.materials.v1.MatchInvoiceResponse': MatchInvoiceResponse$json,
  '.healthcare.materials.v1.MatchResult': MatchResult$json,
  '.healthcare.materials.v1.MatchLine': MatchLine$json,
  '.healthcare.materials.v1.GetMetricsRequest': GetMetricsRequest$json,
  '.healthcare.materials.v1.GetMetricsResponse': GetMetricsResponse$json,
  '.healthcare.materials.v1.Metrics': Metrics$json,
  '.healthcare.materials.v1.GetFillRateRequest': GetFillRateRequest$json,
  '.healthcare.materials.v1.GetFillRateResponse': GetFillRateResponse$json,
  '.healthcare.materials.v1.SupplierFillRate': SupplierFillRate$json,
  '.healthcare.materials.v1.ListLiabilitiesRequest':
      ListLiabilitiesRequest$json,
  '.healthcare.materials.v1.ListLiabilitiesResponse':
      ListLiabilitiesResponse$json,
};

/// Descriptor for `MaterialsService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List materialsServiceDescriptor = $convert.base64Decode(
    'ChBNYXRlcmlhbHNTZXJ2aWNlElwKB0FkZEl0ZW0SJy5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS'
    '5BZGRJdGVtUmVxdWVzdBooLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkFkZEl0ZW1SZXNwb25z'
    'ZRJ0Cg9SZWNvbmZpZ3VyZUl0ZW0SLy5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SZWNvbmZpZ3'
    'VyZUl0ZW1SZXF1ZXN0GjAuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmVjb25maWd1cmVJdGVt'
    'UmVzcG9uc2USXAoHR2V0SXRlbRInLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldEl0ZW1SZX'
    'F1ZXN0GiguaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuR2V0SXRlbVJlc3BvbnNlEmIKCUxpc3RJ'
    'dGVtcxIpLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RJdGVtc1JlcXVlc3QaKi5oZWFsdG'
    'hjYXJlLm1hdGVyaWFscy52MS5MaXN0SXRlbXNSZXNwb25zZRJoCgtBZGRTdXBwbGllchIrLmhl'
    'YWx0aGNhcmUubWF0ZXJpYWxzLnYxLkFkZFN1cHBsaWVyUmVxdWVzdBosLmhlYWx0aGNhcmUubW'
    'F0ZXJpYWxzLnYxLkFkZFN1cHBsaWVyUmVzcG9uc2USgAEKE1NldFN1cHBsaWVyQXBwcm92YWwS'
    'My5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5TZXRTdXBwbGllckFwcHJvdmFsUmVxdWVzdBo0Lm'
    'hlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlNldFN1cHBsaWVyQXBwcm92YWxSZXNwb25zZRJuCg1M'
    'aXN0U3VwcGxpZXJzEi0uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdFN1cHBsaWVyc1JlcX'
    'Vlc3QaLi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0U3VwcGxpZXJzUmVzcG9uc2USbgoN'
    'U2V0U3RvY2tMZXZlbBItLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlNldFN0b2NrTGV2ZWxSZX'
    'F1ZXN0Gi4uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuU2V0U3RvY2tMZXZlbFJlc3BvbnNlEnQK'
    'D0xpc3RTdG9ja0xldmVscxIvLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RTdG9ja0xldm'
    'Vsc1JlcXVlc3QaMC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0U3RvY2tMZXZlbHNSZXNw'
    'b25zZRJ0Cg9BZGRBcHByb3ZhbFJ1bGUSLy5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5BZGRBcH'
    'Byb3ZhbFJ1bGVSZXF1ZXN0GjAuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuQWRkQXBwcm92YWxS'
    'dWxlUmVzcG9uc2USegoRTGlzdEFwcHJvdmFsUnVsZXMSMS5oZWFsdGhjYXJlLm1hdGVyaWFscy'
    '52MS5MaXN0QXBwcm92YWxSdWxlc1JlcXVlc3QaMi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5M'
    'aXN0QXBwcm92YWxSdWxlc1Jlc3BvbnNlEn0KElJlbW92ZUFwcHJvdmFsUnVsZRIyLmhlYWx0aG'
    'NhcmUubWF0ZXJpYWxzLnYxLlJlbW92ZUFwcHJvdmFsUnVsZVJlcXVlc3QaMy5oZWFsdGhjYXJl'
    'Lm1hdGVyaWFscy52MS5SZW1vdmVBcHByb3ZhbFJ1bGVSZXNwb25zZRJ3ChBSYWlzZVJlcXVpc2'
    'l0aW9uEjAuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmFpc2VSZXF1aXNpdGlvblJlcXVlc3Qa'
    'MS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SYWlzZVJlcXVpc2l0aW9uUmVzcG9uc2USdwoQR2'
    'V0QXBwcm92YWxSb3V0ZRIwLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldEFwcHJvdmFsUm91'
    'dGVSZXF1ZXN0GjEuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuR2V0QXBwcm92YWxSb3V0ZVJlc3'
    'BvbnNlEnoKEVN1Ym1pdFJlcXVpc2l0aW9uEjEuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuU3Vi'
    'bWl0UmVxdWlzaXRpb25SZXF1ZXN0GjIuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuU3VibWl0Um'
    'VxdWlzaXRpb25SZXNwb25zZRJ6ChFEZWNpZGVSZXF1aXNpdGlvbhIxLmhlYWx0aGNhcmUubWF0'
    'ZXJpYWxzLnYxLkRlY2lkZVJlcXVpc2l0aW9uUmVxdWVzdBoyLmhlYWx0aGNhcmUubWF0ZXJpYW'
    'xzLnYxLkRlY2lkZVJlcXVpc2l0aW9uUmVzcG9uc2UScQoOR2V0UmVxdWlzaXRpb24SLi5oZWFs'
    'dGhjYXJlLm1hdGVyaWFscy52MS5HZXRSZXF1aXNpdGlvblJlcXVlc3QaLy5oZWFsdGhjYXJlLm'
    '1hdGVyaWFscy52MS5HZXRSZXF1aXNpdGlvblJlc3BvbnNlEncKEExpc3RSZXF1aXNpdGlvbnMS'
    'MC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0UmVxdWlzaXRpb25zUmVxdWVzdBoxLmhlYW'
    'x0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RSZXF1aXNpdGlvbnNSZXNwb25zZRJcCgdPcGVuUmZx'
    'EicuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuT3BlblJmcVJlcXVlc3QaKC5oZWFsdGhjYXJlLm'
    '1hdGVyaWFscy52MS5PcGVuUmZxUmVzcG9uc2USYgoJUmVjb3JkQmlkEikuaGVhbHRoY2FyZS5t'
    'YXRlcmlhbHMudjEuUmVjb3JkQmlkUmVxdWVzdBoqLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLl'
    'JlY29yZEJpZFJlc3BvbnNlEmgKC0NvbXBhcmVCaWRzEisuaGVhbHRoY2FyZS5tYXRlcmlhbHMu'
    'djEuQ29tcGFyZUJpZHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuQ29tcGFyZU'
    'JpZHNSZXNwb25zZRJZCgZHZXRSZnESJi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5HZXRSZnFS'
    'ZXF1ZXN0GicuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuR2V0UmZxUmVzcG9uc2USXwoITGlzdF'
    'JmcXMSKC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0UmZxc1JlcXVlc3QaKS5oZWFsdGhj'
    'YXJlLm1hdGVyaWFscy52MS5MaXN0UmZxc1Jlc3BvbnNlEmUKClBsYWNlT3JkZXISKi5oZWFsdG'
    'hjYXJlLm1hdGVyaWFscy52MS5QbGFjZU9yZGVyUmVxdWVzdBorLmhlYWx0aGNhcmUubWF0ZXJp'
    'YWxzLnYxLlBsYWNlT3JkZXJSZXNwb25zZRJlCgpJc3N1ZU9yZGVyEiouaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuSXNzdWVPcmRlclJlcXVlc3QaKy5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5J'
    'c3N1ZU9yZGVyUmVzcG9uc2USZQoKQW1lbmRPcmRlchIqLmhlYWx0aGNhcmUubWF0ZXJpYWxzLn'
    'YxLkFtZW5kT3JkZXJSZXF1ZXN0GisuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuQW1lbmRPcmRl'
    'clJlc3BvbnNlEncKEEdldFB1cmNoYXNlT3JkZXISMC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS'
    '5HZXRQdXJjaGFzZU9yZGVyUmVxdWVzdBoxLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldFB1'
    'cmNoYXNlT3JkZXJSZXNwb25zZRJ9ChJMaXN0T3JkZXJSZXZpc2lvbnMSMi5oZWFsdGhjYXJlLm'
    '1hdGVyaWFscy52MS5MaXN0T3JkZXJSZXZpc2lvbnNSZXF1ZXN0GjMuaGVhbHRoY2FyZS5tYXRl'
    'cmlhbHMudjEuTGlzdE9yZGVyUmV2aXNpb25zUmVzcG9uc2USfQoSTGlzdFB1cmNoYXNlT3JkZX'
    'JzEjIuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdFB1cmNoYXNlT3JkZXJzUmVxdWVzdBoz'
    'LmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RQdXJjaGFzZU9yZGVyc1Jlc3BvbnNlEmsKDF'
    'JlY2VpdmVHb29kcxIsLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlJlY2VpdmVHb29kc1JlcXVl'
    'c3QaLS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SZWNlaXZlR29vZHNSZXNwb25zZRJcCgdJbn'
    'NwZWN0EicuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuSW5zcGVjdFJlcXVlc3QaKC5oZWFsdGhj'
    'YXJlLm1hdGVyaWFscy52MS5JbnNwZWN0UmVzcG9uc2USZQoKR2V0UmVjZWlwdBIqLmhlYWx0aG'
    'NhcmUubWF0ZXJpYWxzLnYxLkdldFJlY2VpcHRSZXF1ZXN0GisuaGVhbHRoY2FyZS5tYXRlcmlh'
    'bHMudjEuR2V0UmVjZWlwdFJlc3BvbnNlEmsKDExpc3RSZWNlaXB0cxIsLmhlYWx0aGNhcmUubW'
    'F0ZXJpYWxzLnYxLkxpc3RSZWNlaXB0c1JlcXVlc3QaLS5oZWFsdGhjYXJlLm1hdGVyaWFscy52'
    'MS5MaXN0UmVjZWlwdHNSZXNwb25zZRJuCg1SZWNvbW1lbmRQaWNrEi0uaGVhbHRoY2FyZS5tYX'
    'RlcmlhbHMudjEuUmVjb21tZW5kUGlja1JlcXVlc3QaLi5oZWFsdGhjYXJlLm1hdGVyaWFscy52'
    'MS5SZWNvbW1lbmRQaWNrUmVzcG9uc2USZQoKSXNzdWVTdG9jaxIqLmhlYWx0aGNhcmUubWF0ZX'
    'JpYWxzLnYxLklzc3VlU3RvY2tSZXF1ZXN0GisuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuSXNz'
    'dWVTdG9ja1Jlc3BvbnNlEmgKC1JldHVyblN0b2NrEisuaGVhbHRoY2FyZS5tYXRlcmlhbHMudj'
    'EuUmV0dXJuU3RvY2tSZXF1ZXN0GiwuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmV0dXJuU3Rv'
    'Y2tSZXNwb25zZRJrCgxMaXN0QmFsYW5jZXMSLC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaX'
    'N0QmFsYW5jZXNSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdEJhbGFuY2Vz'
    'UmVzcG9uc2USawoMR2V0QXZhaWxhYmxlEiwuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuR2V0QX'
    'ZhaWxhYmxlUmVxdWVzdBotLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldEF2YWlsYWJsZVJl'
    'c3BvbnNlEm4KDUxpc3RNb3ZlbWVudHMSLS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0TW'
    '92ZW1lbnRzUmVxdWVzdBouLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RNb3ZlbWVudHNS'
    'ZXNwb25zZRJ3ChBEaXNwYXRjaFRyYW5zZmVyEjAuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuRG'
    'lzcGF0Y2hUcmFuc2ZlclJlcXVlc3QaMS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5EaXNwYXRj'
    'aFRyYW5zZmVyUmVzcG9uc2USdAoPUmVjZWl2ZVRyYW5zZmVyEi8uaGVhbHRoY2FyZS5tYXRlcm'
    'lhbHMudjEuUmVjZWl2ZVRyYW5zZmVyUmVxdWVzdBowLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYx'
    'LlJlY2VpdmVUcmFuc2ZlclJlc3BvbnNlEokBChZMaXN0VHJhbnNmZXJzSW5UcmFuc2l0EjYuaG'
    'VhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdFRyYW5zZmVyc0luVHJhbnNpdFJlcXVlc3QaNy5o'
    'ZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0VHJhbnNmZXJzSW5UcmFuc2l0UmVzcG9uc2USYg'
    'oJT3BlbkNvdW50EikuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuT3BlbkNvdW50UmVxdWVzdBoq'
    'LmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLk9wZW5Db3VudFJlc3BvbnNlEmgKC1JlY29yZENvdW'
    '50EisuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmVjb3JkQ291bnRSZXF1ZXN0GiwuaGVhbHRo'
    'Y2FyZS5tYXRlcmlhbHMudjEuUmVjb3JkQ291bnRSZXNwb25zZRJrCgxBcHByb3ZlQ291bnQSLC'
    '5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5BcHByb3ZlQ291bnRSZXF1ZXN0Gi0uaGVhbHRoY2Fy'
    'ZS5tYXRlcmlhbHMudjEuQXBwcm92ZUNvdW50UmVzcG9uc2USaAoLUmVqZWN0Q291bnQSKy5oZW'
    'FsdGhjYXJlLm1hdGVyaWFscy52MS5SZWplY3RDb3VudFJlcXVlc3QaLC5oZWFsdGhjYXJlLm1h'
    'dGVyaWFscy52MS5SZWplY3RDb3VudFJlc3BvbnNlEl8KCEdldENvdW50EiguaGVhbHRoY2FyZS'
    '5tYXRlcmlhbHMudjEuR2V0Q291bnRSZXF1ZXN0GikuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEu'
    'R2V0Q291bnRSZXNwb25zZRJlCgpMaXN0Q291bnRzEiouaGVhbHRoY2FyZS5tYXRlcmlhbHMudj'
    'EuTGlzdENvdW50c1JlcXVlc3QaKy5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5MaXN0Q291bnRz'
    'UmVzcG9uc2USXwoIQmxvY2tMb3QSKC5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5CbG9ja0xvdF'
    'JlcXVlc3QaKS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5CbG9ja0xvdFJlc3BvbnNlEmUKClJl'
    'bGVhc2VMb3QSKi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SZWxlYXNlTG90UmVxdWVzdBorLm'
    'hlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlJlbGVhc2VMb3RSZXNwb25zZRJuCg1HZXRSZWNhbGxM'
    'aXN0Ei0uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuR2V0UmVjYWxsTGlzdFJlcXVlc3QaLi5oZW'
    'FsdGhjYXJlLm1hdGVyaWFscy52MS5HZXRSZWNhbGxMaXN0UmVzcG9uc2USdAoPTGlzdEJsb2Nr'
    'ZWRMb3RzEi8uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdEJsb2NrZWRMb3RzUmVxdWVzdB'
    'owLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RCbG9ja2VkTG90c1Jlc3BvbnNlElkKBkdl'
    'dExvdBImLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldExvdFJlcXVlc3QaJy5oZWFsdGhjYX'
    'JlLm1hdGVyaWFscy52MS5HZXRMb3RSZXNwb25zZRJfCghMaXN0TG90cxIoLmhlYWx0aGNhcmUu'
    'bWF0ZXJpYWxzLnYxLkxpc3RMb3RzUmVxdWVzdBopLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLk'
    'xpc3RMb3RzUmVzcG9uc2USZQoKTGlzdEFsZXJ0cxIqLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYx'
    'Lkxpc3RBbGVydHNSZXF1ZXN0GisuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdEFsZXJ0c1'
    'Jlc3BvbnNlEmsKDFN1Z2dlc3RPcmRlchIsLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLlN1Z2dl'
    'c3RPcmRlclJlcXVlc3QaLS5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5TdWdnZXN0T3JkZXJSZX'
    'Nwb25zZRJuCg1SZWNvcmRJbnZvaWNlEi0uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuUmVjb3Jk'
    'SW52b2ljZVJlcXVlc3QaLi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5SZWNvcmRJbnZvaWNlUm'
    'VzcG9uc2USawoMTWF0Y2hJbnZvaWNlEiwuaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTWF0Y2hJ'
    'bnZvaWNlUmVxdWVzdBotLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLk1hdGNoSW52b2ljZVJlc3'
    'BvbnNlEmUKCkdldE1ldHJpY3MSKi5oZWFsdGhjYXJlLm1hdGVyaWFscy52MS5HZXRNZXRyaWNz'
    'UmVxdWVzdBorLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldE1ldHJpY3NSZXNwb25zZRJoCg'
    'tHZXRGaWxsUmF0ZRIrLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldEZpbGxSYXRlUmVxdWVz'
    'dBosLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkdldEZpbGxSYXRlUmVzcG9uc2USdAoPTGlzdE'
    'xpYWJpbGl0aWVzEi8uaGVhbHRoY2FyZS5tYXRlcmlhbHMudjEuTGlzdExpYWJpbGl0aWVzUmVx'
    'dWVzdBowLmhlYWx0aGNhcmUubWF0ZXJpYWxzLnYxLkxpc3RMaWFiaWxpdGllc1Jlc3BvbnNl');
