import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/domain/services/auth_service/all_auth_builder.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/local/local_storage.dart';

enum AuthenticationStatus {
  loading,
  error,
  success,
}

enum AuthenticationType {
  login,
  register,
  googleLogin,
  emailAuthLogin,
}

class UserAuthService extends ChangeNotifier {
  final authBuilder = AllTypeAuthBuilder();
  String? _errorMsg, _sessionID;
  AuthenticationType _authType = AuthenticationType.login;
  AuthenticationStatus _status = AuthenticationStatus.loading;
  EmailLinkAuthenticationRepo? _repo;

  String? get errorMsg => this._errorMsg;
  AuthenticationType get authType => this._authType;
  AuthenticationStatus get status => this._status;

  void get _setDefault {
    _errorMsg = null;
    //_sessionID = null;
  }

  String? get sessionID {
    return LocallyStoredData.getSessionID();
  }

  void logOut() {
    return LocallyStoredData.deleteUserKey();
  }

  Future<bool> userExists(String userID) async {
    final isExists = await authBuilder.checkUserExists(userID);
    return isExists ? true : false;
  }

  Future<bool> login() async {
    _setDefault;
    // _authType = AuthenticationType.googleLogin;
    // notifyListeners();
    try {
      await authBuilder.login();
      return true;
    } on BaseException catch (e) {
      log("Exception $e");
      _errorMsg = e.msg;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _setDefault;
    //_authType = AuthenticationType.register;
    //notifyListeners();
    try {
      await authBuilder.register(username, email, password);
      return true;
    } on BaseException catch (e) {
      log("Exception $e");
      _errorMsg = e.msg;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String userID, String password) async {
    _setDefault;
    // _authType = AuthenticationType.login;
    // notifyListeners();
    try {
      await authBuilder.signIn(userID, password);
      return true;
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
      _errorMsg = e.msg;
      notifyListeners();
    }
    return false;
  }

  Future<bool> loginWithEmail(String email) async {
    _setDefault;
    // _authType = AuthenticationType.emailAuthLogin;
    // notifyListeners();
    try {
      _repo = await authBuilder.loginWithEmail(email);
      _repo!.onLinkListener(
        onSuccess: _onSuccess,
        onError: _onError,
      );
      return true;
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
      _errorMsg = e.msg;
    }

    notifyListeners();
    return false;
  }

  Future<bool> _onSuccess(PendingDynamicLinkData? linkData) async {
    _errorMsg = null;
    notifyListeners();
    try {
      log("OnLinkAuthenticate");
      await _repo!.onLinkAuthenticate(linkData);
      _status = AuthenticationStatus.success;
      return true;
    } on BaseException catch (e) {
      log("Error onSucess: $e");
      _status = AuthenticationStatus.error;
      _errorMsg = e.msg;
    }
    notifyListeners();
    return false;
  }

  Future<dynamic> _onError(OnLinkErrorException? error) async {
    log("Error $error in Link");
  }

  Future<void> tryTo(Function callback) async {
    try {
      await callback();
    } on BaseException catch (e) {
      _errorMsg = e.msg;
    }
  }
}
