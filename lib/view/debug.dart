import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/helper/notification-helper.dart';
import 'package:hello_flutter/store/counter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DebugView extends StatefulWidget {
  @override
  DebugViewState createState() => DebugViewState();
}

class DebugViewState extends State<DebugView> {
  NotificationHelper notificationHelper = NotificationHelper.instance;
  @override
  initState() {
    super.initState();
  }

  final _toPayAction = ExpenseAction.instance;
  var title = "Debugging Tools";
  final dbHelper = DatabaseHelper.instance;
  String _debugText = "";

  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
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

  mobxView() {
    return [
      // buttonDebug("Increment Counter", () {
      //   _pushScreenWithTextField("Describe Table", (val) {
      //     dbHelper.describeTable(val);
      //   });
      // }),
      // #################################
      // Wrapping in the Observer will automatically re-render on changes to counter.value
      Observer(
          builder: (_) =>
              buttonDebug('Store Counter: ${CounterStore.value}', () {
                CounterStore.increment();
              })
          // Text('Store Counter: ${CounterStore.value}'),
          )
    ];
  }

  Widget getDebugTextView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: new Text(_debugText),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: new Material(
          child: new Container(
            child: new SingleChildScrollView(
              child: new ConstrainedBox(
                constraints: new BoxConstraints(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    buttonDebug("Raw Query", () {
                      _pushScreenWithTextField("Raw Query", (val) async {
                        String r = await dbHelper.execAndReturnLog(val);
                        setState(() {
                          _debugText = r;
                        });
                      });
                    }),
                    buttonDebug("Describe Table", () {
                      _pushScreenWithTextField("Describe Table", (val) async {
                        String r = await dbHelper.describeTable(val);
                        setState(() {
                          _debugText = r;
                        });
                      });
                    }),
                    buttonDebug("Query All Record", () {
                      _pushScreenWithTextField("Query All Record", (val) async {
                        String r = await dbHelper.debugQueryAllRows(val);
                        setState(() {
                          _debugText = r;
                        });
                      });
                    }),
                    buttonDebug("Populate Expense (Current Month)", () {
                      _toPayAction.populateMonthly();
                    }),
                    buttonDebug("List All Table", () async {
                      String r = await dbHelper.listAllTable();
                      setState(() {
                        _debugText = r;
                      });
                    }),
                    buttonDebug("Show Notification", () {
                      notificationHelper.showNotificationWithDefaultSound();
                    }),
                    ...mobxView(),
                    getDebugTextView(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
