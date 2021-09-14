import 'package:notifications/domain/factory/firebase_factory.dart';
import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';

class AuthService extends ChangeNotifier {
  String? _errorMsg;
  String? get errorMsg => this._errorMsg;
  final userRegisterRepo = FirebaseUserFactoryImpl()
      .create<FirebaseRegisterWithIDPassRepo>(
          FirebaseOperationType.registerWithIdPass);

  Future<void> createUser(
      String username, String email, String password) async {
    try {
      await userRegisterRepo!
          .createUserWithIDAndPass(UserAccountModel(email, username, password));
    } on BaseException catch (e) {
      log("Exception : ${e.msg}");
      _errorMsg = e.msg;
    }
    notifyListeners();
  }

  Future<void> login(String userID, String password) async {
    try {
      await userRegisterRepo!.loginUser(userID, password);
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
    }
  }
}
