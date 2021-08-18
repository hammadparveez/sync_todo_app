import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notifications/domain/services/action_code_service/auth_link_code_service.dart';
import 'package:notifications/domain/services/dynamic_link_service/dynamic_link.dart';
import 'package:notifications/domain/services/exception.dart';
import 'package:notifications/infrastructure/firebase_add_user/firebase_add_user_impl.dart';
import 'package:notifications/resources/constants/durations.dart';
import 'package:notifications/resources/constants/exceptions.dart';

abstract class LoginService extends ChangeNotifier {
  String? _userID;
  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn => _isUserLoggedIn;
  String? get userID => _userID;

  login(String email, [String? password]);
  Future<void> logOut();
}

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
    _userID = Hive.box("loginBox").get("user");
    log("User ID $_userID & $_isUserLoggedIn");
    if (_userID != null)
      _isUserLoggedIn = true;
    else
      _isUserLoggedIn = false;
    log("Is Logged ID $_isUserLoggedIn");
    notifyListeners();
  }

  @override
  Future<void> login(String email, [String? password]) async {
    _userEmail = email;
    isEmailSent = false;
    errMsg = null;
    _userID = Hive.box("loginBox").get("user");
    if (_userID == null) await _canLogIn();
    notifyListeners();
  }

  Future<void> logOut() async {
    await Hive.box("loginBox").delete("user");
    _isUserLoggedIn = false;
    _userID = null;
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
        _userID = user['email'];
      }
      _isUserLoggedIn = true;
      notifyListeners();
    }
  }

  Future _onError(OnLinkErrorException? linkData) async {
    log("Dynamic Linking Error ");
  }
}
