import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/hero.dart';
import 'package:rltut/src/monster.dart';

abstract class Action {
  final Actor _actor;
  Actor get actor => _actor;

  final GameMap _gameMap;
  GameMap get gameMap => _gameMap;

  Action(this._actor, this._gameMap);

  List perform();
}

class WalkAction extends Action {
  final Direction _direction;
  Direction get direction => _direction;

  WalkAction(Actor actor, GameMap gameMap, this._direction) : super(actor, gameMap);

  @override
  List perform() {
    var results = [];
    var destination = actor.pos + direction;
    if (!gameMap.validDestination(destination)) {
      return results;
    }
    var target = gameMap.isOccupied(destination);
    if (target != null) {
      if (actor is Monster && target is Monster) {
        return results;
      } else {
        results.add({'alternative': {'attack': target}});
        return results;
      }
    }

    _actor.pos = destination;

    return results;

  }
} // End of class WalkAction

class IdleAction extends Action {
  IdleAction(Actor actor, GameMap gameMap) : super(actor, gameMap);

  @override
  List perform() {
    return [];
// print('${actor.name} stares blankly into space.');
  }
} // End of class IdleAction

class HitAction extends Action {
  final Actor target;
  HitAction(Actor actor, GameMap gameMap, this.target) : super(actor, gameMap);

  @override
  List perform() {
    var results = [];

    if (!actor.isAlive) {
      return results;
    }
    var amount = actor.melee.power - target.defense.toughness;
    if (amount > 0) {
      results.add({'message': '${actor.name} hits ${target.name} for $amount points of damage.'});
// print('${actor.name} hits ${target.name} for $amount points of damage.');
      var dead = target.takeDamage(amount);
      if (dead) {
        results.add({'message': '${actor.name} killed ${target.name}!'});
        target.die();
        if (target is Hero) {
          results.add({'playerDead': true});
        }
// print('${actor.name} killed ${target.name}!');
      }
    } else {
      results.add({'message': '${actor.name} attacks ${target.name} but does not cause any damage.'});
// print('${actor.name} attacks ${target.name} but does not cause any damage.');
    }
    return results;
  }
} // End of class HitAction