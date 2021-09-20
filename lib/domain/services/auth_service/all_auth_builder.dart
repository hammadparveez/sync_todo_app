import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/firebase_email_link/email_link_auth_repo_impl.dart';
import 'package:notifications/infrastructure/firebase_login_user/firebase_login_user_impl.dart';

class AllTypeAuthBuilder {
  FirebaseRegisterWithIDPassRepo userRepo = FirebaseUserWithIDPassRepoImpl();

  Future<void> login() async {
    final googleSignInRepo = FirebaseGoogleAuthRepo();
    await googleSignInRepo.login();
  }

  register(String username, String email, String password)async {
  await  userRepo
        .createUserWithIDAndPass(UserAccountModel(username, email, password));
  }

  signIn(String userID, String password) async{
    await userRepo.loginUser(userID, password);
  }

  Future<EmailLinkAuthenticationRepo> loginWithEmail(
    String email,
  ) async {
    EmailLinkAuthenticationRepo repo = EmailLinkAuthRepoImpl();
    repo.setValue(email);
    await repo.login();
    return repo;
    //repo.onLinkListener(onSucces, onError);
  }
}
