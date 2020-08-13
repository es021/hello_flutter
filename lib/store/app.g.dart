// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$App on _App, Store {
  final _$viewIndexAtom = Atom(name: '_App.viewIndex');

  @override
  int get viewIndex {
    _$viewIndexAtom.reportRead();
    return super.viewIndex;
  }

  @override
  set viewIndex(int value) {
    _$viewIndexAtom.reportWrite(value, super.viewIndex, () {
      super.viewIndex = value;
    });
  }

  final _$_AppActionController = ActionController(name: '_App');

  @override
  void setViewIndex(dynamic index) {
    final _$actionInfo =
        _$_AppActionController.startAction(name: '_App.setViewIndex');
    try {
      return super.setViewIndex(index);
    } finally {
      _$_AppActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
viewIndex: ${viewIndex}
    ''';
  }
}
