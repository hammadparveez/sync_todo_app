import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/globals.dart';
import 'package:flash/flash.dart';

Future<bool> get hasConnection async {
  return await getIt.get<NetworkService>().hasConnection();
}

Future<String?> hasNetworkError() async {
  return await getIt.get<NetworkService>().hasNetworkError();
}

Future<void> networkCheckCallback(BuildContext context, VoidCallback cb) async {
  final error = await hasNetworkError();
  if (error != null) return context.showErrorBar(content: Text(error));
  cb();
}

Future<void> closeAnyPopup(BuildContext context, bool isOpened) async =>
    isOpened ? await Beamer.of(context).popRoute() : null;

void firebaseToGeneralException(FirebaseException e) {
  log("ExceptionFirebase -> $e");
  if (e.code == UNAVAILABLE || (NETWORK_FAILED == e.code))
    throw NetworkFailure(ExceptionsMessages.somethingWrongInternetMsg);
  else if (e.code == PERMISSION_DENIED || UNKNOWN == e.code)
    throw UnknownException(ExceptionsMessages.unexpectedError);
  else if (INVALID_EMAIL == e.code)
    throw CredentialsInvalid(ExceptionsMessages.invalidEmailMsg);
  else if (USER_EXISTS == e.code) throw CredentialsInvalid(e.message!);
}

void platformToGeneralException(PlatformException e) {
  log("PlatformException: ${e.code}");
  switch (e.code) {
    case NETWORK_ERROR:
      throw NetworkFailure(ExceptionsMessages.somethingWrongInternetMsg);
    case SIGN_IN_FAILED:
      throw LoginFailure("Failed to Sign In, Please try again!");
    case USER_EXISTS:
      throw LoginFailure(e.message!);

    default:
      throw UnknownException(ExceptionsMessages.unexpectedError);
  }
}

String? getGeneralExceptionMsg(BaseException e) {
  switch (e.runtimeType) {
    case NetworkFailure:
      return e.msg;
    case CredentialsInvalid:
      return e.msg;
  }
}
