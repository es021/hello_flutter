import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/color-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/RecurringModel.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hello_flutter/view/expense-add.dart';

class ExpenseListView extends StatefulWidget {
  @override
  ExpenseListViewState createState() => ExpenseListViewState();
}

class ExpenseListViewState extends State<ExpenseListView> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final _toPayAction = ExpenseAction.instance;
  final _initialMonth = TimeHelper.currentMonth();
  final _initialYear = TimeHelper.currentYear();
  int _currentMonth = TimeHelper.currentMonth();
  int _currentYear = TimeHelper.currentYear();

  int _orderByCurrentIndex = 0;
  var _orderByList = [
    {
      "label": "Paid",
      "sql": '${ExpenseModel.col_is_paid} asc',
    },
    {
      "label": "Category",
      "sql": '${ExpenseModel.col_category} asc',
    },
    {
      "label": "Amount",
      "sql": '${ExpenseModel.col_amount} desc',
    }
  ];

  var _list = List<ExpenseModel>();
  String title = "My Expenses";
  Map _isPaidMap = {};
  final _limitPage = 10;
  bool _loading = false;
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

  getIsPaid(ExpenseModel d, int index) {
    bool isPaid = _isPaidMap[index] == null // kalau kat program null
        ? (d.is_paid == "1" ? true : false) // amik dari db
        : _isPaidMap[index];
    return isPaid;
  }

  Widget getListItem(BuildContext context, ExpenseModel d, int index) {
    int id = d.id;
    double amount = d.amount;
    double amount_custom = d.amount_custom;
    bool hasAmountCustom = amount_custom != null && amount_custom > 0;
    var isPaid = getIsPaid(d, index);

    // create style for text
    var titleStyle = isPaid
        ? TextStyle(fontSize: 15, color: Colors.grey)
        : TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: ColorHelper.GreyText,
          );

    var amountStyle = (hasAmountCustom)
        ? TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.lineThrough,
          )
        : TextStyle(fontSize: 13);

    var title = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Text(d.title, style: titleStyle),
        SizedBox(height: 3),
        Row(
          children: [
            Text(
              'RM ${amount.toStringAsFixed(2)}',
              style: titleStyle.merge(amountStyle),
            ),
            hasAmountCustom
                ? Text(
                    ' | RM ${amount_custom.toStringAsFixed(2)}',
                    style: titleStyle.merge(TextStyle(fontSize: 13)),
                  )
                : Text(""),
          ],
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
        backgroundColor: ExpenseHelper.iconColorCategory(d.category),
        // backgroundColor: isPaid
        //     ? Colors.grey[400]
        //     : ExpenseHelper.iconColorCategory(d.category),
        child: Icon(ExpenseHelper.iconCategory(d.category)),
        foregroundColor: Colors.white,
      ),
    );

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: listTile,
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
        )
      ],
    );
  }

  updateIsPaid(id, is_paid) async {
    print('updating id=$id | is_paid=$is_paid');
    Map<String, dynamic> row = {
      ExpenseModel.col_id: id,
      ExpenseModel.col_is_paid: is_paid,
      ExpenseModel.col_updated_at: TimeHelper.currentTimeInSeconds()
    };
    final rowsAffected = await _toPayAction.update(row);
    print('updated $rowsAffected row(s)');
  }

  Widget renderList(BuildContext context) {
    if (_list.length == 0) {
      return Expanded(
        flex: 3,
        child: ViewHelper.emptyState(
          actionText: "Generate From Recurring",
          actionHandler: () async {
            await _toPayAction.populateMonthly(
                month: _currentMonth, year: _currentYear);
            refreshList();
          },
        ),
      );
    } else {
      return new Expanded(
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            ExpenseModel entity = _list[index];
            return getListItem(context, entity, index);
          },
        ),
      );
    }
  }

  void emptyList() {
    setState(() {
      _isPaidMap = {};
      _list = List<ExpenseModel>();
    });
  }

  void addFirstList(t) {
    setState(() {
      _list.insert(0, t);
    });
  }

  void addLastList(t) {
    setState(() {
      _list.add(t);
    });
  }

  getOrderBy() {
    var orderByObj = _orderByList[_orderByCurrentIndex];
    return orderByObj;
  }

  void refreshList() async {
    setState(() {
      _loading = true;
    });
    emptyList();

    var rows = await _toPayAction.query(
        _currentMonth, _currentYear, getOrderBy()["sql"]);
    rows.forEach((r) => {addLastList(r)});
    setState(() {
      _loading = false;
    });
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
    var body;
    if (_loading) {
      body = <Widget>[ViewHelper.loading()];
    } else {
      var orderButton = FlatButton(
        onPressed: () {
          setState(() {
            _orderByCurrentIndex = _orderByCurrentIndex + 1;
            if (_orderByCurrentIndex >= _orderByList.length) {
              _orderByCurrentIndex = 0;
            }
          });
          refreshList();
        },
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Text(
              '${getOrderBy()["label"]}',
              style: TextStyle(color: ColorHelper.GreyText),
            )
          ],
        ),
      );

      body = <Widget>[
        ViewHelper.titleSection(
          trail: orderButton,
          text: '${TimeHelper.getMonthText(_currentMonth)} $_currentYear',
          subtextCustom: Row(
            children: [
              Text(
                'RM ${getTotalPaid().toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 15),
              Text("|"),
              SizedBox(width: 15),
              Text(
                'RM ${getTotalPaid(isSaving: true).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
        renderList(context),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_left),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Text("Swipe here to change month")),
              Icon(Icons.arrow_right),
            ],
          ),
        )
      ];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: body,
    );
  }

  getPageChildren() {
    var ret = <Widget>[];
    for (var i = 0; i < _limitPage; i++) {
      ret.add(getMainView());
    }
    return ret;
  }

  getTotalPaid({isSaving = false}) {
    double total = 0;
    int index = 0;
    _list.forEach((d) {
      var isPaid = getIsPaid(d, index);
      index++;

      var isSkip = (!isSaving && d.category == ExpenseHelper.category_saving) ||
          (isSaving && d.category != ExpenseHelper.category_saving);

      if (isSkip) {
        return;
      }

      if (isPaid) {
        if (d.amount_custom != null && d.amount_custom > 0) {
          total += d.amount_custom;
        } else {
          total += d.amount;
        }
      }
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
        // print("pageIndex=$pageIndex");
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
