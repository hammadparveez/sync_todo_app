import 'dart:developer';

import 'package:notifications/export.dart';

Future<bool> get hasConnection async {
  final isConnected = await getIt.get<NetworkService>().hasConnection();
  return isConnected ? true : false;
}

void firebaseToGeneralException(FirebaseException e) {
  log("ExceptionFirebase -> $e");
  if (e.code == UNAVAILABLE)
    throw NetworkFailure(ExceptionsMessages.somethingWrongInternetMsg);
  else if (e.code == PERMISSION_DENIED)
    throw UnknownException(ExceptionsMessages.unexpectedError);
}

String? getGeneralExceptionMsg(BaseException e) {
  switch (e.runtimeType) {
    case NetworkFailure:
      return e.msg;
    case CredentialsInvalid:
      return e.msg;
  }
}
