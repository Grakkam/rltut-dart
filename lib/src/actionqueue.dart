import 'dart:collection';

import 'package:rltut/src/action.dart';

class ActionQueue {
  final Queue _actionQueue = Queue();
  List _results = [];

  void addAction(Action action) {
    _actionQueue.add(action);
  } // End of addAction()

  void perform() {
    while (_actionQueue.isNotEmpty) {
      Action action = _actionQueue.removeFirst();
      _results = action.perform();

      for (var result in _results) {
        var message = result.remove('message');
        if (message != null) {
print(message);
        }

        var alternativeAction = result.remove('alternative');
        if (alternativeAction != null) {
          var target = alternativeAction.remove('attack');
          if (target != null) {
            addAction(HitAction(action.actor, action.gameMap, target));
          }
        }
        
      } // End for

    } // End while
  } // End of perform()

} // End of class ActionQueue
