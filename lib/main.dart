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
  initState() {
    super.initState();
  }

  // initNotification() {
  //   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  //   // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
  //   var initAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initIOS = new IOSInitializationSettings();
  //   var initSetting = new InitializationSettings(
  //     initAndroid,
  //     initIOS,
  //   );
  //   noti = new FlutterLocalNotificationsPlugin();
  //   noti.initialize(
  //     initSetting,
  //     onSelectNotification: onSelectNotification,
  //   );
  // }

  // Future onSelectNotification(String payload) async {
  //   showDialog(
  //     context: context,
  //     builder: (_) {
  //       return new AlertDialog(
  //         title: Text("PayLoad"),
  //         content: Text("Payload : $payload"),
  //       );
  //     },
  //   );
  // }

  // Future showNotificationWithDefaultSound() async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High);
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await noti.show(
  //     0,
  //     'New Post',
  //     'How to Show Notification in Flutter',
  //     platformChannelSpecifics,
  //     payload: 'Default_Sound',
  //   );
  // }

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

// class NewScreen extends StatelessWidget {
//   String payload;

//   NewScreen({
//     @required this.payload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(payload),
//       ),
//     );
//   }
// }

class ScaffoldViewState extends State<ScaffoldView> {
  // FlutterLocalNotificationsPlugin notification =
  //     FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    setView(0);

    // // init push notification
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('flutter_devs');
    // var initializationSettingsIOs = IOSInitializationSettings();
    // var initSetttings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOs);
    // notification.initialize(initSetttings,
    //     onSelectNotification: onSelectNotification);
  }

  // #########################################
  // ##### NOTIFICATION STUFFS

  // Future<void> scheduleNotification() async {
  //   var scheduledNotificationDateTime =
  //       DateTime.now().add(Duration(seconds: 5));
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'channel id',
  //     'channel name',
  //     'channel description',
  //     icon: 'flutter_devs',
  //     largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
  //   );
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await notification.schedule(0, 'scheduled title', 'scheduled body',
  //       scheduledNotificationDateTime, platformChannelSpecifics);
  // }

  // showNotification() async {
  //   var android = AndroidNotificationDetails('id', 'channel ', 'description',
  //       priority: Priority.High, importance: Importance.Max);
  //   var iOS = IOSNotificationDetails();
  //   var platform = new NotificationDetails(android, iOS);
  //   await notification.show(
  //       0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
  //       payload: 'Welcome to the Local Notification demo');
  // }

  // Future onSelectNotification(String payload) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //     return NewScreen(
  //       payload: payload,
  //     );
  //   }));
  // }

  // ##### NOTIFICATION STUFFS
  // #########################################

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
    // scheduleNotification();
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
