import 'package:notifications/domain/factory/todo_item_factory.dart';
import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/domain/repository/todo_item_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/infrastructure/firebase_todo_item/firebase_todo_item_impl.dart';

const ITEMS = "items";

class AddTodoItemService extends ChangeNotifier {
  final firebaseTodoItem = FirebaseTodoItem();
  final TodoItemRepo todoItemRepo =
      getIt.get<ToDoItemFactory>().create(TodoItemCreationType.basic);
  String? _errMsg;

  String? get errMsg => this._errMsg;

  Future<void> addItem(String title, String desc) async {
    _errMsg = null;
    try {
      final model = await todoItemRepo
          .addTodoItem(AddTodoItemModel(title: title, desc: desc));
      log("Model $model");
      log("AddTodoItemService ->addItem() Item added");
    } on BaseException catch (e) {
      log("AddTodoItemService BaseException ${e}");
      _errMsg = e.msg;
    } catch (e) {
      log("AddTodoItemService Exception ${e}");
      _errMsg = ExceptionsMessages.somethingWrongMsg;
    }

    notifyListeners();
  }
}
