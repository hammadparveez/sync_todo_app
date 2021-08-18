import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(hintText: "Email Address"),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(hintText: "Username"),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(hintText: "Password"),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(hintText: "Confirm Password"),
        ),
      ],
    );
  }
}
