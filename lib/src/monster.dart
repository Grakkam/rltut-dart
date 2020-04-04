import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';

class Breed {
  final String name;
  final int maxHp;
  final String glyph;
  final Color color;

  Breed(this.name, this.maxHp, this.glyph, this.color);
}

class Orc extends Breed {
  Orc()
      : super('Orc', 10, 'o', Color.green);
}

class Troll extends Breed {
  Troll()
      : super('Troll', 20, 'T', Color.darkGreen) {
        
      }
}

class Monster extends Actor {
  Breed _breed;
  Breed get breed => _breed;
  set breed(Breed value) {
    _breed = value;
  }

  Color get color => _breed.color;
  String get glyph => _breed.glyph;

  bool get isAlive => _hp > 0;

  int _hp;

  @override
  bool takeDamage(int amount) {
    _hp -= amount;

    return !isAlive;
  }


  Monster(this._breed, GameMap gameMap, Vec pos)
      : super(gameMap, _breed.name, pos) {
        _hp = _breed.maxHp;

      }
}

