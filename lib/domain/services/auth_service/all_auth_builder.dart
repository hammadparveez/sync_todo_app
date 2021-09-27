import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/auth_user_impl/email_link_auth_repo_impl.dart';
import 'package:notifications/infrastructure/auth_user_impl/firebase_login_user_impl.dart';

class AllTypeAuthBuilder {
  FirebaseRegisterWithIDPassRepo userRepo = FirebaseUserWithIDPassRepoImpl();

  Future<bool?> login() async {
    final googleSignInRepo = FirebaseGoogleAuthRepo();
    return await googleSignInRepo.login();
  }

  Future<bool> checkUserExists(String userID) async {
    try {
      await userRepo.checkUserExists(userID);
      return true;
    } catch (e) {
      return false;
    }
  }

  register(String username, String email, String password) async {
    await userRepo
        .createUserWithIDAndPass(UserAccountModel(email, username, password));
  }

  signIn(String userID, String password) async {
    await userRepo.loginUser(userID, password);
  }

  Future<EmailLinkAuthenticationRepo> loginWithEmail(
    String email,
  ) async {
    EmailLinkAuthenticationRepo repo = EmailLinkAuthRepoImpl();
    repo.setValue(email);
    await repo.login();
    return repo;
  }
}
