import 'package:uuid/uuid.dart';

class UserModel {
  final String email, username, password;
  String uid = Uuid().v4obj().uuid;
  final currentTime = DateTime.now().microsecondsSinceEpoch.toString();

  UserModel(this.email, this.username, this.password);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['email'],
      json['username'],
      json['password'],
    )..uid = json['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": this.uid,
      "email": this.email,
      "username": this.username,
      "password": this.password,
    };
  }
}
