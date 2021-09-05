import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:notifications/export.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  _onChange(BuildContext context, LoginService service) {
    if (service.isUserLoggedIn) {
      Beamer.of(context).popToNamed(Routes.home, stacked: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: googleSignInPod,
      onChange: (_, LoginService service) => _onChange(context, service),
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text("Sign In via Google"),
            onPressed: () async {
              context.read(googleSignInPod).login("");
            },
          ),
        ),
      ),
    );
  }
}
