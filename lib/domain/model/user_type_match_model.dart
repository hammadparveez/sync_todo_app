class UserTypeMatchModel {
  final String userID, sessionId, userMethod;

  static const mIdAndPass ='id-pass';
  static const mGoogleSignIn = 'google-signin';
  static const mEmailLinkAuth = 'email-link-auth';

  factory UserTypeMatchModel.fromJson(Map<String, dynamic> json) {
    return UserTypeMatchModel._(
        sessionId: json['uid'],
        userID: json['email'],
        userMethod: json['method']);
  }

  UserTypeMatchModel._(
      {required this.userID,
      required this.sessionId,
      required this.userMethod});

  static String simplifyUserMethod(String method) {
    switch (method) {
      case mIdAndPass:
        return "Default Account";

      case mGoogleSignIn:
        return "Google Account";

      case mEmailLinkAuth:
        return "Email Link Authentication";

      default:
        return 'Unkown method';
    }
  }
}
