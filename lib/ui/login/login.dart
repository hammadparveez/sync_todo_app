import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:notifications/export.dart';
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
        Beamer.of(context).beamToNamed(Routes.login_with_google);
        break;
      case LoginType.unknown:
        Beamer.of(context).beamToNamed(Routes.register);
        break;
    }
  }

  Future<bool> _exitDialog(_) async {
    return await showDialog<bool>(
            context: _,
            builder: (context) {
              return AlertDialog(
                title: Text("Do you want to exit?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("OK")),
                  TextButton(
                      onPressed: () {
                        Beamer.of(_).popRoute();
                      },
                      child: Text("Cancel"))
                ],
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext _) {
    return WillPopScope(
      onWillPop: () => _exitDialog(_),
      child: Scaffold(
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
      ),
    );
  }
}
