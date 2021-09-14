import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/export.dart';
import 'package:notifications/riverpods/pods.dart';

class AuthCheckWidget extends StatefulWidget {
  final Widget signedInWidget, notSignedInWidget;

  const AuthCheckWidget(
      {Key? key, required this.signedInWidget, required this.notSignedInWidget})
      : super(key: key);

  @override
  AuthCheckWidgetState createState() => AuthCheckWidgetState();
}

class AuthCheckWidgetState extends State<AuthCheckWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      log("After FrameCallback");
      context.read(loginPod).checkIfUserLoggedIn();
    });
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (linkData) async {
          log("App State OnLink Listener");
          final link = linkData?.link;

          final isAuthLink =
              link?.queryParameters['continueUrl']?.contains('login=true') ??
                  false;
          log("Auth Link $isAuthLink");
          if (isAuthLink) {
            if (Hive.box(LOGIN_BOX).get(USER_KEY) != null)
              WidgetUtils.showDefaultToast("An account is already signed-in");
            else
              WidgetUtils.showDefaultToast(
                  "You have to Sign In with Email-Link again");
          }
        },
        onError: (_) async => log("Error in Link"));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) =>
          watch(loginPod).isUserLoggedIn ? widget.signedInWidget : child!,
      child: widget.notSignedInWidget,
    );
  }
}
