/// Simple pie chart with outside labels example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/component/pie-chart.dart';
import 'package:hello_flutter/helper/color-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/view/expense-list.dart';

class ExpenseSummaryView extends StatefulWidget {
  final int pageIndex;
  ExpenseSummaryView({Key key, this.pageIndex = 0}) : super(key: key);
  @override
  ExpenseSummaryViewState createState() => ExpenseSummaryViewState();
}

class ExpenseSummaryViewState extends State<ExpenseSummaryView> {
  var _list = List<ExpenseByCategory>();
  final _limitPage = 10;
  bool _loading = false;
  PageController _pageController;
  final _expenseAction = ExpenseAction.instance;
  final _initialMonth = TimeHelper.currentMonth();
  final _initialYear = TimeHelper.currentYear();
  int _currentMonth = TimeHelper.currentMonth();
  int _currentYear = TimeHelper.currentYear();
  int _currentPageIndex;
  String title = "Expense Summary";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.pageIndex,
    );

    // refreshList();

    updatePage(widget.pageIndex);
  }

  void emptyList() {
    setState(() {
      _list = List<ExpenseByCategory>();
    });
  }

  Future<void> refreshListAsync() async {
    refreshList();
  }

  void refreshList() async {
    setState(() {
      _loading = true;
    });
    emptyList();

    var rows = await _expenseAction.queryGroupByCategory(
      _currentMonth,
      _currentYear,
    );

    rows.forEach((r) {
      // print('${r.category} ${r.total}');
      if (r.total > 0) {
        addLastList(getObj(r.category, r.total));
      }
    });

    setState(() {
      _loading = false;
    });
  }

  void addLastList(t) {
    setState(() {
      _list.add(t);
    });
  }

  ExpenseByCategory getObj(cat, total) {
    return new ExpenseByCategory(
      cat,
      total,
      ExpenseHelper.iconColorCategory(cat, forChart: true),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<ExpenseByCategory, String>> getDataSeries() {
    var data = _list;
    return [
      new charts.Series<ExpenseByCategory, String>(
        id: 'Expense',
        domainFn: (ExpenseByCategory r, _) => r.category,
        measureFn: (ExpenseByCategory r, _) => r.total,
        colorFn: (ExpenseByCategory r, _) => r.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (ExpenseByCategory row, _) =>
            // '${row.category} => ${row.total}',
            // 'RM ${row.total}',
            '${row.category}',
      )
    ];
  }

  getTotalPaid({isSaving = false}) {
    double total = 0;
    _list.forEach((d) {
      var isSkip = (!isSaving && d.category == ExpenseHelper.category_saving) ||
          (isSaving && d.category != ExpenseHelper.category_saving);
      if (isSkip) {
        return;
      }
      total += d.total;
    });
    return total;
  }

  getMainView() {
    var body;
    if (_loading) {
      body = <Widget>[ViewHelper.loading()];
    } else {
      body = <Widget>[renderTitle(), renderChart()];
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

  getAction() {
    var listButton = FlatButton(
      padding: EdgeInsets.only(left: -30),
      onPressed: () {
        ViewHelper.popView(context);
        ViewHelper.pushView(
          context: context,
          view: ExpenseListView(pageIndex: _currentPageIndex),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.list,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Text(
            'View List',
            style: TextStyle(color: ColorHelper.GreyText),
          )
        ],
      ),
    );

    return Row(children: [listButton]);
  }

  renderTitle() {
    var sumText = Row(
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
    );
    // return 'Expense ${TimeHelper.getMonthText(_currentMonth)} $_currentYear';
    return ViewHelper.titleSection(
      text: '${TimeHelper.getMonthText(_currentMonth)} $_currentYear',
      subtextCustom: Column(
        children: [
          sumText,
          getAction(),
        ],
      ),
    );
  }

  renderChart() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: PieChart(
          getDataSeries(),
          legendLabelFn: (value) => ' ( RM ${value.toStringAsFixed(2)} )',
        ),
      ),
    );
  }

  updatePage(pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _currentMonth = _initialMonth - pageIndex;
    });
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    var pageView = PageView(
      controller: _pageController,
      reverse: true,
      pageSnapping: true,
      onPageChanged: (int pageIndex) {
        updatePage(pageIndex);
      },
      children: getPageChildren(),
    );
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: pageView,
      // body: RefreshIndicator(onRefresh: refreshListAsync, child: pageView),
    );
  }
}

/// Sample linear data type.
class ExpenseByCategory {
  final String category;
  final double total;
  final charts.Color color;

  ExpenseByCategory(this.category, this.total, this.color);
}
