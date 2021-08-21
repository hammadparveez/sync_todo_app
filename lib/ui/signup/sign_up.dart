import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:notifications/riverpods/pods.dart';

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

  String? _userNameValidate(String? value) {
    if (value!.isNotEmpty && value.length < 8)
      return "Username Must Be 8 characters long";
    else if (value.isEmpty) return "Username required";
    return null;
  }

  String? _emailValidate(String? value) {
    if (value!.isEmpty)
      return "Email required";
    else if (!value.isEmail) return "Please enter a Valid Email";
    return null;
  }

  String? _passwordValidate(String? value) {
    if (value!.isEmpty)
      return "Password required";
    else if (value.isAlphabetOnly || value.isNumericOnly)
      return "Password must be AlphaNumeric";
    return null;
  }

  String? _confirmPassValidate(String? value) {
    if (value!.isEmpty)
      return "Confirm Password required";
    else if (value != _passwordController.text) return "Password doesn't match";
    return null;
  }

  _onRegister() async {
    bool? isValid = _formKey.currentState?.validate();
    if (isValid!) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please wait...."),
        duration: Duration(seconds: 5),
      ));
      await Future.delayed(Duration(seconds: 5));
      try {
        await context
            .read(registerPod)
            .register(_usernameController.text, _emailController.text,
                _passwordController.text)
            .catchError((_) {
          log("Signup->RegisterUI->Try $_");
        });
      } catch (e) {
        log("Signup->RegisterUI $e");
      }
    } else {
      log("Invalid $isValid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "Email Address"),
                validator: _emailValidate,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(hintText: "Username"),
                validator: _userNameValidate,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "Password"),
                validator: _passwordValidate,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPassController,
                decoration: InputDecoration(hintText: "Confirm Password"),
                validator: _confirmPassValidate,
              ),
              ElevatedButton(onPressed: _onRegister, child: Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
