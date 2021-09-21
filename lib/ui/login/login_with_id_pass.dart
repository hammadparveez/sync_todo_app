import 'dart:developer';

import 'package:notifications/domain/services/auth_service/user_auth_service.dart';
import 'package:notifications/export.dart';

class LoginWithIDAndPass extends StatefulWidget {
  const LoginWithIDAndPass({Key? key}) : super(key: key);

  @override
  _LoginWithIDAndPassState createState() => _LoginWithIDAndPassState();
}

class _LoginWithIDAndPassState extends State<LoginWithIDAndPass> {
  void _login() async {
    log("OnLoginTap");
    // WidgetUtils.showLoaderIndicator(context, "Signing In, Please wait....!");

    final isLoggedIn =
        await context.read(loginPod).signIn('mason@gmail.com', 'ha11');
    if (isLoggedIn)
      Beamer.of(context)
          .popToNamed(Routes.home, replaceCurrent: true, stacked: false);
  }

  void _onChange(_, UserAuthService service) async {
    // await closeAnyPopup(context, !service.isLoading);
    log("User Session ${service.sessionID}");
    if (service.errorMsg != null)
      WidgetUtils.snackBar(context, service.errorMsg!);
    // if (service.isUserLoggedIn) {
    //   log("User Logged In Successfully");
    //   //ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
    //   Beamer.of(context).popToNamed(Routes.home, stacked: false);
    // }
  }

  @override
  Widget build(BuildContext _) {
    return ProviderListener(
      onChange: _onChange,
      provider: loginPod,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(hintText: "Email address or username"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: "Enter Password"),
                ),
                ElevatedButton(onPressed: _login, child: Text("Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
