import 'package:notifications/export.dart';

class FirebaseEmailLinkSignIn {
  Future<void> login(String email) async {
    FirebaseFirestore.instance.collection(USERS).doc();
  }
}
