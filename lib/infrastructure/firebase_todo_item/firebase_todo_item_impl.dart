import 'package:notifications/domain/model/add_todo_item_model.dart';
import 'package:notifications/export.dart';

class FirebaseTodoItem {
  final firestore = FirebaseFirestore.instance;
  Future<void> addItem(String title, String desc) async {
    try {
      final docRef = await firestore
          .collection(USERS)
          .doc("hammad@gmail.com")
          .collection(ITEMS)
          .add(AddTodoItemModel(title: title, desc: desc).toMap());

      final doc = await docRef.get().catchError((_) {
        log("CatchError -> $_");
      });
      log("Document ${doc.exists} and ${doc.data()}");
    } catch (e) {
      log("Exception in AddITem -> $e");
    }
  }
}
