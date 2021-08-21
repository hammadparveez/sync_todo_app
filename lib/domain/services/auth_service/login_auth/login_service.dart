import 'package:flutter/foundation.dart';

abstract class LoginService extends ChangeNotifier {
  String? userID;
  bool isUserLoggedIn = false;

  login(String email, [String? password]);
  Future<void> logOut();
}
