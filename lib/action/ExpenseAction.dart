import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';

class ExpenseAction {
  // make this a singleton class
  ExpenseAction._privateConstructor();
  static final ExpenseAction instance = ExpenseAction._privateConstructor();

  // only have a single app-wide reference to the database
  final dbHelper = DatabaseHelper.instance;

  query(month, year, {orderBy}) async {
    orderBy = orderBy != null && orderBy != "" ? "order by $orderBy" : "";
    var rows = await dbHelper.queryRaw(''' 
      SELECT * FROM ${ExpenseModel.table} WHERE month=$month AND year=$year 
      $orderBy
    ''');
    var toRet = [];
    rows.forEach((r) => {toRet.add(ExpenseModel.fromMap(r))});
    return toRet;
  }

  queryGroupByCategory(month, year) async {
    String q = ''' 
      SELECT category, 
      SUM(CASE WHEN  amount_custom IS NULL OR amount_custom <= 0 THEN amount ELSE amount_custom END) as total 
      FROM ${ExpenseModel.table} 
      WHERE month=$month AND year=$year AND is_paid='1'
      GROUP BY category ORDER BY total desc
    ''';

    var rows = await dbHelper.queryRaw(q);
    var toRet = [];
    rows.forEach((r) => {toRet.add(ExpenseModel.fromMapByCategory(r))});
    return toRet;
  }

  all() async {
    var rows = await dbHelper.queryAllRows(ExpenseModel.table);
    var toRet = [];
    rows.forEach((r) => {toRet.add(ExpenseModel.fromMap(r))});
    return toRet;
  }

  single(id) async {
    var row = await dbHelper.queryById(ExpenseModel.table, id);
    return ExpenseModel.fromMap(row);
  }

  update(Map<String, dynamic> row) async {
    print("[Expense] update");
    print(row);
    return await dbHelper.update(ExpenseModel.table, ExpenseModel.col_id, row);
  }

  populateMonthly({month, year}) async {
    if (month == null) {
      month = TimeHelper.currentMonth();
    }

    if (year == null) {
      year = TimeHelper.currentYear();
    }

    // print('month=${}');
    // print('year=${TimeHelper.currentYear()}');
    var sql = '''
      INSERT OR IGNORE INTO expense (title, category, amount, month, year)
      SELECT title, category, amount, $month, $year FROM recurrings 
    ''';
    return await dbHelper.exec(sql);
  }

  insert(Map<String, dynamic> row) async {
    print("[Expense] insert");
    print(row);
    final id = await dbHelper.insert(ExpenseModel.table, row);
    row["id"] = id;
    return row;
  }

  delete(id) async {
    await dbHelper.delete(ExpenseModel.table, ExpenseModel.col_id, id);
  }
}
