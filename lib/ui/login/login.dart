import 'package:beamer/beamer.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/resources/constants/styles.dart';

enum LoginType { emailLink, idPassword, googleAuth, unknown }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIDController = TextEditingController(),
      _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isAuthenticated = false;

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

  _onLoginTap() async {
    networkCheckCallback(context, () {
      if (_formKey.currentState!.validate())
        context
            .read(loginPod)
            .signIn(_userIDController.text, _passwordController.text);
    });
  }

  onUsernameChange(String? value) async {
    final error = await hasNetworkError();
    if (error == null) {
      isAuthenticated = await context.read(loginPod).userExists(value!);
      setState(() {});
    } else {
      if (isAuthenticated)
        setState(() {
          isAuthenticated = false;
        });
    }
  }

  onPasswordChange(String? value) {}

  loginWith(BuildContext context, LoginType type) {
    switch (type) {
      case LoginType.emailLink:
        Beamer.of(context).beamToNamed(Routes.email_link_auth);
        break;
      case LoginType.idPassword:
        Beamer.of(context).beamToNamed(Routes.login_id_pass);
        break;
      case LoginType.googleAuth:
        Beamer.of(context).beamToNamed(Routes.login_with_google);
        break;
      case LoginType.unknown:
        Beamer.of(context).beamToNamed(Routes.register);
        break;
    }
  }

  Future<bool> _exitDialog(_) async {
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

  _onLoginStatus(BuildContext context, UserAuthService service) {
    if (service.errorMsg != null)
      context.showErrorBar(
          content: Text(
        service.errorMsg!,
        style: TextStyle(fontSize: 12.sp),
      ));
  }

  @override
  Widget build(BuildContext _) {
    return ProviderListener(
      onChange: _onLoginStatus,
      provider: loginPod,
      child: WillPopScope(
        onWillPop: () => _exitDialog(_),
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30.h),
                    Spacer(),
                    Text("Login",
                        style: TextStyle(
                            fontSize: 40.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildTextFieldWithLabel(
                                controller: _userIDController,
                                label: 'Username / Eamil',
                                hintText: 'Email or Username',
                                icon: CupertinoIcons.person,
                                onChange: onUsernameChange,
                                onValidate: (String? value) => (value!.isEmpty)
                                    ? "Please enter Username or Email"
                                    : null,
                                suffixIcon: isAuthenticated
                                    ? CupertinoIcons.checkmark_alt_circle_fill
                                    : CupertinoIcons.clear_circled_solid,
                                suffixColor: isAuthenticated
                                    ? Colors.green
                                    : Styles.defaultColor),
                            const SizedBox(height: 15),
                            buildTextFieldWithLabel(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: 'Password',
                                onValidate: (String? value) => (value!.isEmpty)
                                    ? "Please enter a Password"
                                    : null,
                                obscureText: true,
                                onChange: onPasswordChange,
                                icon: CupertinoIcons.lock),
                            _buildForgetPassword(),
                          ],
                        ),
                      ),
                    ),
                    _buildLoginButton(),
                    SizedBox(height: 30.h),
                    Text("Or", style: TextStyle(fontSize: 14.sp)),
                    const SizedBox(height: 10),
                    _buildIconButtonRow(),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildSignUpButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildIconButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        _buildIconButton(iconPath: 'assets/icons/email-icon.svg', onTap: () {}),
        const SizedBox(width: 8),
        _buildIconButton(
            iconPath: 'assets/icons/icons8-google.svg', onTap: () {}),
      ],
    );
  }

  GestureDetector _buildIconButton(
      {required String iconPath, required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          iconPath,
          height: 30.sp,
          width: 30.sp,
        ));
  }

  Column _buildSignUpButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Don't you have an account?",
          style: TextStyle(color: Colors.black54, fontSize: 14.sp),
        ),
        const SizedBox(height: 5),
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: MaterialStateProperty.all(Styles.defaultColor),
                textStyle:
                    MaterialStateProperty.all(TextStyle(fontSize: 14.sp))),
            onPressed: () {},
            child: Text("Sign Up")),
      ],
    );
  }

  ElevatedButton _buildLoginButton() {
    return ElevatedButton(
        onPressed: _onLoginTap,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          textStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          fixedSize: MaterialStateProperty.all(Size.fromWidth(.7.sw)),
          backgroundColor: MaterialStateProperty.all(Styles.defaultColor),
        ),
        child: Text("Login"));
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

  Widget buildTextFieldWithLabel(
      {required String label,
      required String hintText,
      required IconData icon,
      IconData? suffixIcon,
      Color? suffixColor,
      bool obscureText = false,
      String? Function(String?)? onValidate,
      Function(String?)? onChange,
      TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.purple),
          child: TextFormField(
            validator: onValidate,
            controller: controller,
            obscureText: obscureText,
            onChanged: onChange,
            decoration: InputDecoration(
              filled: false,
              hintText: hintText,
              prefixIcon: Icon(
                icon,
                color: Colors.grey,
              ),
              suffixIcon: Icon(
                suffixIcon,
                color: suffixColor ?? Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
