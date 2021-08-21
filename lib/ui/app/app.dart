import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:notifications/resources/constants/app_strings.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/ui/auth_widget/auth_widget.dart';
import 'package:notifications/ui/home/home.dart';
import 'package:notifications/ui/login/login.dart';
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
          signedInWidget: const Home(), notSignedInWidget: Login()),
      Routes.register: (_, state) => SignUp(),
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
