import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:notifications/domain/services/auth_service/auth_service.dart';
import 'package:notifications/resources/constants/app_strings.dart';
import 'package:notifications/resources/util/widiget_utils.dart';
import 'package:notifications/riverpods/pods.dart';
import 'package:notifications/ui/home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final connectivity = Connectivity();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validator(String? value) {
    return value!.isEmail ? null : "Email is Incorrect";
  }

  _loginStatusHandler(_, EmailLinkLoginService auth) {
    if (auth.isEmailSent)
      WidgetUtils.snackBar(_, AppStrings.emailSentPlzCheck);
    else if (auth.errMsg != null) WidgetUtils.snackBar(_, auth.errMsg!);
  }

  _onTap() async {
    if (_emailController.text.isEmpty)
      return WidgetUtils.showDefaultToast(AppStrings.emailRequired);
    WidgetUtils.showLoaderIndicator(context, "Loading... Please wait!");
    await context.read(loginPod).login(_emailController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      if (watch(loginPod).isUserLoggedIn) return Home();
      return Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  validator: _validator,
                ),
                ProviderListener(
                  provider: loginPod,
                  onChange: _loginStatusHandler,
                  child: ElevatedButton(
                      onPressed: _onTap, child: Text(AppStrings.login)),
                ),
                Consumer(builder: (_, watch, child) {
                  return Text("User: ${watch(loginPod).userID}");
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
