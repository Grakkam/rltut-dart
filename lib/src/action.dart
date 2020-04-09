import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/monster.dart';

abstract class Action {
  final Actor _actor;
  Actor get actor => _actor;

  final GameMap _gameMap;
  GameMap get gameMap => _gameMap;

  Action(this._actor, this._gameMap);

  void perform();
}

class WalkAction extends Action {
  final Direction _direction;
  Direction get direction => _direction;

  WalkAction(Actor actor, GameMap gameMap, this._direction) : super(actor, gameMap);

  @override
  void perform() {
    var destination = actor.pos + direction;
    if (!gameMap.validDestination(destination)) {
      return;
    }
    var target = gameMap.isOccupied(destination);
    if (target != null) {
      if (actor is Monster && target is Monster) {
        return;
      } else {
        gameMap.actions.addAction(HitAction(actor, gameMap, target));
        return;
      }
    }

    _actor.pos = destination;

  }
}

class IdleAction extends Action {
  IdleAction(Actor actor, GameMap gameMap) : super(actor, gameMap);

  @override
  void perform() {
// print('${actor.name} stares blankly into space.');
  }
}

class HitAction extends Action {
  final Actor target;
  HitAction(Actor actor, GameMap gameMap, this.target) : super(actor, gameMap);

  @override
  void perform() {
    var amount = actor.melee.power - target.defense.toughness;
    if (amount > 0) {
print('${actor.name} hits ${target.name} for $amount points of damage.');
      var dead = target.takeDamage(amount);
      if (dead) {
print('${actor.name} killed ${target.name}!');
      }
    } else {
print('${actor.name} attacks ${target.name} but does not cause any damage.');
    }
  }
}