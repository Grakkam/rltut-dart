import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/ui/game_screen.dart';
import 'package:rltut/src/ui/input.dart';

class InventoryScreen extends Screen<Input> {
  final GameScreen _gameScreen;
  final String _title;

  InventoryScreen(this._gameScreen, this._title);

  Game get game => _gameScreen.game;
  GameScreen get gameScreen => _gameScreen;

  @override
  void render(Terminal terminal) {
    terminal.clear();

    var x = 10;

    terminal.writeAt(x, 2, _title);

    var letters = 'abcdefghijklmnopqrstuvwxyz';
    var i = 0;
    var letter = 0;

    for (var item in _gameScreen.game.hero.inventory.contents) {
      var y = i + 4;
      terminal.writeAt(x, y, '${letters[letter]})');
      terminal.writeAt(x + 3, y, item.name, item.color);
      i++;
      letter++;
    }


  } // End of render()

} // End of class InventoryScreen