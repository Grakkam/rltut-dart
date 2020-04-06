import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/combat.dart';
import 'package:rltut/src/gamemap.dart';

abstract class Actor {
  Vec _pos;
  Action _action;
  GameMap _gameMap;
  String _name;

  int _hp;
  set hp(int value) {
    _hp = value;
  }
  int get hp => _hp;

  Attack _melee;
  set melee(Attack value) {
    _melee = value;
  }
  Attack get melee => _melee;
  
  Defense _defense;
  set defense(Defense value) {
    _defense = value;
  }
  Defense get defense => _defense;

  Actor(this._gameMap, this._name, this._pos);

  set name(String name) => _name = name;
  String get name => _name;

  set gameMap(GameMap gameMap) => _gameMap = gameMap;
  GameMap get gameMap => _gameMap;

  set pos(Vec pos) => _pos = pos;
  Vec get pos => _pos;
  int get x => _pos.x;
  int get y => _pos.y;

  void setNextAction(Action action) {
    _action = action;
  }

  Action get action {
    if (_action != null) {
      _action.bind(this);
    }
    return _action;
  }

  bool get isAlive => _hp > 0;

  // Returns true if actor is dead.
  bool takeDamage(int amount) {
    amount = amount - defense.toughness;
    if (amount > 0) {
      hp -= amount;
    }

    return !isAlive;
  }

  Action moveTowards(Vec target) {
    var d = target - pos;
    var distance = distanceTo(target);
    var dx = (d.x / distance).round();
    var dy = (d.y / distance).round();

    if (!(gameMap[Vec(pos.x + dx, pos.y + dy)].blocked) || gameMap.blockingActorAtLocation(Vec(pos.x + dx, pos.y + dy)) != null) {
      return MoveAction(Direction(dx, dy));
    } else {
      return IdleAction();
    }
  }

  double distanceTo(Vec target) {
    var d = target - pos;
    return math.sqrt(d.x * d.x + d.y * d.y);
  }  

}

class Hero extends Actor {

  Color _color;
  set color(Color color) => _color = color;
  Color get color => _color;

  String _glyph;
  set glyph(String input) {
    var rune = input.runes.elementAt(0);
    _glyph = String.fromCharCode(rune);
  }
  String get glyph => _glyph;

  int _maxHp;
  set maxHp(value) {
    _maxHp = value;
  }
  int get maxHp => _maxHp;

  Hero(GameMap gameMap, String name, Vec pos) : super(gameMap, name, pos) {
    _glyph = '@';
    _color = Color.white;
    _melee = Attack(1, 5);
    _defense = Defense(2);
    gameMap.hero = this;
    hp = maxHp = 20;
  }

}


