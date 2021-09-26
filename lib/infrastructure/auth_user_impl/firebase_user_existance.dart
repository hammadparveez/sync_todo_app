import 'package:notifications/domain/model/user_type_match_model.dart';
import 'package:notifications/export.dart';

class FirebaseUserExistance {
  final fs = FirebaseFirestore.instance;
  Map<String, dynamic>? data;
  Future<UserTypeMatchModel?> checkUserExists(String email) async {
    final qs =
        await fs.collection(USERS).where('email', isEqualTo: email).get();

    if (qs.docs.isNotEmpty) {
      data = qs.docs.first.data();
      return UserTypeMatchModel.fromJson(data!);
    }
    return null;
    // throw PlatformException(
    //     code: 'user-exists', message: 'User $email already exists');
  }

  @override
  String toString() {
    return "FirebaseUserExistance: ${data}";
  }
}
