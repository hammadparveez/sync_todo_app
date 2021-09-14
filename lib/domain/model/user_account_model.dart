import 'package:uuid/uuid.dart';

class UserAccountModel {
  final String password, method;
  final String? email, username;
  String? uid = Uuid().v4obj().uuid;

  UserAccountModel(this.email, this.username, this.password, [this.method = 'id-pass', this.uid]);

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
      json['email'],
      json['username'],
      json['password'],
      json['method'],
      json['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": this.uid,
      "email": this.email,
      "username": this.username,
      "password": this.password,
      'method': this.method,
    };
  }
}
