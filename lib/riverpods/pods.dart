
import 'package:notifications/export.dart';

final loginPod = ChangeNotifierProvider<EmailLinkLoginService>((ref) {
  return EmailLinkLoginService(EmailLinkActionCodeSettingsImpl());
});

final googleSignInPod = ChangeNotifierProvider<GoogleSignInAuth>((ref) {
  return GoogleSignInAuth();
});

final loginWithIdAndPassPod =
    ChangeNotifierProvider((_) => EmailAndPasswordService());

final registerPod = ChangeNotifierProvider<AuthUserService>((ref) {
  return AuthUserService();
});

final connectionPod = StreamProvider<ConnectivityResult>((_) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});

final addTodoItemPod = ChangeNotifierProvider((_) => AddTodoItemService());
