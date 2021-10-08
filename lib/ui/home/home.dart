import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';
import 'package:notifications/config/routes/routes.dart';

import 'package:notifications/riverpods/pods.dart';
import 'package:notifications/ui/home/components/todo_item_card_widget.dart';

import 'package:simple_animations/simple_animations.dart';
import 'package:spring/spring.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AnimationMixin {
  Stream<QuerySnapshot<Map<String, dynamic>>>? snapshot;

  List<GlobalKey<AnimatorWidgetState>> _animationKey = [];
  AnimationPreferences? _animationPreferences;
  initState() {
    super.initState();
    _animationPreferences =
        AnimationPreferences(autoPlay: AnimationPlayStates.None);

    context.read(addTodoItemPod).getAddedItem().then((value) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        setState(() {
          snapshot = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _animationKey = [];
    return Scaffold(
      floatingActionButton: _buildFloatingButton(),
      appBar: _buildAppBar(context),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: snapshot,
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return _buildErrorWidget();
            else if (snapshot.connectionState != ConnectionState.active)
              return _buildLoader();
            return _buildSnapshots(snapshot);
          }),
    );
  }

  Widget _buildSnapshots(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: snapshot.data?.docs.length ?? 0,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        itemBuilder: (_, index) {
          final data = snapshot.data?.docs[index].data();
          _animationKey.add(GlobalKey<AnimatorWidgetState>());
          final item = AddTodoItemModel.fromJson(data!);
          return RubberBand(
            key: _animationKey[index],
            preferences: _animationPreferences!,
            child: TodoItemCardWidget(
                item: item, animationKey: _animationKey[index]),
          );
        },
      ),
    );
  }

  Text _buildErrorWidget() => Text("Something went wrong");

  CircularProgressIndicator _buildLoader() => CircularProgressIndicator();

  Widget _buildFloatingButton() {
    return OpenContainer(
        closedColor: Colors.transparent,
        closedElevation: 0,
        openElevation: 0,
        transitionType: ContainerTransitionType.fade,
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        transitionDuration: Duration(milliseconds: 500),
        closedBuilder: (_, openBuilder) => FloatingActionButton(
              elevation: 0,
              onPressed: () => openBuilder(),
              child: Icon(Icons.add),
            ),
        openBuilder: (_, closedBuilder) {
          return AddTodoItems();
        });
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
