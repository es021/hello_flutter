import 'package:mobx/mobx.dart';

// Include generated file
part 'app.g.dart';

// This is the class used by rest of your codebase
class App = _App with _$App;

// The store-class
abstract class _App with Store {
  @observable
  int viewIndex = 0;

  @action
  void setViewIndex(index) {
    viewIndex = index;
  }
  
}


final AppStore = App();
