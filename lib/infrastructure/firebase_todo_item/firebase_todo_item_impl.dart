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

 Future<CollectionReference?> _getItemCollection() async {
   if(itemCollection != null) 
   return itemCollection;
   else {
    final sessionId = LocallyStoredData.getSessionID();
    log("FirebaseTodoItem -> addItem() ");
    final querySnapshot = await fireStore
        .collection(USERS)
        .where('uid', isEqualTo: sessionId)
        .get();
    if (querySnapshot.docs.isNotEmpty)  {
      itemCollection = querySnapshot.docs.first.reference.collection(ITEMS);
      return itemCollection;
    }
     throw StateE 
   }
      
    
  }

  @override
  Future<T?> add<T>() {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<T?> deleteTodoItem<T>() {
    itemCollection ?= 
  }

  @override
  Future<T?> addTodoItem<T>(AddTodoItemModel model) async {
    try {
      collection.add(model.toMap());
      return model as T;
    } on FirebaseException catch (e) {
      log("Exception in addItem()-> $e");
      firebaseToGeneralException(e);
    } catch (e) {
      throw UnknownException(ExceptionsMessages.somethingWrongMsg);
    }
    return null;
  }
}
