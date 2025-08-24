// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api_requests/api_interceptor.dart';
import '/custom_code/observability.dart';
import '/backend/api_requests/api_manager.dart' show BodyType;

class ObservabilityInterceptor extends FFApiInterceptor {
  // Store start time for this specific request
  int? _startTime;

  @override
  Future<ApiCallOptions> onRequest({
    required ApiCallOptions options,
  }) async {
    _startTime = DateTime.now().millisecondsSinceEpoch;

    // Extract endpoint from URL path
    final endpoint = options.apiUrl;

    final body = options.bodyType == BodyType.JSON
        ? jsonDecode(options.body ?? '{}')
        : {};
    final metadata = body.isEmpty ? {} : body['metadata'] ?? {};

    // Start the API call span with metadata from the request
    Observability.startApiCall(
      endpoint: endpoint,
      method: options.callType.name,
      operationName: '${options.callType.name} $endpoint',
      additionalLabels: {
        ...metadata,
        'startTime': _startTime,
      },
    );

    // Remove the metadata from the body
    final updatedBody = body.remove('metadata');

    // Add trace context headers for distributed tracing
    final traceHeaders = Observability.getTraceContext();
    final updatedHeaders = Map<String, String>.from(options.headers);
    updatedHeaders.addAll(traceHeaders);

    // Update the options with the new body and headers
    final updatedOptions = options.copyWith(
      body: updatedBody,
      headers: updatedHeaders,
    );
    return updatedOptions;
  }

  @override
  Future<ApiCallResponse> onResponse({
    required ApiCallResponse response,
    required Future<ApiCallResponse> Function() retryFn,
  }) async {
    var updatedResponse;

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final duration = endTime - _startTime!;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success response - extract observability metadata from response body
      final additionalLabels = <String, dynamic>{
        'result': 'SUCCESS',
        'statusCode': response.statusCode,
        'http.status_code': response.statusCode,
        'duration': duration,
        'endTime': endTime,
      };

      // Extract observability metadata from response body
      try {
        final responseData = response.jsonBody as Map<String, dynamic>;
        if (responseData.containsKey('observabilityMetadata')) {
          final observabilityMetadata =
              responseData['observabilityMetadata'] as Map<String, dynamic>?;
          if (observabilityMetadata != null) {
            additionalLabels.addAll(observabilityMetadata);
          }
        }
      } catch (e) {
        // Ignore parsing errors for metadata extraction
      }

      Observability.addLabels(additionalLabels);

      // Now that we have extracted the observabilityMetadata, we can actually remove the metadata from the body
      final responseData = response.jsonBody as Map<String, dynamic>;
      responseData.remove('observabilityMetadata');
      updatedResponse = response.copyWith(
        jsonBody: responseData,
      );
    } else {
      // Error response
      Observability.addLabels({
        'result': 'FAILURE',
        'statusCode': response.statusCode,
        'http.status_code': response.statusCode,
        'error': 'HTTP Error ${response.statusCode}',
        'duration': duration,
        'endTime': endTime,
      });
    }

    Observability.endSpan();

    return updatedResponse ?? response;
  }
}
