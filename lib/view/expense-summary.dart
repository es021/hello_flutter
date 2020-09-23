/// Simple pie chart with outside labels example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/component/pie-chart.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';

class ExpenseSummaryView extends StatefulWidget {
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
  String title = "Expense Summary";

  @override
  void initState() {
    super.initState();
    refreshList();
    _pageController = PageController(
      initialPage: 0,
    );
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

    var rows =
        await _expenseAction.queryGroupByCategory(_currentMonth, _currentYear);
    rows.forEach((r) {
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

  renderTitle() {
    // return 'Expense ${TimeHelper.getMonthText(_currentMonth)} $_currentYear';
    return ViewHelper.titleSection(
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
    );
  }

  renderChart() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: PieChart(
          getDataSeries(),
          legendLabelFn: (value) => ' ( RM $value )',
        ),
      ),
    );
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
