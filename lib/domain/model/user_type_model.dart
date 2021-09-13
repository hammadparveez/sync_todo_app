class UserExiststanceModel {
  final String userID, sessionId, userMethod;

  UserExiststanceModel({required this.userID, required this.sessionId, required this.userMethod});

  factory UserExiststanceModel.fromJson(Map<String, dynamic> json) {
    return UserExiststanceModel(
        sessionId: json['uid'],
        userID: json['email'], userMethod: json['method']);
  }
}
