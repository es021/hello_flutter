import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/action/RecurringAction.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:hello_flutter/helper/form-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/RecurringModel.dart';
import 'package:hello_flutter/store/recurring.dart';
import 'package:hello_flutter/view/recurring-list.dart';

// 5. @new_entity - view (add)
class RecurringAddView extends StatefulWidget {
  final int editId;
  RecurringAddView({Key key, this.editId = 0}) : super(key: key);

  @override
  RecurringAddViewState createState() => RecurringAddViewState();
}

class RecurringAddViewState extends State<RecurringAddView> {
  final _recurringAction = RecurringAction.instance;

  final List<String> _categoryDataset = ExpenseHelper.getAllCategory();

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
      var editObject = await _recurringAction.single(editId());
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
        body: [Text("Recurring successfully edited.")],
        gotItHandler: (_context) {
          ViewHelper.dialogClose(_context);
          ViewHelper.popView(_context);
          ViewHelper.pushView(
            context: _context,
            view: RecurringListView(),
          );
        },
      );
    } else {
      await insert();
      ViewHelper.dialogPostAdd(
        context: context,
        body: [Text("New recurring successfully added.")],
        viewHandler: (_context) {
          ViewHelper.dialogClose(_context);
          ViewHelper.popView(_context);
          ViewHelper.pushView(
            context: _context,
            view: RecurringListView(),
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
      RecurringModel.col_title: _title,
      RecurringModel.col_category: _category,
      RecurringModel.col_amount: double.parse(_amount),
    };
    var row = await _recurringAction.insert(data);
    RecurringModel t = RecurringModel.fromMap(row);
    RecurringStore.addFirst(t);
  }

  update() async {
    await _recurringAction.update({
      RecurringModel.col_id: editId(),
      RecurringModel.col_title: _title,
      RecurringModel.col_amount: double.parse(_amount),
      RecurringModel.col_category: _category,
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => componentDidMounted(context));
    var title = isEdit() ? 'Editing Recurring #${editId()}' : "Add New Recurring";
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
