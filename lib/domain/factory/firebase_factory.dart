import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/auth_user_impl/firebase_login_user_impl.dart';

enum AuthenticationServiceType { defaultAuthService }

abstract class AuthenticationFactory {
  T? create<T extends UserAccountRepository>();
}

class UserAccountAuthFactory extends AuthenticationFactory {
  @override
  T? create<T extends UserAccountRepository>() {
    switch (T) {
      case UserAuthenticationRepositoryImpl:
        return UserAuthenticationRepositoryImpl() as T;
    }
  }
}
