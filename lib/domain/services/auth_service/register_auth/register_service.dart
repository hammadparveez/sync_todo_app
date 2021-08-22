import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:notifications/domain/model/register_model.dart';
import 'package:notifications/infrastructure/firebase_add_user/firebase_add_user_impl.dart';
import 'package:notifications/resources/exceptions/exceptions.dart';

class RegisterUserService extends ChangeNotifier {
  bool hasAdded = false;
  String? _errorMsg;

  String? get errorMsg => _errorMsg;

  Future<void> register(String username, String email, String password) async {
    _errorMsg = null;
    try {
      UserModel? model = await FirebaseRegisterUser()
          .addUser<UserModel>(UserModel(email, username, password));

      log("Model ${model?.toMap()}");
    } catch (e) {
      if (e is NetworkFailure) _errorMsg = e.msg;
    }
    notifyListeners();
  }
}
