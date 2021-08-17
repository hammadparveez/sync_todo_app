import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/domain/repository/firebase_repo/add_user.dart';

class FirebaseAddUserRepoImpl extends FirebaseAddUserRepository {
  @override
  Future<T?> addUser<T>(String email) async {
    DocumentReference doc;
    final users = fireStore.collection("users");
    final querySnapshot = await users.where("email", isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      doc = await users.add({"email": email});
      log("User added");
      return (await doc.get()).data() as T;
    }
    return (querySnapshot.docs.first.data() as T);
  }
}
