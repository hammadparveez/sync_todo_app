//import 'package:beamer/beamer.dart';
//import 'package:flutter/material.dart';
import 'package:notifications/export.dart';

import 'package:notifications/resources/constants/app_strings.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/ui/auth_widget/auth_widget.dart';
import 'package:notifications/ui/home/home.dart';
// import 'package:notifications/ui/login/login.dart';
// import 'package:notifications/ui/login/login_google.dart';
// import 'package:notifications/ui/login/login_with_email.dart';
//import 'package:notifications/ui/login/login_with_id_pass.dart';
import 'package:notifications/ui/signup/sign_up.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static final authWidgetState = GlobalKey<AuthCheckWidgetState>();
  final routerDelegate = BeamerDelegate(
      locationBuilder: SimpleLocationBuilder(
    routes: {
      Routes.main: (_, state) => AuthCheckWidget(
          key: authWidgetState,
          signedInWidget: Home(),
          notSignedInWidget: LoginScreen()),
      Routes.register: (_, state) => SignUp(),
      Routes.home: (_, state) => Home(),
      Routes.login: (_, state) => LoginScreen(),
      //Routes.home: (_, state) => Home(),
      //Routes.login_with_google: (_, state) => LoginWithGoogle(),
      //Routes.add_todo_item: (_, state) => AddTodoItems(),
      //: (_, state) => LoginWithIDAndPass(),
    },
  ));

  @override
  void initState() {
    super.initState();
    //WidgetUtils.snackBar(context, "You have to Sign In with Email-Link again");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: AppStrings.appTitle,
        theme:
            ThemeData(accentColor: Colors.purple, primaryColor: Colors.green),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        themeMode: ThemeMode.light,
        builder: (_, widget) => ScreenUtilInit(builder: () => widget!));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
