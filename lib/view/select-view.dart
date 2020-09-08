import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/color-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/view/debug.dart';
import 'expense-list.dart';
import 'recurring-list.dart';

class SelectView extends StatefulWidget {
  final BuildContext parentContext;
  SelectView({Key key, this.parentContext}) : super(key: key);

  @override
  SelectViewState createState() => SelectViewState();
}

class SelectViewState extends State<SelectView> {
  final _title = "Open View";
  final _menu = [
    {
      "label": "My Expenses",
      "view": ExpenseListView(),
      "icon": Icons.monetization_on,
      "iconColor": Colors.red
    },
    {
      "label": "Recurring Payment",
      "view": RecurringListView(),
      "icon": Icons.library_books,
      "iconColor": Colors.green
    },
    {
      "label": "Debugging Tool",
      "view": DebugView(),
      "icon": Icons.bug_report,
      "iconColor": Colors.blue
    },
  ];

  Widget buttonMain(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  openPopup(context, view) {
    ViewHelper.pushView(context: widget.parentContext, view: view);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ViewHelper.titleSection(text: _title),
          new Expanded(
            child: ListView.builder(
              itemCount: _menu.length,
              itemBuilder: (BuildContext _context, int index) {
                var d = _menu[index];
                return Container(
                  child: ListTile(
                    onTap: () {
                      openPopup(_context, d["view"]);
                    },
                    leading: CircleAvatar(
                      backgroundColor: d["iconColor"],
                      child: Icon(d["icon"]),
                      foregroundColor: Colors.white,
                    ),
                    isThreeLine: false,
                    title: Text(
                      d["label"],
                      style:
                          TextStyle(fontSize: 20, color: ColorHelper.GreyText),
                    ),
                    subtitle:
                        d["sublabel"] != null ? Text(d["sublabel"]) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
