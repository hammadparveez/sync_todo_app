import 'package:uuid/uuid.dart';

class UserAccountModel {
  final String password, method;
  final String? email, username;
  String? _uid;
  String? get uid => this._uid;

  UserAccountModel(this.email, this.username, this.password,
      {this.method = 'id-pass'})
      : _uid = Uuid().v4obj().uuid;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
      json['email'],
      json['username'],
      json['password'],
      method: json['method'],
    ).._uid = json['uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": this._uid,
      "email": this.email,
      "username": this.username,
      "password": this.password,
      'method': this.method,
    };
  }
}
