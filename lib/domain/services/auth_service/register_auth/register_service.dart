import 'dart:developer';

import 'package:notifications/export.dart';

class AuthUserService extends ChangeNotifier {
  bool _hasAdded = false, _isLoading = false, _hasUserFound =false;
  String? _errorMsg;
  UserModel? _model;

  ///Getters
  bool get hasAdded => _hasAdded;
  bool get isLoading => _isLoading;
  String? get errorMsg => _errorMsg;
  bool get hasUserFound => _hasUserFound;

  Future<void> register(String username, String email, String password) async {
    log("RegisterService -> register()");
    _setDefaultValues(isLoading: true);
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
    _isLoading = false;
    _hasAdded = _model != null && _errorMsg == null ? true : false;
    notifyListeners();
  }

  Future<void> signIn(String usernameOrEmail, String password) async {
    if(_model != null) {
      _hasUserFound = (_model!.email == usernameOrEmail || _model!.username == usernameOrEmail ) && _model!.password == password;
      log("AuthUserService->signIn() -> $_hasUserFound");
      notifyListeners();
    }

  }
  
  _setDefaultValues({bool hasAdded = false, bool isLoading = false, String? errorMsg }) {
    _hasAdded = hasAdded;
    _isLoading = isLoading;
    _errorMsg = errorMsg;
  }
}
