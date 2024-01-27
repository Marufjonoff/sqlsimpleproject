import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = "my_table";

  static const columnId = "_id";
  static const columnName = "name";
  static const columnAge = "age";

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(path, version: _databaseVersion);

    await _db.execute('''
    CREATE TABLE IF NOT EXISTS $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnAge INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.transaction((txn) async {
      return await txn.insert(table, row);
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return _db.query(table);
  }

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery("SELECT COUNT(*) FROM $table");
    return Sqflite.firstIntValue(results) ?? 0;
  }

  /// We are assuming here that the id column in the map is set. The other
  /// column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  /// Deletes the row specified by the id. The number of affected rows is
  /// returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}