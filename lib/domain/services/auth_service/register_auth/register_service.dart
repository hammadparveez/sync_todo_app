import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:notifications/domain/model/register_model.dart';
import 'package:notifications/domain/services/network_service/network_service.dart';
import 'package:notifications/infrastructure/firebase_add_user/firebase_add_user_impl.dart';
import 'package:notifications/main.dart';
import 'package:notifications/resources/exceptions/exceptions.dart';

class RegisterUserService extends ChangeNotifier {
  bool hasAdded = false;
  String? _errorMsg;

  String? get errorMsg => _errorMsg;

  Future<void> register(String username, String email, String password) async {
    _errorMsg = null;
    try {
      final hasConnection = await getIt.get<NetworkService>().hasConnection();
      if (!hasConnection)
        throw NetworkFailure("Make Sure You got a connection");
      UserModel? model = await FirebaseRegisterUser()
          .addUser<UserModel>(UserModel(email, username, password));

      log("Model ${model?.toMap()}");
    } catch (e) {
      if (e is NetworkFailure) _errorMsg = e.msg;
    }
    notifyListeners();
  }
}
