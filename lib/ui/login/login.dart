import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:notifications/resources/constants/routes.dart';

enum LoginType { emailLink, idPassword, googleAuth, unknown }

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  loginWith(BuildContext context, LoginType type) {
    switch (type) {
      case LoginType.emailLink:
        Beamer.of(context).beamToNamed(Routes.email_link_auth);
        break;
      case LoginType.idPassword:
        Beamer.of(context).beamToNamed(Routes.login_id_pass);
        break;
      case LoginType.googleAuth:
        Beamer.of(context).beamToNamed("/google-auth");
        break;
      case LoginType.unknown:
        Beamer.of(context).beamToNamed(Routes.register);
        break;
    }
  }

  @override
  Widget build(BuildContext _) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => loginWith(_, LoginType.emailLink),
                child: Text("Email Link Authentication")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => loginWith(_, LoginType.idPassword),
                child: Text("Username & Password Authentication")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => loginWith(_, LoginType.googleAuth),
                child: Text("Sign In with Google Authentication")),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () => loginWith(_, LoginType.unknown),
                child: Text("Create an Account")),
          ],
        ),
      ),
    );
  }
}
