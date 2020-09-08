import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/helper/form-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/store/expense.dart';
import 'package:hello_flutter/view/expense-list.dart';

// 5. @new_entity - view (add)
class ExpenseAddView extends StatefulWidget {
  final int editId;
  ExpenseAddView({Key key, this.editId = 0}) : super(key: key);

  @override
  ExpenseAddViewState createState() => ExpenseAddViewState();
}

class ExpenseAddViewState extends State<ExpenseAddView> {
  final _expenseAction = ExpenseAction.instance;

  final List<String> _categoryDataset = ExpenseModel.allCategory;

  String _title;
  String _amount;
  String _category;
  bool _mounted;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mounted = false;
    _title = "";
    _amount = "";
    _category = _categoryDataset[0];
  }

  void componentDidMounted(BuildContext context) async {
    if (_mounted) {
      return;
    }

    if (isEdit()) {
      var editObject = await _expenseAction.single(editId());
      var title = editObject.title;
      var amount = '${editObject.amount}';
      var category = editObject.category;

      FormHelper.setText(_titleController, title);
      FormHelper.setText(_amountController, amount);
      setState(() {
        _title = title;
        _amount = amount;
        _category = category;
        _mounted = true;
      });
    }
  }

  editId() {
    return widget.editId;
  }

  isEdit() {
    return editId() > 0;
  }

  resetForm() {
    FormHelper.setText(_titleController, "");
    FormHelper.setText(_amountController, "");
    setState(() {
      _category = _categoryDataset[0];
    });
  }

  submit() async {
    if (isEdit()) {
      await update();
      ViewHelper.dialogPostEdit(
        context: context,
        body: [Text("Expense successfully edited.")],
        gotItHandler: (_context) {
          ViewHelper.dialogClose(_context);
          ViewHelper.popView(_context);
          ViewHelper.pushView(
            context: _context,
            view: ExpenseListView(),
          );
        },
      );
    } else {
      await insert();
      ViewHelper.dialogPostAdd(
        context: context,
        body: [Text("New expense successfully added.")],
        viewHandler: (_context) {
          ViewHelper.dialogClose(_context);
          ViewHelper.popView(_context);
          ViewHelper.pushView(
            context: _context,
            view: ExpenseListView(),
          );
        },
        addMoreHandler: (_context) {
          ViewHelper.dialogClose(_context);
          resetForm();
        },
      );
    }
  }

  insert() async {
    Map<String, dynamic> data = {
      ExpenseModel.col_title: _title,
      ExpenseModel.col_category: _category,
      ExpenseModel.col_amount: double.parse(_amount),
    };
    var row = await _expenseAction.insert(data);
    ExpenseModel t = ExpenseModel.fromMap(row);
    ExpenseStore.addFirst(t);
  }

  update() async {
    await _expenseAction.update({
      ExpenseModel.col_id: editId(),
      ExpenseModel.col_title: _title,
      ExpenseModel.col_amount: double.parse(_amount),
      ExpenseModel.col_category: _category,
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => componentDidMounted(context));
    var title = isEdit() ? 'Editing Expense #${editId()}' : "Add New Expense";
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: Container(
        padding: new EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            FormHelper.formItem(
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
              selectVal: _category,
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
                await submit(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
