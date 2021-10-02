import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:notifications/ui/widgets/screen_sizer.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:spring/spring.dart';
import 'dart:developer' as dev;

enum AnimationsType { width, height, color }

TimelineTween<AnimationsType> createTween() {
  final tween = TimelineTween<AnimationsType>();
  final scene = tween.addScene(
    begin: Duration.zero,
    end: Duration(seconds: 5),
  );
  final firstScene = scene.animate(AnimationsType.color,
      tween: ColorTween(begin: Colors.yellow, end: Colors.purple));
  final secondScene = firstScene
      .addSubsequentScene(duration: Duration(seconds: 2))
      .animate(AnimationsType.height, tween: Tween<double>(begin: 0, end: 150));
  return tween;
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AnimationMixin {
  List<AnimationController?> _animControllers = [];
  Stream<QuerySnapshot<Map<String, dynamic>>>? snapshot;
  ColorTween _tweenColorAnimation =
      ColorTween(begin: Colors.red, end: Colors.purple);
  CustomAnimationControl _control = CustomAnimationControl.stop;
  AnimationController? _colorController;
  Animation<Color?>? _colorAnimation;
  SpringController springController = SpringController();
  initState() {
    super.initState();
    final sessionId = Hive.box(LOGIN_BOX).get(USER_KEY);
    if (sessionId != null) {
      _colorAnimation = ColorTween(begin: Colors.green, end: Colors.lightBlue)
          .animate(controller);

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
    //context.screenUtilInit();

    //dev.log("Sizer Pixel: ${context.textScaleFactor} , ${1.px}");
    // ScreenUtil.init(BoxConstraints(
    //     maxHeight: MediaQuery.of(context).size.height,
    //     maxWidth: MediaQuery.of(context).size.width));
    _animControllers = [];
    return Sizer(
      child: Scaffold(
          //floatingActionButton: _buildFloatingButton(),
          appBar: _buildAppBar(context),
          body: Stack(
            children: [
              Center(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: snapshot,
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Text("Something went wrong");
                        else if (snapshot.connectionState !=
                            ConnectionState.active)
                          return CircularProgressIndicator();
    
                        return Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
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
    
                              return Bounce(
                                key: UniqueKey(),
                                controller: (controller) {
                                  _animControllers.add(controller);
                                },
                                manualTrigger: true,
                                child: Card(
                                  color: _colorAnimation!
                                      .value, //.get(AnimationsType.color),
    
                                  // color: Colors
                                  //     .primaries[Random()
                                  //         .nextInt(Colors.primaries.length)]
                                  //     .shade800,
                                  // Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                  //.withOpacity(1.0),
                                  //elevation: value.get(AnimationsType.height),
    
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.all(context.px(1)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildTextWithShadow(
                                                  text: item.title,
                                                  isBold: true,
                                                  size: context.px(2)),
                                              const SizedBox(height: 8),
                                              _buildTextWithShadow(
                                                  text: item.desc,
                                                  isBold: false,
                                                  size:context.px(2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              color: Colors.white,
                                              onPressed: () {},
                                              icon: Icon(Icons.share)),
                                          IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                _animControllers[index]!
                                                    .reverse();
                                              },
                                              icon: Icon(CupertinoIcons.delete)),
                                        ],
                                      ),
                                      // TextButton(
                                      //     onPressed: () {}, child: Text("Delete")),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      })),
              Positioned(
                bottom: 20,
                right: 20,
                child: OpenContainer(
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    transitionType: ContainerTransitionType.fade,
                    openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    transitionDuration: Duration(milliseconds: 2000),
                    closedBuilder: (_, openBuilder) => FloatingActionButton(
                          onPressed: () => openBuilder(),
                          child: Icon(Icons.add),
                        ),
                    openBuilder: (_, closedBuilder) {
                      return AddTodoItems();
                    }),
              ),
            ],
          )),
    );
  }

  Text _buildTextWithShadow(
      {required String text, bool isBold = false, double size = 14}) {
    return Text(text,
        style: TextStyle(
            fontSize: context.px(size),
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
