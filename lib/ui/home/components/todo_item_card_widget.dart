import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';
import 'package:share/share.dart';

class TodoItemCardWidget extends StatelessWidget {
  const TodoItemCardWidget({
    Key? key,
    required this.item,
    required GlobalKey<AnimatorWidgetState<AnimatorWidget>> animationKey,
  })  : _animationKey = animationKey,
        super(key: key);

  final AddTodoItemModel item;
  final GlobalKey<AnimatorWidgetState<AnimatorWidget>> _animationKey;

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF4E4E4E));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Styles.randomColors[Random().nextInt(Styles.randomColors.length)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ItemTitleWidget(title: item.title, desc: item.desc),
          TodoItemBoxIcons(
            onSharePress: () {
              Share.share("Title: ${item.title}\nDescription: ${item.desc}");
            },
            onDeletePress: () async {
              _animationKey.currentState?.forward();

              final hasNetwork = await hasConnection;
              if (hasNetwork)
                showToast("Deleting an Item...");
              else
                showToast("Item will be as Internet get Establishes");
              await Future.delayed(Duration(seconds: 1));
              await context.read(addTodoItemPod).deleItem(item.uid);
              if (hasNetwork) showToast("Item has been Deleted");
            },
          ),
        ],
      ),
    );
  }
}

class TodoItemBoxIcons extends StatelessWidget {
  const TodoItemBoxIcons({
    Key? key,
    required this.onDeletePress,
    required this.onSharePress,
  }) : super(key: key);

  final VoidCallback onDeletePress, onSharePress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            iconSize: context.px(DefaultSizes.size6),
            color: Colors.white,
            onPressed: onSharePress,
            icon: Icon(Icons.share)),
        IconButton(
            color: Colors.white,
            iconSize: context.px(DefaultSizes.size6),
            onPressed: onDeletePress,
            icon: Icon(CupertinoIcons.delete)),
      ],
    );
  }
}

class ItemTitleWidget extends StatelessWidget {
  const ItemTitleWidget({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  final String title, desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
