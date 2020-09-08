import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 0. @new_entity - model
class RecurringModel {
  static final table = "recurrings";
  static final col_id = 'id';
  static final col_title = 'title';
  static final col_category = 'category';
  static final col_amount = 'amount';
  static final col_is_monthly = 'is_monthly';
  static final col_is_yearly = 'is_yearly';
  static final col_created_at = 'created_at';
  static final col_updated_at = 'updated_at';

  static listSql() {
    var sql = '''
          SELECT * FROM $table 
          ORDER BY $col_amount desc
          ''';
    print(sql);
    return sql;
  }

  static createSql(Database db) async {
    var sql = '''
          CREATE TABLE IF NOT EXISTS $table (
            $col_id INTEGER PRIMARY KEY,
            $col_title TEXT NOT NULL,
            $col_category TEXT,
            $col_amount FLOAT NOT NULL,
            $col_is_monthly CHAR(1) NOT NULL DEFAULT '0',
            $col_is_yearly CHAR(1) NOT NULL DEFAULT '0',
            $col_created_at INTEGER DEFAULT (cast(strftime('%s','now') as int)),
            $col_updated_at INTEGER
          )
          ''';
    print(sql);
    await db.execute(sql);
  }

  int id;
  String title;
  String category;
  double amount;
  String is_monthly;
  String is_yearly;
  int created_at;
  int updated_at;
  // ... more property

  RecurringModel();

  RecurringModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    category = map["category"];
    amount = map["amount"];
    is_monthly = map["is_monthly"];
    is_yearly = map["is_yearly"];
    created_at = map["created_at"];
    updated_at = map["updated_at"];
  }
}
