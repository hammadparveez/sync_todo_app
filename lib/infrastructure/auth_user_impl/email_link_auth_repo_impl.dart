import 'package:notifications/domain/model/google_auth_model.dart';
import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/auth_user_impl/firebase_user_existance.dart';
import 'package:uuid/uuid.dart';

class EmailLinkAuthRepoImpl extends EmailLinkAuthenticationRepo {
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
      required OnLinkErrorCallback onError}) {}

  @override
  bool isEmailLinkValid(String link) {
    // return _fsAuth.isSignInWithEmailLink(link);
    return false;
  }

  Future<void> _delegateLogin() async {
    try {} on FirebaseAuthException catch (e) {
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

class FirebaseGoogleAuthRepo {
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
  Future<bool?> login() async {}
}
