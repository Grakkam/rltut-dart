import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/dungeon/dungeon.dart';
import 'package:rltut/src/engine/core/actor.dart';
import 'package:rltut/src/engine/hero/hero.dart';
import 'package:rltut/src/engine/monster/monster.dart';
import 'package:rltut/src/ui/message-log.dart';


abstract class Action {
  final Actor _actor;
  Actor get actor => _actor;

  final Dungeon _dungeon;
  Dungeon get dungeon => _dungeon;

  Action(this._actor, this._dungeon);

  List perform();
} // End of class Action


class WalkAction extends Action {
  final Direction _direction;
  Direction get direction => _direction;

  WalkAction(Actor actor, Dungeon dungeon, this._direction) : super(actor, dungeon);

  @override
  List perform() {
    var results = [];
    var destination = actor.pos + direction;
    if (!dungeon.validDestination(destination)) {
      return results;
    }
    var target = dungeon.isOccupied(destination);
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
  IdleAction(Actor actor, Dungeon dungeon) : super(actor, dungeon);

  @override
  List perform() {
    return [];
// print('${actor.name} stares blankly into space.');
  }
} // End of class IdleAction


class HitAction extends Action {
  final Actor target;
  HitAction(Actor actor, Dungeon dungeon, this.target) : super(actor, dungeon);

  @override
  List perform() {
    var results = [];

    if (!actor.isAlive) {
      return results;
    }
    var amount = actor.melee.power - target.defense.toughness;
    if (amount > 0) {
      results.add({'message':
          Message(
            '${actor.name} hits ${target.name} for $amount points of damage.',
            Color.white
          )});
      var dead = target.takeDamage(amount);
      if (dead) {
        if (target is Monster) {
          results.add({'message':
              Message(
                '${actor.name} killed ${target.name}!',
                Color.orange
              )});
        }
        if (target is Hero) {
          results.add({'playerDead': true});
        }
        target.die();
      }
    } else {
      results.add({'message':
          Message(
            '${actor.name} attacks ${target.name} but does not cause any damage.',
            Color.white
          )});
    }
    return results;
  }
} // End of class HitAction