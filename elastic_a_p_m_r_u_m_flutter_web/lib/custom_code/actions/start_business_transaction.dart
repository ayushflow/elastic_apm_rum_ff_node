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

Future startBusinessTransaction(
  String name,
  String service,
  String entity,
  String action,
  EventType? eventType,
  dynamic? additionalLabels,
) async {
  Observability.startBusinessTransaction(
    name: name,
    service: service,
    entity: entity,
    action: action,
    userId: FFAppState().loginResponse.username,
    type: eventType ?? EventType.BUSINESS_EVENT,
    additionalLabels: additionalLabels,
  );
}
