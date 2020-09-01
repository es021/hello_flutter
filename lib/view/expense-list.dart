import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/store/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hello_flutter/view/expense-add.dart';

// 6. @new_entity - view (list)
class ExpenseListView extends StatefulWidget {
  @override
  ExpenseListViewState createState() => ExpenseListViewState();
}

class ExpenseListViewState extends State<ExpenseListView> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final DbHelper = DatabaseHelper.instance;
  final _expenseAction = ExpenseAction.instance;
  String title = "My Expenses";

  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  Future<void> refreshListAsync() async {
    refreshList();
  }

  Widget getListItem(BuildContext context, ExpenseModel d, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: ExpenseHelper.iconColorCategory(d.category),
            child: Icon(ExpenseHelper.iconCategory(d.category)),
            foregroundColor: Colors.white,
          ),
          title: Text(d.title),
          subtitle: Text('RM ${d.amount.toStringAsFixed(2)}'),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => ViewHelper.snackbar(context: context, text: 'Archive'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => ViewHelper.snackbar(context: context, text: 'Share'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black26,
          foregroundColor: Colors.black,
          icon: Icons.edit,
          onTap: () => {
            ViewHelper.pushView(
              context: context,
              view: ExpenseAddView(editId: d.id),
            )
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {
            _expenseAction.delete(d.id),
            ExpenseStore.remove(index),
            ViewHelper.snackbar(
                context: context, text: '\'${d.title}\' removed.'),
          },
        ),
      ],
    );
  }

  Widget renderList(BuildContext context) {
    return Observer(
      builder: (_) => new Expanded(
        child: ListView.builder(
          itemCount: ExpenseStore.list.length,
          itemBuilder: (BuildContext context, int index) {
            ExpenseModel entity = ExpenseStore.list[index];
            return getListItem(context, entity, index);
          },
        ),
      ),
    );
  }

  refreshList() async {
    ExpenseStore.emptyList();

    // var rows = await DbHelper.queryAllRows(ExpenseModel.table);
    // rows.forEach((r) => {ExpenseStore.addLast(ExpenseModel.fromMap(r))});

    var rows = await _expenseAction.all();
    rows.forEach((r) => {ExpenseStore.addLast(r)});
  }

  // updateIsChecked(id, is_checked) async {
  //   // row to update
  //   print('updating id=$id | is_checked=$is_checked');
  //   Map<String, dynamic> row = {
  //     ExpenseModel.col_id: id,
  //     ExpenseModel.col_is_checked: is_checked,
  //     ExpenseModel.col_updated_at: DbHelper.currentTimeInSeconds()
  //   };
  //   final rowsAffected =
  //       await DbHelper.update(ExpenseModel.table, ExpenseModel.col_id, row);
  //   print('updated $rowsAffected row(s)');
  // }

  void showNotification(String text) {
    return;
  }

  insertTask(val) async {
    showNotification("Inserting");
    Map<String, dynamic> row = {ExpenseModel.col_title: val};
    final id = await DbHelper.insert(ExpenseModel.table, row);
    row["id"] = id;
    showNotification('Successfully added entity $val ($id)');
    return row;
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

  // ##############################################################################
  // main
  // ##############################################################################
  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: RefreshIndicator(
        onRefresh: refreshListAsync,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            renderList(context),
          ],
        ),
      ),
    );
  }
}
