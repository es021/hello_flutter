import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';

// 2. @new_entity - action
class ExpenseAction {
  // make this a singleton class
  ExpenseAction._privateConstructor();
  static final ExpenseAction instance = ExpenseAction._privateConstructor();

  // only have a single app-wide reference to the database
  final dbHelper = DatabaseHelper.instance;

  all() async {
    var rows = await dbHelper.queryAllRows(ExpenseModel.table);
    var toRet = [];
    rows.forEach((r) => {toRet.add(ExpenseModel.fromMap(r))});
    return toRet;
  }

  single(int id) async {
    var row = await dbHelper.queryById(ExpenseModel.table, id);
    return ExpenseModel.fromMap(row);
  }

  update(Map<String, dynamic> row) async {
    print("[Expense] update");
    print(row);
    return await dbHelper.update(ExpenseModel.table, ExpenseModel.col_id, row);
  }

  insert(Map<String, dynamic> row) async {
    print("[Expense] update");
    print(row);
    final id = await dbHelper.insert(ExpenseModel.table, row);
    row["id"] = id;
    return row;
  }

  delete(int id) async {
    await dbHelper.delete(ExpenseModel.table, ExpenseModel.col_id, id);
  }
}
