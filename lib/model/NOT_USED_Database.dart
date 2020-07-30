import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hello_flutter/model/NOT_USED_TaskModel-with-json-stuff.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;
  static const TB_TASK = "tasks";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TodoListDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $TB_TASK(id INTEGER PRIMARY KEY, label TEXT, done INTEGER)");
    });
  }

  getAllTask() async {
    final db = await database;
    var res = await db.query(TB_TASK);
    List<Task> list =
        res.isNotEmpty ? res.map((c) => Task.fromMap(c)).toList() : [];
    return list;
  }

  insertTask(Task newTask) async {
    final db = await database;
    var res = await db.insert(TB_TASK, newTask.toMap());
    return res;
  }
}
