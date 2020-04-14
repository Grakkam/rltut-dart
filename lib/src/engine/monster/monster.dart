import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/engine/core/actor.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/engine/monster/breed.dart';

class Monster extends Actor {
  Breed breed;
  Monster(Game game, Breed breed, Vec position)
    : super(game, breed.name, breed.icon, breed.color, breed.maxHp,
      breed.melee, breed.defense) {
    pos = position;
  }

  Action takeTurn() {
    var hero = game.hero;
    if (dungeon[pos].isVisible) {
      if (distanceTo(hero.pos) > 1) {
        // return moveTowards(hero.pos);
// print('Monster: $name $pos');
        return moveAstar(hero.pos);
      } else if (hero.hp > 0) {
        return HitAction(this, dungeon, hero);
      }
    }
    return IdleAction(this, dungeon);
  }

} // End of class Monster

