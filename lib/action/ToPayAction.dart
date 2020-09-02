import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/model/ToPayModel.dart';

class ToPayAction {
  // make this a singleton class
  ToPayAction._privateConstructor();
  static final ToPayAction instance = ToPayAction._privateConstructor();

  // only have a single app-wide reference to the database
  final dbHelper = DatabaseHelper.instance;

  query(month, year, orderBy) async {
    orderBy = orderBy != null && orderBy != "" ? "order by $orderBy" : "";
    var rows = await dbHelper.queryRaw(''' 
      SELECT * FROM ${ToPayModel.table} WHERE month=$month AND year=$year 
      $orderBy
    ''');
    var toRet = [];
    rows.forEach((r) => {toRet.add(ToPayModel.fromMap(r))});
    return toRet;
  }

  all() async {
    var rows = await dbHelper.queryAllRows(ToPayModel.table);
    var toRet = [];
    rows.forEach((r) => {toRet.add(ToPayModel.fromMap(r))});
    return toRet;
  }

  single(id) async {
    var row = await dbHelper.queryById(ToPayModel.table, id);
    return ToPayModel.fromMap(row);
  }

  update(Map<String, dynamic> row) async {
    print("[ToPay] update");
    print(row);
    return await dbHelper.update(ToPayModel.table, ToPayModel.col_id, row);
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
      INSERT OR IGNORE INTO to_pay (title, category, amount, month, year)
      SELECT title, category, amount, $month, $year FROM expenses 
    ''';
    return await dbHelper.exec(sql);
  }

  insert(Map<String, dynamic> row) async {
    print("[ToPay] insert");
    print(row);
    final id = await dbHelper.insert(ToPayModel.table, row);
    row["id"] = id;
    return row;
  }

  delete(id) async {
    await dbHelper.delete(ToPayModel.table, ToPayModel.col_id, id);
  }
}
