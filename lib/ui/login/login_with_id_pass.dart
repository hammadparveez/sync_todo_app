import 'package:flutter/material.dart';

class LoginWithIDAndPass extends StatelessWidget {
  const LoginWithIDAndPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return Scaffold(
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
            ],
          ),
        ),
      ),
    );
  }
}
