import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';
import 'interceptors.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Flutter Elastic RUM Demo API Group Code

class FlutterElasticRUMDemoAPIGroup {
  static String getBaseUrl() => 'http://localhost:8080';
  static Map<String, String> headers = {};
  static AuthenticateUserCall authenticateUserCall = AuthenticateUserCall();
  static LoadDashboardDataCall loadDashboardDataCall = LoadDashboardDataCall();
  static CreateANewTicketCall createANewTicketCall = CreateANewTicketCall();

  static final interceptors = [
    ObservabilityInterceptor(),
  ];
}

class AuthenticateUserCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = FlutterElasticRUMDemoAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "username": "john.doe",
  "password": "password123"
}''';
    return FFApiInterceptor.makeApiCall(
      // ignore: prefer_const_constructors - can be mutated by interceptors
      ApiCallOptions(
        callName: 'Authenticate user',
        apiUrl: '${baseUrl}/login',
        callType: ApiCallType.POST,
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        headers: {},
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        params: {},
        body: ffApiRequestBody,
        bodyType: BodyType.JSON,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      ),

      FlutterElasticRUMDemoAPIGroup.interceptors,
    );
  }
}

class LoadDashboardDataCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = FlutterElasticRUMDemoAPIGroup.getBaseUrl();

    return FFApiInterceptor.makeApiCall(
      // ignore: prefer_const_constructors - can be mutated by interceptors
      ApiCallOptions(
        callName: 'Load dashboard data',
        apiUrl: '${baseUrl}/dashboard',
        callType: ApiCallType.GET,
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        headers: {},
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        params: {},

        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      ),

      FlutterElasticRUMDemoAPIGroup.interceptors,
    );
  }
}

class CreateANewTicketCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = FlutterElasticRUMDemoAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "title": "Login issue with mobile app",
  "description": "Users are unable to login using the mobile app. The app shows an error message after entering credentials.",
  "priority": "high"
}''';
    return FFApiInterceptor.makeApiCall(
      // ignore: prefer_const_constructors - can be mutated by interceptors
      ApiCallOptions(
        callName: 'Create a new ticket',
        apiUrl: '${baseUrl}/tickets/create',
        callType: ApiCallType.POST,
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        headers: {},
        // ignore: prefer_const_literals_to_create_immutables - can be mutated by interceptors
        params: {},
        body: ffApiRequestBody,
        bodyType: BodyType.JSON,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        cache: false,
        isStreamingApi: false,
        alwaysAllowBody: false,
      ),

      FlutterElasticRUMDemoAPIGroup.interceptors,
    );
  }
}

/// End Flutter Elastic RUM Demo API Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
