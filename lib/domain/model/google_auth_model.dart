import 'package:notifications/export.dart';
import 'package:uuid/uuid.dart';

class GoogleAuthModel {
  late String uid, email, displayName, img_url, method;
  GoogleAuthModel.fromJson(Map<String, dynamic> json) {
    this.uid = json['uid'];
    this.email = json['email'];
    this.displayName = json['displayName'];
    this.method = json['method'];
  }

  static Map<String, dynamic> toMap(GoogleSignInAccount user) {
    return {
      'uid': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'method': 'google-signin',
    };
  }
}

class EmailLinkAuthModel {
  final String uid, email, method;

  EmailLinkAuthModel({required this.uid, required this.email,required this.method});

  factory EmailLinkAuthModel.fromJson(Map<String, dynamic> json) {
     return EmailLinkAuthModel(uid : json['uid'],
    email : json['email'], method:  json['method']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'email': this.email,
      'method': this.method,
    };
  }
}
