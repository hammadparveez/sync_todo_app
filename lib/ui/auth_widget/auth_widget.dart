//import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/export.dart';
import 'package:notifications/ui/home/home.dart';
//import 'package:notifications/riverpods/pods.dart';

class AuthCheckWidget extends StatefulWidget {
  Widget Function(BuildContext) loggedInBuilder, notLoggedInBuilder;

  AuthCheckWidget(
      {Key? key,
      required this.loggedInBuilder,
      required this.notLoggedInBuilder})
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
    
    return Consumer(builder: (ctx, watch, child) {
      
      return (watch(loginPod).sessionID == null)?
      widget.notLoggedInBuilder(context) :
       widget.loggedInBuilder(context);
    });
  }
}
