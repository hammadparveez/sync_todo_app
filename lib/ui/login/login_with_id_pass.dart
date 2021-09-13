import 'dart:developer';

import 'package:notifications/export.dart';

class LoginWithIDAndPass extends StatefulWidget {
  const LoginWithIDAndPass({Key? key}) : super(key: key);

  @override
  _LoginWithIDAndPassState createState() => _LoginWithIDAndPassState();
}

class _LoginWithIDAndPassState extends State<LoginWithIDAndPass> {
  void _login() async {
    log("OnLoginTap");
    WidgetUtils.showLoaderIndicator(context, "Signing In, Please wait....!");

    context.read(loginWithIdAndPassPod).login("mason@gmail.com", "ha11");
  }

  void _onChange(_, LoginService service) async {
    await closeAnyPopup(context, !service.isLoading);

    if (service.errMsg != null) WidgetUtils.snackBar(context, service.errMsg!);

    if (service.isUserLoggedIn) {
      log("User Logged In Successfully");
      //ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      Beamer.of(context).popToNamed(Routes.home, stacked: false);
    }
  }

  @override
  Widget build(BuildContext _) {
    return WillPopScope(
      onWillPop: () async {
        log("OnWillPopScope");
        ScaffoldMessenger.of(context)
            .removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
        return true;
      },
      child: ProviderListener(
        onChange: _onChange,
        provider: loginWithIdAndPassPod,
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
      ),
    );
  }
}
