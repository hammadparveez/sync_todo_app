import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/local/local_storage.dart';

enum UserAuthenticationType { google, emailLink, manual }

typedef FutureCallBack = Future<T> Function<T>();

class UserAuthenticationRepositoryImpl extends UserAccountRepository {
  final _fsAuth = FirebaseAuth.instance;
  final EmailLinkActionCodeSettingsImpl actionCodeConfig =
      EmailLinkActionCodeSettingsImpl();
  String? _userID;
  @override
  Future<T> add<T>() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<T> get<T>() async {
    try {
      return await checkUserExists(_userID!) as T;
    } catch (e) {
      return {} as T;
    }
  }

  @override
  Future<T> signUp<T>(UserAccountModel model) async {
    log("FirebaseRegisterUser -> CreateUserWithIDAndPass");
    try {
      final usernameQuerySnapshot = await fireStore
          .collection(USERS)
          .where('username', isEqualTo: model.username)
          .get();
      final emailQuerySnapshot = await fireStore
          .collection(USERS)
          .where('email', isEqualTo: model.email)
          .get();
      final usersDocs = usernameQuerySnapshot.docs;
      final emailDocs = emailQuerySnapshot.docs;
      //emailQuerySnapshot.docs.isNotEmpty;
      if (usersDocs.isNotEmpty) {
        final username = usersDocs.first.data()['username'];
        if (username == model.username)
          throw CredentialsInvalid("Username $username already exists");
      } else if (emailDocs.isNotEmpty) {
        final data = emailDocs.first.data();

        if (data['email'] == model.email && data['method'] != 'id-pass')
          throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
              UserTypeMatchModel.simplifyUserMethod(data['method']));
        else if (data['email'] == model.email)
          throw CredentialsInvalid("Email ${data['email']} already exists");
      } else {
        await fireStore.collection(USERS).doc().set(model.toMap());
        await LocallyStoredData.storeUserKey(model.uid);
        log("Before Signing Up Get Key: ${LocallyStoredData.getSessionID()}");
      }
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    }
    return model as T;
  }

  @override
  Future<T?> signIn<T>(String userID, String password) async {
    _userID = userID;
    try {
      final data = await _tryToFindUser(userID, password);
      final user = UserAccountModel.fromJson(data!);
      Hive.box(LOGIN_BOX).put(USER_KEY, user.uid);
      log("User $user");
    } on FirebaseException catch (e) {
      firebaseToGeneralException(e);
    } on CredentialsInvalid catch (e) {
      throw CredentialsInvalid(e.msg);
    }
  }

  Future<void> _doesUserExistsAndMethod(FutureCallBack cb) async {
    try {
      final data = await this.get<Map<String, dynamic>>();
      if (data.isNotEmpty) {

        await cb();
      }
    } catch (e) {}
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
    final data = await this.get();
    if (data['method'] != 'id-pass')
      throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
          UserTypeMatchModel.simplifyUserMethod(data['method']));
    else if (data['password'] != password)
      throw CredentialsInvalid("Please enter a correct password");
    log("TrytoFindUser ${data}");
    return data;
  }

  @override
  Future<T?> loginViaID<T>(String userID) async {
    await _fsAuth
        .sendSignInLinkToEmail(
            email: userID, actionCodeSettings: actionCodeConfig.actionCodes)
        .timeout(Duration(seconds: 15),
            onTimeout: () => throw FirebaseAuthException(code: NETWORK_FAILED));
  }

  @override
  Future<bool?> login() async {
    await GoogleSignIn().signOut();
    try {
      final user = await GoogleSignIn().signIn();
      log("Signin In");
      if (user != null) {
        final userExistanceModel = await this.get<Map<String, dynamic>?>();
        if (userExistanceModel == null) {
          this.add();
          log("Google User Added ");
        } else {
         // if (userExistanceModel.userMethod != 'google-signin')
            throw PlatformException(
              code: USER_EXISTS,
              message: ExceptionsMessages.userAccountMethodWith +
                  UserTypeMatchModel.simplifyUserMethod(""),
            );
        }
      //  Hive.box(LOGIN_BOX).put(USER_KEY, _userAccount!.id);
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
    final link = linkData!.link.toString();
    if (isEmailLinkValid(link)) {
      log("EmailLink is valid: $_userID");
      final data = await this.get<Map<String, dynamic>>();
      final model = UserAccountModel.fromJson(data);
      if (data.isEmpty) {
        //Add User when not found
        //_sessionID = Uuid().v1();
        //this.add();
      } else {
        final userExists = model.method.contains('email-link-auth');
        log("User Exists Method ${userExists} ${model.method} ${model.uid}");
        if (!userExists)
          throw CredentialsInvalid(ExceptionsMessages.userAccountMethodWith +
              UserTypeMatchModel.simplifyUserMethod(model.method));
      }
      Hive.box(LOGIN_BOX).put(USER_KEY, model.uid);
    } else
      throw CredentialsInvalid("Invalid authentication link");
  }
}
