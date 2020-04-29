import 'package:malison/malison.dart';
import 'package:rltut/src/ui/game_screen.dart';
import 'package:rltut/src/ui/input.dart';
import 'package:rltut/src/ui/inventory_screen.dart';

class UseItemScreen extends InventoryScreen {

  UseItemScreen(GameScreen gameScreen) : super(gameScreen, 'Use item');

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
      game.addAction(game.hero.inventory.contents[index].use(game.hero));
      if (game.hero.inventory.contents[index].isConsumable) {
        game.hero.inventory.contents.removeAt(index);
      }
      ui.pop();
      return true;
    }
    return false;
  }

} // End of class UseItemScreen