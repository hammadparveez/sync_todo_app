class UserTypeMatchModel {
  final String userID, sessionId, userMethod;

  factory UserTypeMatchModel.fromJson(Map<String, dynamic> json) {
    return UserTypeMatchModel._(
        sessionId: json['uid'],
        userID: json['email'], userMethod: json['method']);
  }

   UserTypeMatchModel._({required this.userID, required this.sessionId, required this.userMethod});
}
