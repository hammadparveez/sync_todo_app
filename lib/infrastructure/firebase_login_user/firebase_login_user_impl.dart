import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';

class FirebaseLoginUserRepoImpl extends FirebaseLoginUserRepo {
  @override
  Future<T> get<T>() {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<T> getUser<T>(String userID) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}

class FirebaseRegisterUserRepoImpl extends FirebaseRegisterWithIDPassRepo {
  @override
  Future<T> add<T>() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<T> createUserWithIDAndPass<T>(UserAccountModel model)async  {
     log("FirebaseRegisterUser -> AddUser");
    try {
      final usernameQuerySnapshot = await fireStore
          .collection(USERS)
          .where('username', isEqualTo: model.username)
          .get();
      final emailQuerySnapshot = await fireStore
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
        await fireStore.collection(USERS).doc().set(model.toMap());
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    }
   return model as T;
  }
}
