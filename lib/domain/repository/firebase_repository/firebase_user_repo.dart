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

abstract class FirebaseRegisterWithIDPassRepo extends FirebaseAddRepository {
  Future<T> createUserWithIDAndPass<T>(UserAccountModel model);

  Future<T?> loginUser<T>(String userID, String password);

  Future<Map<String, dynamic>> checkUserExists(String userID);
}

abstract class AuthRepository extends FirebaseBaseRepository
    implements FirebaseAddRepository, FirebaseGetRepo {
  Future<bool?> login();
}

abstract class ValueSetter {
  void setValue(String email);
}

abstract class EmailLinkAuthenticationRepo extends AuthRepository
    implements ValueSetter {
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
