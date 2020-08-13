import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/action/TaskAction.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:hello_flutter/store/counter.dart';
import 'package:hello_flutter/store/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';

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
  final taskAction = TaskAction.instance;

  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  // Widget _buildList() {
  //   return _users.length != 0
  //       ? RefreshIndicator(
  //           child: ListView.builder(
  //               padding: EdgeInsets.all(8),
  //               itemCount: _users.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return Card(
  //                   child: Column(
  //                     children: <Widget>[
  //                       ListTile(
  //                         leading: CircleAvatar(
  //                             radius: 30,
  //                             backgroundImage: NetworkImage(
  //                                 _users[index]['picture']['large'])),
  //                         title: Text(_name(_users[index])),
  //                         subtitle: Text(_location(_users[index])),
  //                         trailing: Text(_age(_users[index])),
  //                       )
  //                     ],
  //                   ),
  //                 );
  //               }),
  //           onRefresh: _getData,
  //         )
  //       : Center(child: CircularProgressIndicator());
  // }
  Future<void> refreshListAsync() async {
    refreshList();
  }

  Widget renderList() {
    return Observer(
      builder: (_) => new Expanded(
        child: ListView.builder(
          itemCount: TaskStore.list.length,
          itemBuilder: (BuildContext context, int index) {
            TaskModel task = TaskStore.list[index];
            int id = task.id;
            int createdAtInt = task.created_at;
            String createdAt = createdAtInt != null
                ? TimeHelper.getString(createdAtInt)
                : "Just now";
            // int order = index + 1;

            bool isChecked =
                _taskIsCheckedMap[index] == null // kalau kat program null
                    ? (task.is_checked == "1" ? true : false) // amik dari db
                    : _taskIsCheckedMap[index];

            var titleStyle = isChecked
                ? TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    decoration: TextDecoration.lineThrough)
                : TextStyle();

            var title = new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Text(task.title,
                      style: titleStyle.merge(TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
                  SizedBox(height: 3),
                  new Text(createdAt,
                      style: titleStyle.merge(TextStyle(
                          fontSize: 11, fontStyle: FontStyle.italic))),
                ]);

            var listTile = CheckboxListTile(
              title: title,
              value: isChecked,
              onChanged: (bool value) {
                updateIsChecked(id, value ? "1" : "0");
                setState(() => {_taskIsCheckedMap[index] = value});
              },
              // secondary: new Text('${createdAt}'),
            );

            return Dismissible(
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              key: Key("$id"),
              onDismissed: (direction) {
                // setState(() {
                //   items.removeAt(index);
                // });
                // TaskStore.remove(index);
                taskAction.delete(id);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("Task removed")));
              },
              child: listTile,
            );

            // secondary: new Text('$id.'));
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
    TaskStore.emptyList();
    var tasks = await dbHelper.queryRaw(TaskModel.listSql());
    setState(() {
      _taskIsCheckedMap = {};
    });
    tasks.forEach((t) => {TaskStore.addLast(TaskModel.fromMap(t))});
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
  //     TaskStore.list.add(t);
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
    return RefreshIndicator(
      onRefresh: refreshListAsync,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Observer(
          //   builder: (_) =>
          //       Text('TaskStore list length:${TaskStore.list.length}'),
          // ),
          // Observer(
          //   builder: (_) => Text('CounterStore:${CounterStore.value}'),
          // ),
          // buttonDebug("Refresh List", () {
          //   refreshList();
          // }),
          renderList(),
        ],
      ),
    );
  }
}
