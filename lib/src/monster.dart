import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/combat.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/gamemap.dart';

class Breed {
  final String name;
  final int maxHp;
  final String glyph;
  final Color color;
  final Attack melee;
  final Defense defense;

  Breed(this.name, this.maxHp, this.glyph, this.color, this.melee, this.defense);
}

class Orc extends Breed {
  Orc()
      : super('Orc', 10, 'o', Color.green, Attack(1, 3), Defense(2));
}

class Troll extends Breed {
  Troll()
      : super('Troll', 20, 'T', Color.darkGreen, Attack(1, 5), Defense(4)) {
        
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

  Monster(this._breed, GameMap gameMap, Vec pos)
      : super(gameMap, _breed.name, pos) {
        hp = _breed.maxHp;
        melee = breed.melee;
        defense = breed.defense;
  }

  Action takeTurn() {
    var hero = gameMap.hero;
    if (gameMap[pos].isVisible) {
      if (distanceTo(hero.pos) > 1) {
        return moveTowards(hero.pos);
      } else if (hero.hp > 0) {
        return HitAction(hero, hero.pos);
      }
    }
    return IdleAction();
  }
}

