import 'dart:convert';
import 'package:sqlsimpleproject/sql_providers/todo_provider.dart';

List<TodoModel> todoModelFromMap(String str) => List<TodoModel>.from(json.decode(str).map((x) => TodoModel.fromMap(x)));

class TodoModel {
  late String uuid;
  late String todoId;
  late bool isSelected;
  late String firstname;
  late String lastname;
  late int age;
  late List<String> images;
  late Todo todo;

  TodoModel({
    required this.uuid,
      required this.todoId,
      required this.isSelected,
      required this.firstname,
      required this.lastname,
      required this.age,
      required this.images,
      required this.todo});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map = {
      TodoProvider.columnId: uuid,
      TodoProvider.todoId: todoId,
      TodoProvider.isSelected: isSelected ? 1 : 0,
      TodoProvider.firstname: firstname,
      TodoProvider.lastname: lastname,
      TodoProvider.age: age,
      TodoProvider.images: images.join(","),
      TodoProvider.todo: jsonEncode(todo.toMap()),
    };
    return map;
  }

  TodoModel.fromMap(Map<String, dynamic> map) {
    uuid = map[TodoProvider.columnId];
    todoId = map[TodoProvider.todoId];
    isSelected = map[TodoProvider.isSelected] == 1 ? true : false;
    firstname = map[TodoProvider.firstname];
    lastname = map[TodoProvider.lastname];
    age = map[TodoProvider.age];
    images = map[TodoProvider.images].split(",");
    todo = Todo.fromMap(jsonDecode(map[TodoProvider.todo]));
  }
}

class Todo {
  late String comment;
  late String title;

  Todo({
    required this.title,
    required this.comment
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map = {
      "comment": comment,
      "title": title
    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    comment = map["comment"];
    title = map["title"];
  }
}