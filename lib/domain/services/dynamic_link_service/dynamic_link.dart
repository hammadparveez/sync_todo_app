import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

abstract class DynamicLinkListener {
  final dynamicLink = FirebaseDynamicLinks.instance;

  void attachListener() =>
      dynamicLink.onLink(onSuccess: onSuccess, onError: onError);

  Future<dynamic> onSuccess(PendingDynamicLinkData? linkData);
  Future<dynamic> onError(OnLinkErrorException? linkData);
}
