import 'package:hello_flutter/model/RecurringModel.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'recurring.g.dart';

// 4. @new_entity - store and store.g

// This is the class used by rest of your codebase
class Recurring = _Recurring with _$Recurring;

// The store-class
abstract class _Recurring with Store {
  @observable
  var list = ObservableList<RecurringModel>();

  @action
  void emptyList() {
    list = ObservableList<RecurringModel>();
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

final RecurringStore = Recurring();
