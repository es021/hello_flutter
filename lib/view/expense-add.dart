import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/store/app.dart';
import 'package:hello_flutter/store/expense.dart';
import 'package:hello_flutter/view/expense-list.dart';

class ExpenseAddView extends StatefulWidget {
  @override
  ExpenseAddViewState createState() => ExpenseAddViewState();
}

class ExpenseAddViewState extends State<ExpenseAddView> {
  var title = "Add a new expense";
  final expenseAction = ExpenseAction.instance;

  onSubmitted(val) async {
    print(val);
    var row = await expenseAction.insert(val);
    // addTaskToView(row);
    ExpenseModel t = ExpenseModel.fromMap(row);
    ExpenseStore.addFirst(t);
  }

// push view on top
  void pushView(content, view) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return view;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new TextField(
        autofocus: true,
        onSubmitted: (val) async {
          onSubmitted(val);
          Navigator.pop(context); // Close the add todo screen
          pushView(context, ExpenseListView());
          // AppStore.setViewIndex(0);
        },
        decoration: new InputDecoration(
            //hintText: 'Enter new query here',
            contentPadding: const EdgeInsets.all(16.0)),
      ),
    );
  }
}
