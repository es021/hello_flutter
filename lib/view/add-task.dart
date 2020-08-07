import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:hello_flutter/store/counter.dart';
import 'package:hello_flutter/store/task.dart';
import 'package:hello_flutter/helper/database-helper.dart';

class AddTaskView extends StatefulWidget {
  @override
  AddTaskViewState createState() => AddTaskViewState();
}

class AddTaskViewState extends State<AddTaskView> {
  var title = "Add a new task";
  final dbHelper = DatabaseHelper.instance;

  insertTask(val) async {
    // showNotification("Inserting");
    Map<String, dynamic> row = {TaskModel.col_title: val};
    final id = await dbHelper.insert(TaskModel.table, row);
    row["id"] = id;
    // showNotification('Successfully added task $val ($id)');
    return row;
  }

  onSubmitted(val) async {
    print(val);
    var row = await insertTask(val);
    // addTaskToView(row);
    TaskModel t = TaskModel.fromMap(row);
    StoreTask.addFirst(t);
    StoreCounter.increment();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new TextField(
        autofocus: true,
        onSubmitted: (val) async {
          onSubmitted(val);
          Navigator.pop(context); // Close the add todo screen
        },
        decoration: new InputDecoration(
            //hintText: 'Enter new query here',
            contentPadding: const EdgeInsets.all(16.0)),
      ),
    );
  }
}
