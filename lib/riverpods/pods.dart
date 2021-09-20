import 'package:notifications/config/dynamic_linking_config/auth_link_code_config.dart';


import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';



final loginPod = ChangeNotifierProvider<UserAuthService>((ref) {
  return UserAuthService();
});



final connectionPod = StreamProvider<ConnectivityResult>((_) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});

final addTodoItemPod = ChangeNotifierProvider((_) => AddTodoItemService());
