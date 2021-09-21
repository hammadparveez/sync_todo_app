import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';

class FirebaseUserWithIDPassRepoImpl extends FirebaseRegisterWithIDPassRepo {
  @override
  Future<T> add<T>() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<T> createUserWithIDAndPass<T>(UserAccountModel model) async {
    log("FirebaseRegisterUser -> CreateUserWithIDAndPass");
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

  @override
  Future<T?> loginUser<T>(String userID, String password) async {
    log("Register LoginRepository New -> ()");

    try {
      final querySnapshot = await fireStore.collection(USERS).get();
      final data = _tryToFindUser(querySnapshot, userID, password);
      final user = UserAccountModel.fromJson(data!);
      Hive.box(LOGIN_BOX).put(USER_KEY, user.uid);
      log("User $user");
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on CredentialsInvalid catch (e) {
      throw CredentialsInvalid(e.msg);
    }
  }

  Map<String, dynamic>? _tryToFindUser(
    QuerySnapshot<Map<String, dynamic>> querySnapshot,
    String userID,
    String password,
  ) {
    final doc = querySnapshot.docs.firstWhere((user) {
      final data = user.data();

      return ((data["username"] == userID) || (data["email"] == userID))
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
    log("TrytoFindUser ${doc.data()}");
    return doc.data();
  }
}
