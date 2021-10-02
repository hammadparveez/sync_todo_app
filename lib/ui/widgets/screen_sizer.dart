import 'dart:ui';

import 'package:notifications/export.dart';

class SizerContext {
  static BuildContext? ctx;
  //static MediaQueryData? data;
  static initSizer(BuildContext context) {
    log("InitSizer");
    ctx = context;
    //data = MediaQuery.of(context);
  }
}

class Sizer extends StatelessWidget {
  final Widget child;
  const Sizer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("Sizer->Context ${context.orientation}");
    SizerContext.initSizer(context);
    return child;
  }
}
