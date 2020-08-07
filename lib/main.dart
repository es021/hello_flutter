import 'package:flutter/material.dart';
// change `flutter_database` to whatever your project name is
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/UserModel.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:hello_flutter/view/debug.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import './view/home.dart';
import './view/add-task.dart';

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
        seconds: 1,
        navigateAfterSeconds: new MyApp(),
        title: new Text(
          'Is math related to science?',
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        // image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.blue,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        // onClick: () => print("Flutter Egypt"),
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
      title: 'SQFlite Demo',
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

class ScaffoldViewState extends State<ScaffoldView> {
  int _selectedIndex = 0;
  var _currentView = null;
  var navi = {
    'home': {'index': 0},
    'add_task': {'index': 1, "is_push_view": true},
    'debug': {'index': 2},
  };

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

  bottomNavOnClick(int index) {
    var view = null;
    var isPushOnTop = false;

    if (index == navi["home"]["index"]) {
      view = HomeView();
    }

    if (index == navi["debug"]["index"]) {
      view = DebugView();
    }

    if (index == navi["add_task"]["index"]) {
      view = AddTaskView();
      isPushOnTop = true;
    }

    if (isPushOnTop) {
      // no need to update view
      pushView(view);
      return;
    } else {
      // will update view
      setState(() {
        _currentView = view;
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My First App'),
      ),
      body: Center(
        // child: _widgetOptions.elementAt(_selectedIndex),
        child: _currentView,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Task'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Debug'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('Debug'),
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: bottomNavOnClick,
      ),
    );
  }
}
