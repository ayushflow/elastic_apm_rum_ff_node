// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TicketCreationResponseModelStruct extends BaseStruct {
  TicketCreationResponseModelStruct({
    String? ticketId,
    String? status,
    String? priority,
    String? title,
    String? traceId,
    String? spanId,
  })  : _ticketId = ticketId,
        _status = status,
        _priority = priority,
        _title = title,
        _traceId = traceId,
        _spanId = spanId;

  // "ticketId" field.
  String? _ticketId;
  String get ticketId => _ticketId ?? '';
  set ticketId(String? val) => _ticketId = val;

  bool hasTicketId() => _ticketId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "priority" field.
  String? _priority;
  String get priority => _priority ?? '';
  set priority(String? val) => _priority = val;

  bool hasPriority() => _priority != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

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

  static TicketCreationResponseModelStruct fromMap(Map<String, dynamic> data) =>
      TicketCreationResponseModelStruct(
        ticketId: data['ticketId'] as String?,
        status: data['status'] as String?,
        priority: data['priority'] as String?,
        title: data['title'] as String?,
        traceId: data['traceId'] as String?,
        spanId: data['spanId'] as String?,
      );

  static TicketCreationResponseModelStruct? maybeFromMap(dynamic data) => data
          is Map
      ? TicketCreationResponseModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ticketId': _ticketId,
        'status': _status,
        'priority': _priority,
        'title': _title,
        'traceId': _traceId,
        'spanId': _spanId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ticketId': serializeParam(
          _ticketId,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'priority': serializeParam(
          _priority,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
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

  static TicketCreationResponseModelStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TicketCreationResponseModelStruct(
        ticketId: deserializeParam(
          data['ticketId'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        priority: deserializeParam(
          data['priority'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
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
  String toString() => 'TicketCreationResponseModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TicketCreationResponseModelStruct &&
        ticketId == other.ticketId &&
        status == other.status &&
        priority == other.priority &&
        title == other.title &&
        traceId == other.traceId &&
        spanId == other.spanId;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([ticketId, status, priority, title, traceId, spanId]);
}

TicketCreationResponseModelStruct createTicketCreationResponseModelStruct({
  String? ticketId,
  String? status,
  String? priority,
  String? title,
  String? traceId,
  String? spanId,
}) =>
    TicketCreationResponseModelStruct(
      ticketId: ticketId,
      status: status,
      priority: priority,
      title: title,
      traceId: traceId,
      spanId: spanId,
    );
