// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';
import 'package:hello_flutter/model/Database.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
// import 'dart:collection';
import 'dart:developer';

import 'package:hello_flutter/model/TaskModel.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Todo List', home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];
  Map checkMap = {};

  // This will be called each time the + button is pressed
  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      int currentIndex = _todoItems.length;
      setState(() => {_todoItems.add(task), checkMap[currentIndex] = false});
      // setState(() => hashMap.addAll({1: true}));
    }
  }

  // Build the whole list of todo items
  Widget _buildTodoList(AsyncSnapshot<List<Task>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        Task item = snapshot.data[index];
        return _buildTodoItem(item);
        // return ListTile(
        //   title: Text(item.label),
        //   leading: Text(item.id.toString()),
        //   // trailing: Checkbox(
        //   //   onChanged: (bool value) {
        //   //     DBProvider.db.blockClient(item);
        //   //     setState(() {});
        //   //   },
        //   //   value: item.blocked,
        //   // ),
        // );
      },
    );

    // return new ListView.builder(
    //   itemBuilder: (context, index) {
    //     // itemBuilder will be automatically be called as many times as it takes for the
    //     // list to fill up its available space, which is most likely more than the
    //     // number of todo items we have. So, we need to check the index is OK.
    //     if (index < _todoItems.length) {
    //       return _buildTodoItem(index, _todoItems[index]);
    //     }
    //   },
    // );
  }

  // Build a single todo item
  Widget _buildTodoItem(Task task) {
    int index = task.id;
    String todoText = task.label;
    int order = index + 1;
    return CheckboxListTile(
      title: checkMap[index]
          ? new Text(
              todoText,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  decoration: TextDecoration.lineThrough),
            )
          : new Text(todoText),
      // value: timeDilation != 1.0,
      // value: hashMap[index],
      value: checkMap[index],
      onChanged: (bool value) {
        setState(() => {
              checkMap[index] = value
              // timeDilation = value ? 2.0 : 1.0;
            });
      },
      secondary: new Text('$order.'),
    );
    // return new ListTile(title: new Text(todoText));
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new task')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Todo List')),
        body: _buildTodoList(),
        // body: FutureBuilder<List<Task>>(
        //     future: DBProvider.db.getAllTask(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         //return _buildTodoList(snapshot);
        //         return ListView.builder(
        //           itemCount: snapshot.data.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             Task item = snapshot.data[index];
        //             return ListTile(
        //               title: Text(item.label),
        //               leading: Text(item.id.toString()),
        //               // trailing: Checkbox(
        //               //   onChanged: (bool value) {
        //               //     DBProvider.db.blockClient(item);
        //               //     setState(() {});
        //               //   },
        //               //   value: item.blocked,
        //               // ),
        //             );
        //           },
        //         );
        //       } else {
        //         return Center(child: CircularProgressIndicator());
        //       }
        //     }),
        floatingActionButton: new FloatingActionButton(
          // label: Text("Add Item"),
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add),
        ));
  }
}
