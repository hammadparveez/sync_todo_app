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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          secondary: Styles.defaultColor,
          onSecondary: Colors.white,
          primary: Styles.defaultColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
        textTheme: const TextTheme(
          bodyText1: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3F3E3E)),
          bodyText2: TextStyle(fontSize: 14, color: const Color(0xFF3F3E3E)),
          button: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
