import 'package:flutter/material.dart';

class _ExpenseHelper {
  final category_rent = "rent";
  final category_loan = "loan";
  final category_utility = "utility";
  final category_insurance = "insurance";
  final category_baby_necessity = "baby_necessity";
  final category_transportation = "transportation";
  final category_saving = "saving";
  final category_gift = "gift";
  final category_food = "food";

  getAllCategory() {
    return <String>[
      category_rent,
      category_loan,
      category_utility,
      category_insurance,
      category_transportation,
      category_saving,
      category_gift,
      category_food,
      category_baby_necessity,
    ];
  }

  Color iconColorCategory(String cat) {
    if (cat == this.category_rent) {
      return Colors.blue;
    }
    if (cat == this.category_loan) {
      return Colors.red[600];
    }
    if (cat == this.category_utility) {
      return Colors.brown[800];
    }
    if (cat == this.category_insurance) {
      return Colors.cyan[900];
    }
    if (cat == this.category_baby_necessity) {
      return Colors.pinkAccent;
    }
    if (cat == this.category_transportation) {
      return Colors.blueGrey[700];
    }
    if (cat == this.category_saving) {
      return Colors.green;
    }
    if (cat == this.category_gift) {
      return Colors.pink[900];
    }
    if (cat == this.category_food) {
      return Colors.amber[800];
    }

    return Colors.grey;
  }

  IconData iconCategory(String cat) {
    if (cat == this.category_rent) {
      return Icons.home;
    }
    if (cat == this.category_loan) {
      return Icons.monetization_on;
    }
    if (cat == this.category_utility) {
      return Icons.receipt;
    }
    if (cat == this.category_insurance) {
      return Icons.local_hospital;
    }
    if (cat == this.category_baby_necessity) {
      return Icons.child_care;
    }
    if (cat == this.category_transportation) {
      return Icons.directions_car;
    }
    if (cat == this.category_saving) {
      return Icons.attach_money;
    }
    if (cat == this.category_gift) {
      return Icons.card_giftcard;
    }
    if (cat == this.category_food) {
      return Icons.fastfood;
    }
    return Icons.warning;
  }
}

final ExpenseHelper = _ExpenseHelper();
