import 'dart:async';

import 'package:notifications/domain/model/google_auth_model.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/firebase_user_existance.dart';
import 'package:uuid/uuid.dart';

class EmailLinkLoginService extends LoginService {
  final auth = FirebaseAuth.instance;
  //final firebaseUser = FirebaseAddUserRepoImpl();
  final EmailLinkActionCodeSettings settings;
  final dynamicLinkListener = DynamicLinkListener();
  String? _userEmail;
  EmailLinkLoginService(this.settings);
  bool isEmailSent = false;

  Future<void> logOut() async {
    await Hive.box(LOGIN_BOX).delete(USER_KEY);
    isUserLoggedIn = false;
    userID = null;
    log("User Session ID: ${Hive.box(LOGIN_BOX).get(USER_KEY)}");
    notifyListeners();
  }

  void checkIfUserLoggedIn() async {
    final sessionId = Hive.box(LOGIN_BOX).get(USER_KEY);
    log("UserKey $sessionId");
    isUserLoggedIn = (sessionId != null) ? true : false;
    log("User $isUserLoggedIn && Session ID: $sessionId");
    notifyListeners();
  }

  @override
  Future<void> login(String email, [String? password]) async {
    _userEmail = email;
    isEmailSent = false;
    errMsg = null;
    isUserLoggedIn = Hive.box(LOGIN_BOX).get(USER_KEY) != null ? true : false;
    if (!isUserLoggedIn) await _canLogIn();
    notifyListeners();
  }

  Future<void> _canLogIn() async {
    try {
      await _delegateLogin();
      dynamicLinkListener.attachListener(_onSuccess, _onError);
      isEmailSent = true;
    } on BaseException catch (e) {
      errMsg = e.msg;
    }
  }

  Future<void> _delegateLogin() async {
    try {
      await auth
          .sendSignInLinkToEmail(
              email: _userEmail!, actionCodeSettings: settings.actionCodes)
          .timeout(Duration(seconds: 15),
              onTimeout: () =>
                  throw FirebaseAuthException(code: NETWORK_FAILED));
    } on FirebaseAuthException catch (e) {
      firebaseToGeneralException(e);
    }
  }

  Future<bool?> _onSuccess(PendingDynamicLinkData? linkData) async {
    errMsg = null;
    final isAlreadyLoggedIn =
        (await Hive.box(LOGIN_BOX).get(USER_KEY) != null) ? true : false;
    if (isAlreadyLoggedIn) {
      WidgetUtils.showDefaultToast("User already registered");
    } else {
      isUserLoggedIn = false;
      bool isSignInLink =
          auth.isSignInWithEmailLink("${linkData!.link.toString()}");
      if (isSignInLink) {
        log("Sign In Link is Okay On Success Called");
        isEmailSent = false;
        final userExistanceModel =
            await FirebaseUserExistance().checkUserExists(_userEmail!);
        if (userExistanceModel == null) {
          log("User Does not Exists with Email ${userExistanceModel?.userID}");
          final sessionId = Uuid().v1();
          final docRef = await FirebaseFirestore.instance.collection(USERS).add(
                EmailLinkAuthModel(
                        uid: sessionId,
                        email: _userEmail!,
                        method: 'email-link-auth')
                    .toMap(),
              );
          await Hive.box(LOGIN_BOX).put(USER_KEY, sessionId);
          isUserLoggedIn = true;
        } else {
          log("User  Exists with Email ${userExistanceModel.userMethod.contains('email-link-auth')}");
          if (!userExistanceModel.userMethod.contains('email-link-auth'))
            errMsg =
                "User already registered with different method ${userExistanceModel.userMethod}";
          else {
            await Hive.box(LOGIN_BOX)
                .put(USER_KEY, userExistanceModel.sessionId);
            isUserLoggedIn = true;
          }
        }

        notifyListeners();
      } else
        log("Link was expired");
    }
  }

  Future _onError(OnLinkErrorException? linkData) async {
    log("Dynamic Linking Error ");
  }
}

class GoogleSignInAuth extends LoginService {
  String? errMsg;

  @override
  Future<void> logOut() async {
    await GoogleSignIn().signOut();
    Hive.box(LOGIN_BOX).delete(USER_KEY);
    isUserLoggedIn = false;
    notifyListeners();
  }

  @override
  login(String email, [String? password]) async {
    errMsg = null;
    try {
      isUserLoggedIn = false;
      await GoogleSignIn().signOut();
      final userAccount = await GoogleSignIn().signIn();
      if (userAccount != null) {
        final userExistingModel =
            await FirebaseUserExistance().checkUserExists(userAccount.email);
        if (userExistingModel == null) {
          final docRef = await FirebaseFirestore.instance
              .collection(USERS)
              .add(GoogleAuthModel.toMap(userAccount));
          log("Google User Added :  ${docRef}");
        } else {
          if (userExistingModel.userMethod != 'google-signin')
            throw PlatformException(
              code: USER_EXISTS,
              message:
                  "User was registered already via different method ${userExistingModel.userMethod}",
            );
        }
        isUserLoggedIn = true;
        await Hive.box(LOGIN_BOX).put(USER_KEY, userAccount.id);
      }
    } on PlatformException catch (e) {
      try {
        platformToGeneralException(e);
      } on BaseException catch (e) {
        errMsg = e.msg;
      }
    }
    notifyListeners();
  }
}
