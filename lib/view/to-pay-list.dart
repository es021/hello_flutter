import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_flutter/action/ToPayAction.dart';
import 'package:hello_flutter/helper/color-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/model/ToPayModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hello_flutter/view/to-pay-add.dart';

class ToPayListView extends StatefulWidget {
  @override
  ToPayListViewState createState() => ToPayListViewState();
}

class ToPayListViewState extends State<ToPayListView> {
  // ##############################################################################
  // variables
  // ##############################################################################
  final _toPayAction = ToPayAction.instance;
  final _initialMonth = TimeHelper.currentMonth();
  final _initialYear = TimeHelper.currentYear();
  int _currentMonth = TimeHelper.currentMonth();
  int _currentYear = TimeHelper.currentYear();

  int _orderByCurrentIndex = 0;
  var _orderByList = [
    {
      "label": "Category",
      "sql": '${ToPayModel.col_category} asc',
    },
    {
      "label": "Paid",
      "sql": '${ToPayModel.col_is_paid} asc',
    },
    {
      "label": "Amount",
      "sql": '${ToPayModel.col_amount} desc',
    }
  ];

  var _list = List<ToPayModel>();
  String title = "To Pay";
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

  getIsPaid(ToPayModel d, int index) {
    bool isPaid = _isPaidMap[index] == null // kalau kat program null
        ? (d.is_paid == "1" ? true : false) // amik dari db
        : _isPaidMap[index];
    return isPaid;
  }

  Widget getListItem(BuildContext context, ToPayModel d, int index) {
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
        backgroundColor: isPaid
            ? Colors.grey[400]
            : ExpenseHelper.iconColorCategory(d.category),
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
          caption: 'Edit Amount',
          color: Colors.black26,
          foregroundColor: Colors.black,
          icon: Icons.edit,
          onTap: () => {
            // ViewHelper.snackbar(context: context, text: "Edit Amount")
            ViewHelper.pushView(
              context: context,
              view: ToPayAddView(editId: d.id),
            )
          },
        )
      ],
    );
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
    if (_list.length == 0) {
      return Expanded(
        flex: 3,
        child: ViewHelper.emptyState(
          actionText: "Generate for ${TimeHelper.getMonthText(_currentMonth)}",
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
            ToPayModel entity = _list[index];
            return getListItem(context, entity, index);
          },
        ),
      );
    }
  }

  void emptyList() {
    setState(() {
      _isPaidMap = {};
      _list = List<ToPayModel>();
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
          subtext: 'RM ${getTotalPaid().toStringAsFixed(2)}',
          subtextStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
