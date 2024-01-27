import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlsimpleproject/model/todo_model.dart';
import 'package:sqlsimpleproject/screen/add_todo_screen.dart';
import 'package:sqlsimpleproject/sql_providers/todo_provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final todoProvider = TodoProvider();
  List<TodoModel> todos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoProvider.init();
  }

  Future<void> _getAllTodos() async {
    todos = await todoProvider.getAllTodoModel();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Screen"),
        actions: [
          IconButton(
            onPressed: _getAllTodos,
            icon: const Icon(Icons.refresh, color: Colors.black),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          List<String> images = todos[index].images.isEmpty ? [] : todos[index].images;
          return Stack(
            children: [
              Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: todos[index].isSelected ? Colors.purple : Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Firstname: ",
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                              text: todos[index].firstname,
                              style: const TextStyle(fontWeight: FontWeight.w500)
                            ),
                          ]
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            text: "Lastname: ",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: todos[index].lastname,
                                  style: const TextStyle(fontWeight: FontWeight.w500)
                              ),
                            ]
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            text: "Age: ",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: todos[index].age.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w500)
                              ),
                            ]
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                            text: "Ids: ",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "id - ${todos[index].id}, todoId - ${todos[index].todoId}",
                                  style: const TextStyle(fontWeight: FontWeight.w500)
                              ),
                            ]
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: images.isNotEmpty,
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, indexImage) {
                              return Visibility(
                                visible: images[indexImage].isNotEmpty,
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    image: DecorationImage(
                                      image: NetworkImage(images[indexImage]),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                ),
                              );
                            },
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, CupertinoPageRoute(builder: (__) => const AddTodoScreen()));
                    if(result ?? false) {
                      await _getAllTodos();
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.green),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, CupertinoPageRoute(builder: (__) => const AddTodoScreen()));
          if(result ?? false) {
            await _getAllTodos();
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
