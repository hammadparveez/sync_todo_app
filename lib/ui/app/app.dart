//import 'package:beamer/beamer.dart';
//import 'package:flutter/material.dart';
import 'package:notifications/export.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
}
