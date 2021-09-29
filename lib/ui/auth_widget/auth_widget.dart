//import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/export.dart';
//import 'package:notifications/riverpods/pods.dart';

class AuthCheckWidget extends StatefulWidget {
  final Widget signedInWidget, notSignedInWidget;

  AuthCheckWidget(
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
      context.read(loginPod).isLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      if (watch(loginPod).sessionID == null) return widget.notSignedInWidget;
      return widget.signedInWidget;
    });
  }
}
