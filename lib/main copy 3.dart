import 'package:flutter/material.dart';
// change `flutter_database` to whatever your project name is
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/UserModel.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final dbHelper = DatabaseHelper.instance;
  String _mainText = "Hello World!";
  List<TaskModel> _taskList = [];
  Map _taskIsCheckedMap = {};

  // ##############################################################################
  // helper function
  // ##############################################################################

  // This will be called each time the + button is pressed
  // void _addTodoItem(String task) {
  //   // Only add the task if the user actually entered something
  //   if (task.length > 0) {
  //     int currentIndex = _todoItems.length;
  //     setState(() => {_todoItems.add(task), _taskIsCheckedMap[currentIndex] = false});
  //     // setState(() => hashMap.addAll({1: true}));
  //   }
  // }

  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  List<Widget> renderButton() {
    return [
      buttonDebug("Raw Query", () {
        _pushScreenWithTextField("Raw Query", (val) {
          dbHelper.execAndPrint(val);
        });
      }),
      buttonDebug("Describe Table", () {
        _pushScreenWithTextField("Describe Table", (val) {
          dbHelper.describeTable(val);
        });
      }),
      buttonDebug("Query All Record", () {
        _pushScreenWithTextField("Query All Record", (val) {
          dbHelper.queryAllRows(val);
        });
      }),
      buttonDebug("List All Table", () {
        dbHelper.listAllTable();
      }),
      buttonDebug("Refresh List", () {
        refreshList();
      }),
      // RaisedButton(
      //   child: Text(
      //     'insert',
      //     style: TextStyle(fontSize: 20),
      //   ),
      //   onPressed: () async {
      //     showNotification("Inserting");
      //     var id = await _insert();
      //     showNotification('Done id : $id');
      //   },
      // ),
      // RaisedButton(
      //   child: Text('query'),
      //   onPressed: () async {
      //     var allRows = await dbHelper.queryAllRows(UserModel.table);
      //     emptyUser();
      //     allRows.forEach((row) => {
      //           //print('$row'),
      //           addUser(row),
      //         });

      //     print('_taskList.length ${_taskList.length}');
      //   },
      // ),
      // RaisedButton(
      //   child: Text('update'),
      //   onPressed: () {
      //     _update();
      //   },
      // ),
      // RaisedButton(
      //   child: Text('delete'),
      //   onPressed: () {
      //     _delete();
      //   },
      // ),
    ];
  }

// Build the whole list of todo items
  Widget renderList() {
    // print('renderList => _taskList.length ${_taskList.length}');
    // return Text("hahah");
    return new Expanded(
      child: ListView.builder(
        itemCount: _taskList.length,
        itemBuilder: (BuildContext context, int index) {
          TaskModel task = _taskList[index];
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
    );
  }

  refreshList() async {
    var tasks = await dbHelper.queryRaw(TaskModel.listSql());
    setState(() {
      _taskIsCheckedMap = {};
      _taskList = <TaskModel>[];
    });
    tasks.forEach((t) => {addTaskToView(t)});
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

  addTaskToView(Map<String, dynamic> row) {
    setState(() {
      TaskModel t = TaskModel.fromMap(row);
      _taskList.add(t);
    });
  }

  void showNotification(String text) {
    return;
    // final snackBar = SnackBar(content: Text(text), action: null
    //     // action: SnackBarAction(
    //     //   label: 'Undo',
    //     //   onPressed: () {
    //     //   },
    //     // ),
    //     );
    // Scaffold.of(context).showSnackBar(snackBar);
    // setState(() {
    //   _mainText = text;
    // });
  }

  // void _delete() async {
  //   // Assuming that the number of rows is the id for the last row.
  //   final id = await dbHelper.queryRowCount(UserModel.table);
  //   final rowsDeleted =
  //       await dbHelper.delete(UserModel.table, UserModel.col_id, id);
  //   print('deleted $rowsDeleted row(s): row $id');
  // }

  // void insertAndUpdateView(val) async {
  //   showNotification("Inserting");
  //   Map<String, dynamic> row = {UserModel.col_name: val, UserModel.col_age: 23};
  //   final id = await dbHelper.insert(UserModel.table, row);
  //   // print('inserted row id: $id');
  //   row["id"] = id;
  //   // print("row");
  //   // // print(row);
  //   // return row;
  //   // var row = await _insert(val);
  //   showNotification('Done id : ${row["id"]}');
  //   addUser(row);
  // }

  insertTask(val) async {
    showNotification("Inserting");
    Map<String, dynamic> row = {TaskModel.col_title: val};
    final id = await dbHelper.insert(TaskModel.table, row);
    row["id"] = id;
    showNotification('Successfully added task $val ($id)');
    return row;
  }

  void _pushScreenWithTextField(title, onSubmitted) {
// Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        new MaterialPageRoute(builder: (context) {
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
          ));
    }));
  }

  // void _pushAddTodoScreen() {
  //   // Push this page onto the stack
  //   Navigator.of(context).push(
  //       // MaterialPageRoute will automatically animate the screen entry, as well
  //       // as adding a back button to close it
  //       new MaterialPageRoute(builder: (context) {
  //     return new Scaffold(
  //         appBar: new AppBar(title: new Text('Add a new task')),
  //         body: new TextField(
  //           autofocus: true,
  //           onSubmitted: (val) async {
  //             insertAndUpdateView(val);
  //             Navigator.pop(context); // Close the add todo screen
  //           },
  //           decoration: new InputDecoration(
  //               hintText: 'Enter something to do...',
  //               contentPadding: const EdgeInsets.all(16.0)),
  //         ));
  //   }));
  // }

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
    // setState(() {
    //   _taskList = <UserModel>[];
    // });
    // refreshList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Todo App'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Text(_mainText),
              ...renderButton(),
              renderList(),
            ],
          );
        }),
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     buttonDebug(
        //         "yooo",
        //         () => Scaffold.of(context).showSnackBar(SnackBar(
        //               duration: Duration(milliseconds: 1000),
        //               content: Container(height: 10),
        //               behavior: SnackBarBehavior.floating, // Add this line
        //             ))),
        //     // Text(_mainText),
        //     ...renderButton(),
        //     renderList(),
        //   ],
        // ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            _pushScreenWithTextField("Add a new task", (val) async {
              print(val);
              var row = await insertTask(val);
              addTaskToView(row);
            });
          },
          tooltip: 'Add task',
          child: new Icon(Icons.add),
        ));
  }
}
