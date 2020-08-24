import 'dart:ffi';

import 'package:flutter/material.dart';

class ExpenseModel {
  static final table = "expenses";
  static final col_id = 'id';
  static final col_title = 'title';
  static final col_category = 'category';
  static final col_amount = 'amount';
  static final col_is_monthly = 'is_monthly';
  static final col_is_yearly = 'is_yearly';
  static final col_created_at = 'created_at';
  static final col_updated_at = 'updated_at';

  static final category_rent = "rent";
  static final category_loan = "loan";
  static final category_utility = "utility";

  static listSql() {
    var sql = '''
          SELECT * FROM $table 
          ORDER BY $col_amount desc
          ''';
    print(sql);
    return sql;
  }

  static Color iconColorCategory(String cat) {
    if (cat == category_rent) {
      return Colors.blue[300];
    }
    if (cat == category_loan) {
      return Colors.orange[300];
    }
    if (cat == category_utility) {
      return Colors.purple[300];
    }

    return Colors.grey;
  }

  static IconData iconCategory(String cat) {
    if (cat == category_rent) {
      return Icons.home;
    }
    if (cat == category_loan) {
      return Icons.monetization_on;
    }
    if (cat == category_utility) {
      return Icons.description;
    }

    return Icons.warning;
  }

  static createSql() {
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
    return sql;
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

  ExpenseModel();

  ExpenseModel.fromMap(Map<String, dynamic> map) {
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
