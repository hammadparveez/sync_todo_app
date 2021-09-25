import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/widgets/bold_heading_widget.dart';
import 'package:notifications/ui/widgets/custom_form_widget.dart';
import 'package:notifications/ui/widgets/custom_text_button.dart';
import 'package:notifications/ui/widgets/custom_textfield_labeled.dart';
import 'package:notifications/ui/widgets/default_elevated_button.dart';
import 'package:notifications/ui/widgets/spacer.dart';
import 'package:notifications/resources/extensions/widget_ext.dart';

enum ValidationType {
  username,
  email,
  password,
  confirmPassword,
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "hammad11"),
      _emailController = TextEditingController(text: "mason@gmail.com"),
      _passwordController = TextEditingController(text: "ha11"),
      _confirmPassController = TextEditingController(text: "ha11");

  bool isChecked = false;
  _onValidate(String? value, ValidationType type) {
    switch (type) {
      case ValidationType.username:
        if (value!.isNotEmpty && value.length < 8)
          return "Username Must Be 8 characters long";
        else if (value.isEmpty) return "Username required";
        return null;
      case ValidationType.email:
        if (value!.isEmpty)
          return "Email required";
        else if (!value.isEmail) return "Please enter a Valid Email";
        return null;
      case ValidationType.password:
        if (value!.isEmpty)
          return "Password required";
        else if (value.isAlphabetOnly || value.isNumericOnly)
          return "Password must be AlphaNumeric";
        return null;
      case ValidationType.confirmPassword:
        if (value!.isEmpty)
          return "Confirm Password required";
        else if (value != _passwordController.text)
          return "Password doesn't match";
        return null;
    }
  }

  _onRegister() {
    //Clears any snackbar opened due to Error or Multiple clicks
    //ScaffoldMessenger.of(context).clearSnackBars();
    log("SignUp -> _onRegisterTap ");

    if (_formKey.currentState!.validate()) {
      networkCheckCallback(context, () async {
        WidgetUtils.showLoaderIndicator(context, "Please wait! Loading.....");
        final isLoggedIn = await context.read(loginPod).register(
              _usernameController.text,
              _emailController.text,
              _passwordController.text,
            );
        await Beamer.of(context).popRoute();
        if (isLoggedIn) Beamer.of(context).beamToNamed(Routes.login);
      });
    } else
      log("Form Input Invalid");
  }

  _onChanged(BuildContext ctx, UserAuthService service) async {
    ctx.showDefaultErrorMsg(service, AuthenticationType.register);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: loginPod,
      onChange: _onChanged,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              child: Column(
                children: [
                  _buildSpacer(50),
                  BoldHeadingWidget(heading: "Sign Up"),
                  CustomForm(
                    child: Column(
                      children: [
                        CustomTextFieldWithLabeled(
                            label: "Username",
                            hintText: "Type Username",
                            onValidate: (value) =>
                                _onValidate(value, ValidationType.username),
                            controller: _usernameController,
                            icon: CupertinoIcons.person),
                        CustomTextFieldWithLabeled(
                            label: "Email",
                            hintText: "Type Email",
                            controller: _emailController,
                            onValidate: (value) =>
                                _onValidate(value, ValidationType.email),
                            icon: CupertinoIcons.envelope),
                        CustomTextFieldWithLabeled(
                            label: "Password",
                            hintText: "Type Password",
                            controller: _passwordController,
                            onValidate: (value) =>
                                _onValidate(value, ValidationType.password),
                            icon: CupertinoIcons.lock),
                        CustomTextFieldWithLabeled(
                            label: "Confirm Password",
                            hintText: "Type Confirm Password",
                            onValidate: (value) => _onValidate(
                                value, ValidationType.confirmPassword),
                            controller: _confirmPassController,
                            icon: CupertinoIcons.lock),
                        FormField(
                          initialValue: isChecked,
                          validator: (value) {
                            if (!isChecked)
                              return "Please accept Terms & Conditions";
                          },
                          builder: (state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    fillColor: MaterialStateProperty.all(
                                        Styles.defaultColor),
                                    value: isChecked,
                                    onChanged: (value) {
                                      isChecked = value!;
                                      state.didChange(isChecked);
                                      log("CheckedValue : $isChecked");
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "I accept Terms & Conditions and the Privacy Policy",
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                ],
                              ),
                              state.errorText != null
                                  ? Text(
                                      state.errorText!,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Styles.defaultColor),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        _buildSpacer(10),
                        DefaultElevatedButton(
                          title: "Sign Up",
                          onPressed: _onRegister,
                        ),
                      ],
                    ),
                    formKey: _formKey,
                  ),
                  const SizedBox(height: 10),
                  CustomTextButton(
                    onPressed: () => Beamer.of(context)
                        .popToNamed(Routes.login, stacked: false),
                    title: AppStrings.alreadyHaveAccount,
                  ),
                  // Spacer(flex: 2),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  ResponsiveVrtSpacer _buildSpacer(double value) =>
      ResponsiveVrtSpacer(space: value.h);
}
