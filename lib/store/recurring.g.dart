// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Recurring on _Recurring, Store {
  final _$listAtom = Atom(name: '_Recurring.list');

  @override
  ObservableList<RecurringModel> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(ObservableList<RecurringModel> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$_RecurringActionController = ActionController(name: '_Recurring');

  @override
  void emptyList() {
    final _$actionInfo =
        _$_RecurringActionController.startAction(name: '_Recurring.emptyList');
    try {
      return super.emptyList();
    } finally {
      _$_RecurringActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
