import 'package:notifications/domain/factory/authentication_factory.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/auth_user_impl/firebase_login_user_impl.dart';
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
  final userAuth = getIt
      .get<AuthenticationFactory>()
      .create<UserAuthenticationRepositoryImpl>();
  String? _errorMsg;
  String? _sessionID;
  AuthenticationStatus _status = AuthenticationStatus.loading;

String? get sessionID => this._sessionID;
  String? get errorMsg => this._errorMsg;
  AuthenticationStatus get status => this._status;

  void get _setDefault {
    _errorMsg = null;
  }

  void isLoggedIn() {
    _sessionID = LocallyStoredData.getSessionID();
    notifyListeners();
  }

  void logOut() async {
    await LocallyStoredData.deleteUserKey();
    _sessionID = null;
    notifyListeners();
  }

  Future<bool> userExists(String userID) async {
    log("UserAuthService -> userExists()");
    try {
      final data = await userAuth!.checkUserExists(userID);
      return data.isNotEmpty ? true : false;
    } catch (e) {
      return false;
    }
  }

  ///Signing  in with Google Account
  Future<bool> login() async {
    _errorMsg = null;
    log("UserAuthService -> login()");
    try {
      final loggedIn = await userAuth!.login();
      log("User Logged In: $loggedIn");
      return loggedIn ?? true;
    } on BaseException catch (e) {
      log("Exception $e");
      _errorMsg = e.msg;
      notifyListeners();
      return false;
    }
  }

  /// Signing up an account manually
  Future<bool> register(String username, String email, String password) async {
    _errorMsg = null;
    log("UserAuthService -> register()");
    try {
      await userAuth!.signUp(UserAccountModel(email, username, password));
      return true;
    } on BaseException catch (e) {
      log("Exception $e");
      _errorMsg = e.msg;
      notifyListeners();
    }
    return false;
  }

  ///Signin in manually
  Future<bool> signIn(String userID, String password) async {
    _errorMsg = null;
    log("UserAuthService -> signIn()");
    try {
      await userAuth!.signIn(userID, password);
      return true;
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
      _errorMsg = e.msg;
      notifyListeners();
    }
    return false;
  }

  Future<bool> loginWithEmail(String email) async {
    log("UserAuthService -> loginWithEmail()");
    _setDefault;
    // _authType = AuthenticationType.emailAuthLogin;
    // notifyListeners();
    try {
      await userAuth!.loginViaID(email);
      userAuth!.onLinkListener(onSuccess: _onSuccess, onError: _onError);
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
    log("UserAuthService -> onSuccess()");
    try {
      log("OnLinkAuthenticate()");
      await userAuth!.onLinkAuthenticate(linkData);
      _status = AuthenticationStatus.success;
    } on BaseException catch (e) {
      log("Error onSucess: $e");
      _status = AuthenticationStatus.error;
      _errorMsg = e.msg;
    } catch (e) {
      log("Error->onSuccess: $e");
      _errorMsg = ExceptionsMessages.unexpectedError;
    }
    notifyListeners();
    return _status == AuthenticationStatus.success && _errorMsg == null
        ? true
        : false;
  }

  Future<dynamic> _onError(OnLinkErrorException? error) async {
    log("Error $error in Link");
  }
}
