import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/action/TaskAction.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:hello_flutter/store/app.dart';
import 'package:hello_flutter/store/counter.dart';
import 'package:hello_flutter/store/task.dart';
import 'package:hello_flutter/helper/database-helper.dart';

// @new_entity - view (add)
class TaskAddView extends StatefulWidget {
  @override
  TaskAddViewState createState() => TaskAddViewState();
}

class TaskAddViewState extends State<TaskAddView> {
  var title = "Add a new task";
  final taskAction = TaskAction.instance;

  onSubmitted(val) async {
    print(val);
    var row = await taskAction.insert(val);
    // addTaskToView(row);
    TaskModel t = TaskModel.fromMap(row);
    TaskStore.addFirst(t);
    CounterStore.increment();
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

          AppStore.setViewIndex(0);
        },
        decoration: new InputDecoration(
            //hintText: 'Enter new query here',
            contentPadding: const EdgeInsets.all(16.0)),
      ),
    );
  }
}
