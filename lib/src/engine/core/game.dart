import 'dart:collection';
import 'package:malison/malison.dart';
import 'package:rltut/src/dungeon/dungeon.dart';
import 'package:rltut/src/engine/core/actor.dart';
import 'package:rltut/src/engine/hero/hero.dart';
import 'package:rltut/src/engine/item/item.dart';
import 'package:rltut/src/engine/monster/breed.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/ui/message-log.dart';


/// Root class for the game engine. All game state is contained within this.
class Game {
  bool debug = false;
  Hero hero;
  Dungeon dungeon;

  final Map _breeds = Breeds.getBreeds();
  Map get breeds => _breeds;

  List actors = <Actor>[];
  List items = <Item>[];

  final _actions = Queue<Action>();
  List _results = [];

  void addAction(Action action) {
    _actions.add(action);
  } // End of addAction()

  MessageLog messageLog;

  List update() {
    var turnResults = [];

    while (_actions.isNotEmpty) {
      var action = _actions.removeFirst();
      if (action.actor.isAlive) _results = action.perform();

      for (var result in _results) {
        var message = result.remove('message');
        if (message != null) {
          messageLog.addMessage(message);
        }

        var playerDead = result.remove('playerDead');
        if (playerDead != null) {
          turnResults.add({'playerDead': true});
          messageLog.addMessage(Message('You died!', Color.red));
        }

        var alternativeAction = result.remove('alternative');
        if (alternativeAction != null) {
          var target = alternativeAction.remove('attack');
          if (target != null) {
            addAction(HitAction(action.actor, dungeon, target));
          }
        }
        
      } // End for
    } // End while

    return turnResults;
  } // End of update()

} // End of class Game


