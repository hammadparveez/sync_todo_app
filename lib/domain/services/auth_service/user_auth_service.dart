import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/domain/services/auth_service/all_auth_builder.dart';
import 'package:notifications/export.dart';

class UserAuthService extends ChangeNotifier {
  final authBuilder = AllTypeAuthBuilder();
  EmailLinkAuthenticationRepo? _repo;

  void login() async {
    try {
      await authBuilder.login();
    } catch (e) {
      log("Exception $e");
    }
  }

  void register(String username, String email, String password) async {
    try {
      await authBuilder.register(username, email, password);
    } catch (e) {
      log("Exception $e");
    }
  }

  void signIn(String userID, String password) async {
    try {
      await authBuilder.signIn(userID, password);
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
    }
  }

  void loginWithEmail(String email) async {
    try {
      _repo = await authBuilder.loginWithEmail(email);
      _repo!.onLinkListener(
        onSuccess: _onSuccess,
        onError: _onError,
      );
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
    }
  }

  Future<dynamic> _onSuccess(PendingDynamicLinkData? linkData) async {
    try {
      log("OnLinkAuthenticate");
      await _repo!.onLinkAuthenticate(linkData);
    } catch (e) {
      log("Error onSucess: $e");
    }
  }

  Future<dynamic> _onError(OnLinkErrorException? error) async {
    log("Error $error in Link");
  }
}
