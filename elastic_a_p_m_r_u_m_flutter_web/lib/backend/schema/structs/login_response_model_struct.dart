// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LoginResponseModelStruct extends BaseStruct {
  LoginResponseModelStruct({
    bool? ok,
    String? token,
    String? username,
    String? traceId,
    String? spanId,
  })  : _ok = ok,
        _token = token,
        _username = username,
        _traceId = traceId,
        _spanId = spanId;

  // "ok" field.
  bool? _ok;
  bool get ok => _ok ?? false;
  set ok(bool? val) => _ok = val;

  bool hasOk() => _ok != null;

  // "token" field.
  String? _token;
  String get token => _token ?? '';
  set token(String? val) => _token = val;

  bool hasToken() => _token != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;

  bool hasUsername() => _username != null;

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

  static LoginResponseModelStruct fromMap(Map<String, dynamic> data) =>
      LoginResponseModelStruct(
        ok: data['ok'] as bool?,
        token: data['token'] as String?,
        username: data['username'] as String?,
        traceId: data['traceId'] as String?,
        spanId: data['spanId'] as String?,
      );

  static LoginResponseModelStruct? maybeFromMap(dynamic data) => data is Map
      ? LoginResponseModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ok': _ok,
        'token': _token,
        'username': _username,
        'traceId': _traceId,
        'spanId': _spanId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ok': serializeParam(
          _ok,
          ParamType.bool,
        ),
        'token': serializeParam(
          _token,
          ParamType.String,
        ),
        'username': serializeParam(
          _username,
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

  static LoginResponseModelStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      LoginResponseModelStruct(
        ok: deserializeParam(
          data['ok'],
          ParamType.bool,
          false,
        ),
        token: deserializeParam(
          data['token'],
          ParamType.String,
          false,
        ),
        username: deserializeParam(
          data['username'],
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
  String toString() => 'LoginResponseModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LoginResponseModelStruct &&
        ok == other.ok &&
        token == other.token &&
        username == other.username &&
        traceId == other.traceId &&
        spanId == other.spanId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([ok, token, username, traceId, spanId]);
}

LoginResponseModelStruct createLoginResponseModelStruct({
  bool? ok,
  String? token,
  String? username,
  String? traceId,
  String? spanId,
}) =>
    LoginResponseModelStruct(
      ok: ok,
      token: token,
      username: username,
      traceId: traceId,
      spanId: spanId,
    );
