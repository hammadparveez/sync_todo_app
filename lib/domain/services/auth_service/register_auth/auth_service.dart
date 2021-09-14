import 'package:notifications/domain/factory/firebase_factory.dart';
import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';

class AuthService extends ChangeNotifier {
  String? _errorMsg;
  String? get errorMsg => this._errorMsg;

  Future<void> createUser(
      String username, String email, String password) async {
    final userRegisterRepo = FirebaseUserFactoryImpl()
        .create<FirebaseRegisterWithIDPassRepo>(FirebaseOperationType.register);
    try {
      await userRegisterRepo!
          .createUserWithIDAndPass(UserAccountModel(email, username, password));
    } on BaseException catch (e) {
      _errorMsg = e.msg;
    }
    notifyListeners();
  }
}
