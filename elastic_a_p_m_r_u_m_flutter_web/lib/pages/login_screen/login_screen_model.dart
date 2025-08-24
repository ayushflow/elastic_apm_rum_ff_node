import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Authenticate user)] action in Button widget.
  ApiCallResponse? loginApiResponse;
  // Stores action output result for [Backend Call - API (Load dashboard data)] action in Button widget.
  ApiCallResponse? dashboardApiResponse;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
