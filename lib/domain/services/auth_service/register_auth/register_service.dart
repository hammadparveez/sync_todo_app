import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:notifications/domain/model/register_model.dart';
import 'package:notifications/infrastructure/firebase_add_user/firebase_add_user_impl.dart';

class RegisterUserService extends ChangeNotifier {
  bool hasAdded = false;

  Future<void> register(String username, String email, String password) async {
    try {
      UserModel? model = await FirebaseRegisterUser()
          .addUser<UserModel>(UserModel(email, username, password)).catchError((_){log("Notifier Error -> $_")});

      log("Model ${model?.toMap()}");
    } catch (e) {
      log("Find Wrong:");
    }
  }
}
