import 'package:notifications/export.dart';

class LocallyStoredData {
  static void deleteUserKey() async {
    await Hive.box(LOGIN_BOX).delete(USER_KEY);
  }
  static void storeUserKey(dynamic value) async {
    await Hive.box(LOGIN_BOX).put(USER_KEY, value);
  }
  static dynamic getSessionID()  {
    return Hive.box(LOGIN_BOX).get(USER_KEY);
  }
  static bool isUserKeyExists()  {
    return Hive.box(LOGIN_BOX).containsKey(USER_KEY);
  }
}
