// import 'dart:html' as html;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';

const int width = 80;
const int height = 35;

final ui = UserInterface<String>();
final terminal = RetroTerminal.dos(width, height);

final heroX = width ~/ 2;
final heroY = height ~/ 2;

Actor hero = Actor(heroX, heroY, '@', Color.white);

void main() {

  ui.keyPress.bind('up', KeyCode.up);
  ui.keyPress.bind('down', KeyCode.down);
  ui.keyPress.bind('right', KeyCode.right);
  ui.keyPress.bind('left', KeyCode.left);

  updateTerminal();

  ui.push(MainScreen());

  ui.handlingInput = true;
  ui.running = true;

}

void updateTerminal() {
  ui.setTerminal(terminal);
}

class MainScreen extends Screen<String> {

  var action;
  var actions = [];

  var direction;
  var color = Color.gold;

  @override
  bool handleInput(String input) {
    switch (input) {
      case 'up':
        action = MoveAction(0, -1);
        break;

      case 'down':
        action = MoveAction(0, 1);
        break;

      case 'right':
        action = MoveAction(1, 0);
        break;

      case 'left':
        action = MoveAction(-1, 0);
        break;
      
      default:
        return false;
    }

    action.bind(hero);
    actions.add(action);

    if (actions.isNotEmpty) {
      for (var action in actions) {
        action.perform();
      }
      actions = [];
    }

    updateTerminal();
    ui.refresh();

    return true;
  }


  @override
  void render(Terminal terminal) {
    terminal.clear();

    // terminal.writeAt(0, 0, '╔', color);
    // terminal.writeAt(0, height-1, '╚', color);
    // terminal.writeAt(width-1, height-1, '╝', color);
    // terminal.writeAt(width-1, 0, '╗', color);
    // for (var x = 1; x < width-1; x++) {
    //   terminal.writeAt(x, 0, '═', color);
    //   terminal.writeAt(x, height-1, '═', color);
    // }
    // for (var y = 1; y < height-1; y++) {
    //   terminal.writeAt(0, y, '║', color);
    //   terminal.writeAt(width-1, y, '║', color);
    // }


    terminal.writeAt(hero.xpos, hero.ypos, hero.glyph);

  }

}




