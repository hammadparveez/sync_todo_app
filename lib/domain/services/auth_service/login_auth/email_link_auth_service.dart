import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notifications/domain/services/action_code_service/auth_link_code_service.dart';
import 'package:notifications/domain/services/auth_service/login_auth/login_service.dart';
import 'package:notifications/domain/services/dynamic_link_service/dynamic_link.dart';
import 'package:notifications/domain/services/exception.dart';
import 'package:notifications/infrastructure/firebase_add_user/firebase_add_user_impl.dart';
import 'package:notifications/resources/constants/durations.dart';
import 'package:notifications/resources/constants/exceptions.dart';

class EmailLinkLoginService extends LoginService {
  final auth = FirebaseAuth.instance;
  final firebaseUser = FirebaseAddUserRepoImpl();
  final EmailLinkActionCodeSettings settings;
  final dynamicLinkListener = DynamicLinkListener();
  String? _userEmail;
  EmailLinkLoginService(this.settings);
  bool isEmailSent = false;
  String? errMsg;

  void checkIfUserLoggedIn() async {
    userID = Hive.box("loginBox").get("user");
    if (userID != null)
      isUserLoggedIn = true;
    else
      isUserLoggedIn = false;

    notifyListeners();
  }

  @override
  Future<void> login(String email, [String? password]) async {
    _userEmail = email;
    isEmailSent = false;
    errMsg = null;
    userID = Hive.box("loginBox").get("user");
    if (userID == null) await _canLogIn();
    notifyListeners();
  }

  Future<void> logOut() async {
    await Hive.box("loginBox").delete("user");
    isUserLoggedIn = false;
    userID = null;
    notifyListeners();
  }

  Future<void> _canLogIn() async {
    try {
      await _delegateLogin();

      dynamicLinkListener.attachListener(_onSuccess, _onError);
      isEmailSent = true;
    } on AppException catch (e) {
      errMsg = e.message;
    }
  }

  Future<void> _delegateLogin() async {
    try {
      await auth
          .sendSignInLinkToEmail(
              email: _userEmail!, actionCodeSettings: settings.actionCodes)
          .timeout(DefaultDuration.sec20);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } on TimeoutException {
      throw AppException(ExceptionsMessages.somethingWrongInternetMsg);
    }
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case ExceptionsMessages.firebaseInvalidEmailCode:
        throw AppException(ExceptionsMessages.invalidEmailMsg);
      default:
        throw AppException(ExceptionsMessages.somethingWrongMsg);
    }
  }

  Future<bool?> _onSuccess(PendingDynamicLinkData? linkData) async {
    bool isSignInLink =
        auth.isSignInWithEmailLink("${linkData!.link.toString()}");
    if (isSignInLink) {
      final user =
          await firebaseUser.addUser<Map<String, dynamic>>(_userEmail!);
      if (user != null) {
        await Hive.box('loginBox').put('user', user["email"]);
        userID = user['email'];
      }
      isUserLoggedIn = true;
      notifyListeners();
    }
  }

  Future _onError(OnLinkErrorException? linkData) async {
    log("Dynamic Linking Error ");
  }
}
