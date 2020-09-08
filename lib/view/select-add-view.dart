import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/view/expense-add.dart';
import 'package:hello_flutter/view/task-add.dart';
import 'package:hello_flutter/view/to-pay-add.dart';
import 'task-list.dart';
import 'to-pay-list.dart';
import 'expense-list.dart';

class SelectAddView extends StatefulWidget {
  final BuildContext parentContext;
  SelectAddView({Key key, this.parentContext}) : super(key: key);

  @override
  SelectAddViewState createState() => SelectAddViewState();
}

class SelectAddViewState extends State<SelectAddView> {
  Widget buttonMain(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  openPopup(view) {
    ViewHelper.pushView(context: widget.parentContext, view: view);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ViewHelper.titleSection(text: "Add What?"),
        buttonMain("Tasks", () {
          openPopup(TaskAddView());
        }),
        buttonMain("To Pay", () {
          openPopup(ToPayAddView());
        }),
        buttonMain("Expenses", () {
          openPopup(ExpenseAddView());
        }),
      ],
    );
  }
}
