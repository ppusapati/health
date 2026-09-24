// This is a generated file - do not edit.
//
// Generated from healthcare/laundry/v1/laundry.proto.

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

@$core.Deprecated('Use linenCategoryDescriptor instead')
const LinenCategory$json = {
  '1': 'LinenCategory',
  '2': [
    {'1': 'LINEN_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'LINEN_CATEGORY_BEDDING', '2': 1},
    {'1': 'LINEN_CATEGORY_PATIENT', '2': 2},
    {'1': 'LINEN_CATEGORY_THEATRE', '2': 3},
    {'1': 'LINEN_CATEGORY_UNIFORM', '2': 4},
    {'1': 'LINEN_CATEGORY_OTHER', '2': 5},
  ],
};

/// Descriptor for `LinenCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List linenCategoryDescriptor = $convert.base64Decode(
    'Cg1MaW5lbkNhdGVnb3J5Eh4KGkxJTkVOX0NBVEVHT1JZX1VOU1BFQ0lGSUVEEAASGgoWTElORU'
    '5fQ0FURUdPUllfQkVERElORxABEhoKFkxJTkVOX0NBVEVHT1JZX1BBVElFTlQQAhIaChZMSU5F'
    'Tl9DQVRFR09SWV9USEVBVFJFEAMSGgoWTElORU5fQ0FURUdPUllfVU5JRk9STRAEEhgKFExJTk'
    'VOX0NBVEVHT1JZX09USEVSEAU=');

@$core.Deprecated('Use soilClassDescriptor instead')
const SoilClass$json = {
  '1': 'SoilClass',
  '2': [
    {'1': 'SOIL_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'SOIL_CLASS_USED', '2': 1},
    {'1': 'SOIL_CLASS_FOULED', '2': 2},
    {'1': 'SOIL_CLASS_INFECTED', '2': 3},
  ],
};

/// Descriptor for `SoilClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List soilClassDescriptor = $convert.base64Decode(
    'CglTb2lsQ2xhc3MSGgoWU09JTF9DTEFTU19VTlNQRUNJRklFRBAAEhMKD1NPSUxfQ0xBU1NfVV'
    'NFRBABEhUKEVNPSUxfQ0xBU1NfRk9VTEVEEAISFwoTU09JTF9DTEFTU19JTkZFQ1RFRBAD');

@$core.Deprecated('Use washCycleDescriptor instead')
const WashCycle$json = {
  '1': 'WashCycle',
  '2': [
    {'1': 'WASH_CYCLE_UNSPECIFIED', '2': 0},
    {'1': 'WASH_CYCLE_STANDARD', '2': 1},
    {'1': 'WASH_CYCLE_HOT', '2': 2},
    {'1': 'WASH_CYCLE_BARRIER', '2': 3},
    {'1': 'WASH_CYCLE_DELICATE', '2': 4},
  ],
};

/// Descriptor for `WashCycle`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List washCycleDescriptor = $convert.base64Decode(
    'CglXYXNoQ3ljbGUSGgoWV0FTSF9DWUNMRV9VTlNQRUNJRklFRBAAEhcKE1dBU0hfQ1lDTEVfU1'
    'RBTkRBUkQQARISCg5XQVNIX0NZQ0xFX0hPVBACEhYKEldBU0hfQ1lDTEVfQkFSUklFUhADEhcK'
    'E1dBU0hfQ1lDTEVfREVMSUNBVEUQBA==');

@$core.Deprecated('Use collectionStateDescriptor instead')
const CollectionState$json = {
  '1': 'CollectionState',
  '2': [
    {'1': 'COLLECTION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'COLLECTION_STATE_OPEN', '2': 1},
    {'1': 'COLLECTION_STATE_BATCHED', '2': 2},
    {'1': 'COLLECTION_STATE_CANCELLED', '2': 3},
  ],
};

/// Descriptor for `CollectionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List collectionStateDescriptor = $convert.base64Decode(
    'Cg9Db2xsZWN0aW9uU3RhdGUSIAocQ09MTEVDVElPTl9TVEFURV9VTlNQRUNJRklFRBAAEhkKFU'
    'NPTExFQ1RJT05fU1RBVEVfT1BFThABEhwKGENPTExFQ1RJT05fU1RBVEVfQkFUQ0hFRBACEh4K'
    'GkNPTExFQ1RJT05fU1RBVEVfQ0FOQ0VMTEVEEAM=');

@$core.Deprecated('Use batchStateDescriptor instead')
const BatchState$json = {
  '1': 'BatchState',
  '2': [
    {'1': 'BATCH_STATE_UNSPECIFIED', '2': 0},
    {'1': 'BATCH_STATE_LOADING', '2': 1},
    {'1': 'BATCH_STATE_PROCESSING', '2': 2},
    {'1': 'BATCH_STATE_PASSED', '2': 3},
    {'1': 'BATCH_STATE_FAILED', '2': 4},
    {'1': 'BATCH_STATE_REWASHED', '2': 5},
  ],
};

/// Descriptor for `BatchState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List batchStateDescriptor = $convert.base64Decode(
    'CgpCYXRjaFN0YXRlEhsKF0JBVENIX1NUQVRFX1VOU1BFQ0lGSUVEEAASFwoTQkFUQ0hfU1RBVE'
    'VfTE9BRElORxABEhoKFkJBVENIX1NUQVRFX1BST0NFU1NJTkcQAhIWChJCQVRDSF9TVEFURV9Q'
    'QVNTRUQQAxIWChJCQVRDSF9TVEFURV9GQUlMRUQQBBIYChRCQVRDSF9TVEFURV9SRVdBU0hFRB'
    'AF');

@$core.Deprecated('Use lossKindDescriptor instead')
const LossKind$json = {
  '1': 'LossKind',
  '2': [
    {'1': 'LOSS_KIND_UNSPECIFIED', '2': 0},
    {'1': 'LOSS_KIND_CONDEMNED', '2': 1},
    {'1': 'LOSS_KIND_DAMAGED', '2': 2},
    {'1': 'LOSS_KIND_MISSING', '2': 3},
  ],
};

/// Descriptor for `LossKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lossKindDescriptor = $convert.base64Decode(
    'CghMb3NzS2luZBIZChVMT1NTX0tJTkRfVU5TUEVDSUZJRUQQABIXChNMT1NTX0tJTkRfQ09ORE'
    'VNTkVEEAESFQoRTE9TU19LSU5EX0RBTUFHRUQQAhIVChFMT1NTX0tJTkRfTUlTU0lORxAD');

@$core.Deprecated('Use lossStateDescriptor instead')
const LossState$json = {
  '1': 'LossState',
  '2': [
    {'1': 'LOSS_STATE_UNSPECIFIED', '2': 0},
    {'1': 'LOSS_STATE_REPORTED', '2': 1},
    {'1': 'LOSS_STATE_APPROVED', '2': 2},
    {'1': 'LOSS_STATE_REJECTED', '2': 3},
    {'1': 'LOSS_STATE_RECOVERED', '2': 4},
  ],
};

/// Descriptor for `LossState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lossStateDescriptor = $convert.base64Decode(
    'CglMb3NzU3RhdGUSGgoWTE9TU19TVEFURV9VTlNQRUNJRklFRBAAEhcKE0xPU1NfU1RBVEVfUk'
    'VQT1JURUQQARIXChNMT1NTX1NUQVRFX0FQUFJPVkVEEAISFwoTTE9TU19TVEFURV9SRUpFQ1RF'
    'RBADEhgKFExPU1NfU1RBVEVfUkVDT1ZFUkVEEAQ=');

@$core.Deprecated('Use tagKindDescriptor instead')
const TagKind$json = {
  '1': 'TagKind',
  '2': [
    {'1': 'TAG_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TAG_KIND_RFID', '2': 1},
    {'1': 'TAG_KIND_BARCODE', '2': 2},
  ],
};

/// Descriptor for `TagKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tagKindDescriptor = $convert.base64Decode(
    'CgdUYWdLaW5kEhgKFFRBR19LSU5EX1VOU1BFQ0lGSUVEEAASEQoNVEFHX0tJTkRfUkZJRBABEh'
    'QKEFRBR19LSU5EX0JBUkNPREUQAg==');

@$core.Deprecated('Use trackedStateDescriptor instead')
const TrackedState$json = {
  '1': 'TrackedState',
  '2': [
    {'1': 'TRACKED_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TRACKED_STATE_IN_SERVICE', '2': 1},
    {'1': 'TRACKED_STATE_RETIRED', '2': 2},
  ],
};

/// Descriptor for `TrackedState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackedStateDescriptor = $convert.base64Decode(
    'CgxUcmFja2VkU3RhdGUSHQoZVFJBQ0tFRF9TVEFURV9VTlNQRUNJRklFRBAAEhwKGFRSQUNLRU'
    'RfU1RBVEVfSU5fU0VSVklDRRABEhkKFVRSQUNLRURfU1RBVEVfUkVUSVJFRBAC');

@$core.Deprecated('Use linenItemDescriptor instead')
const LinenItem$json = {
  '1': 'LinenItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'category',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LinenCategory',
      '10': 'category'
    },
    {'1': 'unit_weight_g', '3': 5, '4': 1, '5': 5, '10': 'unitWeightG'},
    {
      '1': 'replacement_cost_minor',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'replacementCostMinor'
    },
    {'1': 'tracked', '3': 7, '4': 1, '5': 8, '10': 'tracked'},
    {'1': 'active', '3': 8, '4': 1, '5': 8, '10': 'active'},
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

/// Descriptor for `LinenItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linenItemDescriptor = $convert.base64Decode(
    'CglMaW5lbkl0ZW0SFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhIKBGNvZGUYAiABKAlSBGNvZG'
    'USEgoEbmFtZRgDIAEoCVIEbmFtZRJACghjYXRlZ29yeRgEIAEoDjIkLmhlYWx0aGNhcmUubGF1'
    'bmRyeS52MS5MaW5lbkNhdGVnb3J5UghjYXRlZ29yeRIiCg11bml0X3dlaWdodF9nGAUgASgFUg'
    't1bml0V2VpZ2h0RxI0ChZyZXBsYWNlbWVudF9jb3N0X21pbm9yGAYgASgFUhRyZXBsYWNlbWVu'
    'dENvc3RNaW5vchIYCgd0cmFja2VkGAcgASgIUgd0cmFja2VkEhYKBmFjdGl2ZRgIIAEoCFIGYW'
    'N0aXZlEjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglj'
    'cmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgKIAEoCVIJY3JlYXRlZEJ5EhgKB3ZlcnNpb24YCyABKA'
    'NSB3ZlcnNpb24=');

@$core.Deprecated('Use parLineDescriptor instead')
const ParLine$json = {
  '1': 'ParLine',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'reorder_at', '3': 3, '4': 1, '5': 5, '10': 'reorderAt'},
  ],
};

/// Descriptor for `ParLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parLineDescriptor = $convert.base64Decode(
    'CgdQYXJMaW5lEhsKCWl0ZW1fY29kZRgBIAEoCVIIaXRlbUNvZGUSGgoIcXVhbnRpdHkYAiABKA'
    'VSCHF1YW50aXR5Eh0KCnJlb3JkZXJfYXQYAyABKAVSCXJlb3JkZXJBdA==');

@$core.Deprecated('Use parLevelDescriptor instead')
const ParLevel$json = {
  '1': 'ParLevel',
  '2': [
    {'1': 'par_id', '3': 1, '4': 1, '5': 9, '10': 'parId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'unit_name', '3': 3, '4': 1, '5': 9, '10': 'unitName'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'revision', '3': 5, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'lines',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLine',
      '10': 'lines'
    },
    {'1': 'approved', '3': 7, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'approved_by', '3': 8, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'superseded_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
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

/// Descriptor for `ParLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parLevelDescriptor = $convert.base64Decode(
    'CghQYXJMZXZlbBIVCgZwYXJfaWQYASABKAlSBXBhcklkEhcKB3VuaXRfaWQYAiABKAlSBnVuaX'
    'RJZBIbCgl1bml0X25hbWUYAyABKAlSCHVuaXROYW1lEh8KC2ZhY2lsaXR5X2lkGAQgASgJUgpm'
    'YWNpbGl0eUlkEhoKCHJldmlzaW9uGAUgASgFUghyZXZpc2lvbhI0CgVsaW5lcxgGIAMoCzIeLm'
    'hlYWx0aGNhcmUubGF1bmRyeS52MS5QYXJMaW5lUgVsaW5lcxIaCghhcHByb3ZlZBgHIAEoCFII'
    'YXBwcm92ZWQSHwoLYXBwcm92ZWRfYnkYCCABKAlSCmFwcHJvdmVkQnkSOwoLYXBwcm92ZWRfYX'
    'QYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0EkEKDmVmZmVj'
    'dGl2ZV9mcm9tGAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZlRn'
    'JvbRI/Cg1zdXBlcnNlZGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIM'
    'c3VwZXJzZWRlZEF0EjkKCmNyZWF0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgNIAEoCVIJY3JlYXRlZEJ5EhgKB3ZlcnNp'
    'b24YDiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use collectionLineDescriptor instead')
const CollectionLine$json = {
  '1': 'CollectionLine',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `CollectionLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionLineDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0aW9uTGluZRIbCglpdGVtX2NvZGUYASABKAlSCGl0ZW1Db2RlEhoKCHF1YW50aX'
    'R5GAIgASgFUghxdWFudGl0eQ==');

@$core.Deprecated('Use linenCollectionDescriptor instead')
const LinenCollection$json = {
  '1': 'LinenCollection',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'unit_name', '3': 3, '4': 1, '5': 9, '10': 'unitName'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'soil_class',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.SoilClass',
      '10': 'soilClass'
    },
    {'1': 'handling', '3': 6, '4': 1, '5': 9, '10': 'handling'},
    {'1': 'bag_count', '3': 7, '4': 1, '5': 5, '10': 'bagCount'},
    {'1': 'weight_g', '3': 8, '4': 1, '5': 5, '10': 'weightG'},
    {
      '1': 'lines',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.CollectionLine',
      '10': 'lines'
    },
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.CollectionState',
      '10': 'state'
    },
    {'1': 'batch_id', '3': 11, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'cancel_reason', '3': 12, '4': 1, '5': 9, '10': 'cancelReason'},
    {
      '1': 'collected_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {'1': 'collected_by', '3': 14, '4': 1, '5': 9, '10': 'collectedBy'},
    {'1': 'version', '3': 15, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `LinenCollection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linenCollectionDescriptor = $convert.base64Decode(
    'Cg9MaW5lbkNvbGxlY3Rpb24SIwoNY29sbGVjdGlvbl9pZBgBIAEoCVIMY29sbGVjdGlvbklkEh'
    'cKB3VuaXRfaWQYAiABKAlSBnVuaXRJZBIbCgl1bml0X25hbWUYAyABKAlSCHVuaXROYW1lEh8K'
    'C2ZhY2lsaXR5X2lkGAQgASgJUgpmYWNpbGl0eUlkEj8KCnNvaWxfY2xhc3MYBSABKA4yIC5oZW'
    'FsdGhjYXJlLmxhdW5kcnkudjEuU29pbENsYXNzUglzb2lsQ2xhc3MSGgoIaGFuZGxpbmcYBiAB'
    'KAlSCGhhbmRsaW5nEhsKCWJhZ19jb3VudBgHIAEoBVIIYmFnQ291bnQSGQoId2VpZ2h0X2cYCC'
    'ABKAVSB3dlaWdodEcSOwoFbGluZXMYCSADKAsyJS5oZWFsdGhjYXJlLmxhdW5kcnkudjEuQ29s'
    'bGVjdGlvbkxpbmVSBWxpbmVzEjwKBXN0YXRlGAogASgOMiYuaGVhbHRoY2FyZS5sYXVuZHJ5Ln'
    'YxLkNvbGxlY3Rpb25TdGF0ZVIFc3RhdGUSGQoIYmF0Y2hfaWQYCyABKAlSB2JhdGNoSWQSIwoN'
    'Y2FuY2VsX3JlYXNvbhgMIAEoCVIMY2FuY2VsUmVhc29uEj0KDGNvbGxlY3RlZF9hdBgNIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbGxlY3RlZEF0EiEKDGNvbGxlY3RlZF9i'
    'eRgOIAEoCVILY29sbGVjdGVkQnkSGAoHdmVyc2lvbhgPIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use batchExceptionDescriptor instead')
const BatchException$json = {
  '1': 'BatchException',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `BatchException`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchExceptionDescriptor = $convert.base64Decode(
    'Cg5CYXRjaEV4Y2VwdGlvbhISCgRjb2RlGAEgASgJUgRjb2RlEhYKBmRldGFpbBgCIAEoCVIGZG'
    'V0YWls');

@$core.Deprecated('Use washBatchDescriptor instead')
const WashBatch$json = {
  '1': 'WashBatch',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'machine_id', '3': 4, '4': 1, '5': 9, '10': 'machineId'},
    {
      '1': 'cycle',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.WashCycle',
      '10': 'cycle'
    },
    {'1': 'infected', '3': 6, '4': 1, '5': 8, '10': 'infected'},
    {'1': 'collection_ids', '3': 7, '4': 3, '5': 9, '10': 'collectionIds'},
    {'1': 'weight_g', '3': 8, '4': 1, '5': 5, '10': 'weightG'},
    {
      '1': 'state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.BatchState',
      '10': 'state'
    },
    {'1': 'outcome', '3': 10, '4': 1, '5': 9, '10': 'outcome'},
    {
      '1': 'exceptions',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.BatchException',
      '10': 'exceptions'
    },
    {
      '1': 'peak_temperature_c',
      '3': 12,
      '4': 1,
      '5': 5,
      '10': 'peakTemperatureC'
    },
    {'1': 'hold_minutes', '3': 13, '4': 1, '5': 5, '10': 'holdMinutes'},
    {'1': 'rewash_batch_id', '3': 14, '4': 1, '5': 9, '10': 'rewashBatchId'},
    {
      '1': 'rewash_of_batch_id',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'rewashOfBatchId'
    },
    {
      '1': 'started_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 17, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'completed_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'completed_by', '3': 19, '4': 1, '5': 9, '10': 'completedBy'},
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
  ],
};

/// Descriptor for `WashBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List washBatchDescriptor = $convert.base64Decode(
    'CglXYXNoQmF0Y2gSGQoIYmF0Y2hfaWQYASABKAlSB2JhdGNoSWQSHAoJcmVmZXJlbmNlGAIgAS'
    'gJUglyZWZlcmVuY2USHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSHQoKbWFjaGlu'
    'ZV9pZBgEIAEoCVIJbWFjaGluZUlkEjYKBWN5Y2xlGAUgASgOMiAuaGVhbHRoY2FyZS5sYXVuZH'
    'J5LnYxLldhc2hDeWNsZVIFY3ljbGUSGgoIaW5mZWN0ZWQYBiABKAhSCGluZmVjdGVkEiUKDmNv'
    'bGxlY3Rpb25faWRzGAcgAygJUg1jb2xsZWN0aW9uSWRzEhkKCHdlaWdodF9nGAggASgFUgd3ZW'
    'lnaHRHEjcKBXN0YXRlGAkgASgOMiEuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkJhdGNoU3RhdGVS'
    'BXN0YXRlEhgKB291dGNvbWUYCiABKAlSB291dGNvbWUSRQoKZXhjZXB0aW9ucxgLIAMoCzIlLm'
    'hlYWx0aGNhcmUubGF1bmRyeS52MS5CYXRjaEV4Y2VwdGlvblIKZXhjZXB0aW9ucxIsChJwZWFr'
    'X3RlbXBlcmF0dXJlX2MYDCABKAVSEHBlYWtUZW1wZXJhdHVyZUMSIQoMaG9sZF9taW51dGVzGA'
    '0gASgFUgtob2xkTWludXRlcxImCg9yZXdhc2hfYmF0Y2hfaWQYDiABKAlSDXJld2FzaEJhdGNo'
    'SWQSKwoScmV3YXNoX29mX2JhdGNoX2lkGA8gASgJUg9yZXdhc2hPZkJhdGNoSWQSOQoKc3Rhcn'
    'RlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBIdCgpz'
    'dGFydGVkX2J5GBEgASgJUglzdGFydGVkQnkSPQoMY29tcGxldGVkX2F0GBIgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29tcGxldGVkQXQSIQoMY29tcGxldGVkX2J5GBMgASgJ'
    'Ugtjb21wbGV0ZWRCeRI5CgpjcmVhdGVkX2F0GBQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIJY3JlYXRlZEF0Eh0KCmNyZWF0ZWRfYnkYFSABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJz'
    'aW9uGBYgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use issueLineDescriptor instead')
const IssueLine$json = {
  '1': 'IssueLine',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `IssueLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueLineDescriptor = $convert.base64Decode(
    'CglJc3N1ZUxpbmUSGwoJaXRlbV9jb2RlGAEgASgJUghpdGVtQ29kZRIaCghxdWFudGl0eRgCIA'
    'EoBVIIcXVhbnRpdHk=');

@$core.Deprecated('Use linenIssueDescriptor instead')
const LinenIssue$json = {
  '1': 'LinenIssue',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'unit_name', '3': 3, '4': 1, '5': 9, '10': 'unitName'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'batch_id', '3': 5, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'batch_reference', '3': 6, '4': 1, '5': 9, '10': 'batchReference'},
    {
      '1': 'lines',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.IssueLine',
      '10': 'lines'
    },
    {
      '1': 'issued_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'issued_by', '3': 9, '4': 1, '5': 9, '10': 'issuedBy'},
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

/// Descriptor for `LinenIssue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linenIssueDescriptor = $convert.base64Decode(
    'CgpMaW5lbklzc3VlEhkKCGlzc3VlX2lkGAEgASgJUgdpc3N1ZUlkEhcKB3VuaXRfaWQYAiABKA'
    'lSBnVuaXRJZBIbCgl1bml0X25hbWUYAyABKAlSCHVuaXROYW1lEh8KC2ZhY2lsaXR5X2lkGAQg'
    'ASgJUgpmYWNpbGl0eUlkEhkKCGJhdGNoX2lkGAUgASgJUgdiYXRjaElkEicKD2JhdGNoX3JlZm'
    'VyZW5jZRgGIAEoCVIOYmF0Y2hSZWZlcmVuY2USNgoFbGluZXMYByADKAsyIC5oZWFsdGhjYXJl'
    'LmxhdW5kcnkudjEuSXNzdWVMaW5lUgVsaW5lcxI3Cglpc3N1ZWRfYXQYCCABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUghpc3N1ZWRBdBIbCglpc3N1ZWRfYnkYCSABKAlSCGlzc3Vl'
    'ZEJ5EjsKC3JlY2VpdmVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcm'
    'VjZWl2ZWRBdBIfCgtyZWNlaXZlZF9ieRgLIAEoCVIKcmVjZWl2ZWRCeRIYCgd2ZXJzaW9uGAwg'
    'ASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use lossRecordDescriptor instead')
const LossRecord$json = {
  '1': 'LossRecord',
  '2': [
    {'1': 'loss_id', '3': 1, '4': 1, '5': 9, '10': 'lossId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'item_code', '3': 4, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'kind',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LossKind',
      '10': 'kind'
    },
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'value_minor', '3': 8, '4': 1, '5': 5, '10': 'valueMinor'},
    {
      '1': 'state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LossState',
      '10': 'state'
    },
    {
      '1': 'approval_required',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'approvalRequired'
    },
    {'1': 'approved_by', '3': 11, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {'1': 'decision_note', '3': 13, '4': 1, '5': 9, '10': 'decisionNote'},
    {
      '1': 'reported_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'reported_by', '3': 15, '4': 1, '5': 9, '10': 'reportedBy'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `LossRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lossRecordDescriptor = $convert.base64Decode(
    'CgpMb3NzUmVjb3JkEhcKB2xvc3NfaWQYASABKAlSBmxvc3NJZBIXCgd1bml0X2lkGAIgASgJUg'
    'Z1bml0SWQSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSGwoJaXRlbV9jb2RlGAQg'
    'ASgJUghpdGVtQ29kZRIaCghxdWFudGl0eRgFIAEoBVIIcXVhbnRpdHkSMwoEa2luZBgGIAEoDj'
    'IfLmhlYWx0aGNhcmUubGF1bmRyeS52MS5Mb3NzS2luZFIEa2luZBIWCgZyZWFzb24YByABKAlS'
    'BnJlYXNvbhIfCgt2YWx1ZV9taW5vchgIIAEoBVIKdmFsdWVNaW5vchI2CgVzdGF0ZRgJIAEoDj'
    'IgLmhlYWx0aGNhcmUubGF1bmRyeS52MS5Mb3NzU3RhdGVSBXN0YXRlEisKEWFwcHJvdmFsX3Jl'
    'cXVpcmVkGAogASgIUhBhcHByb3ZhbFJlcXVpcmVkEh8KC2FwcHJvdmVkX2J5GAsgASgJUgphcH'
    'Byb3ZlZEJ5EjsKC2FwcHJvdmVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIKYXBwcm92ZWRBdBIjCg1kZWNpc2lvbl9ub3RlGA0gASgJUgxkZWNpc2lvbk5vdGUSOwoLcm'
    'Vwb3J0ZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZXBvcnRlZEF0'
    'Eh8KC3JlcG9ydGVkX2J5GA8gASgJUgpyZXBvcnRlZEJ5EhgKB3ZlcnNpb24YECABKANSB3Zlcn'
    'Npb24=');

@$core.Deprecated('Use trackedMovementDescriptor instead')
const TrackedMovement$json = {
  '1': 'TrackedMovement',
  '2': [
    {'1': 'location', '3': 1, '4': 1, '5': 9, '10': 'location'},
    {'1': 'holder_id', '3': 2, '4': 1, '5': 9, '10': 'holderId'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'recorded_by', '3': 4, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'occurred_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `TrackedMovement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackedMovementDescriptor = $convert.base64Decode(
    'Cg9UcmFja2VkTW92ZW1lbnQSGgoIbG9jYXRpb24YASABKAlSCGxvY2F0aW9uEhsKCWhvbGRlcl'
    '9pZBgCIAEoCVIIaG9sZGVySWQSEgoEbm90ZRgDIAEoCVIEbm90ZRIfCgtyZWNvcmRlZF9ieRgE'
    'IAEoCVIKcmVjb3JkZWRCeRI7CgtvY2N1cnJlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCm9jY3VycmVkQXQ=');

@$core.Deprecated('Use trackedItemDescriptor instead')
const TrackedItem$json = {
  '1': 'TrackedItem',
  '2': [
    {'1': 'tracked_id', '3': 1, '4': 1, '5': 9, '10': 'trackedId'},
    {'1': 'tag_id', '3': 2, '4': 1, '5': 9, '10': 'tagId'},
    {
      '1': 'tag_kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.TagKind',
      '10': 'tagKind'
    },
    {'1': 'item_code', '3': 4, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'assigned_to', '3': 5, '4': 1, '5': 9, '10': 'assignedTo'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'state',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.TrackedState',
      '10': 'state'
    },
    {
      '1': 'movements',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedMovement',
      '10': 'movements'
    },
    {'1': 'retired_reason', '3': 9, '4': 1, '5': 9, '10': 'retiredReason'},
    {
      '1': 'registered_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'registeredAt'
    },
    {'1': 'registered_by', '3': 11, '4': 1, '5': 9, '10': 'registeredBy'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `TrackedItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackedItemDescriptor = $convert.base64Decode(
    'CgtUcmFja2VkSXRlbRIdCgp0cmFja2VkX2lkGAEgASgJUgl0cmFja2VkSWQSFQoGdGFnX2lkGA'
    'IgASgJUgV0YWdJZBI5Cgh0YWdfa2luZBgDIAEoDjIeLmhlYWx0aGNhcmUubGF1bmRyeS52MS5U'
    'YWdLaW5kUgd0YWdLaW5kEhsKCWl0ZW1fY29kZRgEIAEoCVIIaXRlbUNvZGUSHwoLYXNzaWduZW'
    'RfdG8YBSABKAlSCmFzc2lnbmVkVG8SHwoLZmFjaWxpdHlfaWQYBiABKAlSCmZhY2lsaXR5SWQS'
    'OQoFc3RhdGUYByABKA4yIy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuVHJhY2tlZFN0YXRlUgVzdG'
    'F0ZRJECgltb3ZlbWVudHMYCCADKAsyJi5oZWFsdGhjYXJlLmxhdW5kcnkudjEuVHJhY2tlZE1v'
    'dmVtZW50Ugltb3ZlbWVudHMSJQoOcmV0aXJlZF9yZWFzb24YCSABKAlSDXJldGlyZWRSZWFzb2'
    '4SPwoNcmVnaXN0ZXJlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHJl'
    'Z2lzdGVyZWRBdBIjCg1yZWdpc3RlcmVkX2J5GAsgASgJUgxyZWdpc3RlcmVkQnkSGAoHdmVyc2'
    'lvbhgMIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use custodyDescriptor instead')
const Custody$json = {
  '1': 'Custody',
  '2': [
    {'1': 'location', '3': 1, '4': 1, '5': 9, '10': 'location'},
    {'1': 'holder_id', '3': 2, '4': 1, '5': 9, '10': 'holderId'},
    {'1': 'recorded_by', '3': 3, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'occurred_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'known', '3': 5, '4': 1, '5': 8, '10': 'known'},
  ],
};

/// Descriptor for `Custody`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List custodyDescriptor = $convert.base64Decode(
    'CgdDdXN0b2R5EhoKCGxvY2F0aW9uGAEgASgJUghsb2NhdGlvbhIbCglob2xkZXJfaWQYAiABKA'
    'lSCGhvbGRlcklkEh8KC3JlY29yZGVkX2J5GAMgASgJUgpyZWNvcmRlZEJ5EjsKC29jY3VycmVk'
    'X2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBIUCgVrbm'
    '93bhgFIAEoCFIFa25vd24=');

@$core.Deprecated('Use configureLinenItemRequestDescriptor instead')
const ConfigureLinenItemRequest$json = {
  '1': 'ConfigureLinenItemRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'category',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LinenCategory',
      '10': 'category'
    },
    {'1': 'unit_weight_g', '3': 4, '4': 1, '5': 5, '10': 'unitWeightG'},
    {
      '1': 'replacement_cost_minor',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'replacementCostMinor'
    },
    {'1': 'tracked', '3': 6, '4': 1, '5': 8, '10': 'tracked'},
  ],
};

/// Descriptor for `ConfigureLinenItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureLinenItemRequestDescriptor = $convert.base64Decode(
    'ChlDb25maWd1cmVMaW5lbkl0ZW1SZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZR'
    'gCIAEoCVIEbmFtZRJACghjYXRlZ29yeRgDIAEoDjIkLmhlYWx0aGNhcmUubGF1bmRyeS52MS5M'
    'aW5lbkNhdGVnb3J5UghjYXRlZ29yeRIiCg11bml0X3dlaWdodF9nGAQgASgFUgt1bml0V2VpZ2'
    'h0RxI0ChZyZXBsYWNlbWVudF9jb3N0X21pbm9yGAUgASgFUhRyZXBsYWNlbWVudENvc3RNaW5v'
    'chIYCgd0cmFja2VkGAYgASgIUgd0cmFja2Vk');

@$core.Deprecated('Use configureLinenItemResponseDescriptor instead')
const ConfigureLinenItemResponse$json = {
  '1': 'ConfigureLinenItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ConfigureLinenItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureLinenItemResponseDescriptor =
    $convert.base64Decode(
        'ChpDb25maWd1cmVMaW5lbkl0ZW1SZXNwb25zZRI0CgRpdGVtGAEgASgLMiAuaGVhbHRoY2FyZS'
        '5sYXVuZHJ5LnYxLkxpbmVuSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use retireLinenItemRequestDescriptor instead')
const RetireLinenItemRequest$json = {
  '1': 'RetireLinenItemRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `RetireLinenItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireLinenItemRequestDescriptor =
    $convert.base64Decode(
        'ChZSZXRpcmVMaW5lbkl0ZW1SZXF1ZXN0EhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZA==');

@$core.Deprecated('Use retireLinenItemResponseDescriptor instead')
const RetireLinenItemResponse$json = {
  '1': 'RetireLinenItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RetireLinenItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireLinenItemResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXRpcmVMaW5lbkl0ZW1SZXNwb25zZRI0CgRpdGVtGAEgASgLMiAuaGVhbHRoY2FyZS5sYX'
        'VuZHJ5LnYxLkxpbmVuSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use listLinenItemsRequestDescriptor instead')
const ListLinenItemsRequest$json = {
  '1': 'ListLinenItemsRequest',
  '2': [
    {
      '1': 'category',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LinenCategory',
      '10': 'category'
    },
    {'1': 'tracked_only', '3': 2, '4': 1, '5': 8, '10': 'trackedOnly'},
    {'1': 'active_only', '3': 3, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 5, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListLinenItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLinenItemsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0TGluZW5JdGVtc1JlcXVlc3QSQAoIY2F0ZWdvcnkYASABKA4yJC5oZWFsdGhjYXJlLm'
    'xhdW5kcnkudjEuTGluZW5DYXRlZ29yeVIIY2F0ZWdvcnkSIQoMdHJhY2tlZF9vbmx5GAIgASgI'
    'Ugt0cmFja2VkT25seRIfCgthY3RpdmVfb25seRgDIAEoCFIKYWN0aXZlT25seRIbCglwYWdlX3'
    'NpemUYBCABKAVSCHBhZ2VTaXplEhYKBm9mZnNldBgFIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listLinenItemsResponseDescriptor instead')
const ListLinenItemsResponse$json = {
  '1': 'ListLinenItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListLinenItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLinenItemsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0TGluZW5JdGVtc1Jlc3BvbnNlEjYKBWl0ZW1zGAEgAygLMiAuaGVhbHRoY2FyZS5sYX'
        'VuZHJ5LnYxLkxpbmVuSXRlbVIFaXRlbXM=');

@$core.Deprecated('Use setParLevelRequestDescriptor instead')
const SetParLevelRequest$json = {
  '1': 'SetParLevelRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'unit_name', '3': 2, '4': 1, '5': 9, '10': 'unitName'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'lines',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `SetParLevelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setParLevelRequestDescriptor = $convert.base64Decode(
    'ChJTZXRQYXJMZXZlbFJlcXVlc3QSFwoHdW5pdF9pZBgBIAEoCVIGdW5pdElkEhsKCXVuaXRfbm'
    'FtZRgCIAEoCVIIdW5pdE5hbWUSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSNAoF'
    'bGluZXMYBCADKAsyHi5oZWFsdGhjYXJlLmxhdW5kcnkudjEuUGFyTGluZVIFbGluZXM=');

@$core.Deprecated('Use setParLevelResponseDescriptor instead')
const SetParLevelResponse$json = {
  '1': 'SetParLevelResponse',
  '2': [
    {
      '1': 'par',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLevel',
      '10': 'par'
    },
  ],
};

/// Descriptor for `SetParLevelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setParLevelResponseDescriptor = $convert.base64Decode(
    'ChNTZXRQYXJMZXZlbFJlc3BvbnNlEjEKA3BhchgBIAEoCzIfLmhlYWx0aGNhcmUubGF1bmRyeS'
    '52MS5QYXJMZXZlbFIDcGFy');

@$core.Deprecated('Use approveParLevelRequestDescriptor instead')
const ApproveParLevelRequest$json = {
  '1': 'ApproveParLevelRequest',
  '2': [
    {'1': 'par_id', '3': 1, '4': 1, '5': 9, '10': 'parId'},
    {
      '1': 'effective_from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `ApproveParLevelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveParLevelRequestDescriptor = $convert.base64Decode(
    'ChZBcHByb3ZlUGFyTGV2ZWxSZXF1ZXN0EhUKBnBhcl9pZBgBIAEoCVIFcGFySWQSQQoOZWZmZW'
    'N0aXZlX2Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3RpdmVG'
    'cm9t');

@$core.Deprecated('Use approveParLevelResponseDescriptor instead')
const ApproveParLevelResponse$json = {
  '1': 'ApproveParLevelResponse',
  '2': [
    {
      '1': 'par',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLevel',
      '10': 'par'
    },
  ],
};

/// Descriptor for `ApproveParLevelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveParLevelResponseDescriptor =
    $convert.base64Decode(
        'ChdBcHByb3ZlUGFyTGV2ZWxSZXNwb25zZRIxCgNwYXIYASABKAsyHy5oZWFsdGhjYXJlLmxhdW'
        '5kcnkudjEuUGFyTGV2ZWxSA3Bhcg==');

@$core.Deprecated('Use getParInForceRequestDescriptor instead')
const GetParInForceRequest$json = {
  '1': 'GetParInForceRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
  ],
};

/// Descriptor for `GetParInForceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getParInForceRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRQYXJJbkZvcmNlUmVxdWVzdBIXCgd1bml0X2lkGAEgASgJUgZ1bml0SWQ=');

@$core.Deprecated('Use getParInForceResponseDescriptor instead')
const GetParInForceResponse$json = {
  '1': 'GetParInForceResponse',
  '2': [
    {
      '1': 'par',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLevel',
      '10': 'par'
    },
  ],
};

/// Descriptor for `GetParInForceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getParInForceResponseDescriptor = $convert.base64Decode(
    'ChVHZXRQYXJJbkZvcmNlUmVzcG9uc2USMQoDcGFyGAEgASgLMh8uaGVhbHRoY2FyZS5sYXVuZH'
    'J5LnYxLlBhckxldmVsUgNwYXI=');

@$core.Deprecated('Use listParLevelsRequestDescriptor instead')
const ListParLevelsRequest$json = {
  '1': 'ListParLevelsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'live_only', '3': 3, '4': 1, '5': 8, '10': 'liveOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 5, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListParLevelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listParLevelsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0UGFyTGV2ZWxzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZB'
    'IXCgd1bml0X2lkGAIgASgJUgZ1bml0SWQSGwoJbGl2ZV9vbmx5GAMgASgIUghsaXZlT25seRIb'
    'CglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXplEhYKBm9mZnNldBgFIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listParLevelsResponseDescriptor instead')
const ListParLevelsResponse$json = {
  '1': 'ListParLevelsResponse',
  '2': [
    {
      '1': 'pars',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLevel',
      '10': 'pars'
    },
  ],
};

/// Descriptor for `ListParLevelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listParLevelsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UGFyTGV2ZWxzUmVzcG9uc2USMwoEcGFycxgBIAMoCzIfLmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5QYXJMZXZlbFIEcGFycw==');

@$core.Deprecated('Use recordCollectionRequestDescriptor instead')
const RecordCollectionRequest$json = {
  '1': 'RecordCollectionRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'unit_name', '3': 2, '4': 1, '5': 9, '10': 'unitName'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'soil_class',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.SoilClass',
      '10': 'soilClass'
    },
    {'1': 'bag_count', '3': 5, '4': 1, '5': 5, '10': 'bagCount'},
    {'1': 'weight_g', '3': 6, '4': 1, '5': 5, '10': 'weightG'},
    {
      '1': 'lines',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.CollectionLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `RecordCollectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCollectionRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmRDb2xsZWN0aW9uUmVxdWVzdBIXCgd1bml0X2lkGAEgASgJUgZ1bml0SWQSGwoJdW'
    '5pdF9uYW1lGAIgASgJUgh1bml0TmFtZRIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJ'
    'ZBI/Cgpzb2lsX2NsYXNzGAQgASgOMiAuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlNvaWxDbGFzc1'
    'IJc29pbENsYXNzEhsKCWJhZ19jb3VudBgFIAEoBVIIYmFnQ291bnQSGQoId2VpZ2h0X2cYBiAB'
    'KAVSB3dlaWdodEcSOwoFbGluZXMYByADKAsyJS5oZWFsdGhjYXJlLmxhdW5kcnkudjEuQ29sbG'
    'VjdGlvbkxpbmVSBWxpbmVz');

@$core.Deprecated('Use recordCollectionResponseDescriptor instead')
const RecordCollectionResponse$json = {
  '1': 'RecordCollectionResponse',
  '2': [
    {
      '1': 'collection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenCollection',
      '10': 'collection'
    },
  ],
};

/// Descriptor for `RecordCollectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCollectionResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvcmRDb2xsZWN0aW9uUmVzcG9uc2USRgoKY29sbGVjdGlvbhgBIAEoCzImLmhlYWx0aG'
        'NhcmUubGF1bmRyeS52MS5MaW5lbkNvbGxlY3Rpb25SCmNvbGxlY3Rpb24=');

@$core.Deprecated('Use recountCollectionRequestDescriptor instead')
const RecountCollectionRequest$json = {
  '1': 'RecountCollectionRequest',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
    {
      '1': 'lines',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.CollectionLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `RecountCollectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recountCollectionRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvdW50Q29sbGVjdGlvblJlcXVlc3QSIwoNY29sbGVjdGlvbl9pZBgBIAEoCVIMY29sbG'
    'VjdGlvbklkEjsKBWxpbmVzGAIgAygLMiUuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkNvbGxlY3Rp'
    'b25MaW5lUgVsaW5lcw==');

@$core.Deprecated('Use recountCollectionResponseDescriptor instead')
const RecountCollectionResponse$json = {
  '1': 'RecountCollectionResponse',
  '2': [
    {
      '1': 'collection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenCollection',
      '10': 'collection'
    },
  ],
};

/// Descriptor for `RecountCollectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recountCollectionResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvdW50Q29sbGVjdGlvblJlc3BvbnNlEkYKCmNvbGxlY3Rpb24YASABKAsyJi5oZWFsdG'
        'hjYXJlLmxhdW5kcnkudjEuTGluZW5Db2xsZWN0aW9uUgpjb2xsZWN0aW9u');

@$core.Deprecated('Use cancelCollectionRequestDescriptor instead')
const CancelCollectionRequest$json = {
  '1': 'CancelCollectionRequest',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelCollectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelCollectionRequestDescriptor =
    $convert.base64Decode(
        'ChdDYW5jZWxDb2xsZWN0aW9uUmVxdWVzdBIjCg1jb2xsZWN0aW9uX2lkGAEgASgJUgxjb2xsZW'
        'N0aW9uSWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use cancelCollectionResponseDescriptor instead')
const CancelCollectionResponse$json = {
  '1': 'CancelCollectionResponse',
  '2': [
    {
      '1': 'collection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenCollection',
      '10': 'collection'
    },
  ],
};

/// Descriptor for `CancelCollectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelCollectionResponseDescriptor =
    $convert.base64Decode(
        'ChhDYW5jZWxDb2xsZWN0aW9uUmVzcG9uc2USRgoKY29sbGVjdGlvbhgBIAEoCzImLmhlYWx0aG'
        'NhcmUubGF1bmRyeS52MS5MaW5lbkNvbGxlY3Rpb25SCmNvbGxlY3Rpb24=');

@$core.Deprecated('Use listCollectionsRequestDescriptor instead')
const ListCollectionsRequest$json = {
  '1': 'ListCollectionsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'soil_class',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.SoilClass',
      '10': 'soilClass'
    },
    {
      '1': 'states',
      '3': 4,
      '4': 3,
      '5': 14,
      '6': '.healthcare.laundry.v1.CollectionState',
      '10': 'states'
    },
    {'1': 'batch_id', '3': 5, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'pending_only', '3': 6, '4': 1, '5': 8, '10': 'pendingOnly'},
    {
      '1': 'from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 9, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 10, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListCollectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0Q29sbGVjdGlvbnNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eU'
    'lkEhcKB3VuaXRfaWQYAiABKAlSBnVuaXRJZBI/Cgpzb2lsX2NsYXNzGAMgASgOMiAuaGVhbHRo'
    'Y2FyZS5sYXVuZHJ5LnYxLlNvaWxDbGFzc1IJc29pbENsYXNzEj4KBnN0YXRlcxgEIAMoDjImLm'
    'hlYWx0aGNhcmUubGF1bmRyeS52MS5Db2xsZWN0aW9uU3RhdGVSBnN0YXRlcxIZCghiYXRjaF9p'
    'ZBgFIAEoCVIHYmF0Y2hJZBIhCgxwZW5kaW5nX29ubHkYBiABKAhSC3BlbmRpbmdPbmx5Ei4KBG'
    'Zyb20YByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAggASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8SGwoJcGFnZV9zaXplGAkgASgFUghwYW'
    'dlU2l6ZRIWCgZvZmZzZXQYCiABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listCollectionsResponseDescriptor instead')
const ListCollectionsResponse$json = {
  '1': 'ListCollectionsResponse',
  '2': [
    {
      '1': 'collections',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenCollection',
      '10': 'collections'
    },
  ],
};

/// Descriptor for `ListCollectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCollectionsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0Q29sbGVjdGlvbnNSZXNwb25zZRJICgtjb2xsZWN0aW9ucxgBIAMoCzImLmhlYWx0aG'
        'NhcmUubGF1bmRyeS52MS5MaW5lbkNvbGxlY3Rpb25SC2NvbGxlY3Rpb25z');

@$core.Deprecated('Use checkCollectionWeightRequestDescriptor instead')
const CheckCollectionWeightRequest$json = {
  '1': 'CheckCollectionWeightRequest',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
  ],
};

/// Descriptor for `CheckCollectionWeightRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkCollectionWeightRequestDescriptor =
    $convert.base64Decode(
        'ChxDaGVja0NvbGxlY3Rpb25XZWlnaHRSZXF1ZXN0EiMKDWNvbGxlY3Rpb25faWQYASABKAlSDG'
        'NvbGxlY3Rpb25JZA==');

@$core.Deprecated('Use checkCollectionWeightResponseDescriptor instead')
const CheckCollectionWeightResponse$json = {
  '1': 'CheckCollectionWeightResponse',
  '2': [
    {'1': 'declared_pieces', '3': 1, '4': 1, '5': 5, '10': 'declaredPieces'},
    {'1': 'expected_g', '3': 2, '4': 1, '5': 5, '10': 'expectedG'},
    {'1': 'actual_g', '3': 3, '4': 1, '5': 5, '10': 'actualG'},
    {'1': 'variance_g', '3': 4, '4': 1, '5': 5, '10': 'varianceG'},
    {'1': 'unanswerable', '3': 5, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `CheckCollectionWeightResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkCollectionWeightResponseDescriptor = $convert.base64Decode(
    'Ch1DaGVja0NvbGxlY3Rpb25XZWlnaHRSZXNwb25zZRInCg9kZWNsYXJlZF9waWVjZXMYASABKA'
    'VSDmRlY2xhcmVkUGllY2VzEh0KCmV4cGVjdGVkX2cYAiABKAVSCWV4cGVjdGVkRxIZCghhY3R1'
    'YWxfZxgDIAEoBVIHYWN0dWFsRxIdCgp2YXJpYW5jZV9nGAQgASgFUgl2YXJpYW5jZUcSIgoMdW'
    '5hbnN3ZXJhYmxlGAUgASgIUgx1bmFuc3dlcmFibGU=');

@$core.Deprecated('Use openWashBatchRequestDescriptor instead')
const OpenWashBatchRequest$json = {
  '1': 'OpenWashBatchRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'machine_id', '3': 3, '4': 1, '5': 9, '10': 'machineId'},
    {
      '1': 'cycle',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.WashCycle',
      '10': 'cycle'
    },
    {
      '1': 'rewash_of_batch_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'rewashOfBatchId'
    },
  ],
};

/// Descriptor for `OpenWashBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openWashBatchRequestDescriptor = $convert.base64Decode(
    'ChRPcGVuV2FzaEJhdGNoUmVxdWVzdBIcCglyZWZlcmVuY2UYASABKAlSCXJlZmVyZW5jZRIfCg'
    'tmYWNpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBIdCgptYWNoaW5lX2lkGAMgASgJUgltYWNo'
    'aW5lSWQSNgoFY3ljbGUYBCABKA4yIC5oZWFsdGhjYXJlLmxhdW5kcnkudjEuV2FzaEN5Y2xlUg'
    'VjeWNsZRIrChJyZXdhc2hfb2ZfYmF0Y2hfaWQYBSABKAlSD3Jld2FzaE9mQmF0Y2hJZA==');

@$core.Deprecated('Use openWashBatchResponseDescriptor instead')
const OpenWashBatchResponse$json = {
  '1': 'OpenWashBatchResponse',
  '2': [
    {
      '1': 'batch',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batch'
    },
  ],
};

/// Descriptor for `OpenWashBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openWashBatchResponseDescriptor = $convert.base64Decode(
    'ChVPcGVuV2FzaEJhdGNoUmVzcG9uc2USNgoFYmF0Y2gYASABKAsyIC5oZWFsdGhjYXJlLmxhdW'
    '5kcnkudjEuV2FzaEJhdGNoUgViYXRjaA==');

@$core.Deprecated('Use loadWashBatchRequestDescriptor instead')
const LoadWashBatchRequest$json = {
  '1': 'LoadWashBatchRequest',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'collection_id', '3': 2, '4': 1, '5': 9, '10': 'collectionId'},
  ],
};

/// Descriptor for `LoadWashBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadWashBatchRequestDescriptor = $convert.base64Decode(
    'ChRMb2FkV2FzaEJhdGNoUmVxdWVzdBIZCghiYXRjaF9pZBgBIAEoCVIHYmF0Y2hJZBIjCg1jb2'
    'xsZWN0aW9uX2lkGAIgASgJUgxjb2xsZWN0aW9uSWQ=');

@$core.Deprecated('Use loadWashBatchResponseDescriptor instead')
const LoadWashBatchResponse$json = {
  '1': 'LoadWashBatchResponse',
  '2': [
    {
      '1': 'batch',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batch'
    },
  ],
};

/// Descriptor for `LoadWashBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadWashBatchResponseDescriptor = $convert.base64Decode(
    'ChVMb2FkV2FzaEJhdGNoUmVzcG9uc2USNgoFYmF0Y2gYASABKAsyIC5oZWFsdGhjYXJlLmxhdW'
    '5kcnkudjEuV2FzaEJhdGNoUgViYXRjaA==');

@$core.Deprecated('Use startWashBatchRequestDescriptor instead')
const StartWashBatchRequest$json = {
  '1': 'StartWashBatchRequest',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
  ],
};

/// Descriptor for `StartWashBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startWashBatchRequestDescriptor =
    $convert.base64Decode(
        'ChVTdGFydFdhc2hCYXRjaFJlcXVlc3QSGQoIYmF0Y2hfaWQYASABKAlSB2JhdGNoSWQ=');

@$core.Deprecated('Use startWashBatchResponseDescriptor instead')
const StartWashBatchResponse$json = {
  '1': 'StartWashBatchResponse',
  '2': [
    {
      '1': 'batch',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batch'
    },
  ],
};

/// Descriptor for `StartWashBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startWashBatchResponseDescriptor =
    $convert.base64Decode(
        'ChZTdGFydFdhc2hCYXRjaFJlc3BvbnNlEjYKBWJhdGNoGAEgASgLMiAuaGVhbHRoY2FyZS5sYX'
        'VuZHJ5LnYxLldhc2hCYXRjaFIFYmF0Y2g=');

@$core.Deprecated('Use completeWashBatchRequestDescriptor instead')
const CompleteWashBatchRequest$json = {
  '1': 'CompleteWashBatchRequest',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'passed', '3': 2, '4': 1, '5': 8, '10': 'passed'},
    {'1': 'outcome', '3': 3, '4': 1, '5': 9, '10': 'outcome'},
    {
      '1': 'peak_temperature_c',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'peakTemperatureC'
    },
    {'1': 'hold_minutes', '3': 5, '4': 1, '5': 5, '10': 'holdMinutes'},
    {
      '1': 'exceptions',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.BatchException',
      '10': 'exceptions'
    },
  ],
};

/// Descriptor for `CompleteWashBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeWashBatchRequestDescriptor = $convert.base64Decode(
    'ChhDb21wbGV0ZVdhc2hCYXRjaFJlcXVlc3QSGQoIYmF0Y2hfaWQYASABKAlSB2JhdGNoSWQSFg'
    'oGcGFzc2VkGAIgASgIUgZwYXNzZWQSGAoHb3V0Y29tZRgDIAEoCVIHb3V0Y29tZRIsChJwZWFr'
    'X3RlbXBlcmF0dXJlX2MYBCABKAVSEHBlYWtUZW1wZXJhdHVyZUMSIQoMaG9sZF9taW51dGVzGA'
    'UgASgFUgtob2xkTWludXRlcxJFCgpleGNlcHRpb25zGAYgAygLMiUuaGVhbHRoY2FyZS5sYXVu'
    'ZHJ5LnYxLkJhdGNoRXhjZXB0aW9uUgpleGNlcHRpb25z');

@$core.Deprecated('Use completeWashBatchResponseDescriptor instead')
const CompleteWashBatchResponse$json = {
  '1': 'CompleteWashBatchResponse',
  '2': [
    {
      '1': 'batch',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batch'
    },
  ],
};

/// Descriptor for `CompleteWashBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeWashBatchResponseDescriptor =
    $convert.base64Decode(
        'ChlDb21wbGV0ZVdhc2hCYXRjaFJlc3BvbnNlEjYKBWJhdGNoGAEgASgLMiAuaGVhbHRoY2FyZS'
        '5sYXVuZHJ5LnYxLldhc2hCYXRjaFIFYmF0Y2g=');

@$core.Deprecated('Use rewashBatchRequestDescriptor instead')
const RewashBatchRequest$json = {
  '1': 'RewashBatchRequest',
  '2': [
    {'1': 'failed_batch_id', '3': 1, '4': 1, '5': 9, '10': 'failedBatchId'},
    {'1': 'into_batch_id', '3': 2, '4': 1, '5': 9, '10': 'intoBatchId'},
  ],
};

/// Descriptor for `RewashBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rewashBatchRequestDescriptor = $convert.base64Decode(
    'ChJSZXdhc2hCYXRjaFJlcXVlc3QSJgoPZmFpbGVkX2JhdGNoX2lkGAEgASgJUg1mYWlsZWRCYX'
    'RjaElkEiIKDWludG9fYmF0Y2hfaWQYAiABKAlSC2ludG9CYXRjaElk');

@$core.Deprecated('Use rewashBatchResponseDescriptor instead')
const RewashBatchResponse$json = {
  '1': 'RewashBatchResponse',
  '2': [
    {
      '1': 'batch',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batch'
    },
  ],
};

/// Descriptor for `RewashBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rewashBatchResponseDescriptor = $convert.base64Decode(
    'ChNSZXdhc2hCYXRjaFJlc3BvbnNlEjYKBWJhdGNoGAEgASgLMiAuaGVhbHRoY2FyZS5sYXVuZH'
    'J5LnYxLldhc2hCYXRjaFIFYmF0Y2g=');

@$core.Deprecated('Use getWashBatchRequestDescriptor instead')
const GetWashBatchRequest$json = {
  '1': 'GetWashBatchRequest',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
  ],
};

/// Descriptor for `GetWashBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWashBatchRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRXYXNoQmF0Y2hSZXF1ZXN0EhkKCGJhdGNoX2lkGAEgASgJUgdiYXRjaElk');

@$core.Deprecated('Use getWashBatchResponseDescriptor instead')
const GetWashBatchResponse$json = {
  '1': 'GetWashBatchResponse',
  '2': [
    {
      '1': 'batch',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batch'
    },
  ],
};

/// Descriptor for `GetWashBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWashBatchResponseDescriptor = $convert.base64Decode(
    'ChRHZXRXYXNoQmF0Y2hSZXNwb25zZRI2CgViYXRjaBgBIAEoCzIgLmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5XYXNoQmF0Y2hSBWJhdGNo');

@$core.Deprecated('Use listWashBatchesRequestDescriptor instead')
const ListWashBatchesRequest$json = {
  '1': 'ListWashBatchesRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'machine_id', '3': 2, '4': 1, '5': 9, '10': 'machineId'},
    {
      '1': 'cycle',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.WashCycle',
      '10': 'cycle'
    },
    {
      '1': 'states',
      '3': 4,
      '4': 3,
      '5': 14,
      '6': '.healthcare.laundry.v1.BatchState',
      '10': 'states'
    },
    {
      '1': 'from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 7, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 8, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListWashBatchesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWashBatchesRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0V2FzaEJhdGNoZXNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eU'
    'lkEh0KCm1hY2hpbmVfaWQYAiABKAlSCW1hY2hpbmVJZBI2CgVjeWNsZRgDIAEoDjIgLmhlYWx0'
    'aGNhcmUubGF1bmRyeS52MS5XYXNoQ3ljbGVSBWN5Y2xlEjkKBnN0YXRlcxgEIAMoDjIhLmhlYW'
    'x0aGNhcmUubGF1bmRyeS52MS5CYXRjaFN0YXRlUgZzdGF0ZXMSLgoEZnJvbRgFIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YBiABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgJ0bxIbCglwYWdlX3NpemUYByABKAVSCHBhZ2VTaXplEhYKBm9mZnNl'
    'dBgIIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listWashBatchesResponseDescriptor instead')
const ListWashBatchesResponse$json = {
  '1': 'ListWashBatchesResponse',
  '2': [
    {
      '1': 'batches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashBatch',
      '10': 'batches'
    },
  ],
};

/// Descriptor for `ListWashBatchesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWashBatchesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0V2FzaEJhdGNoZXNSZXNwb25zZRI6CgdiYXRjaGVzGAEgAygLMiAuaGVhbHRoY2FyZS'
        '5sYXVuZHJ5LnYxLldhc2hCYXRjaFIHYmF0Y2hlcw==');

@$core.Deprecated('Use listAffectedUnitsRequestDescriptor instead')
const ListAffectedUnitsRequest$json = {
  '1': 'ListAffectedUnitsRequest',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
  ],
};

/// Descriptor for `ListAffectedUnitsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAffectedUnitsRequestDescriptor =
    $convert.base64Decode(
        'ChhMaXN0QWZmZWN0ZWRVbml0c1JlcXVlc3QSGQoIYmF0Y2hfaWQYASABKAlSB2JhdGNoSWQ=');

@$core.Deprecated('Use listAffectedUnitsResponseDescriptor instead')
const ListAffectedUnitsResponse$json = {
  '1': 'ListAffectedUnitsResponse',
  '2': [
    {'1': 'unit_ids', '3': 1, '4': 3, '5': 9, '10': 'unitIds'},
  ],
};

/// Descriptor for `ListAffectedUnitsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAffectedUnitsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0QWZmZWN0ZWRVbml0c1Jlc3BvbnNlEhkKCHVuaXRfaWRzGAEgAygJUgd1bml0SWRz');

@$core.Deprecated('Use issueLinenRequestDescriptor instead')
const IssueLinenRequest$json = {
  '1': 'IssueLinenRequest',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'unit_name', '3': 3, '4': 1, '5': 9, '10': 'unitName'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'lines',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.IssueLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `IssueLinenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueLinenRequestDescriptor = $convert.base64Decode(
    'ChFJc3N1ZUxpbmVuUmVxdWVzdBIZCghiYXRjaF9pZBgBIAEoCVIHYmF0Y2hJZBIXCgd1bml0X2'
    'lkGAIgASgJUgZ1bml0SWQSGwoJdW5pdF9uYW1lGAMgASgJUgh1bml0TmFtZRIfCgtmYWNpbGl0'
    'eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBI2CgVsaW5lcxgFIAMoCzIgLmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5Jc3N1ZUxpbmVSBWxpbmVz');

@$core.Deprecated('Use issueLinenResponseDescriptor instead')
const IssueLinenResponse$json = {
  '1': 'IssueLinenResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenIssue',
      '10': 'issue'
    },
  ],
};

/// Descriptor for `IssueLinenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueLinenResponseDescriptor = $convert.base64Decode(
    'ChJJc3N1ZUxpbmVuUmVzcG9uc2USNwoFaXNzdWUYASABKAsyIS5oZWFsdGhjYXJlLmxhdW5kcn'
    'kudjEuTGluZW5Jc3N1ZVIFaXNzdWU=');

@$core.Deprecated('Use receiveLinenRequestDescriptor instead')
const ReceiveLinenRequest$json = {
  '1': 'ReceiveLinenRequest',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
  ],
};

/// Descriptor for `ReceiveLinenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveLinenRequestDescriptor =
    $convert.base64Decode(
        'ChNSZWNlaXZlTGluZW5SZXF1ZXN0EhkKCGlzc3VlX2lkGAEgASgJUgdpc3N1ZUlk');

@$core.Deprecated('Use receiveLinenResponseDescriptor instead')
const ReceiveLinenResponse$json = {
  '1': 'ReceiveLinenResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenIssue',
      '10': 'issue'
    },
  ],
};

/// Descriptor for `ReceiveLinenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveLinenResponseDescriptor = $convert.base64Decode(
    'ChRSZWNlaXZlTGluZW5SZXNwb25zZRI3CgVpc3N1ZRgBIAEoCzIhLmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5MaW5lbklzc3VlUgVpc3N1ZQ==');

@$core.Deprecated('Use listLinenIssuesRequestDescriptor instead')
const ListLinenIssuesRequest$json = {
  '1': 'ListLinenIssuesRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'batch_id', '3': 3, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'outstanding_only', '3': 4, '4': 1, '5': 8, '10': 'outstandingOnly'},
    {
      '1': 'from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 7, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 8, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListLinenIssuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLinenIssuesRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0TGluZW5Jc3N1ZXNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eU'
    'lkEhcKB3VuaXRfaWQYAiABKAlSBnVuaXRJZBIZCghiYXRjaF9pZBgDIAEoCVIHYmF0Y2hJZBIp'
    'ChBvdXRzdGFuZGluZ19vbmx5GAQgASgIUg9vdXRzdGFuZGluZ09ubHkSLgoEZnJvbRgFIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YBiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgJ0bxIbCglwYWdlX3NpemUYByABKAVSCHBhZ2VTaXplEhYKBm'
    '9mZnNldBgIIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listLinenIssuesResponseDescriptor instead')
const ListLinenIssuesResponse$json = {
  '1': 'ListLinenIssuesResponse',
  '2': [
    {
      '1': 'issues',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenIssue',
      '10': 'issues'
    },
  ],
};

/// Descriptor for `ListLinenIssuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLinenIssuesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0TGluZW5Jc3N1ZXNSZXNwb25zZRI5CgZpc3N1ZXMYASADKAsyIS5oZWFsdGhjYXJlLm'
        'xhdW5kcnkudjEuTGluZW5Jc3N1ZVIGaXNzdWVz');

@$core.Deprecated('Use itemCountDescriptor instead')
const ItemCount$json = {
  '1': 'ItemCount',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `ItemCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemCountDescriptor = $convert.base64Decode(
    'CglJdGVtQ291bnQSGwoJaXRlbV9jb2RlGAEgASgJUghpdGVtQ29kZRIaCghxdWFudGl0eRgCIA'
    'EoBVIIcXVhbnRpdHk=');

@$core.Deprecated('Use shortfallDescriptor instead')
const Shortfall$json = {
  '1': 'Shortfall',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'par', '3': 2, '4': 1, '5': 5, '10': 'par'},
    {'1': 'on_hand', '3': 3, '4': 1, '5': 5, '10': 'onHand'},
    {'1': 'short', '3': 4, '4': 1, '5': 5, '10': 'short'},
  ],
};

/// Descriptor for `Shortfall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shortfallDescriptor = $convert.base64Decode(
    'CglTaG9ydGZhbGwSGwoJaXRlbV9jb2RlGAEgASgJUghpdGVtQ29kZRIQCgNwYXIYAiABKAVSA3'
    'BhchIXCgdvbl9oYW5kGAMgASgFUgZvbkhhbmQSFAoFc2hvcnQYBCABKAVSBXNob3J0');

@$core.Deprecated('Use getUnitStockRequestDescriptor instead')
const GetUnitStockRequest$json = {
  '1': 'GetUnitStockRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
  ],
};

/// Descriptor for `GetUnitStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnitStockRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRVbml0U3RvY2tSZXF1ZXN0EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZA==');

@$core.Deprecated('Use getUnitStockResponseDescriptor instead')
const GetUnitStockResponse$json = {
  '1': 'GetUnitStockResponse',
  '2': [
    {
      '1': 'on_hand',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ItemCount',
      '10': 'onHand'
    },
    {
      '1': 'issued',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ItemCount',
      '10': 'issued'
    },
    {
      '1': 'returned',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ItemCount',
      '10': 'returned'
    },
    {
      '1': 'written_off',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.ItemCount',
      '10': 'writtenOff'
    },
    {
      '1': 'unreconciled_returns',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'unreconciledReturns'
    },
    {
      '1': 'shortfalls',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.Shortfall',
      '10': 'shortfalls'
    },
    {
      '1': 'par_in_force',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.ParLevel',
      '10': 'parInForce'
    },
    {'1': 'no_par', '3': 8, '4': 1, '5': 8, '10': 'noPar'},
    {'1': 'truncated', '3': 9, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetUnitStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnitStockResponseDescriptor = $convert.base64Decode(
    'ChRHZXRVbml0U3RvY2tSZXNwb25zZRI5Cgdvbl9oYW5kGAEgAygLMiAuaGVhbHRoY2FyZS5sYX'
    'VuZHJ5LnYxLkl0ZW1Db3VudFIGb25IYW5kEjgKBmlzc3VlZBgCIAMoCzIgLmhlYWx0aGNhcmUu'
    'bGF1bmRyeS52MS5JdGVtQ291bnRSBmlzc3VlZBI8CghyZXR1cm5lZBgDIAMoCzIgLmhlYWx0aG'
    'NhcmUubGF1bmRyeS52MS5JdGVtQ291bnRSCHJldHVybmVkEkEKC3dyaXR0ZW5fb2ZmGAQgAygL'
    'MiAuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkl0ZW1Db3VudFIKd3JpdHRlbk9mZhIxChR1bnJlY2'
    '9uY2lsZWRfcmV0dXJucxgFIAEoBVITdW5yZWNvbmNpbGVkUmV0dXJucxJACgpzaG9ydGZhbGxz'
    'GAYgAygLMiAuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlNob3J0ZmFsbFIKc2hvcnRmYWxscxJBCg'
    'xwYXJfaW5fZm9yY2UYByABKAsyHy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuUGFyTGV2ZWxSCnBh'
    'ckluRm9yY2USFQoGbm9fcGFyGAggASgIUgVub1BhchIcCgl0cnVuY2F0ZWQYCSABKAhSCXRydW'
    '5jYXRlZA==');

@$core.Deprecated('Use reportLinenLossRequestDescriptor instead')
const ReportLinenLossRequest$json = {
  '1': 'ReportLinenLossRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LossKind',
      '10': 'kind'
    },
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReportLinenLossRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportLinenLossRequestDescriptor = $convert.base64Decode(
    'ChZSZXBvcnRMaW5lbkxvc3NSZXF1ZXN0EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBIfCgtmYW'
    'NpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBIbCglpdGVtX2NvZGUYAyABKAlSCGl0ZW1Db2Rl'
    'EhoKCHF1YW50aXR5GAQgASgFUghxdWFudGl0eRIzCgRraW5kGAUgASgOMh8uaGVhbHRoY2FyZS'
    '5sYXVuZHJ5LnYxLkxvc3NLaW5kUgRraW5kEhYKBnJlYXNvbhgGIAEoCVIGcmVhc29u');

@$core.Deprecated('Use reportLinenLossResponseDescriptor instead')
const ReportLinenLossResponse$json = {
  '1': 'ReportLinenLossResponse',
  '2': [
    {
      '1': 'loss',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LossRecord',
      '10': 'loss'
    },
  ],
};

/// Descriptor for `ReportLinenLossResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportLinenLossResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXBvcnRMaW5lbkxvc3NSZXNwb25zZRI1CgRsb3NzGAEgASgLMiEuaGVhbHRoY2FyZS5sYX'
        'VuZHJ5LnYxLkxvc3NSZWNvcmRSBGxvc3M=');

@$core.Deprecated('Use approveLinenLossRequestDescriptor instead')
const ApproveLinenLossRequest$json = {
  '1': 'ApproveLinenLossRequest',
  '2': [
    {'1': 'loss_id', '3': 1, '4': 1, '5': 9, '10': 'lossId'},
    {'1': 'approve', '3': 2, '4': 1, '5': 8, '10': 'approve'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ApproveLinenLossRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLinenLossRequestDescriptor =
    $convert.base64Decode(
        'ChdBcHByb3ZlTGluZW5Mb3NzUmVxdWVzdBIXCgdsb3NzX2lkGAEgASgJUgZsb3NzSWQSGAoHYX'
        'Bwcm92ZRgCIAEoCFIHYXBwcm92ZRISCgRub3RlGAMgASgJUgRub3Rl');

@$core.Deprecated('Use approveLinenLossResponseDescriptor instead')
const ApproveLinenLossResponse$json = {
  '1': 'ApproveLinenLossResponse',
  '2': [
    {
      '1': 'loss',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LossRecord',
      '10': 'loss'
    },
  ],
};

/// Descriptor for `ApproveLinenLossResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLinenLossResponseDescriptor =
    $convert.base64Decode(
        'ChhBcHByb3ZlTGluZW5Mb3NzUmVzcG9uc2USNQoEbG9zcxgBIAEoCzIhLmhlYWx0aGNhcmUubG'
        'F1bmRyeS52MS5Mb3NzUmVjb3JkUgRsb3Nz');

@$core.Deprecated('Use recoverLinenLossRequestDescriptor instead')
const RecoverLinenLossRequest$json = {
  '1': 'RecoverLinenLossRequest',
  '2': [
    {'1': 'loss_id', '3': 1, '4': 1, '5': 9, '10': 'lossId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecoverLinenLossRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recoverLinenLossRequestDescriptor =
    $convert.base64Decode(
        'ChdSZWNvdmVyTGluZW5Mb3NzUmVxdWVzdBIXCgdsb3NzX2lkGAEgASgJUgZsb3NzSWQSEgoEbm'
        '90ZRgCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use recoverLinenLossResponseDescriptor instead')
const RecoverLinenLossResponse$json = {
  '1': 'RecoverLinenLossResponse',
  '2': [
    {
      '1': 'loss',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LossRecord',
      '10': 'loss'
    },
  ],
};

/// Descriptor for `RecoverLinenLossResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recoverLinenLossResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvdmVyTGluZW5Mb3NzUmVzcG9uc2USNQoEbG9zcxgBIAEoCzIhLmhlYWx0aGNhcmUubG'
        'F1bmRyeS52MS5Mb3NzUmVjb3JkUgRsb3Nz');

@$core.Deprecated('Use listLinenLossesRequestDescriptor instead')
const ListLinenLossesRequest$json = {
  '1': 'ListLinenLossesRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.LossKind',
      '10': 'kind'
    },
    {
      '1': 'states',
      '3': 5,
      '4': 3,
      '5': 14,
      '6': '.healthcare.laundry.v1.LossState',
      '10': 'states'
    },
    {
      '1': 'from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 8, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 9, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListLinenLossesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLinenLossesRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0TGluZW5Mb3NzZXNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eU'
    'lkEhcKB3VuaXRfaWQYAiABKAlSBnVuaXRJZBIbCglpdGVtX2NvZGUYAyABKAlSCGl0ZW1Db2Rl'
    'EjMKBGtpbmQYBCABKA4yHy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTG9zc0tpbmRSBGtpbmQSOA'
    'oGc3RhdGVzGAUgAygOMiAuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkxvc3NTdGF0ZVIGc3RhdGVz'
    'Ei4KBGZyb20YBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGA'
    'cgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8SGwoJcGFnZV9zaXplGAggASgF'
    'UghwYWdlU2l6ZRIWCgZvZmZzZXQYCSABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listLinenLossesResponseDescriptor instead')
const ListLinenLossesResponse$json = {
  '1': 'ListLinenLossesResponse',
  '2': [
    {
      '1': 'losses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.LossRecord',
      '10': 'losses'
    },
  ],
};

/// Descriptor for `ListLinenLossesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLinenLossesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0TGluZW5Mb3NzZXNSZXNwb25zZRI5CgZsb3NzZXMYASADKAsyIS5oZWFsdGhjYXJlLm'
        'xhdW5kcnkudjEuTG9zc1JlY29yZFIGbG9zc2Vz');

@$core.Deprecated('Use listPendingLossApprovalsRequestDescriptor instead')
const ListPendingLossApprovalsRequest$json = {
  '1': 'ListPendingLossApprovalsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `ListPendingLossApprovalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPendingLossApprovalsRequestDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0UGVuZGluZ0xvc3NBcHByb3ZhbHNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUg'
        'pmYWNpbGl0eUlk');

@$core.Deprecated('Use listPendingLossApprovalsResponseDescriptor instead')
const ListPendingLossApprovalsResponse$json = {
  '1': 'ListPendingLossApprovalsResponse',
  '2': [
    {
      '1': 'losses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.LossRecord',
      '10': 'losses'
    },
  ],
};

/// Descriptor for `ListPendingLossApprovalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPendingLossApprovalsResponseDescriptor =
    $convert.base64Decode(
        'CiBMaXN0UGVuZGluZ0xvc3NBcHByb3ZhbHNSZXNwb25zZRI5CgZsb3NzZXMYASADKAsyIS5oZW'
        'FsdGhjYXJlLmxhdW5kcnkudjEuTG9zc1JlY29yZFIGbG9zc2Vz');

@$core.Deprecated('Use registerTagRequestDescriptor instead')
const RegisterTagRequest$json = {
  '1': 'RegisterTagRequest',
  '2': [
    {'1': 'tag_id', '3': 1, '4': 1, '5': 9, '10': 'tagId'},
    {
      '1': 'tag_kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.laundry.v1.TagKind',
      '10': 'tagKind'
    },
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'assigned_to', '3': 4, '4': 1, '5': 9, '10': 'assignedTo'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `RegisterTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerTagRequestDescriptor = $convert.base64Decode(
    'ChJSZWdpc3RlclRhZ1JlcXVlc3QSFQoGdGFnX2lkGAEgASgJUgV0YWdJZBI5Cgh0YWdfa2luZB'
    'gCIAEoDjIeLmhlYWx0aGNhcmUubGF1bmRyeS52MS5UYWdLaW5kUgd0YWdLaW5kEhsKCWl0ZW1f'
    'Y29kZRgDIAEoCVIIaXRlbUNvZGUSHwoLYXNzaWduZWRfdG8YBCABKAlSCmFzc2lnbmVkVG8SHw'
    'oLZmFjaWxpdHlfaWQYBSABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use registerTagResponseDescriptor instead')
const RegisterTagResponse$json = {
  '1': 'RegisterTagResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RegisterTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerTagResponseDescriptor = $convert.base64Decode(
    'ChNSZWdpc3RlclRhZ1Jlc3BvbnNlEjYKBGl0ZW0YASABKAsyIi5oZWFsdGhjYXJlLmxhdW5kcn'
    'kudjEuVHJhY2tlZEl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use recordTagScanRequestDescriptor instead')
const RecordTagScanRequest$json = {
  '1': 'RecordTagScanRequest',
  '2': [
    {'1': 'tag_id', '3': 1, '4': 1, '5': 9, '10': 'tagId'},
    {'1': 'location', '3': 2, '4': 1, '5': 9, '10': 'location'},
    {'1': 'holder_id', '3': 3, '4': 1, '5': 9, '10': 'holderId'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordTagScanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordTagScanRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRUYWdTY2FuUmVxdWVzdBIVCgZ0YWdfaWQYASABKAlSBXRhZ0lkEhoKCGxvY2F0aW'
    '9uGAIgASgJUghsb2NhdGlvbhIbCglob2xkZXJfaWQYAyABKAlSCGhvbGRlcklkEhIKBG5vdGUY'
    'BCABKAlSBG5vdGU=');

@$core.Deprecated('Use recordTagScanResponseDescriptor instead')
const RecordTagScanResponse$json = {
  '1': 'RecordTagScanResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RecordTagScanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordTagScanResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRUYWdTY2FuUmVzcG9uc2USNgoEaXRlbRgBIAEoCzIiLmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5UcmFja2VkSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use retireTagRequestDescriptor instead')
const RetireTagRequest$json = {
  '1': 'RetireTagRequest',
  '2': [
    {'1': 'tracked_id', '3': 1, '4': 1, '5': 9, '10': 'trackedId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RetireTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireTagRequestDescriptor = $convert.base64Decode(
    'ChBSZXRpcmVUYWdSZXF1ZXN0Eh0KCnRyYWNrZWRfaWQYASABKAlSCXRyYWNrZWRJZBIWCgZyZW'
    'Fzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use retireTagResponseDescriptor instead')
const RetireTagResponse$json = {
  '1': 'RetireTagResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RetireTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireTagResponseDescriptor = $convert.base64Decode(
    'ChFSZXRpcmVUYWdSZXNwb25zZRI2CgRpdGVtGAEgASgLMiIuaGVhbHRoY2FyZS5sYXVuZHJ5Ln'
    'YxLlRyYWNrZWRJdGVtUgRpdGVt');

@$core.Deprecated('Use getTagCustodyRequestDescriptor instead')
const GetTagCustodyRequest$json = {
  '1': 'GetTagCustodyRequest',
  '2': [
    {'1': 'tag_id', '3': 1, '4': 1, '5': 9, '10': 'tagId'},
  ],
};

/// Descriptor for `GetTagCustodyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTagCustodyRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRUYWdDdXN0b2R5UmVxdWVzdBIVCgZ0YWdfaWQYASABKAlSBXRhZ0lk');

@$core.Deprecated('Use getTagCustodyResponseDescriptor instead')
const GetTagCustodyResponse$json = {
  '1': 'GetTagCustodyResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedItem',
      '10': 'item'
    },
    {
      '1': 'custody',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.Custody',
      '10': 'custody'
    },
  ],
};

/// Descriptor for `GetTagCustodyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTagCustodyResponseDescriptor = $convert.base64Decode(
    'ChVHZXRUYWdDdXN0b2R5UmVzcG9uc2USNgoEaXRlbRgBIAEoCzIiLmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5UcmFja2VkSXRlbVIEaXRlbRI4CgdjdXN0b2R5GAIgASgLMh4uaGVhbHRoY2FyZS5s'
    'YXVuZHJ5LnYxLkN1c3RvZHlSB2N1c3RvZHk=');

@$core.Deprecated('Use listTrackedItemsRequestDescriptor instead')
const ListTrackedItemsRequest$json = {
  '1': 'ListTrackedItemsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'item_code', '3': 2, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'assigned_to', '3': 3, '4': 1, '5': 9, '10': 'assignedTo'},
    {'1': 'in_service_only', '3': 4, '4': 1, '5': 8, '10': 'inServiceOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 6, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListTrackedItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTrackedItemsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0VHJhY2tlZEl0ZW1zUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
    'lJZBIbCglpdGVtX2NvZGUYAiABKAlSCGl0ZW1Db2RlEh8KC2Fzc2lnbmVkX3RvGAMgASgJUgph'
    'c3NpZ25lZFRvEiYKD2luX3NlcnZpY2Vfb25seRgEIAEoCFINaW5TZXJ2aWNlT25seRIbCglwYW'
    'dlX3NpemUYBSABKAVSCHBhZ2VTaXplEhYKBm9mZnNldBgGIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listTrackedItemsResponseDescriptor instead')
const ListTrackedItemsResponse$json = {
  '1': 'ListTrackedItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListTrackedItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTrackedItemsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0VHJhY2tlZEl0ZW1zUmVzcG9uc2USOAoFaXRlbXMYASADKAsyIi5oZWFsdGhjYXJlLm'
        'xhdW5kcnkudjEuVHJhY2tlZEl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use staleTrackedItemDescriptor instead')
const StaleTrackedItem$json = {
  '1': 'StaleTrackedItem',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.TrackedItem',
      '10': 'item'
    },
    {
      '1': 'custody',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.Custody',
      '10': 'custody'
    },
    {'1': 'quiet_days', '3': 3, '4': 1, '5': 5, '10': 'quietDays'},
    {'1': 'never_seen', '3': 4, '4': 1, '5': 8, '10': 'neverSeen'},
  ],
};

/// Descriptor for `StaleTrackedItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List staleTrackedItemDescriptor = $convert.base64Decode(
    'ChBTdGFsZVRyYWNrZWRJdGVtEjYKBGl0ZW0YASABKAsyIi5oZWFsdGhjYXJlLmxhdW5kcnkudj'
    'EuVHJhY2tlZEl0ZW1SBGl0ZW0SOAoHY3VzdG9keRgCIAEoCzIeLmhlYWx0aGNhcmUubGF1bmRy'
    'eS52MS5DdXN0b2R5UgdjdXN0b2R5Eh0KCnF1aWV0X2RheXMYAyABKAVSCXF1aWV0RGF5cxIdCg'
    'puZXZlcl9zZWVuGAQgASgIUgluZXZlclNlZW4=');

@$core.Deprecated('Use listStaleTrackedItemsRequestDescriptor instead')
const ListStaleTrackedItemsRequest$json = {
  '1': 'ListStaleTrackedItemsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `ListStaleTrackedItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStaleTrackedItemsRequestDescriptor =
    $convert.base64Decode(
        'ChxMaXN0U3RhbGVUcmFja2VkSXRlbXNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYW'
        'NpbGl0eUlk');

@$core.Deprecated('Use listStaleTrackedItemsResponseDescriptor instead')
const ListStaleTrackedItemsResponse$json = {
  '1': 'ListStaleTrackedItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.laundry.v1.StaleTrackedItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListStaleTrackedItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStaleTrackedItemsResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0U3RhbGVUcmFja2VkSXRlbXNSZXNwb25zZRI9CgVpdGVtcxgBIAMoCzInLmhlYWx0aG'
        'NhcmUubGF1bmRyeS52MS5TdGFsZVRyYWNrZWRJdGVtUgVpdGVtcw==');

@$core.Deprecated('Use washSummaryDescriptor instead')
const WashSummary$json = {
  '1': 'WashSummary',
  '2': [
    {'1': 'run', '3': 1, '4': 1, '5': 5, '10': 'run'},
    {'1': 'passed', '3': 2, '4': 1, '5': 5, '10': 'passed'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
    {'1': 'rewashed', '3': 4, '4': 1, '5': 5, '10': 'rewashed'},
    {'1': 'in_flight', '3': 5, '4': 1, '5': 5, '10': 'inFlight'},
    {'1': 'infected', '3': 6, '4': 1, '5': 5, '10': 'infected'},
    {'1': 'weight_kg', '3': 7, '4': 1, '5': 5, '10': 'weightKg'},
    {'1': 'with_exceptions', '3': 8, '4': 1, '5': 5, '10': 'withExceptions'},
    {'1': 'unanswerable', '3': 9, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `WashSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List washSummaryDescriptor = $convert.base64Decode(
    'CgtXYXNoU3VtbWFyeRIQCgNydW4YASABKAVSA3J1bhIWCgZwYXNzZWQYAiABKAVSBnBhc3NlZB'
    'IWCgZmYWlsZWQYAyABKAVSBmZhaWxlZBIaCghyZXdhc2hlZBgEIAEoBVIIcmV3YXNoZWQSGwoJ'
    'aW5fZmxpZ2h0GAUgASgFUghpbkZsaWdodBIaCghpbmZlY3RlZBgGIAEoBVIIaW5mZWN0ZWQSGw'
    'oJd2VpZ2h0X2tnGAcgASgFUgh3ZWlnaHRLZxInCg93aXRoX2V4Y2VwdGlvbnMYCCABKAVSDndp'
    'dGhFeGNlcHRpb25zEiIKDHVuYW5zd2VyYWJsZRgJIAEoCFIMdW5hbnN3ZXJhYmxl');

@$core.Deprecated('Use getWashReportRequestDescriptor instead')
const GetWashReportRequest$json = {
  '1': 'GetWashReportRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `GetWashReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWashReportRequestDescriptor = $convert.base64Decode(
    'ChRHZXRXYXNoUmVwb3J0UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZB'
    'IuCgRmcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgD'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRv');

@$core.Deprecated('Use getWashReportResponseDescriptor instead')
const GetWashReportResponse$json = {
  '1': 'GetWashReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.WashSummary',
      '10': 'summary'
    },
    {'1': 'truncated', '3': 2, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetWashReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWashReportResponseDescriptor = $convert.base64Decode(
    'ChVHZXRXYXNoUmVwb3J0UmVzcG9uc2USPAoHc3VtbWFyeRgBIAEoCzIiLmhlYWx0aGNhcmUubG'
    'F1bmRyeS52MS5XYXNoU3VtbWFyeVIHc3VtbWFyeRIcCgl0cnVuY2F0ZWQYAiABKAhSCXRydW5j'
    'YXRlZA==');

@$core.Deprecated('Use linenLossSummaryDescriptor instead')
const LinenLossSummary$json = {
  '1': 'LinenLossSummary',
  '2': [
    {'1': 'reported', '3': 1, '4': 1, '5': 5, '10': 'reported'},
    {'1': 'pieces', '3': 2, '4': 1, '5': 5, '10': 'pieces'},
    {'1': 'value_minor', '3': 3, '4': 1, '5': 5, '10': 'valueMinor'},
    {'1': 'condemned', '3': 4, '4': 1, '5': 5, '10': 'condemned'},
    {'1': 'damaged', '3': 5, '4': 1, '5': 5, '10': 'damaged'},
    {'1': 'missing', '3': 6, '4': 1, '5': 5, '10': 'missing'},
    {'1': 'recovered', '3': 7, '4': 1, '5': 5, '10': 'recovered'},
    {
      '1': 'awaiting_approval',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'awaitingApproval'
    },
    {'1': 'rejected', '3': 9, '4': 1, '5': 5, '10': 'rejected'},
  ],
};

/// Descriptor for `LinenLossSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linenLossSummaryDescriptor = $convert.base64Decode(
    'ChBMaW5lbkxvc3NTdW1tYXJ5EhoKCHJlcG9ydGVkGAEgASgFUghyZXBvcnRlZBIWCgZwaWVjZX'
    'MYAiABKAVSBnBpZWNlcxIfCgt2YWx1ZV9taW5vchgDIAEoBVIKdmFsdWVNaW5vchIcCgljb25k'
    'ZW1uZWQYBCABKAVSCWNvbmRlbW5lZBIYCgdkYW1hZ2VkGAUgASgFUgdkYW1hZ2VkEhgKB21pc3'
    'NpbmcYBiABKAVSB21pc3NpbmcSHAoJcmVjb3ZlcmVkGAcgASgFUglyZWNvdmVyZWQSKwoRYXdh'
    'aXRpbmdfYXBwcm92YWwYCCABKAVSEGF3YWl0aW5nQXBwcm92YWwSGgoIcmVqZWN0ZWQYCSABKA'
    'VSCHJlamVjdGVk');

@$core.Deprecated('Use getLinenLossReportRequestDescriptor instead')
const GetLinenLossReportRequest$json = {
  '1': 'GetLinenLossReportRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `GetLinenLossReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLinenLossReportRequestDescriptor = $convert.base64Decode(
    'ChlHZXRMaW5lbkxvc3NSZXBvcnRSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbG'
    'l0eUlkEi4KBGZyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioK'
    'AnRvGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getLinenLossReportResponseDescriptor instead')
const GetLinenLossReportResponse$json = {
  '1': 'GetLinenLossReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.laundry.v1.LinenLossSummary',
      '10': 'summary'
    },
    {'1': 'truncated', '3': 2, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetLinenLossReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLinenLossReportResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRMaW5lbkxvc3NSZXBvcnRSZXNwb25zZRJBCgdzdW1tYXJ5GAEgASgLMicuaGVhbHRoY2'
        'FyZS5sYXVuZHJ5LnYxLkxpbmVuTG9zc1N1bW1hcnlSB3N1bW1hcnkSHAoJdHJ1bmNhdGVkGAIg'
        'ASgIUgl0cnVuY2F0ZWQ=');

const $core.Map<$core.String, $core.dynamic> LaundryServiceBase$json = {
  '1': 'LaundryService',
  '2': [
    {
      '1': 'ConfigureLinenItem',
      '2': '.healthcare.laundry.v1.ConfigureLinenItemRequest',
      '3': '.healthcare.laundry.v1.ConfigureLinenItemResponse'
    },
    {
      '1': 'RetireLinenItem',
      '2': '.healthcare.laundry.v1.RetireLinenItemRequest',
      '3': '.healthcare.laundry.v1.RetireLinenItemResponse'
    },
    {
      '1': 'ListLinenItems',
      '2': '.healthcare.laundry.v1.ListLinenItemsRequest',
      '3': '.healthcare.laundry.v1.ListLinenItemsResponse'
    },
    {
      '1': 'SetParLevel',
      '2': '.healthcare.laundry.v1.SetParLevelRequest',
      '3': '.healthcare.laundry.v1.SetParLevelResponse'
    },
    {
      '1': 'ApproveParLevel',
      '2': '.healthcare.laundry.v1.ApproveParLevelRequest',
      '3': '.healthcare.laundry.v1.ApproveParLevelResponse'
    },
    {
      '1': 'GetParInForce',
      '2': '.healthcare.laundry.v1.GetParInForceRequest',
      '3': '.healthcare.laundry.v1.GetParInForceResponse'
    },
    {
      '1': 'ListParLevels',
      '2': '.healthcare.laundry.v1.ListParLevelsRequest',
      '3': '.healthcare.laundry.v1.ListParLevelsResponse'
    },
    {
      '1': 'RecordCollection',
      '2': '.healthcare.laundry.v1.RecordCollectionRequest',
      '3': '.healthcare.laundry.v1.RecordCollectionResponse'
    },
    {
      '1': 'RecountCollection',
      '2': '.healthcare.laundry.v1.RecountCollectionRequest',
      '3': '.healthcare.laundry.v1.RecountCollectionResponse'
    },
    {
      '1': 'CancelCollection',
      '2': '.healthcare.laundry.v1.CancelCollectionRequest',
      '3': '.healthcare.laundry.v1.CancelCollectionResponse'
    },
    {
      '1': 'ListCollections',
      '2': '.healthcare.laundry.v1.ListCollectionsRequest',
      '3': '.healthcare.laundry.v1.ListCollectionsResponse'
    },
    {
      '1': 'CheckCollectionWeight',
      '2': '.healthcare.laundry.v1.CheckCollectionWeightRequest',
      '3': '.healthcare.laundry.v1.CheckCollectionWeightResponse'
    },
    {
      '1': 'OpenWashBatch',
      '2': '.healthcare.laundry.v1.OpenWashBatchRequest',
      '3': '.healthcare.laundry.v1.OpenWashBatchResponse'
    },
    {
      '1': 'LoadWashBatch',
      '2': '.healthcare.laundry.v1.LoadWashBatchRequest',
      '3': '.healthcare.laundry.v1.LoadWashBatchResponse'
    },
    {
      '1': 'StartWashBatch',
      '2': '.healthcare.laundry.v1.StartWashBatchRequest',
      '3': '.healthcare.laundry.v1.StartWashBatchResponse'
    },
    {
      '1': 'CompleteWashBatch',
      '2': '.healthcare.laundry.v1.CompleteWashBatchRequest',
      '3': '.healthcare.laundry.v1.CompleteWashBatchResponse'
    },
    {
      '1': 'RewashBatch',
      '2': '.healthcare.laundry.v1.RewashBatchRequest',
      '3': '.healthcare.laundry.v1.RewashBatchResponse'
    },
    {
      '1': 'GetWashBatch',
      '2': '.healthcare.laundry.v1.GetWashBatchRequest',
      '3': '.healthcare.laundry.v1.GetWashBatchResponse'
    },
    {
      '1': 'ListWashBatches',
      '2': '.healthcare.laundry.v1.ListWashBatchesRequest',
      '3': '.healthcare.laundry.v1.ListWashBatchesResponse'
    },
    {
      '1': 'ListAffectedUnits',
      '2': '.healthcare.laundry.v1.ListAffectedUnitsRequest',
      '3': '.healthcare.laundry.v1.ListAffectedUnitsResponse'
    },
    {
      '1': 'IssueLinen',
      '2': '.healthcare.laundry.v1.IssueLinenRequest',
      '3': '.healthcare.laundry.v1.IssueLinenResponse'
    },
    {
      '1': 'ReceiveLinen',
      '2': '.healthcare.laundry.v1.ReceiveLinenRequest',
      '3': '.healthcare.laundry.v1.ReceiveLinenResponse'
    },
    {
      '1': 'ListLinenIssues',
      '2': '.healthcare.laundry.v1.ListLinenIssuesRequest',
      '3': '.healthcare.laundry.v1.ListLinenIssuesResponse'
    },
    {
      '1': 'GetUnitStock',
      '2': '.healthcare.laundry.v1.GetUnitStockRequest',
      '3': '.healthcare.laundry.v1.GetUnitStockResponse'
    },
    {
      '1': 'ReportLinenLoss',
      '2': '.healthcare.laundry.v1.ReportLinenLossRequest',
      '3': '.healthcare.laundry.v1.ReportLinenLossResponse'
    },
    {
      '1': 'ApproveLinenLoss',
      '2': '.healthcare.laundry.v1.ApproveLinenLossRequest',
      '3': '.healthcare.laundry.v1.ApproveLinenLossResponse'
    },
    {
      '1': 'RecoverLinenLoss',
      '2': '.healthcare.laundry.v1.RecoverLinenLossRequest',
      '3': '.healthcare.laundry.v1.RecoverLinenLossResponse'
    },
    {
      '1': 'ListLinenLosses',
      '2': '.healthcare.laundry.v1.ListLinenLossesRequest',
      '3': '.healthcare.laundry.v1.ListLinenLossesResponse'
    },
    {
      '1': 'ListPendingLossApprovals',
      '2': '.healthcare.laundry.v1.ListPendingLossApprovalsRequest',
      '3': '.healthcare.laundry.v1.ListPendingLossApprovalsResponse'
    },
    {
      '1': 'RegisterTag',
      '2': '.healthcare.laundry.v1.RegisterTagRequest',
      '3': '.healthcare.laundry.v1.RegisterTagResponse'
    },
    {
      '1': 'RecordTagScan',
      '2': '.healthcare.laundry.v1.RecordTagScanRequest',
      '3': '.healthcare.laundry.v1.RecordTagScanResponse'
    },
    {
      '1': 'RetireTag',
      '2': '.healthcare.laundry.v1.RetireTagRequest',
      '3': '.healthcare.laundry.v1.RetireTagResponse'
    },
    {
      '1': 'GetTagCustody',
      '2': '.healthcare.laundry.v1.GetTagCustodyRequest',
      '3': '.healthcare.laundry.v1.GetTagCustodyResponse'
    },
    {
      '1': 'ListTrackedItems',
      '2': '.healthcare.laundry.v1.ListTrackedItemsRequest',
      '3': '.healthcare.laundry.v1.ListTrackedItemsResponse'
    },
    {
      '1': 'ListStaleTrackedItems',
      '2': '.healthcare.laundry.v1.ListStaleTrackedItemsRequest',
      '3': '.healthcare.laundry.v1.ListStaleTrackedItemsResponse'
    },
    {
      '1': 'GetWashReport',
      '2': '.healthcare.laundry.v1.GetWashReportRequest',
      '3': '.healthcare.laundry.v1.GetWashReportResponse'
    },
    {
      '1': 'GetLinenLossReport',
      '2': '.healthcare.laundry.v1.GetLinenLossReportRequest',
      '3': '.healthcare.laundry.v1.GetLinenLossReportResponse'
    },
  ],
};

@$core.Deprecated('Use laundryServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    LaundryServiceBase$messageJson = {
  '.healthcare.laundry.v1.ConfigureLinenItemRequest':
      ConfigureLinenItemRequest$json,
  '.healthcare.laundry.v1.ConfigureLinenItemResponse':
      ConfigureLinenItemResponse$json,
  '.healthcare.laundry.v1.LinenItem': LinenItem$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.laundry.v1.RetireLinenItemRequest': RetireLinenItemRequest$json,
  '.healthcare.laundry.v1.RetireLinenItemResponse':
      RetireLinenItemResponse$json,
  '.healthcare.laundry.v1.ListLinenItemsRequest': ListLinenItemsRequest$json,
  '.healthcare.laundry.v1.ListLinenItemsResponse': ListLinenItemsResponse$json,
  '.healthcare.laundry.v1.SetParLevelRequest': SetParLevelRequest$json,
  '.healthcare.laundry.v1.ParLine': ParLine$json,
  '.healthcare.laundry.v1.SetParLevelResponse': SetParLevelResponse$json,
  '.healthcare.laundry.v1.ParLevel': ParLevel$json,
  '.healthcare.laundry.v1.ApproveParLevelRequest': ApproveParLevelRequest$json,
  '.healthcare.laundry.v1.ApproveParLevelResponse':
      ApproveParLevelResponse$json,
  '.healthcare.laundry.v1.GetParInForceRequest': GetParInForceRequest$json,
  '.healthcare.laundry.v1.GetParInForceResponse': GetParInForceResponse$json,
  '.healthcare.laundry.v1.ListParLevelsRequest': ListParLevelsRequest$json,
  '.healthcare.laundry.v1.ListParLevelsResponse': ListParLevelsResponse$json,
  '.healthcare.laundry.v1.RecordCollectionRequest':
      RecordCollectionRequest$json,
  '.healthcare.laundry.v1.CollectionLine': CollectionLine$json,
  '.healthcare.laundry.v1.RecordCollectionResponse':
      RecordCollectionResponse$json,
  '.healthcare.laundry.v1.LinenCollection': LinenCollection$json,
  '.healthcare.laundry.v1.RecountCollectionRequest':
      RecountCollectionRequest$json,
  '.healthcare.laundry.v1.RecountCollectionResponse':
      RecountCollectionResponse$json,
  '.healthcare.laundry.v1.CancelCollectionRequest':
      CancelCollectionRequest$json,
  '.healthcare.laundry.v1.CancelCollectionResponse':
      CancelCollectionResponse$json,
  '.healthcare.laundry.v1.ListCollectionsRequest': ListCollectionsRequest$json,
  '.healthcare.laundry.v1.ListCollectionsResponse':
      ListCollectionsResponse$json,
  '.healthcare.laundry.v1.CheckCollectionWeightRequest':
      CheckCollectionWeightRequest$json,
  '.healthcare.laundry.v1.CheckCollectionWeightResponse':
      CheckCollectionWeightResponse$json,
  '.healthcare.laundry.v1.OpenWashBatchRequest': OpenWashBatchRequest$json,
  '.healthcare.laundry.v1.OpenWashBatchResponse': OpenWashBatchResponse$json,
  '.healthcare.laundry.v1.WashBatch': WashBatch$json,
  '.healthcare.laundry.v1.BatchException': BatchException$json,
  '.healthcare.laundry.v1.LoadWashBatchRequest': LoadWashBatchRequest$json,
  '.healthcare.laundry.v1.LoadWashBatchResponse': LoadWashBatchResponse$json,
  '.healthcare.laundry.v1.StartWashBatchRequest': StartWashBatchRequest$json,
  '.healthcare.laundry.v1.StartWashBatchResponse': StartWashBatchResponse$json,
  '.healthcare.laundry.v1.CompleteWashBatchRequest':
      CompleteWashBatchRequest$json,
  '.healthcare.laundry.v1.CompleteWashBatchResponse':
      CompleteWashBatchResponse$json,
  '.healthcare.laundry.v1.RewashBatchRequest': RewashBatchRequest$json,
  '.healthcare.laundry.v1.RewashBatchResponse': RewashBatchResponse$json,
  '.healthcare.laundry.v1.GetWashBatchRequest': GetWashBatchRequest$json,
  '.healthcare.laundry.v1.GetWashBatchResponse': GetWashBatchResponse$json,
  '.healthcare.laundry.v1.ListWashBatchesRequest': ListWashBatchesRequest$json,
  '.healthcare.laundry.v1.ListWashBatchesResponse':
      ListWashBatchesResponse$json,
  '.healthcare.laundry.v1.ListAffectedUnitsRequest':
      ListAffectedUnitsRequest$json,
  '.healthcare.laundry.v1.ListAffectedUnitsResponse':
      ListAffectedUnitsResponse$json,
  '.healthcare.laundry.v1.IssueLinenRequest': IssueLinenRequest$json,
  '.healthcare.laundry.v1.IssueLine': IssueLine$json,
  '.healthcare.laundry.v1.IssueLinenResponse': IssueLinenResponse$json,
  '.healthcare.laundry.v1.LinenIssue': LinenIssue$json,
  '.healthcare.laundry.v1.ReceiveLinenRequest': ReceiveLinenRequest$json,
  '.healthcare.laundry.v1.ReceiveLinenResponse': ReceiveLinenResponse$json,
  '.healthcare.laundry.v1.ListLinenIssuesRequest': ListLinenIssuesRequest$json,
  '.healthcare.laundry.v1.ListLinenIssuesResponse':
      ListLinenIssuesResponse$json,
  '.healthcare.laundry.v1.GetUnitStockRequest': GetUnitStockRequest$json,
  '.healthcare.laundry.v1.GetUnitStockResponse': GetUnitStockResponse$json,
  '.healthcare.laundry.v1.ItemCount': ItemCount$json,
  '.healthcare.laundry.v1.Shortfall': Shortfall$json,
  '.healthcare.laundry.v1.ReportLinenLossRequest': ReportLinenLossRequest$json,
  '.healthcare.laundry.v1.ReportLinenLossResponse':
      ReportLinenLossResponse$json,
  '.healthcare.laundry.v1.LossRecord': LossRecord$json,
  '.healthcare.laundry.v1.ApproveLinenLossRequest':
      ApproveLinenLossRequest$json,
  '.healthcare.laundry.v1.ApproveLinenLossResponse':
      ApproveLinenLossResponse$json,
  '.healthcare.laundry.v1.RecoverLinenLossRequest':
      RecoverLinenLossRequest$json,
  '.healthcare.laundry.v1.RecoverLinenLossResponse':
      RecoverLinenLossResponse$json,
  '.healthcare.laundry.v1.ListLinenLossesRequest': ListLinenLossesRequest$json,
  '.healthcare.laundry.v1.ListLinenLossesResponse':
      ListLinenLossesResponse$json,
  '.healthcare.laundry.v1.ListPendingLossApprovalsRequest':
      ListPendingLossApprovalsRequest$json,
  '.healthcare.laundry.v1.ListPendingLossApprovalsResponse':
      ListPendingLossApprovalsResponse$json,
  '.healthcare.laundry.v1.RegisterTagRequest': RegisterTagRequest$json,
  '.healthcare.laundry.v1.RegisterTagResponse': RegisterTagResponse$json,
  '.healthcare.laundry.v1.TrackedItem': TrackedItem$json,
  '.healthcare.laundry.v1.TrackedMovement': TrackedMovement$json,
  '.healthcare.laundry.v1.RecordTagScanRequest': RecordTagScanRequest$json,
  '.healthcare.laundry.v1.RecordTagScanResponse': RecordTagScanResponse$json,
  '.healthcare.laundry.v1.RetireTagRequest': RetireTagRequest$json,
  '.healthcare.laundry.v1.RetireTagResponse': RetireTagResponse$json,
  '.healthcare.laundry.v1.GetTagCustodyRequest': GetTagCustodyRequest$json,
  '.healthcare.laundry.v1.GetTagCustodyResponse': GetTagCustodyResponse$json,
  '.healthcare.laundry.v1.Custody': Custody$json,
  '.healthcare.laundry.v1.ListTrackedItemsRequest':
      ListTrackedItemsRequest$json,
  '.healthcare.laundry.v1.ListTrackedItemsResponse':
      ListTrackedItemsResponse$json,
  '.healthcare.laundry.v1.ListStaleTrackedItemsRequest':
      ListStaleTrackedItemsRequest$json,
  '.healthcare.laundry.v1.ListStaleTrackedItemsResponse':
      ListStaleTrackedItemsResponse$json,
  '.healthcare.laundry.v1.StaleTrackedItem': StaleTrackedItem$json,
  '.healthcare.laundry.v1.GetWashReportRequest': GetWashReportRequest$json,
  '.healthcare.laundry.v1.GetWashReportResponse': GetWashReportResponse$json,
  '.healthcare.laundry.v1.WashSummary': WashSummary$json,
  '.healthcare.laundry.v1.GetLinenLossReportRequest':
      GetLinenLossReportRequest$json,
  '.healthcare.laundry.v1.GetLinenLossReportResponse':
      GetLinenLossReportResponse$json,
  '.healthcare.laundry.v1.LinenLossSummary': LinenLossSummary$json,
};

/// Descriptor for `LaundryService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List laundryServiceDescriptor = $convert.base64Decode(
    'Cg5MYXVuZHJ5U2VydmljZRJ5ChJDb25maWd1cmVMaW5lbkl0ZW0SMC5oZWFsdGhjYXJlLmxhdW'
    '5kcnkudjEuQ29uZmlndXJlTGluZW5JdGVtUmVxdWVzdBoxLmhlYWx0aGNhcmUubGF1bmRyeS52'
    'MS5Db25maWd1cmVMaW5lbkl0ZW1SZXNwb25zZRJwCg9SZXRpcmVMaW5lbkl0ZW0SLS5oZWFsdG'
    'hjYXJlLmxhdW5kcnkudjEuUmV0aXJlTGluZW5JdGVtUmVxdWVzdBouLmhlYWx0aGNhcmUubGF1'
    'bmRyeS52MS5SZXRpcmVMaW5lbkl0ZW1SZXNwb25zZRJtCg5MaXN0TGluZW5JdGVtcxIsLmhlYW'
    'x0aGNhcmUubGF1bmRyeS52MS5MaXN0TGluZW5JdGVtc1JlcXVlc3QaLS5oZWFsdGhjYXJlLmxh'
    'dW5kcnkudjEuTGlzdExpbmVuSXRlbXNSZXNwb25zZRJkCgtTZXRQYXJMZXZlbBIpLmhlYWx0aG'
    'NhcmUubGF1bmRyeS52MS5TZXRQYXJMZXZlbFJlcXVlc3QaKi5oZWFsdGhjYXJlLmxhdW5kcnku'
    'djEuU2V0UGFyTGV2ZWxSZXNwb25zZRJwCg9BcHByb3ZlUGFyTGV2ZWwSLS5oZWFsdGhjYXJlLm'
    'xhdW5kcnkudjEuQXBwcm92ZVBhckxldmVsUmVxdWVzdBouLmhlYWx0aGNhcmUubGF1bmRyeS52'
    'MS5BcHByb3ZlUGFyTGV2ZWxSZXNwb25zZRJqCg1HZXRQYXJJbkZvcmNlEisuaGVhbHRoY2FyZS'
    '5sYXVuZHJ5LnYxLkdldFBhckluRm9yY2VSZXF1ZXN0GiwuaGVhbHRoY2FyZS5sYXVuZHJ5LnYx'
    'LkdldFBhckluRm9yY2VSZXNwb25zZRJqCg1MaXN0UGFyTGV2ZWxzEisuaGVhbHRoY2FyZS5sYX'
    'VuZHJ5LnYxLkxpc3RQYXJMZXZlbHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkxp'
    'c3RQYXJMZXZlbHNSZXNwb25zZRJzChBSZWNvcmRDb2xsZWN0aW9uEi4uaGVhbHRoY2FyZS5sYX'
    'VuZHJ5LnYxLlJlY29yZENvbGxlY3Rpb25SZXF1ZXN0Gi8uaGVhbHRoY2FyZS5sYXVuZHJ5LnYx'
    'LlJlY29yZENvbGxlY3Rpb25SZXNwb25zZRJ2ChFSZWNvdW50Q29sbGVjdGlvbhIvLmhlYWx0aG'
    'NhcmUubGF1bmRyeS52MS5SZWNvdW50Q29sbGVjdGlvblJlcXVlc3QaMC5oZWFsdGhjYXJlLmxh'
    'dW5kcnkudjEuUmVjb3VudENvbGxlY3Rpb25SZXNwb25zZRJzChBDYW5jZWxDb2xsZWN0aW9uEi'
    '4uaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkNhbmNlbENvbGxlY3Rpb25SZXF1ZXN0Gi8uaGVhbHRo'
    'Y2FyZS5sYXVuZHJ5LnYxLkNhbmNlbENvbGxlY3Rpb25SZXNwb25zZRJwCg9MaXN0Q29sbGVjdG'
    'lvbnMSLS5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlzdENvbGxlY3Rpb25zUmVxdWVzdBouLmhl'
    'YWx0aGNhcmUubGF1bmRyeS52MS5MaXN0Q29sbGVjdGlvbnNSZXNwb25zZRKCAQoVQ2hlY2tDb2'
    'xsZWN0aW9uV2VpZ2h0EjMuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkNoZWNrQ29sbGVjdGlvbldl'
    'aWdodFJlcXVlc3QaNC5oZWFsdGhjYXJlLmxhdW5kcnkudjEuQ2hlY2tDb2xsZWN0aW9uV2VpZ2'
    'h0UmVzcG9uc2USagoNT3Blbldhc2hCYXRjaBIrLmhlYWx0aGNhcmUubGF1bmRyeS52MS5PcGVu'
    'V2FzaEJhdGNoUmVxdWVzdBosLmhlYWx0aGNhcmUubGF1bmRyeS52MS5PcGVuV2FzaEJhdGNoUm'
    'VzcG9uc2USagoNTG9hZFdhc2hCYXRjaBIrLmhlYWx0aGNhcmUubGF1bmRyeS52MS5Mb2FkV2Fz'
    'aEJhdGNoUmVxdWVzdBosLmhlYWx0aGNhcmUubGF1bmRyeS52MS5Mb2FkV2FzaEJhdGNoUmVzcG'
    '9uc2USbQoOU3RhcnRXYXNoQmF0Y2gSLC5oZWFsdGhjYXJlLmxhdW5kcnkudjEuU3RhcnRXYXNo'
    'QmF0Y2hSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlN0YXJ0V2FzaEJhdGNoUmVzcG'
    '9uc2USdgoRQ29tcGxldGVXYXNoQmF0Y2gSLy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuQ29tcGxl'
    'dGVXYXNoQmF0Y2hSZXF1ZXN0GjAuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkNvbXBsZXRlV2FzaE'
    'JhdGNoUmVzcG9uc2USZAoLUmV3YXNoQmF0Y2gSKS5oZWFsdGhjYXJlLmxhdW5kcnkudjEuUmV3'
    'YXNoQmF0Y2hSZXF1ZXN0GiouaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlJld2FzaEJhdGNoUmVzcG'
    '9uc2USZwoMR2V0V2FzaEJhdGNoEiouaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkdldFdhc2hCYXRj'
    'aFJlcXVlc3QaKy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuR2V0V2FzaEJhdGNoUmVzcG9uc2UScA'
    'oPTGlzdFdhc2hCYXRjaGVzEi0uaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkxpc3RXYXNoQmF0Y2hl'
    'c1JlcXVlc3QaLi5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlzdFdhc2hCYXRjaGVzUmVzcG9uc2'
    'USdgoRTGlzdEFmZmVjdGVkVW5pdHMSLy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlzdEFmZmVj'
    'dGVkVW5pdHNSZXF1ZXN0GjAuaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkxpc3RBZmZlY3RlZFVuaX'
    'RzUmVzcG9uc2USYQoKSXNzdWVMaW5lbhIoLmhlYWx0aGNhcmUubGF1bmRyeS52MS5Jc3N1ZUxp'
    'bmVuUmVxdWVzdBopLmhlYWx0aGNhcmUubGF1bmRyeS52MS5Jc3N1ZUxpbmVuUmVzcG9uc2USZw'
    'oMUmVjZWl2ZUxpbmVuEiouaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlJlY2VpdmVMaW5lblJlcXVl'
    'c3QaKy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuUmVjZWl2ZUxpbmVuUmVzcG9uc2UScAoPTGlzdE'
    'xpbmVuSXNzdWVzEi0uaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkxpc3RMaW5lbklzc3Vlc1JlcXVl'
    'c3QaLi5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlzdExpbmVuSXNzdWVzUmVzcG9uc2USZwoMR2'
    'V0VW5pdFN0b2NrEiouaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkdldFVuaXRTdG9ja1JlcXVlc3Qa'
    'Ky5oZWFsdGhjYXJlLmxhdW5kcnkudjEuR2V0VW5pdFN0b2NrUmVzcG9uc2UScAoPUmVwb3J0TG'
    'luZW5Mb3NzEi0uaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlJlcG9ydExpbmVuTG9zc1JlcXVlc3Qa'
    'Li5oZWFsdGhjYXJlLmxhdW5kcnkudjEuUmVwb3J0TGluZW5Mb3NzUmVzcG9uc2UScwoQQXBwcm'
    '92ZUxpbmVuTG9zcxIuLmhlYWx0aGNhcmUubGF1bmRyeS52MS5BcHByb3ZlTGluZW5Mb3NzUmVx'
    'dWVzdBovLmhlYWx0aGNhcmUubGF1bmRyeS52MS5BcHByb3ZlTGluZW5Mb3NzUmVzcG9uc2UScw'
    'oQUmVjb3ZlckxpbmVuTG9zcxIuLmhlYWx0aGNhcmUubGF1bmRyeS52MS5SZWNvdmVyTGluZW5M'
    'b3NzUmVxdWVzdBovLmhlYWx0aGNhcmUubGF1bmRyeS52MS5SZWNvdmVyTGluZW5Mb3NzUmVzcG'
    '9uc2UScAoPTGlzdExpbmVuTG9zc2VzEi0uaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkxpc3RMaW5l'
    'bkxvc3Nlc1JlcXVlc3QaLi5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlzdExpbmVuTG9zc2VzUm'
    'VzcG9uc2USiwEKGExpc3RQZW5kaW5nTG9zc0FwcHJvdmFscxI2LmhlYWx0aGNhcmUubGF1bmRy'
    'eS52MS5MaXN0UGVuZGluZ0xvc3NBcHByb3ZhbHNSZXF1ZXN0GjcuaGVhbHRoY2FyZS5sYXVuZH'
    'J5LnYxLkxpc3RQZW5kaW5nTG9zc0FwcHJvdmFsc1Jlc3BvbnNlEmQKC1JlZ2lzdGVyVGFnEiku'
    'aGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlJlZ2lzdGVyVGFnUmVxdWVzdBoqLmhlYWx0aGNhcmUubG'
    'F1bmRyeS52MS5SZWdpc3RlclRhZ1Jlc3BvbnNlEmoKDVJlY29yZFRhZ1NjYW4SKy5oZWFsdGhj'
    'YXJlLmxhdW5kcnkudjEuUmVjb3JkVGFnU2NhblJlcXVlc3QaLC5oZWFsdGhjYXJlLmxhdW5kcn'
    'kudjEuUmVjb3JkVGFnU2NhblJlc3BvbnNlEl4KCVJldGlyZVRhZxInLmhlYWx0aGNhcmUubGF1'
    'bmRyeS52MS5SZXRpcmVUYWdSZXF1ZXN0GiguaGVhbHRoY2FyZS5sYXVuZHJ5LnYxLlJldGlyZV'
    'RhZ1Jlc3BvbnNlEmoKDUdldFRhZ0N1c3RvZHkSKy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuR2V0'
    'VGFnQ3VzdG9keVJlcXVlc3QaLC5oZWFsdGhjYXJlLmxhdW5kcnkudjEuR2V0VGFnQ3VzdG9keV'
    'Jlc3BvbnNlEnMKEExpc3RUcmFja2VkSXRlbXMSLi5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlz'
    'dFRyYWNrZWRJdGVtc1JlcXVlc3QaLy5oZWFsdGhjYXJlLmxhdW5kcnkudjEuTGlzdFRyYWNrZW'
    'RJdGVtc1Jlc3BvbnNlEoIBChVMaXN0U3RhbGVUcmFja2VkSXRlbXMSMy5oZWFsdGhjYXJlLmxh'
    'dW5kcnkudjEuTGlzdFN0YWxlVHJhY2tlZEl0ZW1zUmVxdWVzdBo0LmhlYWx0aGNhcmUubGF1bm'
    'RyeS52MS5MaXN0U3RhbGVUcmFja2VkSXRlbXNSZXNwb25zZRJqCg1HZXRXYXNoUmVwb3J0Eisu'
    'aGVhbHRoY2FyZS5sYXVuZHJ5LnYxLkdldFdhc2hSZXBvcnRSZXF1ZXN0GiwuaGVhbHRoY2FyZS'
    '5sYXVuZHJ5LnYxLkdldFdhc2hSZXBvcnRSZXNwb25zZRJ5ChJHZXRMaW5lbkxvc3NSZXBvcnQS'
    'MC5oZWFsdGhjYXJlLmxhdW5kcnkudjEuR2V0TGluZW5Mb3NzUmVwb3J0UmVxdWVzdBoxLmhlYW'
    'x0aGNhcmUubGF1bmRyeS52MS5HZXRMaW5lbkxvc3NSZXBvcnRSZXNwb25zZQ==');
