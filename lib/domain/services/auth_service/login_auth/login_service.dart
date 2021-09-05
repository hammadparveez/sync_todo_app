import 'package:flutter/foundation.dart';

abstract class LoginService extends ChangeNotifier {
  String? userID;
  bool isUserLoggedIn = false, isLoading = false;
  String? errMsg;
  

  login(String email, [String? password]);
  Future<void> logOut();
}
