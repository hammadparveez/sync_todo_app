import 'package:notifications/export.dart';
import 'package:notifications/ui/home/home.dart';

//LOGIN METHODS
const kIdPass = 'id-pass';
const kGoogleSignIn = 'google-signin';
const kEmailLinkAuth= 'email-link-auth';
/////////////


final getIt = GetIt.I;
///Firebase Collection "users"
const USERS = "users";

//Hive box keys
const USER_KEY = "user";
//Hive Boxes names
const LOGIN_BOX = "loginBox";






//////////ROUTES SETTINGS
final _authWidgetState = GlobalKey<AuthCheckWidgetState>();
//Route settings globally
final routerDelegate = BeamerDelegate(

      locationBuilder: SimpleLocationBuilder(

    routes: { 
      Routes.main: (_, state) => AuthCheckWidget(
          key: _authWidgetState,
          signedInWidget: Home(),
          notSignedInWidget: LoginScreen()),
      Routes.register: (_, state) => SignUp(),
      Routes.home: (_, state) => Home(),
      Routes.add_todo_item: (_, state) => AddTodoItems(),
      Routes.login: (_, state) => LoginScreen(),
     
    },
  ));


