import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/resources/constants/app_strings.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/ui/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
      locationBuilder: SimpleLocationBuilder(
    routes: {
      Routes.main: (_, state) => Login(),
    },
  ));
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: AppStrings.appTitle,
        theme: ThemeData(),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
      ),
    );
  }
}
