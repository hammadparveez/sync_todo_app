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
    context.read(registerPod).signIn("hammad122@gmail.com", "ham1");
  }

  @override
  Widget build(BuildContext _) {
    return ProviderListener(
      onChange: (_, AuthUserService service) async {
        await Future.delayed(Duration(seconds: 3));
        if (!service.isLoading) await Beamer.of(context).popRoute();

        if (service.errorMsg != null)
          WidgetUtils.snackBar(context, service.errorMsg!);
      },
      provider: registerPod,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: "Enter Username/Email"),
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
