
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';



final loginPod = ChangeNotifierProvider<UserAuthService>((ref) {
  return UserAuthService();
});


final addTodoItemPod = ChangeNotifierProvider((_) => AddTodoItemService());
