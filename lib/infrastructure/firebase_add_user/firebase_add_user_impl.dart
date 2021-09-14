import 'dart:async';
import 'dart:developer';

import 'package:notifications/export.dart';

//import 'package:notifications/resources/extensions/timeout_ext.dart';




class FirebaseRegisterUser {
  final fs = FirebaseFirestore.instance;

  Future<T?> addUser<T>(UserAccountModel model) async {
    log("FirebaseRegisterUser -> AddUser");
    try {
      final usernameQuerySnapshot = await fs
          .collection(USERS)
          .where('username', isEqualTo: model.username)
          .get();
      final emailQuerySnapshot = await fs
          .collection(USERS)
          .where('email', isEqualTo: model.email)
          .get();
      final usersDocs = usernameQuerySnapshot.docs;
      final emailDocs = emailQuerySnapshot.docs;
      //emailQuerySnapshot.docs.isNotEmpty;
      if (usersDocs.isNotEmpty) {
        final username = usersDocs.first.data()['username'];
        if (username == model.username)
          throw CredentialsInvalid("Username $username already exists");
      } else if (emailDocs.isNotEmpty) {
        final data = emailDocs.first.data();
        log("Data: $data  AND ${data['method'] != 'id-pass'}");
        if (data['email'] == model.email && data['method'] != 'id-pass')
          throw CredentialsInvalid(
              "User was registered via different method ${data['method']}");
        else if (data['email'] == model.email)
          throw CredentialsInvalid("Email ${data['email']} already exists");
      } else
        await fs.collection(USERS).doc().set(model.toMap());

      return model as T;
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    }
  }

  Future<UserAccountModel?> getUser(String usernameOrEmail, String password) async {
    log("RegisterUserRepo -> ()");
    try {
      final querySnapshot = await fs.collection(USERS).get();
      final user = _tryToFindUser(querySnapshot, usernameOrEmail, password);
      return UserAccountModel.fromJson(user);
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
    },
        orElse: () =>
            throw CredentialsInvalid("Username/Email does not exists"));

    if (doc.data()['method'] != 'id-pass')
      throw CredentialsInvalid(
          "User was registered with a different method ${doc.data()['method']}");
    else if (doc.data()['password'] != password)
      throw CredentialsInvalid("Please enter a correct password");
    return doc.data();
  }
}
