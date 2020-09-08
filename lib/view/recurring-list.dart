import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/action/RecurringAction.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/RecurringModel.dart';
import 'package:hello_flutter/store/recurring.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hello_flutter/view/recurring-add.dart';

// 6. @new_entity - view (list)
class RecurringListView extends StatefulWidget {
  @override
  RecurringListViewState createState() => RecurringListViewState();
}

class RecurringListViewState extends State<RecurringListView> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final DbHelper = DatabaseHelper.instance;
  final _recurringAction = RecurringAction.instance;
  String title = "Recurring Payment";

  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  Future<void> refreshListAsync() async {
    refreshList();
  }

  Widget getListItem(BuildContext context, RecurringModel d, int index) {
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
              view: RecurringAddView(editId: d.id),
            )
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {
            _recurringAction.delete(d.id),
            RecurringStore.remove(index),
            ViewHelper.snackbar(
                context: context, text: '\'${d.title}\' removed.'),
          },
        ),
      ],
    );
  }

  Widget renderList(BuildContext context) {
    return Observer(builder: (_) {
      if (RecurringStore.list.length <= 0) {
        return ViewHelper.emptyState(
          actionText: "Add Recurring Payment",
          actionHandler: () {
            ViewHelper.pushView(context: context, view: RecurringAddView());
          },
        );
      } else {
        return new Expanded(
          child: ListView.builder(
            itemCount: RecurringStore.list.length,
            itemBuilder: (BuildContext context, int index) {
              RecurringModel entity = RecurringStore.list[index];
              return getListItem(context, entity, index);
            },
          ),
        );
      }
    });
  }

  refreshList() async {
    RecurringStore.emptyList();

    // var rows = await DbHelper.queryAllRows(RecurringModel.table);
    // rows.forEach((r) => {RecurringStore.addLast(RecurringModel.fromMap(r))});

    var rows = await _recurringAction.all();
    rows.forEach((r) => {RecurringStore.addLast(r)});
  }

  // updateIsChecked(id, is_checked) async {
  //   // row to update
  //   print('updating id=$id | is_checked=$is_checked');
  //   Map<String, dynamic> row = {
  //     RecurringModel.col_id: id,
  //     RecurringModel.col_is_checked: is_checked,
  //     RecurringModel.col_updated_at: DbHelper.currentTimeInSeconds()
  //   };
  //   final rowsAffected =
  //       await DbHelper.update(RecurringModel.table, RecurringModel.col_id, row);
  //   print('updated $rowsAffected row(s)');
  // }

  void showNotification(String text) {
    return;
  }

  insertTask(val) async {
    showNotification("Inserting");
    Map<String, dynamic> row = {RecurringModel.col_title: val};
    final id = await DbHelper.insert(RecurringModel.table, row);
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
