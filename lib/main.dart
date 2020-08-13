import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/config/app-config.dart';
// change `flutter_database` to whatever your project name is
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/model/UserModel.dart';
import 'package:hello_flutter/model/TaskModel.dart';
import 'package:hello_flutter/store/app.dart';
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
          APP_SPLASH_SCREEN,
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
  var _currentView = null;
  var navi = {
    'home': {'index': 0},
    'add_task': {'index': 1, "is_push_view": true},
    'debug': {'index': 2},
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

  bottomNavOnClick(int index) {
    if (index == navi["add_task"]["index"]) {
      pushView(AddTaskView());
    } else {
      AppStore.setViewIndex(index);
    }
  }

  setView(int index) {
    var view = null;
    if (index == navi["home"]["index"]) {
      view = HomeView();
    }
    if (index == navi["debug"]["index"]) {
      view = DebugView();
    }
    return view;
  }

  // setView(int index) {
  //   var view = null;
  //   var isPushOnTop = false;

  //   if (index == navi["home"]["index"]) {
  //     view = HomeView();
  //   }

  //   if (index == navi["debug"]["index"]) {
  //     view = DebugView();
  //   }

  //   if (index == navi["add_task"]["index"]) {
  //     view = AddTaskView();
  //     isPushOnTop = true;
  //   }

  //   if (isPushOnTop) {
  //     // no need to update view
  //     pushView(view);
  //     return;
  //   } else {
  //     // will update view
  //     setState(() {
  //       _currentView = view;
  //       _selectedIndex = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
          ],
          currentIndex: AppStore.viewIndex,
          selectedItemColor: Colors.amber[800],
          onTap: bottomNavOnClick,
        ),
      ),
    );
  }
}
