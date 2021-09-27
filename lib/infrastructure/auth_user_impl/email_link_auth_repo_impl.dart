import 'package:notifications/config/dynamic_linking_config/auth_link_code_config.dart';
import 'package:notifications/domain/model/google_auth_model.dart';
import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/auth_user_impl/firebase_user_existance.dart';
import 'package:uuid/uuid.dart';

class EmailLinkAuthRepoImpl extends EmailLinkAuthenticationRepo
    implements AuthRepository {
  final _fsAuth = FirebaseAuth.instance;
  final EmailLinkActionCodeSettingsImpl actionCodeConfig =
      EmailLinkActionCodeSettingsImpl();
  String? _email, _sessionID;

  EmailLinkAuthRepoImpl();

  @protected
  @override
  Future<T> add<T>() async {
    final docRef = await FirebaseFirestore.instance.collection(USERS).add(
          EmailLinkAuthModel(
                  uid: _sessionID!, email: _email!, method: 'email-link-auth')
              .toMap(),
        );
    return docRef as T;
  }

  @protected
  @override
  Future<T> get<T>() async {
    return await FirebaseUserExistance().checkUserExists(_email!) as T;
  }

  @override
  Future<bool?> login() async {
    setValue(_email!);
    try {
      await _delegateLogin();
    } on BaseException catch (e) {
      throw e;
    }
  }

  @override
  void setValue(String email) {
    _email = email;
  }

  @override
  void onLinkListener(
      {required OnLinkSuccessCallback onSuccess,
      required OnLinkErrorCallback onError}) {
    FirebaseDynamicLinks.instance
        .onLink(onSuccess: onSuccess, onError: onError);
  }

  @override
  bool isEmailLinkValid(String link) {
    return _fsAuth.isSignInWithEmailLink(link);
  }

  Future<void> _delegateLogin() async {
    try {
      await _fsAuth
          .sendSignInLinkToEmail(
              email: _email!, actionCodeSettings: actionCodeConfig.actionCodes)
          .timeout(Duration(seconds: 15),
              onTimeout: () =>
                  throw FirebaseAuthException(code: NETWORK_FAILED));
    } on FirebaseAuthException catch (e) {
      firebaseToGeneralException(e);
    }
  }

  @override
  Future<bool?> onLinkAuthenticate(PendingDynamicLinkData? linkData) async {
    final link = linkData!.link.toString();
    if (isEmailLinkValid(link)) {
      log("EmailLink is valid: $_email");
      final userExistanceModel = await this.get<UserTypeMatchModel?>();
      if (userExistanceModel == null) {
        log("User Does not Exists with Email ${userExistanceModel?.userID}");
        _sessionID = Uuid().v1();
        this.add();
      } else {
        final userExists =
            userExistanceModel.userMethod.contains('email-link-auth');
        log("User Exists Method ${userExists} ${userExistanceModel.userMethod} ${userExistanceModel.userID} , ${userExistanceModel.sessionId}");
        if (!userExists)
          throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
              UserTypeMatchModel.simplifyUserMethod(
                  userExistanceModel.userMethod));
      }
      Hive.box(LOGIN_BOX).put(USER_KEY, userExistanceModel!.sessionId);
    } else
      throw CredentialsInvalid("Invalid authentication link");
  }

  Future onLinkError(OnLinkErrorException? linkData) async {
    log("Hello WOrld");
  }
}

class FirebaseGoogleAuthRepo extends AuthRepository {
  GoogleSignInAccount? _userAccount;
  String? _email;
  @protected
  @override
  Future<T> add<T>() async {
    return await FirebaseFirestore.instance
        .collection(USERS)
        .add(GoogleAuthModel.toMap(_userAccount!)) as T;
  }

  @protected
  @override
  Future<T> get<T>() async {
    return await FirebaseUserExistance().checkUserExists(_email!) as T;
  }

  @override
  Future<bool?> login() async {
    await GoogleSignIn().signOut();
    try {
      _userAccount = await GoogleSignIn().signIn();
      log("Signin In");
      if (_userAccount != null) {
        _email = _userAccount?.email;
        final userExistanceModel = await this.get<UserTypeMatchModel?>();
        if (userExistanceModel == null) {
          this.add();
          log("Google User Added ");
        } else {
          if (userExistanceModel.userMethod != 'google-signin')
            throw PlatformException(
              code: USER_EXISTS,
              message: ExceptionsMessages.userAccountMethodWith +
                  UserTypeMatchModel.simplifyUserMethod(
                      userExistanceModel.userMethod),
            );
        }
        Hive.box(LOGIN_BOX).put(USER_KEY, _userAccount!.id);
      } else
        return false;
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on PlatformException catch (e) {
      platformToGeneralException(e);
    }
  }
}
