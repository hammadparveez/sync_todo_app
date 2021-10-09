import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/domain/repository/todo_item_repo.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/constants/exceptions_messages.dart';
import 'package:notifications/resources/local/local_storage.dart';

class FirebaseTodoItem extends TodoItemRepo {
  static final FirebaseTodoItem _instance = FirebaseTodoItem._();
  FirebaseTodoItem._();
  factory FirebaseTodoItem() => _instance;

  CollectionReference? itemCollection;
  String? prevSessionID;

  Future<CollectionReference?> _getItemCollection() async {
    final sessionId = LocallyStoredData.getSessionID();
    log("Previous SessionID: $prevSessionID");
    log("New SessionID: $sessionId");
    if (itemCollection != null && sessionId == prevSessionID)
      return itemCollection;
    else {
      prevSessionID = sessionId;
      log("FirebaseTodoItem -> addItem() ");
      final querySnapshot = await fireStore
          .collection(USERS)
          .where('uid', isEqualTo: sessionId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        itemCollection = querySnapshot.docs.first.reference.collection(ITEMS);
        return itemCollection;
      }
    }
  }

  @override
  Future<T?> add<T>() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<T?> deleteTodoItem<T>(String itemID) async {
    final collection = await _getItemCollection();
    final docs = await collection?.where('uid', isEqualTo: itemID).get();
    docs?.docs.first.reference.delete();
  }

  @override
  Future<T?> addTodoItem<T>(AddTodoItemModel model) async {
    try {
      final qs = await _getItemCollection();
      qs?.add(
        model.toMap()..addAll({'createdAt': FieldValue.serverTimestamp()}),
      );

      return model as T;
    } on FirebaseException catch (e) {
      log("Exception in addItem()-> $e");
      firebaseToGeneralException(e);
    } catch (e) {
      throw UnknownException(ExceptionsMessages.somethingWrongMsg);
    }
    return null;
  }

  Future<Stream<QuerySnapshot<Object?>>> getTodoItems<T>() async {
    final collection = await _getItemCollection();
    if (collection != null)
      return collection.orderBy('createdAt', descending: true).snapshots();
    else
      throw UnknownException("Seems to me like, Something went wrong");
  }
}
