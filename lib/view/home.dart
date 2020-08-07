import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:hello_flutter/store/counter.dart';
import 'package:hello_flutter/store/task.dart';
import 'package:flutter/cupertino.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final dbHelper = DatabaseHelper.instance;
  Map _taskIsCheckedMap = {};

  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  Widget renderList() {
    return Observer(
      builder: (_) => new Expanded(
        child: ListView.builder(
          itemCount: StoreTask.list.length,
          itemBuilder: (BuildContext context, int index) {
            TaskModel task = StoreTask.list[index];
            int id = task.id;
            String title = task.title;
            String is_checked = task.is_checked;
            // int order = index + 1;

            bool isChecked =
                _taskIsCheckedMap[index] == null // kalau kat program null
                    ? (is_checked == "1" ? true : false) // amik dari db
                    : _taskIsCheckedMap[index];

            return CheckboxListTile(
                title: isChecked
                    ? new Text(
                        title,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            decoration: TextDecoration.lineThrough),
                      )
                    : new Text(title),
                value: isChecked,
                onChanged: (bool value) {
                  updateIsChecked(id, value ? "1" : "0");
                  setState(() => {_taskIsCheckedMap[index] = value});
                },
                secondary: new Text('$id.'));
            // return CheckboxListTile(
            //   title: _taskIsCheckedMap[id]
            //       ? new Text(
            //           name,
            //           style: TextStyle(
            //               color: Colors.black.withOpacity(0.4),
            //               decoration: TextDecoration.lineThrough),
            //         )
            //       : new Text(name),
            //   value: _taskIsCheckedMap[index],
            //   onChanged: (bool value) {
            //     setState(() => {_taskIsCheckedMap[index] = value});
            //   },
            //   secondary: new Text('$order.'),
          },
        ),
      ),
    );
  }

  refreshList() async {
    StoreTask.emptyList();
    var tasks = await dbHelper.queryRaw(TaskModel.listSql());
    setState(() {
      _taskIsCheckedMap = {};
    });
    tasks.forEach((t) => {StoreTask.addLast(TaskModel.fromMap(t))});
  }

  // Button onPressed methods
  // _insert(val) async {
  //   // row to insert
  //   Map<String, dynamic> row = {UserModel.col_name: val, UserModel.col_age: 23};
  //   final id = await dbHelper.insert(UserModel.table, row);
  //   // print('inserted row id: $id');
  //   row["id"] = id;

  //   // print("row");
  //   // print(row);
  //   return row;
  // }

  updateIsChecked(id, is_checked) async {
    // row to update
    print('updating id=$id | is_checked=$is_checked');
    Map<String, dynamic> row = {
      TaskModel.col_id: id,
      TaskModel.col_is_checked: is_checked,
      TaskModel.col_updated_at: dbHelper.currentTimeInSeconds()
    };
    final rowsAffected =
        await dbHelper.update(TaskModel.table, TaskModel.col_id, row);
    print('updated $rowsAffected row(s)');
  }

  // emptyUser() {
  //   setState(() {
  //     _taskList = <UserModel>[];5
  //   });
  // }

  // void addUser(Map<String, dynamic> row) {
  //   print("addUser");
  //   print(row);
  //   setState(() {
  //     UserModel u = UserModel.fromMap(row);
  //     _taskList.add(u);
  //   });
  // }

  // addTaskToView(Map<String, dynamic> row) {
  //   setState(() {
  //     TaskModel t = TaskModel.fromMap(row);
  //     StoreTask.list.add(t);
  //   });
  // }

  void showNotification(String text) {
    return;
  }

  insertTask(val) async {
    showNotification("Inserting");
    Map<String, dynamic> row = {TaskModel.col_title: val};
    final id = await dbHelper.insert(TaskModel.table, row);
    row["id"] = id;
    showNotification('Successfully added task $val ($id)');
    return row;
  }

  void _pushScreenWithTextField(title, onSubmitted) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(title: new Text(title)),
            body: new TextField(
              autofocus: true,
              onSubmitted: (val) async {
                onSubmitted(val);
                Navigator.pop(context); // Close the add todo screen
              },
              decoration: new InputDecoration(
                  contentPadding: const EdgeInsets.all(16.0)),
            ),
          );
        },
      ),
    );
  }

  // ##############################################################################
  // main
  // ##############################################################################
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Observer(
          builder: (_) =>
              Text('StoreTask list length:${StoreTask.list.length}'),
        ),
        Observer(
          builder: (_) => Text('StoreCounter:${StoreCounter.value}'),
        ),
        buttonDebug("Refresh List", () {
          refreshList();
        }),
        renderList(),
      ],
    );
  }
}
