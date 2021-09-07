class AddTodoItemModel {
  final String title, desc;

  

  AddTodoItemModel({required this.title, required this.desc});

  factory AddTodoItemModel.toJson(Map<String, dynamic> json) =>
      AddTodoItemModel(title: json['title'], desc: json['desc']);

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'desc': this.desc,
    };
  }
}
