import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/domain/services/action_code_service/auth_link_code_service.dart';
import 'package:notifications/domain/services/auth_service/auth_service.dart';

final loginPod = ChangeNotifierProvider<EmailLinkLoginService>((ref) {
  final ConnectivityResult? result = ref.watch(connectionPod).data?.value;
  return EmailLinkLoginService(EmailLinkActionCodeSettingsImpl(), result);
});

final connectionPod = StreamProvider<ConnectivityResult>((_) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});
