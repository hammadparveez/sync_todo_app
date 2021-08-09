import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:notifications/domain/services/action_code_service/auth_link_code_service.dart';
import 'package:notifications/resources/constants/durations.dart';
import 'package:notifications/resources/constants/exceptions.dart';

abstract class LoginService extends ChangeNotifier {
  login(String email, [String? password]);
}

class EmailLinkLoginService extends LoginService {
  final auth = FirebaseAuth.instance;
  final EmailLinkActionCodeSettings settings;
  final ConnectivityResult? connectivityResult;
  String? _userEmail;
  EmailLinkLoginService(this.settings, [this.connectivityResult]);

  bool isEmailSent = false;
  String? errMsg;
  @override
  Future<void> login(String email, [String? password]) async {
    _userEmail = email;
    isEmailSent = false;
    errMsg = null;
    await _canLogIn();
    notifyListeners();
  }

  Future<void> _canLogIn() async {
    try {
      log("Connectivity: ${connectivityResult}");
      await _beforeLoginCheckConnectivity();
      isEmailSent = true;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } on TimeoutException catch (e) {
      errMsg = ExceptionsMessages.somethingWrongInternetMsg;
    } on SocketException catch (e) {
      errMsg = e.message;
    }
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case ExceptionsMessages.firebaseInvalidEmailCode:
        errMsg = ExceptionsMessages.invalidEmailMsg;
        break;
      default:
        errMsg = ExceptionsMessages.somethingWrongMsg;
        break;
    }
  }

  Future<void> _beforeLoginCheckConnectivity() async {
    if (connectivityResult != null &&
        connectivityResult == ConnectivityResult.none)
      throw SocketException("Internet Connection is not working");
    await auth
        .sendSignInLinkToEmail(
            email: _userEmail!, actionCodeSettings: settings.actionCodes)
        .timeout(DefaultDuration.sec20);
  }
}
