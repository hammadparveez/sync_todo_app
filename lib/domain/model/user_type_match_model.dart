class UserTypeMatchModel {
  final String userID, sessionId, userMethod;

  factory UserTypeMatchModel.fromJson(Map<String, dynamic> json) {
    return UserTypeMatchModel._(
        sessionId: json['uid'],
        userID: json['email'],
        userMethod: UserTypeMatchModel.simplifyUserMethod(json['method']));
  }

  UserTypeMatchModel._(
      {required this.userID,
      required this.sessionId,
      required this.userMethod});

  static String simplifyUserMethod(String method) {
    switch (method) {
      case 'id-pass':
        return "Default Account";

      case 'google-signin':
        return "Google Account";

      case 'email-link-auth':
        return "Email Link Authentication";

      default:
        return 'Unkown method';
    }
  }
}
