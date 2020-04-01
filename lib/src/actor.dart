import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/gamemap.dart';

abstract class Actor {
  Vec _pos;
  String _glyph;
  Color _color;
  Action _action;
  GameMap _gameMap;
  String _name;

  Actor (String name, String glyph, Color color) {
    _pos = pos;
    _glyph = glyph;
    _color = color;
    _name = name;
  }

  set name(String name) => _name = name;
  String get name => _name;

  set gameMap(GameMap gameMap) => _gameMap = gameMap;
  GameMap get gameMap => _gameMap;

  set pos(Vec pos) => _pos = pos;
  Vec get pos => _pos;
  int get x => _pos.x;
  int get y => _pos.y;

  set color(Color color) => _color = color;
  Color get color => _color;

  set glyph(String input) {
    var rune = input.runes.elementAt(0);
    _glyph = String.fromCharCode(rune);
  }
  String get glyph => _glyph;

  void setNextAction(Action action) {
    _action = action;
  }

  Action get action {
    if (_action != null) {
      _action.bind(this);
    }
    return _action;
  }

}

class Hero extends Actor {
  
  Hero(String name) : super(name, '@', Color.white) {

  }
}


class Orc extends Actor {
  
  Orc(Vec pos) : super('Orc', 'o', Color.green) {
    _pos = pos;
  }
}


class Troll extends Actor {
  
  Troll(Vec pos) : super('Troll', 'T', Color.darkGreen) {
    _pos = pos;
  }
}