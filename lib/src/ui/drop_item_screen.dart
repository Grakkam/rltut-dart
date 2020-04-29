import 'package:malison/malison.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/ui/game_screen.dart';
import 'package:rltut/src/ui/input.dart';
import 'package:rltut/src/ui/inventory_screen.dart';

class DropItemScreen extends InventoryScreen {

  DropItemScreen(GameScreen gameScreen) : super(gameScreen, 'Drop item');

  @override
  bool handleInput(Input input) {
    switch (input) {
      case Input.cancel:
        ui.pop();
        return true;
      
      default:
        return false;
    }

  } // End of handleInput()

  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode >= KeyCode.a && keyCode <= KeyCode.z) {
      var index = (keyCode - KeyCode.a).toInt();
      if (index >= game.hero.inventory.contents.length) return false;
      game.addAction(DropAction(game.hero, game.dungeon, itemIndex: index));
      ui.pop();
      return true;
    }
    return false;
  }

} // End of class DropItemScreen