import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/export.dart';

abstract class FirebaseBaseRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
}

abstract class FirebaseAddRepository extends FirebaseBaseRepository {
  @protected
  Future<T> add<T>();
}

abstract class FirebaseGetRepo extends FirebaseBaseRepository {
  @protected
  Future<T> get<T>();
}

abstract class UserAccountRepository extends FirebaseBaseRepository
    implements LoginRepository, EmailLinkAuthenticationRepo , LoginWithIdOnlyRepository {
  Future<T> signUp<T>(UserAccountModel model);

  Future<T?> signIn<T>(String userID, String password);

  Future<Map<String, dynamic>> checkUserExists(String userID);
}

abstract class LoginRepository extends FirebaseBaseRepository
    implements FirebaseAddRepository, FirebaseGetRepo {
  Future<bool?> login();
}

abstract class LoginWithIdOnlyRepository {
  Future<T?> loginViaID<T>(String userID);
}

abstract class ValueSetter {
  void setValue(String email);
}

abstract class EmailLinkAuthenticationRepo extends LoginRepository {
  @protected
  bool isEmailLinkValid(String link);
  void onLinkListener(
      {required OnLinkSuccessCallback onSuccess,
      required OnLinkErrorCallback onError});
  Future<dynamic> onLinkAuthenticate(PendingDynamicLinkData? linkData);
}

abstract class FirebaseLoginUserRepo extends FirebaseGetRepo {
  Future<T> getUser<T>(String userID);
}
