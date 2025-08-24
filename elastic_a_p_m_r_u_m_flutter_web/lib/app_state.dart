import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  LoginResponseModelStruct _loginResponse = LoginResponseModelStruct();
  LoginResponseModelStruct get loginResponse => _loginResponse;
  set loginResponse(LoginResponseModelStruct value) {
    _loginResponse = value;
  }

  void updateLoginResponseStruct(Function(LoginResponseModelStruct) updateFn) {
    updateFn(_loginResponse);
  }
}
