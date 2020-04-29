import 'package:meta/meta.dart';
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

  List results = [];

  List perform();
} // End of class Action


class WalkAction extends Action {
  final Direction _direction;
  Direction get direction => _direction;

  WalkAction(Actor actor, Dungeon dungeon, this._direction) : super(actor, dungeon);

  @override
  List perform() {
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

class DropAction extends Action {
  int itemIndex;
  DropAction(Actor actor, Dungeon dungeon, {@required this.itemIndex}) : super(actor, dungeon);

  @override
  List perform() {
    if (actor.inventory.contents.isEmpty) {
      results.add({'message':
          Message(
            'You\'re not carrying anything!'
          )});
    } else {
      for (var item in dungeon.items) {
        if (actor.pos == item.pos) {
          results.add({'message':
              Message(
                'You can\'t drop that here.'
              )});
          return results;
        }      
      }

      var item = actor.inventory.remove(itemIndex);
      item.pos = actor.pos;
      dungeon.items.add(item);
      results.add({'message':
          Message(
            'You drop the ${item.name}!',
            item.color
          )});
    }
    return results;
  }
}

class PickupAction extends Action {
  PickupAction(Actor actor, Dungeon dungeon) : super(actor, dungeon);

  @override
  List perform() {
    for (var i = 0; i < dungeon.items.length; i++) {
      if (dungeon.items[i].pos == actor.pos) {
        if (actor.inventory.add(dungeon.items[i])) {
          results.add({'message':
              Message(
                'You pick up the ${dungeon.items[i].name}!',
                dungeon.items[i].color
              )});
          dungeon.items.removeAt(i);
        } else {
          results.add({'message':
              Message(
                'You can\'t carry any more.'
              )});
        }
        
        return results;
      }
    }

    results.add({'message':
        Message(
          'There is nothing here to pick up...'
        )});

    return results;
  }
}

class HitAction extends Action {
  final Actor target;
  HitAction(Actor actor, Dungeon dungeon, this.target) : super(actor, dungeon);

  @override
  List perform() {

    if (!actor.isAlive) {
      return results;
    }
    var amount = actor.melee.power - target.defense.toughness;
    if (amount > 0) {
      results.add({'message':
          Message(
            '${actor.name} hits ${target.name} for $amount points of damage.'
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
            '${actor.name} attacks ${target.name} but does not cause any damage.'
          )});
    }
    return results;
  }
} // End of class HitAction


class HealAction extends Action {
  int amount;

  HealAction(Actor actor, Dungeon dungeon, this.amount) : super(actor, dungeon);

  @override
  List perform() {
    if (actor.hp == actor.maxHp) {
      results.add({'message':
          Message(
            'You are already at full health.'
          )});
    } else {
      results.add({'message':
          Message(
            'Your wounds start to heal and you feel better!'
          )});
      actor.heal(amount);
    }
    return results;
  }
} // End of class HealAction
