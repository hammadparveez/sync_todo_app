import 'package:notifications/domain/factory/firebase_factory.dart';
import 'package:notifications/export.dart';

abstract class LoginAuthService extends ChangeNotifier {
  Future<void> login();
}

 class UserIDPassAuthService extends LoginAuthService {
  final UserAccountModel model;
  
  UserIDPassAuthService(this.model);
  @override
  Future<void> login() async {
       try {
        
     // return user;
    } on BaseException catch (e) {
      log("RegisterService -> Exception:  $e");
    
    } catch (e) {
      log("!!!!!!EXCEPTION!!!!!! $e");
    }
  }

  
}
