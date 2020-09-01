import 'package:hello_flutter/model/ToPayModel.dart';
import 'package:hello_flutter/helper/time-helper.dart';
import 'package:mobx/mobx.dart';

// Include generated file

part 'to_pay.g.dart';

// This is the class used by rest of your codebase
class ToPay = _ToPay with _$ToPay;

// The store-class
abstract class _ToPay with Store {
  @observable
  var list = ObservableList<ToPayModel>();
  int currentMonth = TimeHelper.currentMonth();
  int currentYear = TimeHelper.currentYear();

  @action
  void emptyList() {
    list = ObservableList<ToPayModel>();
  }

  void remove(index) {
    list.removeAt(index);
  }

  void addFirst(t) {
    list.insert(0, t);
  }

  void addLast(t) {
    list.add(t);
  }
}

final ToPayStore = ToPay();
