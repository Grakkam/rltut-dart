import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/dungeon/dungeon.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/engine/core/astar.dart';
import 'package:rltut/src/engine/core/combat.dart';
import 'game.dart';

abstract class Actor {
  final Game game;
  String name;
  String icon;
  Color color;
  Attack melee;
  Defense defense;

  Actor(this.game, this.name, this.icon, this.color, this._maxHp, this.melee, this.defense) {
    hp = maxHp;
  }

  bool isBlocking = true;

  Vec _pos;
  Vec get pos => _pos;
  set pos(Vec value) {
    if (value != _pos) {
      _pos = value;
    }
  }

  int get x => pos.x;
  set x(int value) {
    pos = Vec(value, y);
  }

  int get y => pos.y;
  set y(int value) {
    pos = Vec(x, value);
  }

  int _maxHp;
  int get maxHp => _maxHp;
  set maxHp(int value) {
    _maxHp = value;
  }

  int _hp;
  int get hp => _hp;
  set hp(int value) {
    _hp = value.clamp(0, maxHp);
  }

  /// Returns true if actor is dead.
  bool takeDamage(int amount) {
    hp -= amount;
    return !isAlive;
  } // End of takeDamage()

  /// Temporary? Probably spawn a corpse item instead...
  void die() {
    icon = '%';
    color = Color.darkRed;
    isBlocking = false;
    name = 'remains of ' + name;
  }

  bool get isAlive => hp > 0;

  bool get isVisibleToHero => game.dungeon[pos].isVisible;

  Dungeon get dungeon => game.dungeon;

  Action moveTowards(Vec target) {
    var d = target - pos;
    var distance = distanceTo(target);
    var dx = (d.x / distance).round();
    var dy = (d.y / distance).round();

    if (!(dungeon[Vec(pos.x + dx, pos.y + dy)].blocked)
        || dungeon.isOccupied(Vec(pos.x + dx, pos.y + dy)) != null) {
      return WalkAction(this, dungeon,Direction(dx, dy));
    } else {
      return IdleAction(this, dungeon);
    }
  } // End of moveTowards()

  double distanceTo(Vec target) {
    var d = target - pos;
    return math.sqrt(d.x * d.x + d.y * d.y);
  } // End of distanceTo()

  Action moveAstar(Vec target) {
    var path = Astar.findPath(dungeon, pos, target);
    return moveTowards(path[1]);
  } // End of moveAstar()


} // End of class Actor