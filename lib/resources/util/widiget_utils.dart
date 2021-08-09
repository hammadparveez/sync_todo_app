import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetUtils {
  static void snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showLoaderIndicator(BuildContext context, String message) {
    showDialog(
        context: context,
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
