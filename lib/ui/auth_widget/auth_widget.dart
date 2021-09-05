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
  _AuthCheckWidgetState createState() => _AuthCheckWidgetState();
}

class _AuthCheckWidgetState extends State<AuthCheckWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      log("After FrameCallback");
      context.read(loginPod).checkIfUserLoggedIn();
    });
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
