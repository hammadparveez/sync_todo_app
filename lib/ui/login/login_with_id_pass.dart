import 'package:notifications/export.dart';
import 'dart:developer';

class LoginWithIDAndPass extends StatefulWidget {
  const LoginWithIDAndPass({Key? key}) : super(key: key);

  @override
  _LoginWithIDAndPassState createState() => _LoginWithIDAndPassState();
}

class _LoginWithIDAndPassState extends State<LoginWithIDAndPass> {


  void _login() {
    log("OnLoginTap");
    context.read(registerPod).signIn("hamm@gg.co", "ham11");
  }

  @override
  Widget build(BuildContext _) {
    return ProviderListener(
      onChange: (_,AuthUserService service){
        log("OnChangeListener ${service.hasUserFound}");

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
