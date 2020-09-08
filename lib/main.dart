import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/config/app-config.dart';
import 'package:hello_flutter/store/app.dart';
import 'package:hello_flutter/view/select-add-view.dart';
import 'package:hello_flutter/view/select-view.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'view/task-list.dart';

// import 'view/task-add.dart';
// import 'package:hello_flutter/view/debug.dart';
// import 'package:hello_flutter/view/recurring-add.dart';
// import 'package:hello_flutter/view/recurring-list.dart';
// import 'package:hello_flutter/view/expense-add.dart';
// import 'package:hello_flutter/view/expense-list.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyAppWrapper(),
  ));
}

class MyAppWrapper extends StatefulWidget {
  @override
  _MyAppStateWrapper createState() => new _MyAppStateWrapper();
}

class _MyAppStateWrapper extends State<MyAppWrapper> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: APP_SPLASH_SCREEN_TIME_SECOND,
        navigateAfterSeconds: new MyApp(),
        title: new Text(
          APP_SPLASH_SCREEN_QUOTE,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        // image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.blue,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.white70);
  }
}

// ############################################
// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScaffoldView(),
    );
  }
}

class ScaffoldView extends StatefulWidget {
  ScaffoldView({Key key}) : super(key: key);
  @override
  ScaffoldViewState createState() => ScaffoldViewState();
}

// 0. @new_view - enum
enum View {
  TaskList,
  TaskAdd,
  RecurringList,
  RecurringAdd,
  Debug,
  SelectView,
  SelectAddView,
  ExpenseList,
  ExpenseAdd
}

class ScaffoldViewState extends State<ScaffoldView> {
  // var _currentView = null;
  BuildContext _context = null;

  // 1. @new_view - navi
  var navi = {
    // in bottom navigation
    View.TaskList: {'index': 0},
    View.SelectAddView: {'index': 1},
    View.SelectView: {'index': 2},
    // popup
    View.TaskAdd: {'index': 3},
    View.RecurringList: {'index': 4},
    View.RecurringAdd: {'index': 5},
    View.ExpenseList: {'index': 6},
    View.ExpenseAdd: {'index': 7},

    // ##########################
    View.Debug: {'index': 99},
    // 'task_list': {'index': 0},
    // 'add_task': {'index': 1, "is_push_view": true},
    // 'debug': {'index': 2},
  };

  @override
  void initState() {
    super.initState();
    setView(0);
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // push view on top
  void pushView(view) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return view;
        },
      ),
    );
  }

  // 2a. @new_view - Go To
  // Future<View> selectViewPopup(BuildContext context) async {
  //   return await showDialog<View>(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return SimpleDialog(
  //           title: const Text('Go To'),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //               child: const Text('Expense'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(View.ExpenseList);
  //               },
  //             ),
  //             SimpleDialogOption(
  //               child: const Text('My Recurrings'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(View.RecurringList);
  //               },
  //             ),
  //             SimpleDialogOption(
  //               child: const Text('Debug'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(View.Debug);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  // 2b. @new_view - Add What
  // Future<View> selectAddViewPopup(BuildContext context) async {
  //   return await showDialog<View>(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return SimpleDialog(
  //           title: const Text('Add What?'),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //               child: const Text('Task'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(View.TaskAdd);
  //               },
  //             ),
  //             SimpleDialogOption(
  //               child: const Text('Recurring'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(View.RecurringAdd);
  //               },
  //             ),
  //             SimpleDialogOption(
  //               child: const Text('Expense'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(View.ExpenseAdd);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  // 3. @new_view - which view to open
  bottomNavOnClick(int index) async {
    // ##############################################
    // SELECT VIEW FROM POPUP
    // ##############################################

    // select view popup
    // View redirect = null;
    // if (index == navi[View.SelectView]["index"]) {
    //   redirect = await selectViewPopup(_context);
    // }
    // if (index == navi[View.SelectAddView]["index"]) {
    //   redirect = await selectAddViewPopup(_context);
    // }

    // if (redirect != null) {
    //   try {
    //     bottomNavOnClick(navi[redirect]["index"]);
    //   } catch (err) {
    //     print(err);
    //   }
    //   return;
    // }

    // // ##############################################
    // // OPEN ADD WHAT POPUP
    // // ##############################################
    // if (index == navi[View.TaskAdd]["index"]) {
    //   pushView(TaskAddView());
    //   return;
    // }
    // if (index == navi[View.RecurringAdd]["index"]) {
    //   pushView(RecurringAddView());
    //   return;
    // }
    // if (index == navi[View.ExpenseAdd]["index"]) {
    //   pushView(ExpenseAddView());
    //   return;
    // }
    // // ##############################################
    // // OPEN GO TO POPUP
    // // ##############################################
    // if (index == navi[View.RecurringList]["index"]) {
    //   pushView(RecurringListView());
    //   return;
    // }
    // if (index == navi[View.ExpenseList]["index"]) {
    //   pushView(ExpenseListView());
    //   return;
    // }
    // if (index == navi[View.Debug]["index"]) {
    //   pushView(DebugView());
    //   return;
    // }

    // ##############################################
    // CHANGE MAIN VIEW
    // ##############################################
    AppStore.setViewIndex(index);
  }

  // set view yang ada dlm bottom navigation only
  setView(int index) {
    print("index $index");
    var view = null;
    if (index == navi[View.TaskList]["index"]) {
      view = TaskListView();
    }
    if (index == navi[View.SelectAddView]["index"]) {
      view = SelectAddView(parentContext: context);
    }
    if (index == navi[View.SelectView]["index"]) {
      view = SelectView(parentContext: context);
    }
    if (view == null) {
      view = new Container(child: Text('View at index $index not found'));
    }
    return view;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Observer(
      builder: (_) =>
          // buttonDebug('Store Counter: ${CounterStore.value}', () {
          //   CounterStore.increment();
          // })

          Scaffold(
        appBar: AppBar(
          title: const Text(APP_TITLE),
        ),
        // body: _currentView,
        body: setView(AppStore.viewIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              title: Text('To Do'),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.check_circle),
            //   title: Text('Expense'),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Add'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_carousel),
              title: Text('Open View'),
            ),
          ],
          currentIndex: AppStore.viewIndex,
          selectedItemColor: Colors.amber[800],
          onTap: bottomNavOnClick,
        ),
      ),
    );
  }
}
