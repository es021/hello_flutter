import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/view/expense-add-pre.dart';
import 'package:hello_flutter/view/recurring-add.dart';
import 'package:hello_flutter/view/task-add.dart';
import 'package:hello_flutter/view/expense-add.dart';
import 'package:hello_flutter/helper/color-helper.dart';

class SelectAddView extends StatefulWidget {
  final BuildContext parentContext;
  SelectAddView({Key key, this.parentContext}) : super(key: key);

  @override
  SelectAddViewState createState() => SelectAddViewState();
}

class SelectAddViewState extends State<SelectAddView> {
  final _title = "Add What?";
  final _menu = [
    {
      "label": "Add Task",
      "view": TaskAddView(),
      "icon": Icons.check_circle,
      "iconColor": Colors.teal
    },
    {
      "label": "Add Expense",
      // "view": ExpenseAddView(),
      "view": ExpenseAddPreView(),
      "icon": Icons.monetization_on,
      "iconColor": Colors.red
    },
    {
      "label": "Add Recurring Payment",
      "view": RecurringAddView(),
      "icon": Icons.library_books,
      "iconColor": Colors.green
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
