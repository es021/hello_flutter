import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  final category_vacation = "vacation";
  final category_entertainment = "entertainment";

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
      category_vacation,
      category_entertainment,
    ];
  }

  iconColorCategory(String cat, {bool forChart = false}) {
    if (cat == this.category_entertainment) {
      if (forChart) {
        return charts.MaterialPalette.teal.shadeDefault;
      }
      return Colors.teal[600];
    }

    if (cat == this.category_vacation) {
      if (forChart) {
        return charts.MaterialPalette.blue.shadeDefault;
      }
      return Colors.indigoAccent;
    }

    if (cat == this.category_rent) {
      if (forChart) {
        return charts.MaterialPalette.blue.shadeDefault;
      }
      return Colors.blue;
    }

    if (cat == this.category_loan) {
      if (forChart) {
        return charts.MaterialPalette.red.shadeDefault;
      }
      return Colors.red[600];
    }

    if (cat == this.category_utility) {
      if (forChart) {
        return charts.MaterialPalette.gray.shadeDefault;
      }
      return Colors.brown[800];
    }

    if (cat == this.category_insurance) {
      if (forChart) {
        return charts.MaterialPalette.cyan.shadeDefault;
      }
      return Colors.cyan[900];
    }

    if (cat == this.category_baby_necessity) {
      if (forChart) {
        return charts.MaterialPalette.pink.shadeDefault;
      }
      return Colors.pinkAccent;
    }

    if (cat == this.category_transportation) {
      if (forChart) {
        return charts.MaterialPalette.lime.shadeDefault;
      }
      return Colors.blueGrey[700];
    }

    if (cat == this.category_saving) {
      if (forChart) {
        return charts.MaterialPalette.green.shadeDefault;
      }
      return Colors.green;
    }

    if (cat == this.category_gift) {
      if (forChart) {
        return charts.MaterialPalette.indigo.shadeDefault;
      }
      return Colors.pink[900];
    }

    if (cat == this.category_food) {
      if (forChart) {
        return charts.MaterialPalette.deepOrange.shadeDefault;
      }
      return Colors.amber[800];
    }

    if (forChart) {
      return charts.MaterialPalette.gray.shadeDefault;
    }
    return Colors.grey;
  }

  IconData iconCategory(String cat) {
    if (cat == this.category_entertainment) {
      return Icons.gamepad;
    }
    if (cat == this.category_vacation) {
      return Icons.hotel;
    }
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
