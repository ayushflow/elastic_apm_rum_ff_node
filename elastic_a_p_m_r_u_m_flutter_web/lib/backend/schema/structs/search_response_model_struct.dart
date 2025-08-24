// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SearchResponseModelStruct extends BaseStruct {
  SearchResponseModelStruct({
    String? query,
    List<String>? results,
    int? count,
    String? traceId,
  })  : _query = query,
        _results = results,
        _count = count,
        _traceId = traceId;

  // "query" field.
  String? _query;
  String get query => _query ?? '';
  set query(String? val) => _query = val;

  bool hasQuery() => _query != null;

  // "results" field.
  List<String>? _results;
  List<String> get results => _results ?? const [];
  set results(List<String>? val) => _results = val;

  void updateResults(Function(List<String>) updateFn) {
    updateFn(_results ??= []);
  }

  bool hasResults() => _results != null;

  // "count" field.
  int? _count;
  int get count => _count ?? 0;
  set count(int? val) => _count = val;

  void incrementCount(int amount) => count = count + amount;

  bool hasCount() => _count != null;

  // "traceId" field.
  String? _traceId;
  String get traceId => _traceId ?? '';
  set traceId(String? val) => _traceId = val;

  bool hasTraceId() => _traceId != null;

  static SearchResponseModelStruct fromMap(Map<String, dynamic> data) =>
      SearchResponseModelStruct(
        query: data['query'] as String?,
        results: getDataList(data['results']),
        count: castToType<int>(data['count']),
        traceId: data['traceId'] as String?,
      );

  static SearchResponseModelStruct? maybeFromMap(dynamic data) => data is Map
      ? SearchResponseModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'query': _query,
        'results': _results,
        'count': _count,
        'traceId': _traceId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'query': serializeParam(
          _query,
          ParamType.String,
        ),
        'results': serializeParam(
          _results,
          ParamType.String,
          isList: true,
        ),
        'count': serializeParam(
          _count,
          ParamType.int,
        ),
        'traceId': serializeParam(
          _traceId,
          ParamType.String,
        ),
      }.withoutNulls;

  static SearchResponseModelStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      SearchResponseModelStruct(
        query: deserializeParam(
          data['query'],
          ParamType.String,
          false,
        ),
        results: deserializeParam<String>(
          data['results'],
          ParamType.String,
          true,
        ),
        count: deserializeParam(
          data['count'],
          ParamType.int,
          false,
        ),
        traceId: deserializeParam(
          data['traceId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SearchResponseModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SearchResponseModelStruct &&
        query == other.query &&
        listEquality.equals(results, other.results) &&
        count == other.count &&
        traceId == other.traceId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([query, results, count, traceId]);
}

SearchResponseModelStruct createSearchResponseModelStruct({
  String? query,
  int? count,
  String? traceId,
}) =>
    SearchResponseModelStruct(
      query: query,
      count: count,
      traceId: traceId,
    );
