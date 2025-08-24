// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/observability.dart';

Future initializeJourney(String? bpId) async {
  Observability.initializeJourney(
    bpId: bpId ?? Observability.getTraceContext()['X-BP-Id'],
    traceId: Observability.getTraceContext()['X-Trace-Id'],
    requestId: Observability.getTraceContext()['X-Request-Id'],
    userId: FFAppState().loginResponse.username,
  );
}
