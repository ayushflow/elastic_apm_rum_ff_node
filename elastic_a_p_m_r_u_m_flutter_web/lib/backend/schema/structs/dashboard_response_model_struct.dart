// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DashboardResponseModelStruct extends BaseStruct {
  DashboardResponseModelStruct({
    String? welcome,
    String? timestamp,
    MetricsModelStruct? metrics,
    String? traceId,
    String? spanId,
  })  : _welcome = welcome,
        _timestamp = timestamp,
        _metrics = metrics,
        _traceId = traceId,
        _spanId = spanId;

  // "welcome" field.
  String? _welcome;
  String get welcome => _welcome ?? '';
  set welcome(String? val) => _welcome = val;

  bool hasWelcome() => _welcome != null;

  // "timestamp" field.
  String? _timestamp;
  String get timestamp => _timestamp ?? '';
  set timestamp(String? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  // "metrics" field.
  MetricsModelStruct? _metrics;
  MetricsModelStruct get metrics => _metrics ?? MetricsModelStruct();
  set metrics(MetricsModelStruct? val) => _metrics = val;

  void updateMetrics(Function(MetricsModelStruct) updateFn) {
    updateFn(_metrics ??= MetricsModelStruct());
  }

  bool hasMetrics() => _metrics != null;

  // "traceId" field.
  String? _traceId;
  String get traceId => _traceId ?? '';
  set traceId(String? val) => _traceId = val;

  bool hasTraceId() => _traceId != null;

  // "spanId" field.
  String? _spanId;
  String get spanId => _spanId ?? '';
  set spanId(String? val) => _spanId = val;

  bool hasSpanId() => _spanId != null;

  static DashboardResponseModelStruct fromMap(Map<String, dynamic> data) =>
      DashboardResponseModelStruct(
        welcome: data['welcome'] as String?,
        timestamp: data['timestamp'] as String?,
        metrics: data['metrics'] is MetricsModelStruct
            ? data['metrics']
            : MetricsModelStruct.maybeFromMap(data['metrics']),
        traceId: data['traceId'] as String?,
        spanId: data['spanId'] as String?,
      );

  static DashboardResponseModelStruct? maybeFromMap(dynamic data) => data is Map
      ? DashboardResponseModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'welcome': _welcome,
        'timestamp': _timestamp,
        'metrics': _metrics?.toMap(),
        'traceId': _traceId,
        'spanId': _spanId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'welcome': serializeParam(
          _welcome,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.String,
        ),
        'metrics': serializeParam(
          _metrics,
          ParamType.DataStruct,
        ),
        'traceId': serializeParam(
          _traceId,
          ParamType.String,
        ),
        'spanId': serializeParam(
          _spanId,
          ParamType.String,
        ),
      }.withoutNulls;

  static DashboardResponseModelStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DashboardResponseModelStruct(
        welcome: deserializeParam(
          data['welcome'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.String,
          false,
        ),
        metrics: deserializeStructParam(
          data['metrics'],
          ParamType.DataStruct,
          false,
          structBuilder: MetricsModelStruct.fromSerializableMap,
        ),
        traceId: deserializeParam(
          data['traceId'],
          ParamType.String,
          false,
        ),
        spanId: deserializeParam(
          data['spanId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DashboardResponseModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DashboardResponseModelStruct &&
        welcome == other.welcome &&
        timestamp == other.timestamp &&
        metrics == other.metrics &&
        traceId == other.traceId &&
        spanId == other.spanId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([welcome, timestamp, metrics, traceId, spanId]);
}

DashboardResponseModelStruct createDashboardResponseModelStruct({
  String? welcome,
  String? timestamp,
  MetricsModelStruct? metrics,
  String? traceId,
  String? spanId,
}) =>
    DashboardResponseModelStruct(
      welcome: welcome,
      timestamp: timestamp,
      metrics: metrics ?? MetricsModelStruct(),
      traceId: traceId,
      spanId: spanId,
    );
