import 'package:flutter/material.dart';
import 'package:sqlsimpleproject/model/todo_model.dart';
import 'package:sqlsimpleproject/sql_providers/todo_provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

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

  Future<bool> _insert() async {
    bool result = false;
    TodoModel todoModel = TodoModel(
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

  @override
  void initState() {
    super.initState();
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
              await _insert().then((value) async {
                if(value) {
                  Navigator.of(context).pop(true);
                }
              });
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
