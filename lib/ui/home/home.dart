import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/routes.dart';
import 'package:notifications/riverpods/pods.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? snapshot;
  initState() {
    super.initState();
    final sessionId = Hive.box(LOGIN_BOX).get(USER_KEY);
    if (sessionId != null) {
      FirebaseFirestore.instance
          .collection(USERS)
          .where('uid', isEqualTo: sessionId)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty)
          setState(() {
            snapshot = value.docs.first.reference.collection(ITEMS).snapshots();
          });
        else
          log("Cannot find");
      });
    }
  }

  _onTap() {
    Beamer.of(context).beamToNamed(Routes.add_todo_item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _onTap,
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: snapshot,
                builder: (context, snapshot) {
                  log("Snapshot ${snapshot.connectionState}");
                  if (snapshot.hasError)
                    return Text("Something went wrong");
                  else if (snapshot.connectionState != ConnectionState.active)
                    return CircularProgressIndicator();
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      return Text(
                          "$index Data: ${snapshot.data?.docs[index].data()['title']}");
                    },
                    itemCount: snapshot.data?.docs.length ?? 0,
                  );
                })));
  }
}
