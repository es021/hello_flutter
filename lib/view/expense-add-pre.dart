import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_flutter/action/ExpenseAction.dart';
import 'package:hello_flutter/helper/form-helper.dart';
import 'package:hello_flutter/helper/expense-helper.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:hello_flutter/helper/view-helper.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:hello_flutter/view/expense-add.dart';
import 'package:hello_flutter/view/expense-list.dart';

// 5. @new_entity - view (add)
class ExpenseAddPreView extends StatefulWidget {
  ExpenseAddPreView({Key key}) : super(key: key);
  @override
  ExpenseAddPreViewState createState() => ExpenseAddPreViewState();
}

class ExpenseAddPreViewState extends State<ExpenseAddPreView> {
  final List<String> _categoryDataset = ExpenseHelper.getAllCategory();
  @override
  void initState() {
    super.initState();
  }

  getCategoryButton() {
    
    double sizeIcon = 40;
    double sizeCircle = sizeIcon + 25;
    double sizeContainer = sizeIcon + 60;

    List<Widget> r = [];
    for (var i = 0; i < _categoryDataset.length; i++) {
      var cat = _categoryDataset[i];

      var button = Ink(
        decoration: ShapeDecoration(
          color: ExpenseHelper.iconColorCategory(cat),
          shape: CircleBorder(),
        ),
        child: new SizedBox(
          height: sizeCircle,
          width: sizeCircle,
          child: IconButton(
            icon: Icon(ExpenseHelper.iconCategory(cat), size: sizeIcon),
            color: Colors.white,
            onPressed: () {
              // print(cat);
              ViewHelper.pushView(
                  context: context, view: ExpenseAddView(category: cat));
            },
          ),
        ),
      );

      r.add(
        SizedBox(
          height: sizeContainer,
          width: sizeContainer,
          child: Column(
            children: [button, SizedBox(height: 7), Text(cat)],
          ),
        ),
      );
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    var title = "Choose Expense Category";
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: new EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  // alignment: WrapAlignment.spaceAround,
                  spacing: 30.0, // gap between adjacent chips
                  runSpacing: 30.0, // gap between lines
                  children: getCategoryButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
