import 'dart:collection';
import 'package:rltut/src/action.dart';

class ActionQueue {
  final Queue _actionQueue = Queue();
  List _results = [];

  void addAction(Action action) {
    _actionQueue.add(action);
  } // End of addAction()

  List perform() {
    var turnResults = [];

    while (_actionQueue.isNotEmpty) {
      Action action = _actionQueue.removeFirst();
      _results = action.perform();

      for (var result in _results) {

        var message = result.remove('message');
        if (message != null) {
print(message);
        }

        var playerDead = result.remove('playerDead');
        if (playerDead != null) {
          turnResults.add({'playerDead': true});
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

    return turnResults;
  } // End of perform()

} // End of class ActionQueue
