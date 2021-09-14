import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/export.dart';

abstract class FirebaseBaseRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
}

abstract class FirebaseAddRepository extends FirebaseBaseRepository {
  Future<T> add<T>();
}

abstract class FirebaseGetRepo extends FirebaseBaseRepository {
  Future<T> get<T>();
}

abstract class FirebaseRegisterWithIDPassRepo extends FirebaseAddRepository {
  Future<T> createUserWithIDAndPass<T>(UserAccountModel model);

  Future<T> loginUser<T>(String userID, String password);
}

abstract class FirebaseLoginUserRepo extends FirebaseGetRepo {
  Future<T> getUser<T>(String userID);
}
