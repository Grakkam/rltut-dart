import 'dart:collection';

import 'package:rltut/src/action.dart';

class ActionQueue {
  final Queue _actionQueue = Queue();

  void addAction(Action action) {
    _actionQueue.add(action);
  }

  void perform() {
    while (_actionQueue.isNotEmpty) {
      Action action = _actionQueue.removeFirst();
      action.perform();
    }
  }

}
