import 'package:hello_flutter/model/TaskModel.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'task.g.dart';

// This is the class used by rest of your codebase
class Task = _Task with _$Task;

// The store-class
abstract class _Task with Store {
  @observable
  var list = ObservableList<TaskModel>();

  @action
  void emptyList() {
    list = ObservableList<TaskModel>();
  }

  void addFirst(t) {
    list.insert(0, t);
  }

  void addLast(t) {
    list.add(t);
  }
}

final StoreTask = Task();
