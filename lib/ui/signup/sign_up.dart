//import 'dart:developer';

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
import 'package:flash/flash.dart';

enum ValidationFieldType {
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
  bool isLoaderOpened = false, hasTapped = false;
  bool isChecked = false;

  //Validating all inputFields
  _onValidate(String? value, ValidationFieldType type) {
    switch (type) {
      case ValidationFieldType.username:
        if (value!.isNotEmpty && value.length < 8)
          return "Username Must Be 8 characters long";
        else if (value.isEmpty) return "Username required";
        break;
      case ValidationFieldType.email:
        if (value!.isEmpty)
          return "Email required";
        else if (!value.isEmail) return "Please enter a Valid Email";
        break;
      case ValidationFieldType.password:
        if (value!.isEmpty)
          return "Password required";
        else if (value.isAlphabetOnly || value.isNumericOnly)
          return "Password must be AlphaNumeric";
        break;
      case ValidationFieldType.confirmPassword:
        if (value!.isEmpty)
          return "Confirm Password required";
        else if (value != _passwordController.text)
          return "Password doesn't match";
        break;
    }
    return null;
  }

  //updates checkBox (selected/unselected)
  _onChecked(FormFieldState state) {
    isChecked = !isChecked;
    log("State : $isChecked");
    state.didChange(isChecked);
  }

  ///Dialog pops up on Sign up button tap
  _showLoaderOnCreatingAccount() {
    WidgetUtils.showLoaderIndicator(context, "Please wait! Loading.....",
        onBackPress: () async {
      if (isLoaderOpened) {
        context.showInfoBar(
            content: Text("We are trying to create an account"));
        return false;
      }
      return true;
    });
  }

  _onRegister() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      networkCheckCallback(context, () async {
        _showLoaderOnCreatingAccount();
        setState(() => isLoaderOpened = true);
        final isLoggedIn = await context.read(loginPod).register(
              _usernameController.text,
              _emailController.text,
              _passwordController.text,
            );
        setState(() => isLoaderOpened = false);

        ///Close Loader after registering, despite of it's status
        popRoute();
        if (isLoggedIn) Beamer.of(context).beamToNamed(Routes.home);
      });
    }
  }

  //Event Listener for errors when registering an account
  _onChanged(BuildContext ctx, UserAuthService service) async {
    if (service.errorMsg != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      WidgetUtils.showErrorBar(service.errorMsg!);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: loginPod,
      onChange: _onChanged,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: context.fH(),
            child: _buildSignUpScreen(),
          ),
        ),
      ),
    );
  }

  Column _buildSignUpScreen() {
    return Column(
      children: [
        _buildSpacer(50),
        BoldHeadingWidget(heading: "Sign Up"),
        _buildSignUpForm(),
        const SizedBox(height: 10),
        _buildAlreadyHaveAccount(),
        // Spacer(flex: 2),
      ],
    );
  }

  CustomTextButton _buildAlreadyHaveAccount() {
    return CustomTextButton(
      onPressed: () =>
          Beamer.of(context).popToNamed(Routes.login, stacked: false),
      title: AppStrings.alreadyHaveAccount,
    );
  }

  CustomForm _buildSignUpForm() {
    return CustomForm(
      child: Column(
        children: [
          _buildUsernameField(),
          _buildEmailField(),
          _buildPasswordField(),
          _buildConfirmPasswordField(),
          _buildAcceptPrivacyCheck(),
          _buildSpacer(10),
          DefaultElevatedButton(
            title: "Sign Up",
            onPressed: _onRegister,
          ),
        ],
      ),
      formKey: _formKey,
    );
  }

  CustomTextFieldWithLabeled _buildUsernameField() {
    return CustomTextFieldWithLabeled(
        label: "Username",
        hintText: "Type Username",
        onValidate: (value) => _onValidate(value, ValidationFieldType.username),
        controller: _usernameController,
        icon: CupertinoIcons.person);
  }

  CustomTextFieldWithLabeled _buildEmailField() {
    return CustomTextFieldWithLabeled(
        label: "Email",
        hintText: "Type Email",
        controller: _emailController,
        onValidate: (value) => _onValidate(value, ValidationFieldType.email),
        icon: CupertinoIcons.envelope);
  }

  CustomTextFieldWithLabeled _buildPasswordField() {
    return CustomTextFieldWithLabeled(
        label: "Password",
        hintText: "Type Password",
        controller: _passwordController,
        onValidate: (value) => _onValidate(value, ValidationFieldType.password),
        icon: CupertinoIcons.lock);
  }

  CustomTextFieldWithLabeled _buildConfirmPasswordField() {
    return CustomTextFieldWithLabeled(
        label: "Confirm Password",
        hintText: "Type Confirm Password",
        onValidate: (value) =>
            _onValidate(value, ValidationFieldType.confirmPassword),
        controller: _confirmPassController,
        icon: CupertinoIcons.lock);
  }

  FormField<bool> _buildAcceptPrivacyCheck() {
    return FormField(
      initialValue: isChecked,
      validator: (value) {
        if (!isChecked) return "Please accept Terms & Conditions";
      },
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _onChecked(state),
            child: Row(
              children: [
                Checkbox(
                  fillColor: MaterialStateProperty.all(Styles.defaultColor),
                  value: isChecked,
                  onChanged: (_) => _onChecked(state),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Flexible(
                  child: Text(
                    "I accept Terms & Conditions and the Privacy Policy",
                    style: TextStyle(fontSize: context.px(13)),
                  ),
                ),
              ],
            ),
          ),
          state.errorText != null
              ? Text(
                  state.errorText!,
                  style: TextStyle(fontSize: context.px(14), color: Styles.defaultColor),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  ResponsiveVrtSpacer _buildSpacer(double value) =>
      ResponsiveVrtSpacer(space: context.factorSize(value));
}
