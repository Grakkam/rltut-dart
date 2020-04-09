import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/combat.dart';
import 'package:rltut/src/gamemap.dart';

abstract class Actor {

  GameMap _gameMap;
  set gameMap(GameMap gameMap) => _gameMap = gameMap;
  GameMap get gameMap => _gameMap;

  String _name;
  set name(String name) => _name = name;
  String get name => _name;

  String _glyph;
  set glyph(String input) {
    var rune = input.runes.elementAt(0);
    _glyph = String.fromCharCode(rune);
  }
  String get glyph => _glyph;

  Color _color;
  set color(Color color) => _color = color;
  Color get color => _color;

  Actor(this._gameMap, this._name, this._glyph, this._color);

  Vec _pos;
  set pos(Vec value) => _pos = value;
  Vec get pos => _pos;

  int _hp;
  set hp(int value) => _hp = value;
  int get hp => _hp;

  Attack _melee;
  set melee(Attack value) => _melee = value;
  Attack get melee => _melee;
  
  Defense _defense;
  set defense(Defense value) => _defense = value;
  Defense get defense => _defense;

  bool get isAlive => _hp > 0;

  /// Returns true if actor is dead.
  bool takeDamage(int amount) {
    hp -= amount;
    return !isAlive;
  }

  Action moveTowards(Vec target) {
    var d = target - pos;
    var distance = distanceTo(target);
    var dx = (d.x / distance).round();
    var dy = (d.y / distance).round();

    if (!(gameMap[Vec(pos.x + dx, pos.y + dy)].blocked) || gameMap.isOccupied(Vec(pos.x + dx, pos.y + dy)) != null) {
      return WalkAction(this, gameMap,Direction(dx, dy));
    } else {
      return IdleAction(this, gameMap);
    }
  }

  double distanceTo(Vec target) {
    var d = target - pos;
    return math.sqrt(d.x * d.x + d.y * d.y);
  }  

}

class Hero extends Actor {

  int _maxHp;
  set maxHp(value) => _maxHp = value;
  int get maxHp => _maxHp;

  Hero(GameMap gameMap, String name, String glyph, Color color) : super(gameMap, name, glyph, color) {
    _melee = Attack(1, 5);
    _defense = Defense(2);
    gameMap.hero = this;
    hp = maxHp = 30;
  }

}


