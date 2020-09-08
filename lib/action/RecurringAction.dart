import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/RecurringModel.dart';

// 2. @new_entity - action
class RecurringAction {
  // make this a singleton class
  RecurringAction._privateConstructor();
  static final RecurringAction instance = RecurringAction._privateConstructor();

  // only have a single app-wide reference to the database
  final dbHelper = DatabaseHelper.instance;

  all() async {
    var rows = await dbHelper.queryAllRows(RecurringModel.table);
    var toRet = [];
    rows.forEach((r) => {toRet.add(RecurringModel.fromMap(r))});
    return toRet;
  }

  single(int id) async {
    var row = await dbHelper.queryById(RecurringModel.table, id);
    return RecurringModel.fromMap(row);
  }

  update(Map<String, dynamic> row) async {
    print("[Recurring] update");
    print(row);
    return await dbHelper.update(RecurringModel.table, RecurringModel.col_id, row);
  }

  insert(Map<String, dynamic> row) async {
    print("[Recurring] update");
    print(row);
    final id = await dbHelper.insert(RecurringModel.table, row);
    row["id"] = id;
    return row;
  }

  delete(int id) async {
    await dbHelper.delete(RecurringModel.table, RecurringModel.col_id, id);
  }
}
