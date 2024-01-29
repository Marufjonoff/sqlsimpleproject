import 'package:flutter/material.dart';
import 'package:sqlsimpleproject/model/todo_model.dart';
import 'package:sqlsimpleproject/sql_providers/todo_provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoScreen extends StatefulWidget {
  final bool? isEditable;
  final TodoModel? model;

  const AddTodoScreen({super.key, this.isEditable, this.model});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final todoProvider = TodoProvider();

  final TextEditingController lastname = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController comment = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController todoId = TextEditingController();

  /// insert
  Future<bool> _insert() async {
    bool result = false;
    Uuid uuid = const Uuid();
    TodoModel todoModel = TodoModel(
        uuid: uuid.v4(),
        todoId: todoId.text.trim(),
        isSelected: todoId.text.trim() == "1000" || todoId.text.trim() == "1001" ? true : false,
        firstname: firstname.text.trim(),
        lastname: lastname.text.trim(),
        age: int.tryParse(age.text.trim()) ?? 20,
        images: [],
        todo: Todo(
          title: title.text.trim(),
          comment: comment.text.trim()
        )
    );

    final id = await todoProvider.insert(todoModel);
    debugPrint("Success inserted row id: $id");
    if(id >= 1) {
      result = true;
    }
    return result;
  }

  /// update
  Future<bool> _update() async {
    bool result = false;
    TodoModel todoModel = TodoModel(
        uuid: widget.model!.uuid,
        todoId: todoId.text.trim(),
        isSelected: todoId.text.trim() == "1000" || todoId.text.trim() == "1001" ? true : false,
        firstname: firstname.text.trim(),
        lastname: lastname.text.trim(),
        age: int.tryParse(age.text.trim()) ?? 20,
        images: [
          "https://news.ubc.ca/wp-content/uploads/2023/08/AdobeStock_559145847.jpeg"
        ],
        todo: Todo(
            title: title.text.trim(),
            comment: comment.text.trim()
        )
    );
    debugPrint("Query: ${todoModel.toMap()}");
    final id = await todoProvider.update(todoModel);
    debugPrint("Success update row id: $id");
    if(id >= 1) {
      result = true;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    bool isEdit = widget.isEditable ?? false;
    TodoModel? model = widget.model;

    if(isEdit) {
      lastname.text = model!.lastname;
      firstname.text = model.firstname;
      age.text = model.age.toString();
      comment.text = model.todo.comment;
      title.text = model.todo.title;
      todoId.text = model.todoId;
      debugPrint("\nEdit id: ${model.uuid}\n");
    }

    todoProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add todo"),
        actions: [
          TextButton(
            onPressed: () async {
              if(widget.isEditable ?? false) {
                await _update().then((value) async {
                  if(value) {
                    Navigator.of(context).pop(true);
                  }
                });
              } else {
                await _insert().then((value) async {
                  if(value) {
                    Navigator.of(context).pop(true);
                  }
                });
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.green, fontSize: 16),),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: firstname,
                decoration: const InputDecoration(
                  hintText: "Firstname"
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lastname,
                decoration: const InputDecoration(
                    hintText: "Lastname"
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: age,
                decoration: const InputDecoration(
                    hintText: "Age"
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: comment,
                decoration: const InputDecoration(
                    hintText: "Comment"
                ),
              ),
              const SizedBox(height: 10),TextField(
                controller: title,
                decoration: const InputDecoration(
                    hintText: "Title"
                ),
              ),
              const SizedBox(height: 10),TextField(
                controller: todoId,
                decoration: const InputDecoration(
                    hintText: "TodoId Example: 1000, 1001, 1002"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
