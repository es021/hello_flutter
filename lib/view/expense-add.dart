import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/form-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/store/expense.dart';
import 'package:hello_flutter/view/expense-list.dart';

class ExpenseAddView extends StatefulWidget {
  @override
  ExpenseAddViewState createState() => ExpenseAddViewState();
}

class ExpenseAddViewState extends State<ExpenseAddView> {
  var _viewTitle = "Add a new expense";
  final _expenseAction = ExpenseAction.instance;

  String _title = "";
  String _category = "";
  String _amount = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  List<String> _categoryDataset = <String>[
    ExpenseModel.category_rent,
    ExpenseModel.category_loan,
    ExpenseModel.category_utility
  ];

  resetForm() {
    _titleController.text = "";
    _amountController.text = "";
    setState(() {
      _title = "";
      _amount = "";
      _category = _categoryDataset[0];
    });
  }

  // insertAndClose() async {
  //   print("insert");
  //   print("_title=$_title");
  //   print("_category=$_category");
  //   print("_amount=$_amount");

  //   var row = await _expenseAction.insert(_title, _category, _amount);
  //   ExpenseModel t = ExpenseModel.fromMap(row);
  //   ExpenseStore.addFirst(t);
  //   Navigator.pop(context); // Close the add todo screen
  //   pushView(context, ExpenseListView());
  // }

  insert() async {
    print("insert");
    print("_title=$_title");
    print("_category=$_category");
    print("_amount=$_amount");
    var row =
        await _expenseAction.insert(_title, _category, double.parse(_amount));
    ExpenseModel t = ExpenseModel.fromMap(row);
    ExpenseStore.addFirst(t);
  }

// push view on top

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(_viewTitle)),
      body: Container(
        padding: new EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            FormHelper.formItem(
              currentVal: _title,
              controller: _titleController,
              type: "text",
              label: "Title",
              onChanged: (val) => {
                setState(() {
                  _title = val;
                })
              },
            ),
            FormHelper.formItem(
              currentVal: _amount,
              controller: _amountController,
              type: "number",
              label: "Amount",
              onChanged: (val) => {
                setState(() {
                  _amount = val;
                })
              },
            ),
            FormHelper.formItem(
              currentVal: _category,
              controller: _categoryController,
              type: "select",
              label: "Category",
              dataset: _categoryDataset,
              onChanged: (val) => {
                setState(() {
                  _category = val;
                })
              },
            ),
            FormHelper.formSubmit(
              onPressed: () async => {
                await insert(),
                ViewHelper.dialogPostAdd(
                  context: context,
                  body: [Text("New expense successfully added.")],
                  viewHandler: (_context) {
                    ViewHelper.dialogClose(_context);
                    ViewHelper.pushView(
                      context: _context,
                      view: ExpenseListView(),
                    );
                  },
                  addMoreHandler: (_context) {
                    ViewHelper.dialogClose(_context);
                    resetForm();
                  },
                ),
              },
            ),
            // DropdownButton(items: ["sad", "asd"], onChanged: null),
          ],
        ),
      ),
    );
  }
}
