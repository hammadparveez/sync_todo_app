import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/infrastructure/auth_user_impl/firebase_login_user_impl.dart';

enum FirebaseOperationType {
  registerWithIdPass,
  loginWithIdPass,
  googleAuth,
  emailLink
}

abstract class FirebaseUserFactory {
  T? create<T extends FirebaseBaseRepository>(FirebaseOperationType type);
}

class FirebaseUserFactoryImpl extends FirebaseUserFactory {
  @override
  T? create<T extends FirebaseBaseRepository>(FirebaseOperationType type) {
    switch (type) {
      case FirebaseOperationType.loginWithIdPass:
        break;

      case FirebaseOperationType.registerWithIdPass:
        return FirebaseUserWithIDPassRepoImpl() as T;
      case FirebaseOperationType.googleAuth:
        break;
      case FirebaseOperationType.emailLink:
        break;
      //return FirebaseUserWithIDPassRepoImpl() as T;
    }
  }
}
