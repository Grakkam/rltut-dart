// import 'dart:html' as html;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/gamemap.dart';

const bool debug = false;

const int width = 100;
const int height = 35;

final ui = UserInterface<String>();
final terminal = RetroTerminal.dos(width, height);

var gameMap = GameMap(width, height);

var fov = Fov(gameMap);

Actor hero = Actor(Vec(0, 0), '@', Color.white);
List actors = <Actor>[hero];

List rooms;

void main() {
  hero.gameMap = gameMap;

  ui.keyPress.bind('up', KeyCode.up);
  ui.keyPress.bind('down', KeyCode.down);
  ui.keyPress.bind('right', KeyCode.right);
  ui.keyPress.bind('left', KeyCode.left);

  rooms = gameMap.makeMap(25, 6, 15);
  hero.pos = gameMap.entrance;
  fov.refresh(hero.pos);

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
      action = actor.action;
      action.perform();
    }

    fov.refresh(hero.pos);

    updateTerminal();
    ui.refresh();


    return true;
  }


  @override
  void render(Terminal terminal) {
    terminal.clear();

    for (var pos in gameMap.tiles.bounds) {
      var tile = gameMap[pos];
      var wall = tile.blocked;
      var color;
      if (tile.isVisible) {
        if (wall) {
          color = gameMap.colors['lightWall'];
        } else {
          color = gameMap.colors['lightGround'];
        }
      } else if (tile.isExplored) {
        if (wall) {
          color = gameMap.colors['darkWall'];
        } else {
          color = gameMap.colors['darkGround'];
        }
      } else if (debug) {
        if (wall) {
          color = gameMap.colors['unexploredWall'];
        } else {
          color = gameMap.colors['unexploredGround'];
        }
      }
      terminal.writeAt(pos.x, pos.y, ' ', color, color);
    }

    for (Actor actor in actors) {
      terminal.writeAt(actor.x, actor.y, actor.glyph, actor.color, gameMap.colors['lightGround']);
    }


  }

}




