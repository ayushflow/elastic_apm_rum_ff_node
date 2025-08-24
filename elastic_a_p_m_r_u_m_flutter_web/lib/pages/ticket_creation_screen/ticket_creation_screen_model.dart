import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'ticket_creation_screen_widget.dart' show TicketCreationScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TicketCreationScreenModel
    extends FlutterFlowModel<TicketCreationScreenWidget> {
  ///  Local state fields for this page.

  String? assignedOfficer;

  TicketCreationResponseModelStruct? ticketResponse;
  void updateTicketResponseStruct(
      Function(TicketCreationResponseModelStruct) updateFn) {
    updateFn(ticketResponse ??= TicketCreationResponseModelStruct());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (Create a new ticket)] action in Button widget.
  ApiCallResponse? ticketCreationApiResponse;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }

  /// Action blocks.
  Future simulateOfficerAssignment(BuildContext context) async {
    await actions.startBusinessSpan(
      'assign_ticket_batch',
      'Ticket',
      'ASSIGN_OFFICER',
      EventType.BATCH_PROCESS,
      <String, String?>{
        'ticketId': ticketResponse?.ticketId,
        'eventSequence': '2',
        'processType': 'BATCH_ASSIGNMENT',
      },
    );
    await Future.delayed(
      Duration(
        milliseconds: 2000,
      ),
    );
    assignedOfficer =
        'officer_${'${DateTime.now().millisecondsSinceEpoch % 1000}'}';
    await actions.addLabels(
      <String, String?>{
        'assignedOfficer': assignedOfficer,
        'assignmentMethod': 'AUTO_ASSIGN',
      },
    );
    await actions.endSpan();
  }
}
