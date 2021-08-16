import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:notifications/domain/services/dynamic_link_service/dynamic_link.dart';
import 'package:notifications/infrastructure/firebase_add_user/firebase_add_user_impl.dart';

class EmailDynamicLinkListener extends DynamicLinkListener {
  final auth = FirebaseAuth.instance;
  final firebaseUser = FirebaseAddUserRepoImpl();
  @override
  Future onError(OnLinkErrorException? linkData) async {
    log("Dynamic Linking Error ");
  }

  @override
  Future<bool?> onSuccess(PendingDynamicLinkData? linkData) async {
    bool isSignInLink =
        auth.isSignInWithEmailLink("${linkData!.link.toString()}");
    log("Trying to check $isSignInLink");
    firebaseUser.addUser("alex mason Hammad@gmail.com");
    return isSignInLink;
  }
}
