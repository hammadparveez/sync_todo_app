abstract class BaseException implements Exception {
  final String msg;
  BaseException(this.msg);
}

class NetworkFailure implements BaseException {
  final String msg;
  NetworkFailure(this.msg);
}

class LoginFailure implements BaseException {
  final String msg;
  LoginFailure(this.msg);
}


class CredentialsInvalid implements BaseException {
  final String msg;
  CredentialsInvalid(this.msg);
}

class SignUpFailure implements BaseException {
  final String msg;
  SignUpFailure(this.msg);
}

class UnknownException implements BaseException {
  final String msg;
  UnknownException(this.msg);
}
