import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/TaskModel.dart';

// @new_entity - action
class TaskAction {
  // make this a singleton class
  TaskAction._privateConstructor();
  static final TaskAction instance = TaskAction._privateConstructor();

  // only have a single app-wide reference to the database
  final dbHelper = DatabaseHelper.instance;

  insert(val) async {
    // showNotification("Inserting");
    Map<String, dynamic> row = {TaskModel.col_title: val};
    final id = await dbHelper.insert(TaskModel.table, row);
    row["id"] = id;
    // showNotification('Successfully added task $val ($id)');
    return row;
  }

  delete(id) async {
    await dbHelper.delete(TaskModel.table, TaskModel.col_id, id);
  }
}
