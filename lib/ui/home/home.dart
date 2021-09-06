import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/riverpods/pods.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Todo List"),
          actions: [
            TextButton.icon(
                onPressed: () async {
                  await context.read(loginPod).logOut();
                  Beamer.of(context).beamToNamed(Routes.main);
                },
                icon: Icon(Icons.logout_rounded, color: Colors.white),
                label: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: Text("Logged In ")),
          ],
        )));
  }
}
