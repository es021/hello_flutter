import 'package:hello_flutter/model/ExpenseModel.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'expense.g.dart';

// This is the class used by rest of your codebase
class Expense = _Expense with _$Expense;

// The store-class
abstract class _Expense with Store {
  @observable
  var list = ObservableList<ExpenseModel>();

  @action
  void emptyList() {
    list = ObservableList<ExpenseModel>();
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

final ExpenseStore = Expense();
