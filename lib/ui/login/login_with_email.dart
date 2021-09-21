import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/app_strings.dart';
import 'package:notifications/resources/util/widiget_utils.dart';
import 'package:notifications/riverpods/pods.dart';
import 'package:notifications/ui/home/home.dart';

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginWithEmail> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validator(String? value) {
    return value!.isEmail ? null : "Email is Incorrect";
  }

  _loginStatusHandler(_, UserAuthService auth) {
    // if (auth.isEmailSent)
    //   WidgetUtils.snackBar(_, AppStrings.emailSentPlzCheck);
    // else if (auth.errMsg != null) WidgetUtils.snackBar(_, auth.errMsg!);
  }

  _onTap() async {
    if (_emailController.text.isEmpty)
      return WidgetUtils.showDefaultToast(AppStrings.emailRequired);
    //WidgetUtils.showLoaderIndicator(context, "Loading... Please wait!");
    log("Tapped Email Sign In");
    context.read(loginPod).loginWithEmail(_emailController.text);
    //Navigator.of(context).pop();
  }

  _onChange(_, UserAuthService service) {
    log("User Session ${service.sessionID}");
    if (service.errorMsg != null)
      WidgetUtils.snackBar(context, service.errorMsg!);

    // if (service.isUserLoggedIn)
    //   Beamer.of(_).popToNamed(Routes.home, stacked: false);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: loginPod,
      onChange: _onChange,
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: _validator,
                  ),
                  ElevatedButton(
                      onPressed: _onTap, child: Text(AppStrings.login)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
