//import 'package:beamer/beamer.dart';
//import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:notifications/export.dart';
import 'package:notifications/ui/home/home.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  //////////ROUTES SETTINGS
  static BeamerDelegate routerDelegate = BeamerDelegate(
      locationBuilder: SimpleLocationBuilder(
    routes: {
      Routes.main: (_, state) {
        return AuthCheckWidget(
          notLoggedInBuilder: (_) => LoginScreen(),
          loggedInBuilder: (_) => Home(),
        );
      },
      Routes.register: (_, state) => SignUp(),
      Routes.home: (_, state) => Home(),
      Routes.add_todo_item: (_, state) => AddTodoItems(),
      Routes.login: (_, state) => LoginScreen(),
    },
  ));

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appTitle,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      themeMode: ThemeMode.light,
      builder: DevicePreview.appBuilder,
   
    );
  }
}
