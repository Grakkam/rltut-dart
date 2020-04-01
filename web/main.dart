import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/gamemap.dart';

const bool debug = false;

enum GameStates { playerTurn, enemyTurn }
var gameState;

const int width = 100;
const int height = 35;

final ui = UserInterface<String>();
final terminal = RetroTerminal.dos(width, height);

var gameMap = GameMap(width, height);
var fov = Fov(gameMap);

Hero hero = Hero('Swoosh');
List actors = <Actor>[hero];


void main() {

  ui.keyPress.bind('up', KeyCode.up);
  ui.keyPress.bind('down', KeyCode.down);
  ui.keyPress.bind('right', KeyCode.right);
  ui.keyPress.bind('left', KeyCode.left);

  hero.gameMap = gameMap;
  gameMap.maxMonstersPerRoom = 3;
  gameMap.makeMap(25, 6, 15);
  hero.pos = gameMap.entrance;
  actors.addAll(gameMap.monsters);

  fov.refresh(hero.pos);
  gameState = GameStates.playerTurn;

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

    if (gameState == GameStates.playerTurn) {

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
        gameState = GameStates.enemyTurn;
      }
    }

    if (gameState == GameStates.enemyTurn) {
      for (var monster in gameMap.monsters) {
        monster.setNextAction(IdleAction());
      }
      gameState = GameStates.playerTurn;
    }


    for (var actor in actors) {
      if (actor.action != null) {
        actor.action.perform();
      }
      actor.setNextAction(null);
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

    for (var actor in actors) {
      if (gameMap.tiles[actor.pos].isVisible) {
        terminal.writeAt(actor.x, actor.y, actor.glyph, actor.color, gameMap.colors['lightGround']);
      }
    }

  }

}




