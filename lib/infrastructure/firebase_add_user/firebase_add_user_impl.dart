import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/domain/model/register_model.dart';
import 'package:notifications/domain/repository/firebase_repo/add_user.dart';

const USERS = "users";

class FirebaseAddUserRepoImpl extends FirebaseAddUserRepository {
  @override
  Future<T?> addUser<T>(String email) async {
    DocumentReference doc;
    final users = fireStore.collection(USERS);
    final x = await CheckingExistingUserFirebase(users)
        .findIfExists("email", isEqualTo: email);
    log("Checking inside XX $x");
    final querySnapshot = await users.where("email", isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      doc = await users.add({"email": email});
      log("User added");
      return (await doc.get()).data() as T;
    }
    return (querySnapshot.docs.first.data() as T);
  }
}

/**
* We need to return QuerySnapshot
 * Collection Reference to get QuerySnapShot
* return Existing User
* */

class FirebaseRegisterUser {
  final fs = FirebaseFirestore.instance;

  Future<T?> addUser<T>(UserModel model) async {
    try {
      final querySnapshot =
          await fs.collection(USERS).doc(model.email).get().catchError((_) {
        log("Add->User->CatchError ${_.runtimeType}");
      });
      // if (!querySnapshot.exists)
      await fs.collection(USERS).doc(model.email).set(model.toMap());
      //else
      log("Exists Already");
      return model as T;
    } on FirebaseException catch (e) {
      log("AddUser->FirebaseException->Catch ${e}");
    } catch (e) {
      log("Add->User->Error ${e.runtimeType}");
    }
    return null;
  }
}

class CheckingExistingUserFirebase {
  final CollectionReference collection;
  CheckingExistingUserFirebase(this.collection);

  Future<QuerySnapshot> findIfExists(
    field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    final querySnapShot = await collection
        .where(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        )
        .get();

    return querySnapShot;
  }
}
