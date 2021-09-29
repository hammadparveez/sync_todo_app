import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';
import 'package:notifications/resources/local/local_storage.dart';

class FirebaseTodoItem {
  final firestore = FirebaseFirestore.instance;
  Future<void> addItem(String title, String desc) async {
    try {
      final sessionId = LocallyStoredData.getSessionID();
      log("FirebaseTodoItem -> addItem() ");
      final querySnapshot = await firestore
          .collection(USERS)
          .where('uid', isEqualTo: sessionId)
          .get();

      if (querySnapshot.docs.isNotEmpty)
        querySnapshot.docs.first.reference
            .collection(ITEMS)
            .add(AddTodoItemModel(title: title, desc: desc).toMap());
    } on FirebaseException catch (e) {
      log("Exception in addItem()-> $e");
      firebaseToGeneralException(e);
    }
  }
}
