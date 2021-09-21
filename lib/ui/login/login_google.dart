import 'dart:developer';

import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  _onChange(BuildContext context, UserAuthService service) {
    log("User Session ${service.sessionID}");
    if (service.errorMsg != null)
      WidgetUtils.snackBar(context, service.errorMsg!);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: loginPod,
      onChange: _onChange,
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text("Sign In via Google"),
            onPressed: () async {
              if (await context.read(loginPod).login())
                Beamer.of(context).popToNamed(Routes.home,
                    replaceCurrent: true, stacked: false);
            },
          ),
        ),
      ),
    );
  }
}
