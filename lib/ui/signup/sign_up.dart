import 'dart:developer';

import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "maswwwon11"),
      _emailController = TextEditingController(text: "mason@gmail.com"),
      _passwordController = TextEditingController(text: "ha11"),
      _confirmPassController = TextEditingController(text: "ha11");

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
    //Clears any snackbar opened due to Error or Multiple clicks
    //ScaffoldMessenger.of(context).clearSnackBars();
    log("SignUp -> _onRegisterTap ");
    if (_formKey.currentState!.validate()) {
      // WidgetUtils.showLoaderIndicator(
      //     context, "Please wait! Loading.....Registering");
      final isLoggedIn = await context.read(loginPod).register(
            _usernameController.text,
            _emailController.text,
            _passwordController.text,
          );
      if (isLoggedIn) Beamer.of(context).beamToNamed(Routes.login_id_pass);
    } else
      log("Form Input Invalid");
  }

  _onChanged(_, UserAuthService service) async {
    if (service.errorMsg != null)
      WidgetUtils.snackBar(context, service.errorMsg!);
    // if (!service.isLoading) await Beamer.of(context).popRoute();
    // if (service.taskCompleted) {
    //   log("User Added Successfully");
    //   Beamer.of(context).popToNamed(
    //     Routes.login_id_pass,
    //     replaceCurrent: true,
    //   );
    // } else {
    //   WidgetUtils.snackBar(context, service.errorMsg!);
    // }
  }

  _alreadyHaveAccount() => Beamer.of(context).popToNamed(Routes.main);

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: loginPod,
      onChange: _onChanged,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
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
                  ElevatedButton(
                      onPressed: _onRegister, child: Text("Sign Up")),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: _alreadyHaveAccount,
                      child: Text("Already Have an Account?")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
