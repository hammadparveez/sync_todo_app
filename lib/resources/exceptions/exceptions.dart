class NetworkFailure implements Exception {
  final String msg;
  NetworkFailure(this.msg);
}

class LoginFailure implements Exception {
  final String msg;
  LoginFailure(this.msg);
}

class SignUpFailure implements Exception {
  final String msg;
  SignUpFailure(this.msg);
}

class UnknownException implements Exception {
  final String msg;
  UnknownException(this.msg);
}
