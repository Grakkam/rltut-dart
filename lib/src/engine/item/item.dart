import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/engine/core/actor.dart';

abstract class Item {
  String name;
  String icon;
  Color color;
  Vec pos;
  final bool isConsumable = true;

  Item(this.name, this.icon, this.color, this.pos);

  Action use(Actor actor);
} // End of class Item


class HealingPotion extends Item {
  int healAmount;
  HealingPotion(String name, String icon, Color color, Vec pos, this.healAmount)
    : super(name, icon, color, pos);

  @override
  Action use(Actor actor) {
    return HealAction(actor, actor.dungeon, healAmount);
  }

} // End of class HealingPotion


