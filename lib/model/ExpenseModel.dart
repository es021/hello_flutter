import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseModel {
  static final table = "expense";
  static final col_id = 'id';
  static final col_title = 'title';
  static final col_category = 'category';
  static final col_amount = 'amount';
  static final col_amount_custom = 'amount_custom';
  static final col_is_paid = 'is_paid';
  static final col_month = 'month';
  static final col_year = 'year';
  static final col_created_at = 'created_at';
  static final col_updated_at = 'updated_at';

  static listSql() {
    var sql = '''
          SELECT * FROM $table 
          ORDER BY $col_year desc, $col_month desc
          ''';
    print(sql);
    return sql;
  }

  static createSql(Database db) async {
    var createSql = '''
          CREATE TABLE IF NOT EXISTS $table (
            $col_id INTEGER PRIMARY KEY,
            $col_title TEXT NOT NULL,
            $col_category TEXT,
            $col_amount FLOAT NOT NULL,
            $col_amount_custom FLOAT,
            $col_is_paid CHAR(1) NOT NULL DEFAULT '0',
            $col_month INTEGER NOT NULL,
            $col_year INTEGER NOT NULL,
            $col_created_at INTEGER DEFAULT (cast(strftime('%s','now') as int)),
            $col_updated_at INTEGER
          )
          ''';
    await db.execute(createSql);

    await db.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS ${table}_composite_index 
      ON $table ($col_title, $col_category, $col_month, $col_year)
    ''');

    // mock data
    // await db.execute('''
    //   INSERT INTO $table ($col_title, $col_category, $col_month, $col_year, $col_amount, $col_amount_custom) 
    //   VALUES 
    //   ('Item ${ExpenseHelper.category_baby_necessity}', '${ExpenseHelper.category_baby_necessity}', 9, 2020, 40.5, 0),
    //   ('Item ${ExpenseHelper.category_food}', '${ExpenseHelper.category_food}', 9, 2020, 100.00, null),
    //   ('Item ${ExpenseHelper.category_transportation}', '${ExpenseHelper.category_transportation}', 9, 2020, 210.0, null),
    //   ('Item ${ExpenseHelper.category_utility}', '${ExpenseHelper.category_utility}', 9, 2020, 21.21, 0),
    //   ('Item ${ExpenseHelper.category_baby_necessity} 2', '${ExpenseHelper.category_baby_necessity}', 9, 2020, 140.5, null)
    // ''');

    // the old expenses already renamed to recurring
    // await db.execute('''
    //   DROP table expenses
    // ''');
  }

  int id;
  String title;
  String category;
  double total;
  double amount;
  double amount_custom;
  String is_paid;
  int month;
  int year;
  int created_at;
  int updated_at;

  ExpenseModel();

  ExpenseModel.fromMapByCategory(Map<String, dynamic> map) {
    category = map["category"];
    total = map["total"];
  }

  ExpenseModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    category = map["category"];
    amount = map["amount"];
    amount_custom = map["amount_custom"];
    is_paid = map["is_paid"];
    month = map["month"];
    year = map["year"];
    created_at = map["created_at"];
    updated_at = map["updated_at"];
  }
}
