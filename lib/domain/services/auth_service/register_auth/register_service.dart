import 'dart:developer';

import 'package:notifications/export.dart';

class AuthUserService extends ChangeNotifier {
  bool _taskCompleted = false, _isLoading = false, _hasUserFound = false;
  String? _errorMsg;
  UserModel? _model;

  ///Getters
  bool get taskCompleted => _taskCompleted;
  bool get isLoading => _isLoading;
  String? get errorMsg => _errorMsg;
  bool get hasUserFound => _hasUserFound;
  final firebase = FirebaseRegisterUser();
  Future<void> register(String username, String email, String password) async {
    log("RegisterService -> register()");
    _setDefaultValues(isLoading: true);
    try {
      _model = await firebase
          .addUser<UserModel>(UserModel(email, username, password));
    } catch (e) {
      log("ExceptionType: ${e.runtimeType}");
      if (e is SignUpFailure)
        _errorMsg = e.msg;
      else if (e is NetworkFailure) _errorMsg = e.msg;
    }
    log("RegisterService -> ${_model?.email}");
    _isLoading = false;
    _taskCompleted = _model != null && _errorMsg == null ? true : false;
    notifyListeners();
  }

  Future<void> signIn(String usernameOrEmail, String password) async {
    _setDefaultValues(isLoading: true);
    _model = await _tryToGetUser(usernameOrEmail, password);
    if (_model != null) _taskCompleted = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<UserModel?> _tryToGetUser(
      String usernameOrEmail, String password) async {
    try {
      final user = await firebase.getUser(usernameOrEmail, password);
      return user;
    } on BaseException catch (e) {
      log("RegisterService -> Exception:  $e");
      _errorMsg = getGeneralExceptionMsg(e);
    } catch (e) {
      log("!!!!!!EXCEPTION!!!!!! $e");
    }
  }

  _setDefaultValues(
      {bool taskCompleted = false, bool isLoading = false, String? errorMsg}) {
    _taskCompleted = taskCompleted;
    _isLoading = isLoading;
    _errorMsg = errorMsg;
  }
}
