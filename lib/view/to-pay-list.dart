import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hello_flutter/action/ToPayAction.dart';
import 'package:hello_flutter/helper/color-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ToPayModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_flutter/helper/database-helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hello_flutter/store/to_pay.dart';

class ToPayListView extends StatefulWidget {
  @override
  ToPayListViewState createState() => ToPayListViewState();
}

class ToPayListViewState extends State<ToPayListView> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final DbHelper = DatabaseHelper.instance;
  final _toPayAction = ToPayAction.instance;
  final _initialMonth = TimeHelper.currentMonth();
  final _initialYear = TimeHelper.currentYear();
  int _currentMonth = TimeHelper.currentMonth();
  int _currentYear = TimeHelper.currentYear();
  var _list = List<ToPayModel>();
  String title = "To Pay";
  Map _isPaidMap = {};
  final _limitPage = 10;
  PageController _pageController;
  Widget buttonDebug(title, onPressed) {
    return RaisedButton(
      child: Text(title),
      onPressed: onPressed,
    );
  }

  Future<void> refreshListAsync() async {
    refreshList();
  }

  getIsPaid(ToPayModel d, int index) {
    bool isPaid = _isPaidMap[index] == null // kalau kat program null
        ? (d.is_paid == "1" ? true : false) // amik dari db
        : _isPaidMap[index];
    return isPaid;
  }

  Widget getListItem(BuildContext context, ToPayModel d, int index) {
    int id = d.id;
    double amount = d.amount;

    // bool isPaid = d.is_paid == "1" ? true : false;

    var isPaid = getIsPaid(d, index);
    var titleStyle = isPaid
        ? TextStyle(
            color: Colors.black.withOpacity(0.4),
            decoration: TextDecoration.lineThrough)
        : TextStyle();

    var title = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Text(
          d.title,
          style: titleStyle.merge(
            TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ColorHelper.GreyText,
            ),
          ),
        ),
        SizedBox(height: 3),
        new Text(
          'RM ${amount.toStringAsFixed(2)}',
          style: titleStyle.merge(
            TextStyle(fontSize: 13),
          ),
        ),
      ],
    );

    var listTile = CheckboxListTile(
      title: title,
      value: isPaid,
      onChanged: (bool value) {
        updateIsPaid(id, value ? "1" : "0");
        setState(() => {_isPaidMap[index] = value});
      },
      secondary: CircleAvatar(
        backgroundColor:
            isPaid ? Colors.grey : ExpenseHelper.iconColorCategory(d.category),
        child: Icon(ExpenseHelper.iconCategory(d.category)),
        foregroundColor: Colors.white,
      ),
    );

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: listTile,
      // Container(
      //   color: Colors.white,
      //   child: ListTile(
      //     leading: CircleAvatar(
      //       backgroundColor: ExpenseHelper.iconColorCategory(d.category),
      //       child: Icon(ExpenseHelper.iconCategory(d.category)),
      //       foregroundColor: Colors.white,
      //     ),
      //     title: Text(d.title),
      //     subtitle: Text('RM ${d.amount.toStringAsFixed(2)}'),
      //   ),
      // ),
      actions: <Widget>[
        // IconSlideAction(
        //   caption: 'Archive',
        //   color: Colors.blue,
        //   icon: Icons.archive,
        //   onTap: () => ViewHelper.snackbar(context: context, text: 'Archive'),
        // ),
        // IconSlideAction(
        //   caption: 'Share',
        //   color: Colors.indigo,
        //   icon: Icons.share,
        //   onTap: () => ViewHelper.snackbar(context: context, text: 'Share'),
        // ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit Amount',
          color: Colors.black26,
          foregroundColor: Colors.black,
          icon: Icons.edit,
          onTap: () => {
            ViewHelper.snackbar(context: context, text: "Edit Amount")
            // ViewHelper.pushView(
            //   context: context,
            //   view: ExpenseAddView(editId: d.id),
            // )
          },
        )
      ],
    );

    // // return Dismissible(
    // //   // Show a red background as the item is swiped away.
    // //   background: Container(color: Colors.red),
    // //   key: Key("$id"),
    // //   onDismissed: (direction) {
    // //     _toPayAction.delete(id);
    // //     Scaffold.of(context)
    // //         .showSnackBar(SnackBar(content: Text("Task removed")));
    // //   },
    // //   child: listTile,
    // );
  }

  updateIsPaid(id, is_paid) async {
    print('updating id=$id | is_paid=$is_paid');
    Map<String, dynamic> row = {
      ToPayModel.col_id: id,
      ToPayModel.col_is_paid: is_paid,
      ToPayModel.col_updated_at: TimeHelper.currentTimeInSeconds()
    };
    final rowsAffected = await _toPayAction.update(row);
    print('updated $rowsAffected row(s)');
  }

  Widget renderList(BuildContext context) {
    return new Expanded(
      child: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          ToPayModel entity = _list[index];
          return getListItem(context, entity, index);
        },
      ),
    );
  }

  void emptyList() {
    setState(() {
      _isPaidMap = {};
      _list = List<ToPayModel>();
    });
  }

  void addLastList(t) {
    setState(() {
      _list.insert(0, t);
    });
  }

  refreshList() async {
    emptyList();
    var rows = await _toPayAction.query(_currentMonth, _currentYear);
    rows.forEach((r) => {addLastList(r)});
  }

  void showNotification(String text) {
    return;
  }

  insertTask(val) async {
    showNotification("Inserting");
    Map<String, dynamic> row = {ToPayModel.col_title: val};
    final id = await DbHelper.insert(ToPayModel.table, row);
    row["id"] = id;
    showNotification('Successfully added entity $val ($id)');
    return row;
  }

  // ##############################################################################
  // main
  // ##############################################################################
  @override
  void initState() {
    super.initState();
    refreshList();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  getMainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ViewHelper.titleSection(
          text: '${TimeHelper.getMonthText(_currentMonth)} $_currentYear',
          subtext: 'RM ${getTotalPaid().toStringAsFixed(2)}',
          subtextStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        renderList(context),
      ],
    );
  }

  getPageChildren() {
    var ret = <Widget>[];
    for (var i = 0; i < _limitPage; i++) {
      ret.add(getMainView());
    }
    return ret;
  }

  getTotalPaid() {
    double total = 0;
    int index = 0;
    _list.forEach((d) {
      var isPaid = getIsPaid(d, index);
      if (isPaid) {
        if (d.amount_custom != null && d.amount_custom > 0) {
          total += d.amount_custom;
        } else {
          total += d.amount;
        }
      }
      index++;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    var pageView = PageView(
      controller: _pageController,
      reverse: true,
      pageSnapping: true,
      onPageChanged: (int pageIndex) {
        setState(() {
          _currentMonth = _initialMonth - pageIndex;
        });
        print("pageIndex=$pageIndex");
        refreshList();
      },
      children: getPageChildren(),
    );
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: RefreshIndicator(onRefresh: refreshListAsync, child: pageView),
    );
  }
}
