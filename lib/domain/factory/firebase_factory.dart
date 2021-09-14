import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/infrastructure/firebase_login_user/firebase_login_user_impl.dart';

enum FirebaseOperationType { register, login }

abstract class FirebaseUserFactory {
  T? create<T extends FirebaseBaseRepository>(FirebaseOperationType type);
}

class FirebaseUserFactoryImpl extends FirebaseUserFactory {
  @override
  T? create<T extends FirebaseBaseRepository>(FirebaseOperationType type) {
    switch (type) {
      case FirebaseOperationType.login:
        return FirebaseLoginUserRepoImpl() as T;
      case FirebaseOperationType.register:
        return FirebaseRegisterUserRepoImpl() as T;
    }
  }
}
