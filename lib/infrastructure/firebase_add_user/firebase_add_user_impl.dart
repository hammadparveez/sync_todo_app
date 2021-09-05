import 'dart:async';
import 'dart:developer';

import 'package:notifications/export.dart';

//import 'package:notifications/resources/extensions/timeout_ext.dart';

const USERS = "users";

class FirebaseAddUserRepoImpl extends FirebaseAddUserRepository {
  @override
  Future<T?> addUser<T>(String email) async {}
}

class FirebaseRegisterUser {
  final fs = FirebaseFirestore.instance;

  Future<T?> addUser<T>(UserModel model) async {
    log("FirebaseRegisterUser -> AddUser");
    try {
      await fs.collection(USERS).doc(model.email).get().then(
        (doc) async {
          log("Before Registering");
          if (doc.exists)
            throw SignUpFailure("User already exists");
          else
            await fs.collection(USERS).doc(model.email).set(model.toMap());
        },
      );

      return model as T;
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    }
  }

  Future<UserModel?> getUser(String usernameOrEmail, String password) async {
    log("RegisterUserRepo -> ()");

    try {
      final querySnapshot = await fs.collection(USERS).get(fireStoreOption);
      final user = _tryToFindUser(querySnapshot, usernameOrEmail, password);
      return UserModel.fromJson(user);
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on CredentialsInvalid catch (e) {
      throw CredentialsInvalid(e.msg);
    }
  }

  Map<String, dynamic> _tryToFindUser(
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      String usernameOrEmail,
      String password) {
    final doc = querySnapshot.docs.firstWhere((user) {
      final data = user.data();
      return ((data["username"] == usernameOrEmail) ||
              (data["email"] == usernameOrEmail))
          ? true
          : false;
    }, orElse: () => throw CredentialsInvalid("Username/Email is Incorrect"));
    if (doc.data()['password'] != password)
      throw CredentialsInvalid("Please enter a correct password");
    return doc.data();
  }
}
