import 'package:malison/malison.dart';
import 'package:rltut/src/engine/core/actor.dart';
import 'package:rltut/src/engine/core/combat.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/engine/core/inventory.dart';


class Hero extends Actor {

  final Inventory _inventory = Inventory(capacity: 26);
  @override
  Inventory get inventory => _inventory;

  Hero(Game game, String name, String icon, Color color, int maxHp,
      Attack melee, Defense defense)
      : super(game, name, icon, color, maxHp, melee, defense);
} // End of class Hero
