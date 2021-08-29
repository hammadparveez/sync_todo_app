import 'dart:async';
import 'dart:developer';

import 'package:notifications/export.dart';

//import 'package:notifications/resources/extensions/timeout_ext.dart';

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
            await fs
                .collection(USERS)
                .doc(model.email)
                .set(model.toMap())
                .withDefaultTimeOut;

        },
      ).withDefaultTimeOut;

      return model as T;
    } on FirebaseException catch (e) {
      log("RegisterUser->FirebaseException $e");
      throw NetworkFailure(ExceptionsMessages.somethingWrongMsg);
    } on TimeoutException catch (e) {
      log("RegisterUser->TimeOutException $e");
      throw NetworkFailure(ExceptionsMessages.somethingWrongInternetMsg);
    }
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
