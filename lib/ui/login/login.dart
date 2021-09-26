//import 'dart:async';

//import 'package:beamer/beamer.dart';
//import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/login/components/email_link_auth_dialog.dart';
import 'package:notifications/ui/widgets/bold_heading_widget.dart';
import 'package:notifications/ui/widgets/custom_form_widget.dart';
import 'package:notifications/ui/widgets/custom_text_button.dart';
import 'package:notifications/ui/widgets/custom_textfield_labeled.dart';
import 'package:notifications/ui/widgets/default_elevated_button.dart';
import 'package:notifications/ui/widgets/spacer.dart';
//import 'package:notifications/resources/extensions/widget_ext.dart';

enum LoginType { emailLink, idPassword, googleAuth, unknown }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIDController = TextEditingController(),
      _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? isAuthenticated;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userIDController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _onEmailLinkAuthTap() {
    showDialog(
        context: context,
        builder: (_) {
          return EmailLinkAuthDialog();
        });
  }

  _onGoogleLogin() async {
    final isLoggedIn = await context.read(loginPod).login();
    if (isLoggedIn) Beamer.of(context).beamToNamed(Routes.home);
  }

  _onLoginButtonTap() {
    networkCheckCallback(context, () async {
      if (_formKey.currentState!.validate()) {
        WidgetUtils.showLoaderIndicator(context, 'Loading...');
        final isSignedIn = await context
            .read(loginPod)
            .signIn(_userIDController.text, _passwordController.text);
        Navigator.pop(context);
        if (isSignedIn) Beamer.of(context).beamToNamed(Routes.home);
      }
    });
  }

  _resetAuthenticateState() {
    if (isAuthenticated != null)
      setState(() {
        isAuthenticated = null;
      });
  }

  onUsernameChange(String? value) async {
    final error = await hasNetworkError();
    if (_userIDController.text.isNotEmpty && error == null) {
      isAuthenticated = await context.read(loginPod).userExists(value!);
      setState(() {});
      return;
    }
    _resetAuthenticateState();
  }

  onPasswordChange(String? value) {
    //Code goes here....
  }

  Future<bool> _onBackPress(_) async {
    return await showDialog<bool>(
            context: _,
            builder: (context) {
              return AlertDialog(
                title: Text("Do you want to exit?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("OK")),
                  TextButton(
                      onPressed: () {
                        Beamer.of(_).popRoute();
                      },
                      child: Text("Cancel"))
                ],
              );
            }) ??
        false;
  }

  _onLoginStatus(BuildContext ctx, UserAuthService service) {
    log("LoginStatus: ${service.status} ");
    if (service.errorMsg != null) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      WidgetUtils.showErrorBar(context, service.errorMsg!);
    }
    if (service.errorMsg == null &&
        service.status == AuthenticationStatus.success) {
      log("On Success Listener Login Status");
      Beamer.of(context).beamToNamed(Routes.home);
    }
    //ctx.showErrorBar(content: Text(service.errorMsg!));
    //log("Login Status: ${service.authType}");
    // if (service.authType == AuthenticationType.login ||
    //     service.authType == AuthenticationType.googleLogin)
    //   ctx.showDefaultErrorMsg(service, service.authType);
  }

  @override
  Widget build(BuildContext _) {
    return ProviderListener(
      onChange: _onLoginStatus,
      provider: loginPod,
      child: WillPopScope(
        onWillPop: () => _onBackPress(_),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
              child: SizedBox(height: 1.sh, child: _buildLoginScreen())),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //_buildVrtSpacer(60),
        _buildHeading(),
        //_buildVrtSpacer(30),
        _buildForm(),
        //_buildVrtSpacer(30),
        _buildIconButtons(),

        _buildSignUpButton(),
      ],
    );
  }

  BoldHeadingWidget _buildHeading() =>
      BoldHeadingWidget(heading: AppStrings.login);

  ResponsiveVrtSpacer _buildVrtSpacer(double value) =>
      ResponsiveVrtSpacer(space: value);

  Widget _buildForm() {
    return CustomForm(
      formKey: _formKey,
      child: Column(
        children: [
          _buildUsernameField(),
          _buildVrtSpacer(10),
          _buildPasswordField(),
          _buildForgetPassword(),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFieldWithLabeled(
        controller: _passwordController,
        label: AppStrings.password,
        hintText: AppStrings.password,
        onValidate: (String? value) =>
            (value!.isEmpty) ? AppStrings.emptyPasswordMsg : null,
        obscureText: true,
        onChange: onPasswordChange,
        icon: CupertinoIcons.lock);
  }

  Widget _buildUsernameField() {
    return CustomTextFieldWithLabeled(
        controller: _userIDController,
        label: AppStrings.usernameOrEmail,
        hintText: AppStrings.usernameOrEmail1,
        icon: CupertinoIcons.person,
        onChange: onUsernameChange,
        onValidate: (String? value) =>
            (value!.isEmpty) ? AppStrings.emptyUserIDMsg : null,
        suffixIcon: isAuthenticated == null
            ? null
            : (isAuthenticated!
                ? CupertinoIcons.checkmark_alt_circle_fill
                : CupertinoIcons.clear_circled_solid),
        suffixColor: isAuthenticated == null
            ? null
            : (isAuthenticated! ? Colors.green : Styles.defaultColor));
  }

  Widget _buildIconButtons() {
    return Column(
      children: [
        Text("Or", style: TextStyle(fontSize: 14.sp)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            _buildIconButton(
                iconPath: 'assets/icons/email-icon.svg',
                onTap: _onEmailLinkAuthTap),
            const SizedBox(width: 8),
            _buildIconButton(
                iconPath: 'assets/icons/icons8-google.svg',
                onTap: _onGoogleLogin),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
      {required String iconPath, required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          iconPath,
          height: 30.sp,
          width: 30.sp,
        ));
  }

  Widget _buildSignUpButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: TextStyle(color: Colors.black54, fontSize: 14.sp),
        ),
        const SizedBox(height: 5),
        CustomTextButton(
            title: "Sign Up",
            onPressed: () => Beamer.of(context).beamToNamed(Routes.register)),
      ],
    );
  }

  Widget _buildLoginButton() {
    return DefaultElevatedButton(
      onPressed: _onLoginButtonTap,
      title: AppStrings.login,
    );
  }

  Widget _buildForgetPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Color(0x11000000)),
          foregroundColor: MaterialStateProperty.all(Color(0x55000000)),
        ),
        onPressed: () {},
        child: Text("Forget Password?"),
      ),
    );
  }
}
