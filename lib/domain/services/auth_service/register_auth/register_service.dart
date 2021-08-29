import 'dart:developer';

import 'package:notifications/export.dart';

class RegisterUserService extends ChangeNotifier {
  bool _hasAdded = false;
  String? _errorMsg;
  UserModel? _model;

  ///Getters
  bool get hasAdded => _hasAdded;
  String? get errorMsg => _errorMsg;

  Future<void> register(String username, String email, String password) async {
    log("RegisterService -> register()");
    _errorMsg = null;
    _hasAdded = false;
    try {
      _model = await FirebaseRegisterUser()
          .addUser<UserModel>(UserModel(email, username, password));
    } catch (e) {
      log("ExceptionType: ${e.runtimeType}");
      if(e is SignUpFailure)
        _errorMsg = e.msg;
      else if(e is NetworkFailure)
        _errorMsg = e.msg;
    }
    log("RegisterService -> ${_model?.email}");
    _hasAdded = _model != null && _errorMsg == null ? true : false;
    notifyListeners();
  }
}
