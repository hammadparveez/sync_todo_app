import 'package:notifications/domain/model/google_auth_model.dart';
import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/local/local_storage.dart';
import 'package:uuid/uuid.dart';

enum UserAuthenticationType { google, emailLink, manual }

typedef FutureCallBack = Future<T> Function<T>();

abstract class _ManualAuthenticationType {}

abstract class _GoogleAuthenticationType {}

abstract class _EmailLinkAuthenticationType {}

class UserAuthenticationRepositoryImpl extends UserAccountRepository {
  final _fsAuth = FirebaseAuth.instance;
  final EmailLinkActionCodeSettingsImpl actionCodeConfig =
      EmailLinkActionCodeSettingsImpl();
  String? _userID, _sessionID;
  UserAccountModel? _model;
  GoogleSignInAccount? _googleAuthModel;
  @override
  Future<T?> add<T>() async {
    switch (T) {
      case _ManualAuthenticationType:
        log("this.add() -> _ManualAuthenticationType");
        fireStore.collection(USERS).add(_model!.toMap());
        await LocallyStoredData.storeUserKey(_model!.uid);
        break;
      case _GoogleAuthenticationType:
        log("this.add() -> _GoogleAuthenticationType");
        await fireStore
            .collection(USERS)
            .add(GoogleAuthModel.toMap(_googleAuthModel!));
        await LocallyStoredData.storeUserKey(_googleAuthModel!.id);
        break;
      case _EmailLinkAuthenticationType:
        log("this.add() -> _EmailLinkAuthenticationType");
        _sessionID = Uuid().v4();
        await fireStore.collection(USERS).add(
              EmailLinkAuthModel(
                uid: _sessionID!,
                email: _userID!,
                method: 'email-link-auth',
              ).toMap(),
            );
        break;
    }
  }

  @override
  Future<T> get<T>() async {
    log("this.get()");
    try {
      return await checkUserExists(_userID!) as T;
    } catch (e) {
      return <String, dynamic>{} as T;
    }
  }

  _getUsernameDocs() async {
    final usernameQuerySnapshot = await fireStore
        .collection(USERS)
        .where('username', isEqualTo: _model!.username)
        .get();

    return usernameQuerySnapshot.docs;
  }

  _getEmailDocs() async {
    final emailQuerySnapshot = await fireStore
        .collection(USERS)
        .where('email', isEqualTo: _model!.email)
        .get();
    return emailQuerySnapshot.docs;
  }

  Future<void> _ifUserExistsThrow() async {
    final usersDocs = await _getUsernameDocs();
    final emailDocs = await _getEmailDocs();
    if (usersDocs.isNotEmpty) {
      final username = usersDocs.first.data()['username'];
      if (username == _model!.username)
        throw CredentialsInvalid("Username $username already exists");
    } else if (emailDocs.isNotEmpty) {
      final data = emailDocs.first.data();
      final methodSimplified =
          UserTypeMatchModel.simplifyUserMethod(data['method']);
      if (data['method'] != UserTypeMatchModel.mIdAndPass)
        throw CredentialsInvalid(
            ExceptionsMessages.userAccountMethodWith + methodSimplified);
      else if (data['email'] == _model!.email)
        throw CredentialsInvalid("Email ${data['email']} already exists");
    }
  }

  @override
  Future<T> signUp<T>(UserAccountModel model) async {
    log("UserAuthenticationRepositoryImpl -> signUp()");
    _model = model;
    try {
      await _ifUserExistsThrow();
      await this.add<_ManualAuthenticationType>();
      log("Before Signing Up Get Key: ${LocallyStoredData.getSessionID()}");
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    }
    return model as T;
  }

  @override
  Future<T?> signIn<T>(String userID, String password) async {
    log("UserAuthenticationRepositoryImpl -> signIn()");
    try {
      final data = await _tryToFindUser(userID, password);
      final user = UserAccountModel.fromJson(data!);
      LocallyStoredData.storeUserKey(user.uid);
      log("User $user");
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on CredentialsInvalid catch (e) {
      throw CredentialsInvalid(e.msg);
    }
  }

  @override
  Future<Map<String, dynamic>> checkUserExists(
    String userID,
  ) async {
    final querySnapshot = await fireStore.collection(USERS).get();
    final doc = querySnapshot.docs.firstWhere(
      (user) {
        final data = user.data();
        return ((data["username"] == userID) || (data["email"] == userID))
            ? true
            : false;
      },
      orElse: () => throw CredentialsInvalid(
          ExceptionsMessages.userNotExistsWith + userID),
    );
    return doc.data();
  }

  Future<Map<String, dynamic>>? _tryToFindUser(
    String userID,
    String password,
  ) async {
    _userID = userID;
    final data = await this.get<Map<String, dynamic>>();

    if (data.isEmpty)
      throw CredentialsInvalid("User does not exists");
    else if (data['method'] != UserTypeMatchModel.mIdAndPass)
      throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
          UserTypeMatchModel.simplifyUserMethod(data['method']));
    else if (data['password'] != password)
      throw CredentialsInvalid("Please enter a correct password");
    log("TrytoFindUser ${data}");
    return data;
  }

  ///Sign In with Email Link Authentication
  @override
  Future<T?> loginViaID<T>(String userID) async {
    log("UserAuthenticationRepositoryImpl -> loginViaID()");
    _userID = userID;
    await _fsAuth
        .sendSignInLinkToEmail(
            email: userID, actionCodeSettings: actionCodeConfig.actionCodes)
        .timeout(Duration(seconds: 15),
            onTimeout: () => throw FirebaseAuthException(code: NETWORK_FAILED));
  }

  ///Sign In with Google Authentication
  @override
  Future<bool?> login() async {
    log("UserAuthenticationRepositoryImpl -> login()");
    await GoogleSignIn().signOut();
    try {
      _googleAuthModel = await GoogleSignIn().signIn();
      Map<String, dynamic> data = {};
      if (_googleAuthModel != null) {
        //assigning userID for finding exsisting user
        _userID = _googleAuthModel!.email;
        data = await this.get<Map<String, dynamic>>();
        if (data.isEmpty) {
          await this.add<_GoogleAuthenticationType>();
          log("Google User Added ");
        } else {
          if (data['method'] != 'google-signin')
            throw PlatformException(
              code: USER_EXISTS,
              message: ExceptionsMessages.userAccountMethodWith +
                  UserTypeMatchModel.simplifyUserMethod(data['method']),
            );
        }
        await LocallyStoredData.storeUserKey(_googleAuthModel!.id);
      } else
        return false;
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on PlatformException catch (e) {
      platformToGeneralException(e);
    }
  }

  @override
  bool isEmailLinkValid(String link) {
    return _fsAuth.isSignInWithEmailLink(link);
  }

  @override
  void onLinkListener(
      {required OnLinkSuccessCallback onSuccess,
      required OnLinkErrorCallback onError}) {
    FirebaseDynamicLinks.instance
        .onLink(onSuccess: onSuccess, onError: onError);
  }

  @override
  Future onLinkAuthenticate(PendingDynamicLinkData? linkData) async {
    log("UserAuthenticationRepositoryImpl -> onLinkAuthenticate()");
    final link = linkData!.link.toString();
    if (isEmailLinkValid(link)) {
      final data = await this.get<Map<String, dynamic>>();

      final model = EmailLinkAuthModel.fromJson(data);

      if (data.isEmpty) {
        await this.add<_EmailLinkAuthenticationType>();
      } else {
        final userExists = model.method.contains(kEmailLinkAuth);
        if (!userExists)
          throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
              UserTypeMatchModel.simplifyUserMethod(model.method));
      }
      LocallyStoredData.storeUserKey(model.uid);
    } else
      throw CredentialsInvalid("Invalid authentication link");
  }
}
