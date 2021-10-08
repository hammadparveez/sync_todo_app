//import 'package:beamer/beamer.dart';
//import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/painting.dart';
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
    return
        // WidgetsApp.router(
        //   routeInformationParser: BeamerParser(),
        //   routerDelegate: routerDelegate,
        //   useInheritedMediaQuery: true,
        //  localizationsDelegates:   <LocalizationsDelegate<dynamic>>[
        //     DefaultWidgetsLocalizations.delegate,
        //     DefaultMaterialLocalizations.delegate,
        //   ],
        //   color: Colors.green,
        //   builder: (_, child) {
        //     final mediaQuery =  MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
        //   log("Media Query -> ${ mediaQuery}");
        //     return MediaQuery(
        //       data: mediaQuery.copyWith(textScaleFactor: 1.0),
        //       child: child!,
        //     );
        //   },
        // );
        MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      themeMode: ThemeMode.light,
      builder: (ctx, child) {
        return Theme(
            data: ThemeData(
              textTheme: TextTheme(
                bodyText1: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3F3E3E)),
                bodyText2:
                    TextStyle(fontSize: 14, color: const Color(0xFF3F3E3E)),
                button: TextStyle(fontSize: 15),
              ),
            ),
            child: child!);
      },
    );
  }
}
