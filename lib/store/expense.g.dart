// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Expense on _Expense, Store {
  final _$listAtom = Atom(name: '_Expense.list');

  @override
  ObservableList<ExpenseModel> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(ObservableList<ExpenseModel> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$_ExpenseActionController = ActionController(name: '_Expense');

  @override
  void emptyList() {
    final _$actionInfo =
        _$_ExpenseActionController.startAction(name: '_Expense.emptyList');
    try {
      return super.emptyList();
    } finally {
      _$_ExpenseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
