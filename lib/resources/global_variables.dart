import 'package:animations/animations.dart';
import 'package:notifications/export.dart';
import 'package:notifications/ui/home/home.dart';

//LOGIN METHODS
const kIdPass = 'id-pass';
const kGoogleSignIn = 'google-signin';
const kEmailLinkAuth = 'email-link-auth';
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

