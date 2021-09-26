import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notifications/resources/constants/styles.dart';

class WidgetUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showIconicBar(BuildContext context, String message,
      {Widget? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: EdgeInsets.symmetric(horizontal: 10),
      content: Row(
        children: [
          icon ?? const SizedBox(),
          const SizedBox(width: 10),
          Flexible(child: Text(message)),
        ],
      ),
    ));
  }

  static void showErrorBar(BuildContext ctx, String msg) {
    showIconicBar(ctx, msg,
        icon: Icon(
          CupertinoIcons.clear_circled,
          color: Colors.red,
        ));
  }

  static void showLoaderIndicator(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(message),
                ],
              ),
            ));
  }

  static void showDefaultToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black54,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM);
}
