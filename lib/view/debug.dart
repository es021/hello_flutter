import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/database-helper.dart';

import 'package:hello_flutter/store/counter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DebugView extends StatefulWidget {
  @override
  DebugViewState createState() => DebugViewState();
}

class DebugViewState extends State<DebugView> {
  final dbHelper = DatabaseHelper.instance;

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
              buttonDebug('Store Counter: ${StoreCounter.value}', () {
                StoreCounter.increment();
              })
          // Text('Store Counter: ${StoreCounter.value}'),
          )
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobX Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ...mobxView(),
            // #################################
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: StoreCounter.increment, // 1.Action
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
