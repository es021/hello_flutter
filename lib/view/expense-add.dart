import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/form-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/model/RecurringModel.dart';
import 'package:hello_flutter/view/expense-list.dart';

// 5. @new_entity - view (add)
class ExpenseAddView extends StatefulWidget {
  final int editId;
  final String category;
  ExpenseAddView({Key key, this.editId = 0, this.category}) : super(key: key);

  @override
  ExpenseAddViewState createState() => ExpenseAddViewState();
}

class ExpenseAddViewState extends State<ExpenseAddView> {
  final _toPayAction = ExpenseAction.instance;

  final List<String> _categoryDataset = ExpenseHelper.getAllCategory();

  String _title;
  String _amount;
  String _amount_custom;
  String _month;
  String _year;
  String _category;
  bool _mounted;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _amountCustomController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mounted = false;
    _title = "";
    _amount = "";
    _amount_custom = "";
    _category = widget.category != null ? widget.category : _categoryDataset[0];
  }

  void componentDidMounted(BuildContext context) async {
    if (_mounted) {
      return;
    }

    if (!isEdit()) {
      var month = '${TimeHelper.currentMonth()}';
      var year = '${TimeHelper.currentYear()}';
      FormHelper.setText(_monthController, month);
      FormHelper.setText(_yearController, year);
      setState(() {
        _month = month;
        _year = year;
        _mounted = true;
      });
    } else {
      var editObject = await _toPayAction.single(editId());
      var title = editObject.title;
      var amount = '${editObject.amount}';
      var amount_custom =
          editObject.amount_custom == null ? "" : '${editObject.amount_custom}';
      var month = '${editObject.month}';
      var year = '${editObject.year}';
      var category = editObject.category;

      print("editObject");
      print(editObject);

      FormHelper.setText(_titleController, title);
      FormHelper.setText(_monthController, month);
      FormHelper.setText(_yearController, year);
      FormHelper.setText(_amountController, amount);
      FormHelper.setText(_amountCustomController, amount_custom);
      setState(() {
        _title = title;
        _amount = amount;
        _amount_custom = amount_custom;
        _month = month;
        _year = year;
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
    var month = '${TimeHelper.currentMonth()}';
    var year = '${TimeHelper.currentYear()}';

    FormHelper.setText(_titleController, "");
    FormHelper.setText(_amountController, "");
    FormHelper.setText(_amountCustomController, "");
    FormHelper.setText(_monthController, month);
    FormHelper.setText(_yearController, year);
    setState(() {
      _category = _categoryDataset[0];
      _month = month;
      _year = year;
    });
  }

  submit() async {
    if (isEdit()) {
      await update();
      ViewHelper.dialogPostEdit(
        context: context,
        body: [Text("To pay successfully edited.")],
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
        body: [Text("New to pay successfully added.")],
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

  double parseAmount(amount) {
    try {
      return double.parse(amount);
    } catch (err) {
      return 0;
    }
  }

  insert() async {
    Map<String, dynamic> data = {
      ExpenseModel.col_title: _title,
      ExpenseModel.col_category: _category,
      ExpenseModel.col_amount: parseAmount(_amount),
      ExpenseModel.col_amount_custom: parseAmount(_amount_custom),
      ExpenseModel.col_month: int.parse(_month),
      ExpenseModel.col_year: int.parse(_year),
      ExpenseModel.col_is_paid: "1",
    };
    var row = await _toPayAction.insert(data);
    ExpenseModel t = ExpenseModel.fromMap(row);
    // RecurringStore.addFirst(t);
  }

  update() async {
    await _toPayAction.update({
      ExpenseModel.col_id: editId(),
      ExpenseModel.col_title: _title,
      ExpenseModel.col_amount: parseAmount(_amount),
      ExpenseModel.col_amount_custom: parseAmount(_amount_custom),
      ExpenseModel.col_month: _month,
      ExpenseModel.col_year: _year,
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
      body: SingleChildScrollView(
        child: Container(
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
                controller: _amountCustomController,
                type: "number",
                label: "Amount Custom",
                onChanged: (val) => {
                  setState(() {
                    _amount_custom = val;
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
              FormHelper.formItem(
                controller: _monthController,
                type: "number",
                label: "Month",
                onChanged: (val) => {
                  setState(() {
                    _month = val;
                  })
                },
              ),
              FormHelper.formItem(
                controller: _yearController,
                type: "number",
                label: "Year",
                onChanged: (val) => {
                  setState(() {
                    _year = val;
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
      ),
    );
  }
}
