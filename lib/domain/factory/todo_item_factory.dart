import 'package:notifications/domain/repository/todo_item_repo.dart';
import 'package:notifications/infrastructure/firebase_todo_item/firebase_todo_item_impl.dart';

enum TodoItemCreationType { basic }

abstract class ToDoItemFactory {
  TodoItemRepo create(TodoItemCreationType type);
}

class TodoItemFactoryImpl extends ToDoItemFactory {
  @override
  TodoItemRepo create(TodoItemCreationType type) {
    switch (type) {
      case TodoItemCreationType.basic:
        return FirebaseTodoItem();
    }
  }
}
