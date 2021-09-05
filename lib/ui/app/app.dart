import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'package:notifications/resources/constants/app_strings.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/ui/auth_widget/auth_widget.dart';
import 'package:notifications/ui/home/home.dart';
import 'package:notifications/ui/login/login.dart';
import 'package:notifications/ui/login/login_google.dart';
import 'package:notifications/ui/login/login_with_email.dart';
import 'package:notifications/ui/login/login_with_id_pass.dart';
import 'package:notifications/ui/signup/sign_up.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final routerDelegate = BeamerDelegate(
      locationBuilder: SimpleLocationBuilder(
    routes: {
      Routes.main: (_, state) => AuthCheckWidget(
          signedInWidget: const Home(), notSignedInWidget: LoginScreen()),
      Routes.register: (_, state) => SignUp(),
      Routes.email_link_auth: (_, state) => LoginWithEmail(),
      Routes.login_id_pass: (_, state) => LoginWithIDAndPass(),
      Routes.home: (_, state) => Home(),
      Routes.login_with_google: (_, state) => LoginWithGoogle(),
      //: (_, state) => LoginWithIDAndPass(),
    },
  ));

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: ThemeData(),
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }
}
