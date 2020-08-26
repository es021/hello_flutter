import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';

class ExpenseAction {
  // make this a singleton class
  ExpenseAction._privateConstructor();
  static final ExpenseAction instance = ExpenseAction._privateConstructor();

  // only have a single app-wide reference to the database
  final dbHelper = DatabaseHelper.instance;

  insert(String title, String category, double amount) async {
    // showNotification("Inserting");
    Map<String, dynamic> row = {
      ExpenseModel.col_title: title,
      ExpenseModel.col_category: category,
      ExpenseModel.col_amount: amount
    };
    final id = await dbHelper.insert(ExpenseModel.table, row);
    row["id"] = id;

    return row;
  }

  delete(id) async {
    await dbHelper.delete(ExpenseModel.table, ExpenseModel.col_id, id);
  }
}
