import 'package:notifications/export.dart';

class LocallyStoredData {
  static Future<void> deleteUserKey() async {
    await Hive.box(LOGIN_BOX).delete(USER_KEY);
  }

  static Future<void> storeUserKey(dynamic value) async {
    await Hive.box(LOGIN_BOX).put(USER_KEY, value);
  }

  static String? getSessionID() {
    return Hive.box(LOGIN_BOX).get(USER_KEY);
  }

  static bool isUserKeyExists() {
    return Hive.box(LOGIN_BOX).containsKey(USER_KEY);
  }
}
