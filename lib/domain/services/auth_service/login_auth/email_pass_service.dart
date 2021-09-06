import 'package:notifications/domain/services/auth_service/login_auth/login_service.dart';
import 'package:notifications/export.dart';

class EmailAndPasswordService extends LoginService {
  final firebase = FirebaseRegisterUser();
  @override
  Future<void> logOut() async {}

  @override
  void login(String email, [String? password]) async {
    isUserLoggedIn = false;
    errMsg = null;
    
    final model = await _tryToGetUser(email, password!);
    if (model != null) {
      Hive.box(LOGIN_BOX).put(USER_KEY, true);
      isUserLoggedIn = true;
    }
    //isLoading = false;
    notifyListeners();
  }

  Future<UserModel?> _tryToGetUser(
      String usernameOrEmail, String password) async {
    try {
      final user = await firebase.getUser(usernameOrEmail, password);
      return user;
    } on BaseException catch (e) {
      log("RegisterService -> Exception:  $e");
      errMsg = getGeneralExceptionMsg(e);
    } catch (e) {
      log("!!!!!!EXCEPTION!!!!!! $e");
    }
  }
}
