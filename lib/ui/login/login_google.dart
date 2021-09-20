import 'dart:developer';


import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  _onChange(BuildContext context, UserAuthService service) {
    // if (service.errMsg != null) WidgetUtils.snackBar(context, service.errMsg!);
    // if (service.isUserLoggedIn) {
    //   Beamer.of(context).popToNamed(Routes.home, stacked: false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Sign In via Google"),
          onPressed: () async {
            context.read(loginPod).login();
          },
        ),
      ),
    );
  }
}
