import 'package:flutter/material.dart';
import 'package:hello_flutter/model/ExpenseModel.dart';

class _ExpenseHelper {
  Color iconColorCategory(String cat) {
    if (cat == ExpenseModel.category_rent) {
      return Colors.blue[300];
    }
    if (cat == ExpenseModel.category_loan) {
      return Colors.green;
    }
    if (cat == ExpenseModel.category_utility) {
      return Colors.orange[300];
    }
    if (cat == ExpenseModel.category_insurance) {
      return Colors.red[600];
    }
    if (cat == ExpenseModel.category_baby_necessity) {
      return Colors.pinkAccent;
    }
    if (cat == ExpenseModel.category_transportation) {
      return Colors.amber;
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
      return Icons.receipt;
    }
    if (cat == ExpenseModel.category_insurance) {
      return Icons.local_hospital;
    }
    if (cat == ExpenseModel.category_baby_necessity) {
      return Icons.child_care;
    }
    if (cat == ExpenseModel.category_transportation) {
      return Icons.directions_car;
    }
    return Icons.warning;
  }
}

final ExpenseHelper = _ExpenseHelper();
