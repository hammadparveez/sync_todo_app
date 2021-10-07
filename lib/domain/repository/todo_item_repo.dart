import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/domain/repository/firebase_repos/firebase_user_repo.dart';

abstract class TodoItemRepo extends FirebaseBaseRepository
    implements FirebaseAddRepository {
  Future<T?> addTodoItem<T>(AddTodoItemModel model);
  Future<T?> deleteTodoItem<T>();
}
