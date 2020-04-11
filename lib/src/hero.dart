import 'package:malison/malison.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/combat.dart';
import 'package:rltut/src/gamemap.dart';

class Hero extends Actor {

  int _maxHp;
  set maxHp(value) => _maxHp = value;
  int get maxHp => _maxHp;

  Hero(GameMap gameMap, String name, String glyph, Color color) : super(gameMap, name, glyph, color) {
    melee = Attack(1, 5);
    defense = Defense(2);
    gameMap.hero = this;
    hp = maxHp = 30;
  } // End of Hero()

  void KillHero() {
    glyph = '%';
    color = Color.darkRed;
  }

} // End of class Hero


