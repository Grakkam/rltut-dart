import 'package:malison/malison.dart';
import 'package:rltut/src/engine/core/combat.dart';

/// A breed of monster that shares properties

class Breed {
  final String name;
  final int maxHp;
  final String icon;
  final Color color;
  final Attack melee;
  final Defense defense;

  Breed(this.name, this.maxHp, this.icon, this.color, this.melee, this.defense);
} // End of class Breed

class Breeds {
  static Map getBreeds() {
    var breeds = {
      'orc' : Orc(),
      'troll' : Troll(),
    };

    return breeds;
  }
} // End of class Breeds

class Orc extends Breed {
  Orc()
      : super('Orc', 10, 'o', Color.green, Attack(3), Defense(0));
} // End of class Orc

class Troll extends Breed {
  Troll()
      : super('Troll', 16, 'T', Color.darkGreen, Attack(4), Defense(1));
} // End of class Troll