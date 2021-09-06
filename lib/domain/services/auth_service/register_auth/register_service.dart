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

  //Signing Up User
  Future<void> register(String username, String email, String password) async {
    log("RegisterService -> register()");
    _setDefaultValues();
    try {
      _model = await firebase
          .addUser<UserModel>(UserModel(email, username, password));
    } on BaseException catch (e) {
      _errorMsg = e.msg;
    }
    log("RegisterService -> ${_model?.email}");
    
    _taskCompleted = _model != null && _errorMsg == null ? true : false;
    notifyListeners();
  }

 


  _setDefaultValues(
      {bool taskCompleted = false, bool isLoading = false, String? errorMsg}) {
    _taskCompleted = taskCompleted;
    _isLoading = isLoading;
    _errorMsg = errorMsg;
  }
}
