import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _userIDController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    return WillPopScope(
      onWillPop: () => _exitDialog(_),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                Text(
                  "Login",
                  style:
                      TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Column(
                    children: [
                      buildTextFieldWithLabel(
                          controller: _userIDController,
                          label: 'Username/Eamil',
                          hintText: 'Email or Username',
                          icon: CupertinoIcons.person,
                          suffixIcon: CupertinoIcons.checkmark_alt_circle_fill),
                      const SizedBox(height: 15),
                      buildTextFieldWithLabel(
                          controller: _passwordController,
                          label: 'Password',
                          hintText: 'Password',
                          icon: CupertinoIcons.lock),
                      _buildForgetPassword(),
                    ],
                  ),
                ),
                _buildLoginButton(),
                SizedBox(height: 30.h),
                Text("Or", style: TextStyle(fontSize: 14.sp)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        iconSize: 25.sp,
                        color: Colors.black54,
                        icon: Icon(CupertinoIcons.envelope)),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {},
                        iconSize: 25.sp,
                        color: Colors.black54,
                        icon: Icon(CupertinoIcons.minus_rectangle)),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 16.sp))),
                            onPressed: () {},
                            child: Text("Sign Up"))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildLoginButton() {
    return ElevatedButton(
        onPressed: () {},
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
            controller: controller,
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
