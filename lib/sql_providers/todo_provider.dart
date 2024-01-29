import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlsimpleproject/model/todo_model.dart';

class TodoProvider {
  static const _databaseName = "TodoModel.db";
  static const _databaseVersion = 1;
  static const _table = "todo_model_table";

  static const columnId = "_uuid";
  static const todoId = "todoId";
  static const isSelected = "isSelected";
  static const firstname = "firstname";
  static const lastname = "lastname";
  static const age = "age";
  static const images = "images";
  static const todo = "todo";

  late Database _db;

  /// database delete
  Future<void> databaseDelete() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    await deleteDatabase(path);
  }

  /// init database and create table
  Future<void> init() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    _db = await openDatabase(path, version: _databaseVersion);

    await _db.transaction((txn) async {
      await txn.execute('''
      CREATE TABLE IF NOT EXISTS $_table (
        $columnId TEXT NOT NULL,
        $todoId TEXT NOT NULL,
        $isSelected INTEGER NOT NULL,
        $firstname TEXT NOT NULL,
        $lastname TEXT NOT NULL,
        $age INTEGER NOT NULL,
        $images TEXT NOT NULL,
        $todo TEXT NOT NULL
      )
    ''');
      /// JSONB
    });
  }

  /// insert TodoModel returned insert count
  Future<int> insert(TodoModel model) async {
    return await _db.transaction((txn) async {
      return await txn.insert(_table, model.toMap());
    });
  }

  /// get all TodoModel
  Future<List<TodoModel>> getAllTodoModel() async {
    List<TodoModel> todos = [];
    todos = (await _db.query(_table)).map((e) => TodoModel.fromMap(e)).toList();
    return todos;
  }

  /// all list count
  Future<int> getTodosCount() async {
    final todos = await _db.rawQuery("SELECT COUNT(*) FROM $_table");
    return Sqflite.firstIntValue(todos) ?? 0;
  }

  /// update todo
  Future<int> update(TodoModel todoModel) async {
    return await _db.update(
        _table,
        todoModel.toMap(),
        where: '$columnId = ?',
      whereArgs: [todoModel.uuid]
    );
  }

  /// Deletes the row specified by the id. The number of affected rows is
  /// returned. This should be 1 as long as the row exists.
  Future<int> delete(String uuid) async {
    return await _db.delete(
      _table,
      where: '$columnId = ?',
      whereArgs: [uuid],
    );
  }
}