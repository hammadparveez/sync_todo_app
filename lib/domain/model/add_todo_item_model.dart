import 'package:notifications/export.dart';
import 'package:uuid/uuid.dart';

class AddTodoItemModel {
  final String title, desc;
  Timestamp? createdAt;
  String uid = Uuid().v1();

  AddTodoItemModel({required this.title, required this.desc});

  factory AddTodoItemModel.fromJson(Map<String, dynamic> json) {
    return AddTodoItemModel(
        title: json['title'], desc: json['desc'])
      ..uid = json['uid']
      ..createdAt = json['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'title': this.title,
      'desc': this.desc,
      'createdAt': this.createdAt,
    };
  }
}
