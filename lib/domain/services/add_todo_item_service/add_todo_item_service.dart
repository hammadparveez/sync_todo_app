import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/firebase_todo_item/firebase_todo_item_impl.dart';

const ITEMS = "items";

class AddTodoItemService extends ChangeNotifier {
  final firebaseTodoItem = FirebaseTodoItem();

  Future<void> addItem(String title, String desc) async {
    await firebaseTodoItem.addItem(title, desc);
  }
}
