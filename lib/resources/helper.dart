import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/global_variables.dart';
import 'package:flash/flash.dart';

///Pop or close any dialog or screen, despite of BuildContext
void popRoute() => AppState.routerDelegate.navigator.pop();

///Checks for connection with Host as well, Returns boolean value
Future<bool> get hasConnection async {
  return await getIt.get<NetworkService>().hasConnection();
}

///Checks for connection with Host as well, Returns with a default Message
Future<String?> hasNetworkError() async {
  return await getIt.get<NetworkService>().hasNetworkError();
}

///Checks for network connectivity and shows Default Error, if hasNoError then cb() is called
Future<void> networkCheckCallback(BuildContext context, VoidCallback cb) async {
  final error = await hasNetworkError();
  if (error != null) return context.showErrorBar(content: Text(error));
  cb();
}

//Converting FirebaseExceptions into Custom Exceptions
void firebaseToGeneralException(FirebaseException e) {
  log("firebaseToGeneralException() -> $e");
  if (e.code == UNAVAILABLE || (NETWORK_FAILED == e.code))
    throw NetworkFailure(ExceptionsMessages.somethingWrongInternetMsg);
  else if (e.code == PERMISSION_DENIED || UNKNOWN == e.code)
    throw UnknownException(ExceptionsMessages.unexpectedError);
  else if (INVALID_EMAIL == e.code)
    throw CredentialsInvalid(ExceptionsMessages.invalidEmailMsg);
  else if (USER_EXISTS == e.code) throw CredentialsInvalid(e.message!);
}

//Converting PlatformExceptions e.g(Google Account Authentication) into Custom Exceptions
void platformToGeneralException(PlatformException e) {
  log("PlatformException() ${e.code}");
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

// String? getGeneralExceptionMsg(BaseException e) {
//   switch (e.runtimeType) {
//     case NetworkFailure:
//       return e.msg;
//     case CredentialsInvalid:
//       return e.msg;
//   }
// }
