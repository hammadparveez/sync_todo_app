import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/local/local_storage.dart';

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
          throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
              UserTypeMatchModel.simplifyUserMethod(data['method']));
        else if (data['email'] == model.email)
          throw CredentialsInvalid("Email ${data['email']} already exists");
      } else {
        await fireStore.collection(USERS).doc().set(model.toMap());
        await LocallyStoredData.storeUserKey(model.uid);
        log("Before Signing Up Get Key: ${LocallyStoredData.getSessionID()}");
      }
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    }
    return model as T;
  }

  @override
  Future<T?> loginUser<T>(String userID, String password) async {
    log("Register LoginRepository New -> ()");

    try {
      final data = await _tryToFindUser(userID, password);
      final user = UserAccountModel.fromJson(data!);
      Hive.box(LOGIN_BOX).put(USER_KEY, user.uid);
      log("User $user");
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on CredentialsInvalid catch (e) {
      throw CredentialsInvalid(e.msg);
    }
  }

  @override
  Future<Map<String, dynamic>> checkUserExists(
    String userID,
  ) async {
    final querySnapshot = await fireStore.collection(USERS).get();
    final doc = querySnapshot.docs.firstWhere(
      (user) {
        final data = user.data();
        return ((data["username"] == userID) || (data["email"] == userID))
            ? true
            : false;
      },
      orElse: () => throw CredentialsInvalid(
          ExceptionsMessages.userNotExistsWith + userID),
    );
    return doc.data();
  }

  Future<Map<String, dynamic>>? _tryToFindUser(
    String userID,
    String password,
  ) async {
    final data = await checkUserExists(userID);
    if (data['method'] != 'id-pass')
      throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
          UserTypeMatchModel.simplifyUserMethod(data['method']));
    else if (data['password'] != password)
      throw CredentialsInvalid("Please enter a correct password");
    log("TrytoFindUser ${data}");
    return data;
  }
}
