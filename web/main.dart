// import 'dart:html' as html;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';

const int width = 30;
const int height = 10;

final ui = UserInterface<String>();
final terminal = RetroTerminal.dos(width, height);

final heroX = width ~/ 2;
final heroY = height ~/ 2;

Actor hero = Actor(Vec(heroX, heroY), '@', Color.white);
List actors = <Actor>[hero];
var gameMap = GameMap(width, height);

void main() {
  hero.gameMap = gameMap;

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

  Action action;

  @override
  bool handleInput(String input) {
    switch (input) {
      case 'up':
        action = MoveAction(Direction.n);
        break;

      case 'down':
        action = MoveAction(Direction.s);
        break;

      case 'right':
        action = MoveAction(Direction.e);
        break;

      case 'left':
        action = MoveAction(Direction.w);
        break;
      
      default:
        return false;
    }

    if (action != null) {
      hero.setNextAction(action);
    }


    for (Actor actor in actors) {
      action = hero.action;
      action.perform();
    }

    updateTerminal();
    ui.refresh();


    return true;
  }


  @override
  void render(Terminal terminal) {
    terminal.clear();

    for (var x=0; x<width; x++) {
      for (var y=0; y<height; y++) {
        var tile = gameMap.tiles[Vec(x, y)];
        var wall = tile.blocked;
        if (wall) {
          terminal.writeAt(x, y, ' ', Color.black, gameMap.colors['darkWall']);
        }
        else {
          terminal.writeAt(x, y, ' ', Color.black, gameMap.colors['darkGround']);
        }
      }
    }

    // terminal.writeAt(10, 10, gameMap.toString(), Color.white);
    // var data = '${gameMap.tiles.width} x ${gameMap.tiles.height}';
    // terminal.writeAt(10, 12, data, Color.white);
    // var tile = gameMap.tiles[Vec(1, 1)];
    // terminal.writeAt(10, 15, tile.blocked.toString());

    for (Actor actor in actors) {
      terminal.writeAt(actor.x, actor.y, actor.glyph, actor.color);
    }


  }

}




