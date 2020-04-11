import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/combat.dart';
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
      : super('Orc', 10, 'o', Color.green, Attack(1, 3), Defense(0));
}

class Troll extends Breed {
  Troll()
      : super('Troll', 16, 'T', Color.darkGreen, Attack(1, 4), Defense(1));
}

class Monster extends Actor {
  Breed _breed;
  Breed get breed => _breed;
  set breed(Breed value) {
    _breed = value;
  }

  Monster(this._breed, GameMap gameMap, Vec position)
      : super(gameMap, _breed.name, _breed.glyph, _breed.color) {
        pos = position;
        hp = _breed.maxHp;
        melee = _breed.melee;
        defense = _breed.defense;
  }

  Action takeTurn() {
    var hero = gameMap.hero;
    if (gameMap[pos].isVisible) {
      if (distanceTo(hero.pos) > 1) {
        // return moveTowards(hero.pos);
// print('Monster: $name $pos');
        return moveAstar(hero.pos);
      } else if (hero.hp > 0) {
        return HitAction(this, gameMap, hero);
      }
    }
    return IdleAction(this, gameMap);
  }
}

