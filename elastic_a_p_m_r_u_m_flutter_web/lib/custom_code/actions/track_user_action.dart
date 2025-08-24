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

Future trackUserAction(
  String action,
  String entity,
  dynamic? additionalLabels,
) async {
  Observability.trackUserAction(
    action: action,
    entity: entity,
    additionalLabels: additionalLabels,
  );
}
