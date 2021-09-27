abstract class BaseException implements Exception {
  final String msg;
  BaseException(this.msg);
}

class NetworkFailure extends BaseException {
  NetworkFailure(String msg) : super(msg);
}

class LoginFailure extends BaseException {
  LoginFailure(String msg) : super(msg);
}

class CredentialsInvalid extends BaseException {
  CredentialsInvalid(String msg) : super(msg);
}

class SignUpFailure extends BaseException {
  SignUpFailure(String msg) : super(msg);
}

class UnknownException extends BaseException {
  UnknownException(String msg) : super(msg);
}
