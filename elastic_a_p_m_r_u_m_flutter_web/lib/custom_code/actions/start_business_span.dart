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

Future startBusinessSpan(
  String name,
  String entity,
  String action,
  EventType? eventType,
  dynamic? additionalLabels,
) async {
  Observability.startBusinessSpan(
    name: name,
    entity: entity,
    action: action,
    type: eventType ?? EventType.BUSINESS_EVENT,
    additionalLabels: additionalLabels,
  );
}
