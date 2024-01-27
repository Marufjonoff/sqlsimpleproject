import 'package:flutter/material.dart';
import 'package:sqlsimpleproject/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseHelper = DatabaseHelper();

  Future<void> _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: "Bob",
      DatabaseHelper.columnAge: 23
    };

    final id = await databaseHelper.insert(row);
    debugPrint("Inserted row id: $id");
  }

  void _query() async {
    final allRows = await databaseHelper.queryAllRows();
    debugPrint('Query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await databaseHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await databaseHelper.queryRowCount();
    final rowsDeleted = await databaseHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }
}
