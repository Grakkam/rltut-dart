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

  Attack _melee;
  Attack get melee => _melee;


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

  // Returns true if actor is dead.
  bool takeDamage(int amount);

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

  int _hp;
  set hp(value) {
    _hp = value;
  }
  int get hp => _hp;

  @override
  bool takeDamage(int amount) {
    return false;
  }

  Hero(GameMap gameMap, String name, Vec pos) : super(gameMap, name, pos) {
    _glyph = '@';
    _color = Color.white;
    _melee = Attack(1, 5);
  }
}


