class Todo {
  int? id;
  String title;
  bool isDone;

  Todo({this.id, required this.title, this.isDone = false});

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(id: json['id'], title: json['title'], isDone: json['isDone'] == 1);

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'isDone': isDone ? 1 : 0};

}