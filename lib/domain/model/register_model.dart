import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email, username, password;
  late String uid;
  final currentTime = DateTime.now().microsecondsSinceEpoch.toString();
  final randomTime =
      Timestamp.fromMicrosecondsSinceEpoch(Random(1000).nextInt(99999))
          .nanoseconds
          .toString();
  UserModel(this.email, this.username, this.password) {
    this.uid = currentTime + randomTime;
  }

  /*(BigInt.from(DateTime.now().microsecondsSinceEpoch)
                .toString() +
            BigInt.from(Random(pow(1, 1).toInt()).nextInt(pow(9, 9).toInt()))
                .toString());
*/
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['email'],
      json['username'],
      json['password'],
    );
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
