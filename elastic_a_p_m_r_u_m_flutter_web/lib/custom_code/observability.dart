// observability.dart
@JS('window.ffRum')
library;

import 'package:flutter/foundation.dart';
import 'dart:js_interop';
import 'dart:math';
import '/backend/schema/enums/enums.dart';

@JS('startTransaction')
external void _startTransaction(String name, String type);

@JS('endTransaction')
external void _endTransaction();

@JS('startSpan')
external void _startSpan(String name, String type);

@JS('endSpan')
external void _endSpan();

@JS('addLabels')
external void _addLabels(JSAny labels);

// Business Context Model
class BusinessContext {
  final String? requestId;
  final String? traceId;
  final String? spanId;
  final String? bpId; // Business Process ID
  final String service;
  final EventType type;
  final String entity;
  final String action;
  final ResultType result;
  final String? userId;
  final Map<String, dynamic>? additionalContext;

  BusinessContext({
    this.requestId,
    this.traceId,
    this.spanId,
    this.bpId,
    required this.service,
    required this.type,
    required this.entity,
    required this.action,
    required this.result,
    this.userId,
    this.additionalContext,
  });

  Map<String, dynamic> toMap() {
    return {
      if (requestId != null) 'requestId': requestId,
      if (traceId != null) 'traceId': traceId,
      if (spanId != null) 'spanId': spanId,
      if (bpId != null) 'BPId': bpId,
      'service': service,
      'type': type.name,
      'entity': entity,
      'action': action,
      'result': result.name,
      if (userId != null) 'userId': userId,
      if (additionalContext != null) ...additionalContext!,
    };
  }
}

class Observability {
  static String? _currentTraceId;
  static String? _currentRequestId;
  static String? _currentUserId;
  static String? _currentBpId;
  static int _spanCounter = 0;
  static bool _hasActiveTransaction = false;

  // Initialize a customer journey with a traceId
  static void initializeJourney({
    String? traceId,
    String? requestId,
    String? userId,
    String? bpId,
  }) {
    _currentTraceId = traceId ?? _generateTraceId();
    _currentRequestId = requestId ?? _generateRequestId();
    _currentUserId = userId;
    _currentBpId = bpId;
    _spanCounter = 0;
    _hasActiveTransaction = false;

    debugPrint(
        'RUM Journey initialized: traceId=$_currentTraceId, requestId=$_currentRequestId');
  }

  static String _generateTraceId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${timestamp.toRadixString(16)}-${random.nextInt(0xFFFFFF).toRadixString(16)}';
  }

  static String _generateRequestId() {
    final random = Random();
    return 'req-${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(9999)}';
  }

  static String _generateSpanId() {
    _spanCounter++;
    return '${_currentTraceId}-span-$_spanCounter';
  }

  // Start a business transaction with full context
  static void startBusinessTransaction({
    required String name,
    required String service,
    required String entity,
    required String action,
    EventType type = EventType.BUSINESS_EVENT,
    String? userId,
    Map<String, dynamic>? additionalLabels,
  }) {
    if (!kIsWeb) return;
    if (_hasActiveTransaction) {
      debugPrint(
          'RUM Warning: Transaction already active, ending previous one');
      _endTransaction();
    }

    try {
      // Start the transaction
      _startTransaction(name, type.name);
      _hasActiveTransaction = true;

      // Create business context
      final context = BusinessContext(
        requestId: _currentRequestId,
        traceId: _currentTraceId,
        spanId: _generateSpanId(),
        bpId: _currentBpId,
        service: service,
        type: type,
        entity: entity,
        action: action,
        result: ResultType.PENDING, // Will be updated when transaction ends
        userId: userId ?? _currentUserId,
        additionalContext: additionalLabels,
      );

      // Add all context as labels
      _addLabelsInternal(context.toMap());

      debugPrint('RUM Business Transaction started: ${context.toMap()}');
    } catch (e) {
      debugPrint('RUM startBusinessTransaction failed: $e');
    }
  }

  // End transaction with result
  static void endTransactionWithResult(ResultType result,
      {Map<String, dynamic>? additionalLabels}) {
    if (!kIsWeb) return;
    if (!_hasActiveTransaction) {
      debugPrint('RUM Warning: No active transaction to end');
      return;
    }

    try {
      // Update the result label
      final labels = {
        'result': result.name,
        if (additionalLabels != null) ...additionalLabels,
      };
      _addLabelsInternal(labels);

      // End the transaction
      _endTransaction();
      _hasActiveTransaction = false;

      debugPrint('RUM Transaction ended with result: ${result.name}');
    } catch (e) {
      debugPrint('RUM endTransactionWithResult failed: $e');
    }
  }

  // Start a span for sub-operations
  static void startBusinessSpan({
    required String name,
    required String entity,
    required String action,
    EventType type = EventType.BUSINESS_EVENT,
    Map<String, dynamic>? additionalLabels,
  }) {
    if (!kIsWeb) return;

    try {
      _startSpan(name, type.name);

      final labels = {
        'spanId': _generateSpanId(),
        'entity': entity,
        'action': action,
        'type': type.name,
        if (additionalLabels != null) ...additionalLabels,
      };

      _addLabelsInternal(labels);

      debugPrint('RUM Business Span started: $labels');
    } catch (e) {
      debugPrint('RUM startBusinessSpan failed: $e');
    }
  }

  // Helper for user actions as transactions - auto-starts and ends
  static void trackUserActionAsTransaction({
    required String actionName,
    Map<String, dynamic>? additionalLabels,
  }) {
    if (!kIsWeb) return;

    try {
      final startTime = DateTime.now().millisecondsSinceEpoch;

      // Start the transaction
      _startTransaction(actionName, 'user-action');

      // Add labels
      final labels = {
        'action': actionName,
        'type': 'USER_ACTION',
        'startTime': startTime,
        'duration': 0, // User actions should be instantaneous
        if (additionalLabels != null) ...additionalLabels,
      };
      _addLabelsInternal(labels);

      // Add a small delay before ending to ensure transaction is captured
      Future.delayed(Duration(milliseconds: 10), () {
        try {
          _endTransaction();
          final endTime = DateTime.now().millisecondsSinceEpoch;
          debugPrint(
              'RUM User Action Transaction tracked and ended: $actionName (duration: ${endTime - startTime}ms)');
        } catch (e) {
          debugPrint('RUM trackUserActionAsTransaction end failed: $e');
        }
      });
    } catch (e) {
      debugPrint('RUM trackUserActionAsTransaction failed: $e');
      // Try to end transaction even if error occurred
      try {
        _endTransaction();
      } catch (_) {}
    }
  }

  // Fixed: Helper for GUI events (user actions) - auto-ends immediately
  static void trackUserAction({
    required String action,
    required String entity,
    Map<String, dynamic>? additionalLabels,
  }) {
    if (!kIsWeb) return;

    try {
      final startTime = DateTime.now().millisecondsSinceEpoch;

      // Start the span
      _startSpan('user_action_$action', EventType.USER_ACTION.name);

      // Add labels
      final labels = {
        'entity': entity,
        'action': action,
        'type': EventType.USER_ACTION.name,
        'startTime': startTime,
        'duration': 0, // User actions should be instantaneous
        if (additionalLabels != null) ...additionalLabels,
      };
      _addLabelsInternal(labels);

      // CRITICAL: End the span immediately!
      // User actions are instantaneous events
      _endSpan();

      final endTime = DateTime.now().millisecondsSinceEpoch;
      debugPrint(
          'RUM User Action tracked and ended: $action (duration: ${endTime - startTime}ms)');
    } catch (e) {
      debugPrint('RUM trackUserAction failed: $e');
      // Try to end span even if error occurred
      try {
        _endSpan();
      } catch (_) {}
    }
  }

  // Updated: Helper for API calls with better span naming
  static void startApiCall({
    required String endpoint,
    required String method,
    String? operationName, // Optional custom name
    Map<String, dynamic>? additionalLabels,
  }) {
    if (!kIsWeb) return;

    // Create a descriptive span name
    // Format: "HTTP_METHOD endpoint" or use custom operation name
    // Examples: "POST /login", "GET /dashboard", or "api.login"
    final spanName = operationName ?? '$method $endpoint';

    startBusinessSpan(
      name: spanName,
      entity: endpoint,
      action: method,
      type: EventType.EXTERNAL_CALL,
      additionalLabels: {
        'http.method': method,
        'http.url': endpoint,
        'startTime': DateTime.now().millisecondsSinceEpoch,
        if (additionalLabels != null) ...additionalLabels,
      },
    );
  }

  // Backward compatible wrapper
  static void trackApiCall({
    required String endpoint,
    required String method,
    String? operationName,
    Map<String, dynamic>? additionalLabels,
  }) {
    startApiCall(
      endpoint: endpoint,
      method: method,
      operationName: operationName,
      additionalLabels: additionalLabels,
    );
  }

  // Get current trace context for backend propagation
  static Map<String, String> getTraceContext() {
    return {
      if (_currentTraceId != null) 'X-Trace-Id': _currentTraceId!,
      if (_currentRequestId != null) 'X-Request-Id': _currentRequestId!,
      if (_currentBpId != null) 'X-BP-Id': _currentBpId!,
      if (_currentUserId != null) 'X-User-Id': _currentUserId!,
    };
  }

  // Original methods kept for backward compatibility
  static void startTransaction(String name, {String type = 'custom'}) {
    if (!kIsWeb) return;
    if (_hasActiveTransaction) {
      debugPrint(
          'RUM Warning: Transaction already active, ending previous one');
      _endTransaction();
    }

    try {
      _startTransaction(name, type);
      _hasActiveTransaction = true;
      debugPrint('RUM Transaction started: $name');
    } catch (e) {
      debugPrint('RUM start failed: $e');
    }
  }

  static void endTransaction() {
    if (!kIsWeb) return;
    if (!_hasActiveTransaction) {
      debugPrint('RUM Warning: No active transaction to end');
      return;
    }

    try {
      _endTransaction();
      _hasActiveTransaction = false;
      debugPrint('RUM Transaction ended');
    } catch (e) {
      debugPrint('RUM end failed: $e');
    }
  }

  static void startSpan(String name, {String type = 'custom'}) {
    if (!kIsWeb) return;
    try {
      _startSpan(name, type);
      debugPrint('RUM Span started: $name (type: $type)');
    } catch (e) {
      debugPrint('RUM startSpan failed: $e');
    }
  }

  static void endSpan() {
    if (!kIsWeb) return;
    try {
      _endSpan();
      debugPrint('RUM Span ended');
    } catch (e) {
      debugPrint('RUM endSpan failed: $e');
    }
  }

  static void addLabels(Map<String, dynamic> labels) {
    if (!kIsWeb) return;
    _addLabelsInternal(labels);
  }

  static void _addLabelsInternal(Map<String, dynamic> labels) {
    // Validate and convert to JavaScript object
    final validLabels = <String, dynamic>{};
    for (final entry in labels.entries) {
      final value = entry.value;
      if (value is String || value is int || value is double || value is bool) {
        validLabels[entry.key] = value;
      } else if (value != null) {
        // Convert to string if not null
        validLabels[entry.key] = value.toString();
      }
    }

    try {
      final jsLabels = validLabels.jsify();
      if (jsLabels != null) {
        _addLabels(jsLabels);
        debugPrint('RUM Labels added: $validLabels');
      }
    } catch (e) {
      debugPrint('RUM addLabels failed: $e');
    }
  }
}
