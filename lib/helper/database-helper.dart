import 'dart:io';

import 'package:hello_flutter/model/UserModel.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 2;

  // static final table = 'users';
  // static final columnId = 'id';
  // static final columnName = 'name';
  // static final columnAge = 'age';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    _createTable(_database, _databaseVersion);
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _createTable, onOpen: (Database db) {
      print("open");
      _createTable(db, _databaseVersion);
    });
  }

  /// the current time, in “seconds since the epoch”
  int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  // SQL code to create the database table
  Future _createTable(Database db, int version) async {
    await db.execute(UserModel.createSql());
    await db.execute(TaskModel.createSql());
    // await db.execute('''
    //       CREATE TABLE IF NOT EXISTS $table (
    //         $columnId INTEGER PRIMARY KEY,
    //         $columnName TEXT NOT NULL,
    //         $columnAge INTEGER NOT NULL
    //       )
    //       ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryRaw(String sql) async {
    Database db = await instance.database;
    return await db.rawQuery(sql);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(
      String table, String colId, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[colId];
    return await db.update(table, row, where: '$colId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, String colId, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$colId = ?', whereArgs: [id]);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  queryAllRows(String table) async {
    return execAndReturnLog('''SELECT * from $table;''');
  }

  void execAndPrint(sql) async {
    Database db = await instance.database;
    final rows = await db.rawQuery(sql);
    print("-----------------------------------------");
    print(sql);
    rows.forEach((row) => {print('$row')});
    print("-----------------------------------------");
  }

  execAndReturnLog(sql) async {
    Database db = await instance.database;
    final rows = await db.rawQuery(sql);
    String toRet = "";
    toRet += sql + "\n";
    print(sql);
    rows.forEach((row) => {toRet += '$row' + "\n", print(row)});
    return toRet;
  }

  listAllTable() async {
    return execAndReturnLog('''SELECT name FROM sqlite_master 
    WHERE type ='table' AND name NOT LIKE 'sqlite_%';''');
  }

  describeTable(table) async {
    return execAndReturnLog('''PRAGMA table_info('$table')''');
  }
}
