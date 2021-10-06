//import 'dart:async';

//import 'package:beamer/beamer.dart';
//import 'package:flash/flash.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:notifications/config/routes/routes.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/ui/login/components/email_link_auth_dialog.dart';
import 'package:notifications/ui/widgets/bold_heading_widget.dart';
import 'package:notifications/ui/widgets/custom_form_widget.dart';
import 'package:notifications/ui/widgets/custom_text_button.dart';
import 'package:notifications/ui/widgets/custom_textfield_labeled.dart';
import 'package:notifications/ui/widgets/default_elevated_button.dart';
import 'package:notifications/ui/widgets/orientation_widget.dart';
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
  final _userIdFocuseNode = FocusNode(), _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool? isAuthenticated;

  ///On Email Link Icon press Popup dialog for authentication
  _onEmailLinkAuthTap() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return EmailLinkAuthDialog();
        });
  }

  ///Sign in via Google Authentication Method
  _onGoogleLogin() async {
    final isLoggedIn = await context.read(loginPod).login();
    if (isLoggedIn) Beamer.of(context).popToNamed(Routes.home,stacked: false);
  }

  ///Manually Login with UserID and Password
  _onLoginButtonTap() {
    FocusScope.of(context).unfocus();
    networkCheckCallback(context, () async {
      if (_formKey.currentState!.validate()) {
        WidgetUtils.showLoaderIndicator(context, 'Loading...');
        final isSignedIn = await context
            .read(loginPod)
            .signIn(_userIDController.text, _passwordController.text);
        popRoute();
        if (isSignedIn) Beamer.of(context).beamToNamed(Routes.home,stacked: false);
      }
    });
  }

  onUsernameChange(String? value) async {
    ///nested function  to avoid duplication
    _resetAuthenticateState() {
      if (isAuthenticated != null) setState(() => isAuthenticated = null);
    }

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

  ///Popup Dialog on Back Button Press
  Future<bool> _onBackPress(_) async {
    return await showDialog<bool>(
            context: _,
            builder: (context) {
              return _buildExitDialog();
            }) ??
        false;
  }

  ///Event listener for error while Logging user
  _onProviderListener(BuildContext ctx, UserAuthService service) {
    final hasSucceeded = service.status == AuthenticationStatus.success;
    final hasNoError = service.errorMsg == null;
    if (!hasNoError) WidgetUtils.showErrorBar(service.errorMsg!);
    //Only for Email Link Authentication
    if (hasNoError && hasSucceeded) Beamer.of(context).popToNamed(Routes.home,stacked:false);
  }

  //Disposing textfield controllers
  @override
  void dispose() {
    _userIDController.dispose();
    _passwordController.dispose();
    _userIdFocuseNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    return ProviderListener(
      onChange: _onProviderListener,
      provider: loginPod,
      child: WillPopScope(
        onWillPop: () => _onBackPress(_),
        child: Scaffold(
          body: SingleChildScrollView(
              child: SafeArea(
            child: SizedBox(
              height: context.fH(),
              child: _buildLoginScreen(),
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Column(
      children: [
        Expanded(
          child: const FractionallySizedBox(
              heightFactor: .5,
              widthFactor: .5,
              child: FittedBox(
                child: BoldHeadingWidget(heading: AppStrings.login),
              )),
        ),
        Expanded(
          flex: context.textScaleFactor > 1 ? 3 : 2,
          child: OrientationWidget(
            portrait: _buildPortraitLayout(),
            landsacpe: _buildLandscapeLayout(),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        Expanded(flex: 2, child: _buildForm()),
        const SizedBox(height: 10),
        Expanded(child: _buildIconButtons()),
        Padding(
          padding: EdgeInsets.only(bottom: context.px(DefaultSizes.mSize)),
          child: _buildSignUpButton(),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(flex: 2, child: _buildForm()),
        //Google and Email Icons , Sign Up Button
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(child: _buildIconButtons()),
              Padding(
                padding: const EdgeInsets.only(right: DefaultSizes.size10),
                child: _buildSignUpButton(MainAxisAlignment.center),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return CustomForm(
      formKey: _formKey,
      child: Column(
        children: [
          _buildUsernameField(),
          _buildPasswordField(),
          //Login Button
          Flexible(
              child: DefaultElevatedButton(
            onPressed: _onLoginButtonTap,
            title: AppStrings.login,
          )),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFieldWithLabeled(
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        label: AppStrings.password,
        hintText: AppStrings.password,
        onValidate: (String? value) =>
            (value!.isEmpty) ? AppStrings.emptyPasswordMsg : null,
        obscureText: true,
        icon: CupertinoIcons.lock);
  }

  Widget _buildUsernameField() {
    return CustomTextFieldWithLabeled(
        focusNode: _userIdFocuseNode,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.ifOrientation("Or", "Sign In with"),
            style: Theme.of(context).textTheme.bodyText1),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            _buildIconButton(
                iconPath: 'assets/icons/email-icon.svg',
                onTap: _onEmailLinkAuthTap),
            const SizedBox(width: 10),
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
          height: context.px(DefaultSizes.size9_5),
          width: context.px(8),
        ));
  }

  Widget _buildSignUpButton(
      [MainAxisAlignment colAlignment = MainAxisAlignment.end]) {
    return Column(
      mainAxisAlignment: colAlignment,
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            AppStrings.dontHaveAccount,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 5),
        OpenContainer(
          closedColor: Colors.transparent,
          closedElevation: 0,
          openElevation: 0,
          middleColor: Colors.white,
          transitionDuration: Duration(milliseconds: 500),
          closedBuilder: (ctx, openContainer) => CustomTextButton(
            title: "Sign Up",
            onPressed: () => openContainer(),
          ),
          openBuilder: (ctx, closeContainer) => SignUp(),
        ),
      ],
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
        onPressed: () {
          _passwordFocusNode.unfocus();
        },
        child: Text("Forget Password?"),
      ),
    );
  }

  Widget _buildExitDialog() {
    return AlertDialog(
      title: Text("Do you want to exit?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("OK")),
        TextButton(
            onPressed: () {
              Beamer.of(context).popRoute();
            },
            child: Text("Cancel"))
      ],
    );
  }
}
