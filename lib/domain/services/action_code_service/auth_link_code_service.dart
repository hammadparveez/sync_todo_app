import 'package:firebase_auth/firebase_auth.dart';
import 'package:notifications/resources/constants/api.dart';

abstract class EmailLinkActionCodeSettings {
  ActionCodeSettings get actionCodes;
}

class EmailLinkActionCodeSettingsImpl extends EmailLinkActionCodeSettings {
  _setActionCodes() {
    return ActionCodeSettings(
      url: Api.base_uri,
      androidPackageName: Api.pkgName,
      androidMinimumVersion: Api.androidVersion,
      handleCodeInApp: true,
    );
  }

  @override
  ActionCodeSettings get actionCodes => _setActionCodes();
}
