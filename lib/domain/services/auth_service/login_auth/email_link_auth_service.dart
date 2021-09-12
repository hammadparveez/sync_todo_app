import 'dart:async';

import 'package:notifications/export.dart';

class EmailLinkLoginService extends LoginService {
  final auth = FirebaseAuth.instance;
  final firebaseUser = FirebaseAddUserRepoImpl();
  final EmailLinkActionCodeSettings settings;
  final dynamicLinkListener = DynamicLinkListener();
  String? _userEmail;
  EmailLinkLoginService(this.settings);
  bool isEmailSent = false;

  String? errMsg;

  Future<void> logOut() async {
    await Hive.box(LOGIN_BOX).delete(USER_KEY);
    isUserLoggedIn = false;
    userID = null;
    notifyListeners();
  }

  void checkIfUserLoggedIn() async {
    final sessionId = Hive.box(LOGIN_BOX).get(USER_KEY);
    isUserLoggedIn = (sessionId != null) ? true : false;
    log("User $isUserLoggedIn && Session ID: $sessionId");
    notifyListeners();
  }

  @override
  Future<void> login(String email, [String? password]) async {
    _userEmail = email;
    isEmailSent = false;
    errMsg = null;
    isUserLoggedIn = Hive.box(LOGIN_BOX).get(USER_KEY, defaultValue: false);
    if (!isUserLoggedIn) await _canLogIn();
    notifyListeners();
  }

  Future<void> _canLogIn() async {
    try {
      await _delegateLogin();
      dynamicLinkListener.attachListener(_onSuccess, _onError);
      isEmailSent = true;
    } on BaseException catch (e) {
      errMsg = e.msg;
    }
  }

  Future<void> _delegateLogin() async {
    try {
      await auth
          .sendSignInLinkToEmail(
              email: _userEmail!, actionCodeSettings: settings.actionCodes)
          .timeout(Duration(seconds: 15),
              onTimeout: () =>
                  throw FirebaseAuthException(code: NETWORK_FAILED));
    } on FirebaseAuthException catch (e) {
      firebaseToGeneralException(e);
    }
  }

  Future<bool?> _onSuccess(PendingDynamicLinkData? linkData) async {
    bool isSignInLink =
        auth.isSignInWithEmailLink("${linkData!.link.toString()}");
    if (isSignInLink) {
      isEmailSent = false;
      await Hive.box(LOGIN_BOX).put(USER_KEY, true);
      isUserLoggedIn = true;

      notifyListeners();
    }
  }

  Future _onError(OnLinkErrorException? linkData) async {
    log("Dynamic Linking Error ");
  }
}

class GoogleSignInAuth extends LoginService {
  @override
  Future<void> logOut() async {
    await GoogleSignIn().signOut();
    Hive.box(LOGIN_BOX).delete(USER_KEY);
    isUserLoggedIn = false;
    notifyListeners();
  }

  @override
  login(String email, [String? password]) async {
    try {
      isUserLoggedIn = false;
      final userAccount = await GoogleSignIn().signIn();
      if (userAccount != null) {
        await Hive.box(LOGIN_BOX).put(USER_KEY, true);
        isUserLoggedIn = true;
      }
    } on PlatformException catch (e) {
      platformToGeneralException(e);
    }
    notifyListeners();
  }
}
