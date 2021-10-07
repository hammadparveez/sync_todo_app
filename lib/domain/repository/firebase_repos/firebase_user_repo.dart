import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';

abstract class FirebaseBaseRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
}

abstract class FirebaseAddRepository extends FirebaseBaseRepository {
  @protected
  Future<T?> add<T>();
}

abstract class FirebaseGetRepo extends FirebaseBaseRepository {
  @protected
  Future<T> get<T>();
}
