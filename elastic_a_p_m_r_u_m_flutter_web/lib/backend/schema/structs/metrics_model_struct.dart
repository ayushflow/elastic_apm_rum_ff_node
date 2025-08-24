// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MetricsModelStruct extends BaseStruct {
  MetricsModelStruct({
    int? totalTickets,
    int? openTickets,
    String? avgResponseTime,
  })  : _totalTickets = totalTickets,
        _openTickets = openTickets,
        _avgResponseTime = avgResponseTime;

  // "totalTickets" field.
  int? _totalTickets;
  int get totalTickets => _totalTickets ?? 0;
  set totalTickets(int? val) => _totalTickets = val;

  void incrementTotalTickets(int amount) =>
      totalTickets = totalTickets + amount;

  bool hasTotalTickets() => _totalTickets != null;

  // "openTickets" field.
  int? _openTickets;
  int get openTickets => _openTickets ?? 0;
  set openTickets(int? val) => _openTickets = val;

  void incrementOpenTickets(int amount) => openTickets = openTickets + amount;

  bool hasOpenTickets() => _openTickets != null;

  // "avgResponseTime" field.
  String? _avgResponseTime;
  String get avgResponseTime => _avgResponseTime ?? '';
  set avgResponseTime(String? val) => _avgResponseTime = val;

  bool hasAvgResponseTime() => _avgResponseTime != null;

  static MetricsModelStruct fromMap(Map<String, dynamic> data) =>
      MetricsModelStruct(
        totalTickets: castToType<int>(data['totalTickets']),
        openTickets: castToType<int>(data['openTickets']),
        avgResponseTime: data['avgResponseTime'] as String?,
      );

  static MetricsModelStruct? maybeFromMap(dynamic data) => data is Map
      ? MetricsModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalTickets': _totalTickets,
        'openTickets': _openTickets,
        'avgResponseTime': _avgResponseTime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalTickets': serializeParam(
          _totalTickets,
          ParamType.int,
        ),
        'openTickets': serializeParam(
          _openTickets,
          ParamType.int,
        ),
        'avgResponseTime': serializeParam(
          _avgResponseTime,
          ParamType.String,
        ),
      }.withoutNulls;

  static MetricsModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      MetricsModelStruct(
        totalTickets: deserializeParam(
          data['totalTickets'],
          ParamType.int,
          false,
        ),
        openTickets: deserializeParam(
          data['openTickets'],
          ParamType.int,
          false,
        ),
        avgResponseTime: deserializeParam(
          data['avgResponseTime'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MetricsModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MetricsModelStruct &&
        totalTickets == other.totalTickets &&
        openTickets == other.openTickets &&
        avgResponseTime == other.avgResponseTime;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([totalTickets, openTickets, avgResponseTime]);
}

MetricsModelStruct createMetricsModelStruct({
  int? totalTickets,
  int? openTickets,
  String? avgResponseTime,
}) =>
    MetricsModelStruct(
      totalTickets: totalTickets,
      openTickets: openTickets,
      avgResponseTime: avgResponseTime,
    );
