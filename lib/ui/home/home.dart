import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';
import 'package:notifications/config/routes/routes.dart';
import 'package:notifications/resources/constants/styles.dart';
import 'package:notifications/riverpods/pods.dart';
import 'package:notifications/ui/widgets/custom_text_button.dart';
import 'package:notifications/ui/widgets/default_elevated_button.dart';

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
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            setState(() {
              snapshot =
                  value.docs.first.reference.collection(ITEMS).snapshots();
            });
          });
        else
          debugPrint("Cannot find");
      });
    }
  }

  _onTap() {
    Beamer.of(context).beamToNamed(Routes.add_todo_item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _buildFloatingButton(),
        appBar: _buildAppBar(context),
        body: Center(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: snapshot,
                builder: (context, snapshot) {
                  debugPrint("Snapshot ${snapshot.connectionState}");
                  if (snapshot.hasError)
                    return Text("Something went wrong");
                  else if (snapshot.connectionState != ConnectionState.active)
                    return CircularProgressIndicator();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,

                      itemCount: snapshot.data?.docs.length ?? 0,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(
                              2), // (2, index.isEven ? 2 : 1.5),
                      itemBuilder: (_, index) {
                        final data = snapshot.data?.docs[index].data();
                        final item = AddTodoItemModel.fromJson(data!);
                        debugPrint(
                            "Random: ${(Random().nextDouble() * 0xFFFFFF).toInt()}");

                        return Card(
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          // Color((Random().nextDouble() * 0xFFFFFF).toInt())
                          //.withOpacity(1.0),

                          elevation: 3,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTextWithShadow(
                                          text: item.title,
                                          isBold: true,
                                          size: 15.sp),
                                      const SizedBox(height: 8),
                                      _buildTextWithShadow(
                                          text: item.desc,
                                          isBold: false,
                                          size: 13.sp),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.share)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                              // TextButton(
                              //     onPressed: () {}, child: Text("Delete")),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                })));
  }

  Text _buildTextWithShadow(
      {required String text, bool isBold = false, double size = 14}) {
    return Text(text,
        style: TextStyle(
            fontSize: size.sp,
            fontWeight: isBold ? FontWeight.w500 : null,
            shadows: [
              Shadow(blurRadius: 2, color: Colors.black38, offset: Offset(0, 1))
            ],
            color: Colors.white));
  }

  FloatingActionButton _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: _onTap,
      child: Icon(Icons.add),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Todo List"),
      actions: [
        TextButton.icon(
            onPressed: () async {
              context.read(loginPod).logOut();
              Beamer.of(context).beamToNamed(Routes.main, stacked: false);
            },
            icon: Icon(Icons.logout_rounded, color: Colors.white),
            label: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
