//import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/widgets/bold_heading_widget.dart';
import 'package:notifications/ui/widgets/custom_form_widget.dart';
import 'package:notifications/ui/widgets/custom_text_button.dart';
import 'package:notifications/ui/widgets/custom_textfield_labeled.dart';
import 'package:notifications/ui/widgets/default_elevated_button.dart';
import 'package:notifications/ui/widgets/orientation_widget.dart';
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
  final _usernameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPassController = TextEditingController();
  bool isLoaderOpened = false, hasTapped = false;
  bool isChecked = false;
  bool? isFormValidated;

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
    isFormValidated = _formKey.currentState!.validate();
    //Updating state of [isFormValidated], for different Form layouts
    setState(() {});
    if (isFormValidated!) {
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  bool get _hasSignUpBtnPressed =>
      isFormValidated != null && !isFormValidated! ? true : false;

  ///Checks validaiton when device orientaiton changes,
  ///because it has different Form layout for Portrait and Landscape
  ///[isFormValidated] is true, It will rest, else add some extra height
  ///for avoiding conjusted formfields errorText
  _checkValidationOnRebuild() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_hasSignUpBtnPressed) {
        final isValidated = _formKey.currentState!.validate();
        log("WidgetsBinding.instance->$isValidated ");
        if (isValidated)
          setState(() {
            isFormValidated = true;
          });
      }
    });
  }

  double _getCustomHeight() {
    final defaultHeight = context.fH();
    final scaleFactor = DefaultSizes.largestFontSize * context.textScaleFactor;

    if (context.textScaleFactor > DefaultSizes.defaultFontScaleFactor)
      return defaultHeight + scaleFactor;

    return defaultHeight;
  }

  @override
  Widget build(BuildContext context) {
    _checkValidationOnRebuild();
    return ProviderListener(
      provider: loginPod,
      onChange: _onChanged,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: _getCustomHeight(),
              child: _buildSignUpScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildSignUpScreen() {
    return Column(
      children: [
        const Expanded(
            child: FractionallySizedBox(
          heightFactor: .5,
          widthFactor: .5,
          child:
              FittedBox(child: BoldHeadingWidget(heading: AppStrings.signUp)),
        )),
        Expanded(
          flex: 4,
          child: OrientationWidget(
            landsacpe: _buildSignUpForm(),
            portrait: Column(
              children: [
                _buildSignUpForm(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildAlreadyHaveAccount()),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildSignUpForm() {
    return CustomForm(
        formKey: _formKey,
        child: context.ifOrientation(
            _formFieldsForPortrait(), _formFieldsForLandScape()));
  }

  Widget _formFieldsForLandScape() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUsernameField(),
                  _buildPasswordField(),
                ],
              ),
            ),
            const SizedBox(width: 25),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEmailField(),
                  _buildConfirmPasswordField(),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildAcceptPrivacyCheck()),
            const SizedBox(width: DefaultSizes.size10),
            Expanded(
              child: Center(
                child: DefaultElevatedButton(
                  title: "Sign Up",
                  onPressed: _onRegister,
                  //width: c.maxWidth * .5,
                ),
              ),
              //  Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [

              //     // Text("Or", style: Theme.of(context).textTheme.bodyText1),
              //     // CustomTextButton(
              //     //   title: "Sign In",
              //     //   onPressed: () => Beamer.of(context).popRoute(),
              //     // ),
              //   ],
              // ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Flexible(child: _buildAlreadyHaveAccount()),
      ],
    );
  }

  Widget _formFieldsForPortrait() {
    return Column(
      children: [
        _buildUsernameField(),
        _buildEmailField(),
        _buildPasswordField(),
        _buildConfirmPasswordField(),

        _buildAcceptPrivacyCheck(),
        // _buildSpacer(10),
        DefaultElevatedButton(
          title: "Sign Up",
          onPressed: _onRegister,
        ),
      ],
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
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _onChecked(state),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResponsiveBuilder(builder: (context, sizingInfo) {
                  return Transform.scale(
                    scale:
                        sizingInfo.deviceScreenType == DeviceScreenType.mobile
                            ? 1
                            : 1,
                    child: Checkbox(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: MaterialStateProperty.all(Styles.defaultColor),
                      value: isChecked,
                      onChanged: (_) => _onChecked(state),
                    ),
                  );
                }),
                //const SizedBox(width: 10),
                Flexible(
                    child: Text(
                        "I accept Terms & Conditions and the Privacy Policy",
                        maxLines: 2,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            //fontSize: context.px(DefaultSizes.sSize)
                            ))),
              ],
            ),
          ),
          state.errorText != null
              ? const FittedBox(
                  child: Text(
                    "Please accept Terms & Conditions",
                    textScaleFactor: 1,
                    style: const TextStyle(color: Styles.defaultColor),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
