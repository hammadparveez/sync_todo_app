import 'package:notifications/domain/repository/firebase_repo/add_user.dart';

class FirebaseAddUserRepoImpl extends FirebaseAddUserRepository {
  @override
  void addUser(String email) {
    fireStore.collection("users").add({"email": email});
  }
}
