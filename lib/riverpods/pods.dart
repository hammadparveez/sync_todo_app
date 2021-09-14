
import 'package:notifications/domain/services/auth_service/register_auth/auth_service.dart';
import 'package:notifications/export.dart';

final loginPod = ChangeNotifierProvider<EmailLinkLoginService>((ref) {
  return EmailLinkLoginService(EmailLinkActionCodeSettingsImpl());
});

final googleSignInPod = ChangeNotifierProvider<GoogleSignInAuth>((ref) {
  return GoogleSignInAuth();
});

final loginWithIdAndPassPod =
    ChangeNotifierProvider((_) => EmailAndPasswordService());

final registerPod = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

final connectionPod = StreamProvider<ConnectivityResult>((_) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});

final addTodoItemPod = ChangeNotifierProvider((_) => AddTodoItemService());
