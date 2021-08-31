import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/domain/services/action_code_service/auth_link_code_service.dart';
import 'package:notifications/domain/services/auth_service/login_auth/email_link_auth_service.dart';
import 'package:notifications/domain/services/auth_service/register_auth/register_service.dart';

final loginPod = ChangeNotifierProvider<EmailLinkLoginService>((ref) {
  return EmailLinkLoginService(EmailLinkActionCodeSettingsImpl());
});

final registerPod = ChangeNotifierProvider<AuthUserService>((ref) {
  return AuthUserService();
});

final connectionPod = StreamProvider<ConnectivityResult>((_) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});
