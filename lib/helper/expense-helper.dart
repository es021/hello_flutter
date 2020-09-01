import 'package:flutter/material.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';

class _ExpenseHelper {
  Color iconColorCategory(String cat) {
    if (cat == ExpenseModel.category_rent) {
      return Colors.blue[300];
    }
    if (cat == ExpenseModel.category_loan) {
      return Colors.orange[300];
    }
    if (cat == ExpenseModel.category_utility) {
      return Colors.purple[300];
    }

    return Colors.grey;
  }

  IconData iconCategory(String cat) {
    if (cat == ExpenseModel.category_rent) {
      return Icons.home;
    }
    if (cat == ExpenseModel.category_loan) {
      return Icons.monetization_on;
    }
    if (cat == ExpenseModel.category_utility) {
      return Icons.description;
    }
    return Icons.warning;
  }
}

final ExpenseHelper = _ExpenseHelper();
