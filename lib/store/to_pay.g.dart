// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_pay.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ToPay on _ToPay, Store {
  final _$listAtom = Atom(name: '_ToPay.list');

  @override
  ObservableList<ToPayModel> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(ObservableList<ToPayModel> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$_ToPayActionController = ActionController(name: '_ToPay');

  @override
  void emptyList() {
    final _$actionInfo =
        _$_ToPayActionController.startAction(name: '_ToPay.emptyList');
    try {
      return super.emptyList();
    } finally {
      _$_ToPayActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
