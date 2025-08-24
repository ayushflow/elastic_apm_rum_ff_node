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
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_screen_model.dart';
export 'login_screen_model.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  static String routeName = 'LoginScreen';
  static String routePath = '/loginScreen';

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  late LoginScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.initializeJourney(
        'BP_USER_AUTH_${getCurrentTimestamp.millisecondsSinceEpoch.toString()}',
      );
      await actions.trackUserActionAsTransaction(
        'login_page_view',
        <String, String?>{
          'page': 'login',
          'businessProcess': 'UserAuthentication',
        },
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'LoginScreen',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    var _shouldSetState = false;
                    // start a business transaction for the entire login process
                    unawaited(
                      () async {
                        await actions.startBusinessTransaction(
                          'user_login_process',
                          'portal-ui-application',
                          'User',
                          'LOGIN',
                          EventType.BUSINESS_EVENT,
                          <String, String?>{
                            'eventSequence': '1',
                            'businessProcess': 'UserAuthentication',
                            'flowStep': 'LOGIN_INITIATED',
                          },
                        );
                      }(),
                    );
                    unawaited(
                      () async {
                        await actions.trackUserAction(
                          'CLICK_LOGIN',
                          'LoginButton',
                          <String, String?>{
                            'username': 'demo',
                            'eventSequence': '2',
                          },
                        );
                      }(),
                    );
                    _model.loginApiResponse =
                        await FlutterElasticRUMDemoAPIGroup.authenticateUserCall
                            .call();

                    _shouldSetState = true;
                    if ((_model.loginApiResponse?.succeeded ?? true)) {
                      unawaited(
                        () async {
                          await actions.initializeJourney(
                            null,
                          );
                        }(),
                      );
                      unawaited(
                        () async {
                          await actions.addLabels(
                            <String, String?>{
                              'flowStep': 'LOADING_DASHBOARD',
                              'eventSequence': '3',
                            },
                          );
                        }(),
                      );
                      _model.dashboardApiResponse =
                          await FlutterElasticRUMDemoAPIGroup
                              .loadDashboardDataCall
                              .call();

                      _shouldSetState = true;
                      if ((_model.dashboardApiResponse?.succeeded ?? true)) {
                        unawaited(
                          () async {
                            await actions.endTransactionWithResult(
                              ResultType.SUCCESS,
                              <String, String?>{
                                'flowStep': 'LOGIN_COMPLETED',
                                'nextAction': 'NAVIGATE_TO_DASHBOARD',
                                'eventSequence': '4',
                              },
                            );
                          }(),
                        );

                        context.goNamed(
                          DashboardScreenWidget.routeName,
                          queryParameters: {
                            'dashboardResponse': serializeParam(
                              DashboardResponseModelStruct.maybeFromMap(
                                  (_model.dashboardApiResponse?.jsonBody ??
                                      '')),
                              ParamType.DataStruct,
                            ),
                          }.withoutNulls,
                        );

                        if (_shouldSetState) safeSetState(() {});
                        return;
                      } else {
                        if (_shouldSetState) safeSetState(() {});
                        return;
                      }
                    } else {
                      unawaited(
                        () async {
                          await actions.endTransactionWithResult(
                            ResultType.FAILURE,
                            <String, String?>{
                              'error': 'An error coming from backend',
                              'errorType': 'AUTHENTICATION_FAILED',
                              'flowStep': 'LOGIN_FAILED',
                            },
                          );
                        }(),
                      );
                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }

                    if (_shouldSetState) safeSetState(() {});
                  },
                  text: 'Login',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
