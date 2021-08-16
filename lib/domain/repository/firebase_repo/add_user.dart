import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseAddUserRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  addUser(String value);
}
