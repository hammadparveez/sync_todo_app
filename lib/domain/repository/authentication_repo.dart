
import 'package:notifications/domain/model/user_account_model.dart';
import 'package:notifications/domain/repository/firebase_repos/firebase_user_repo.dart';

import 'package:notifications/export.dart';

abstract class UserAccountRepository extends FirebaseBaseRepository
    implements
        LoginRepository,
        EmailLinkAuthenticationRepo,
        LoginWithIdOnlyRepository {
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

abstract class EmailLinkAuthenticationRepo extends LoginRepository {
  @protected
  bool isEmailLinkValid(String link);
  void onLinkListener(
      {required OnLinkSuccessCallback onSuccess,
      required OnLinkErrorCallback onError});
  Future<dynamic> onLinkAuthenticate(PendingDynamicLinkData? linkData);
}
