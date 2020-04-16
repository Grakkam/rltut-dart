import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/engine/core/game-states.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/engine/monster/monster.dart';
import 'package:rltut/src/ui/bar.dart';
import 'package:rltut/src/ui/input.dart';
import 'package:rltut/src/ui/message-log.dart';

class GameScreen extends Screen<Input> {
  final int width;
  final int height;
  final Game game;
  Bar hpBar;

  GameScreen(this.game, this.width, this.height) {
    var barX = 1;
    var barY = game.dungeon.bounds.height;
    var barWidth = 20;
    hpBar = Bar(Vec(barX, barY), barWidth, 'HP', Color.red, Color.darkRed);

    var messageLogX = barX + barWidth + 2;
    var messageLogY = barY;
    var messageLogWidth = game.dungeon.bounds.width - barWidth - 5;
    var messageLogHeight = height - game.dungeon.bounds.height;
    game.messageLog = MessageLog(Vec(messageLogX, messageLogY), messageLogWidth, messageLogHeight);
  }

  @override
  bool handleInput(Input input) {
    if (game.state == GameStates.playerTurn ) {
    var direction;
      switch (input) {
        case Input.nw:
          direction = Direction.nw;
          break;
        case Input.n:
          direction = Direction.n;
          break;
        case Input.ne:
          direction = Direction.ne;
          break;
        case Input.w:
          direction = Direction.w;
          break;
        case Input.e:
          direction = Direction.e;
          break;
        case Input.sw:
          direction = Direction.sw;
          break;
        case Input.s:
          direction = Direction.s;
          break;
        case Input.se:
          direction = Direction.se;
          break;
        
        default:
          return false;
      }

      if (game.hero.isAlive) {
        if (direction != null) {
          game.addAction(WalkAction(game.hero, game.dungeon, direction));
        }
      }

      game.state = GameStates.enemyTurn;

    } // End if

    if (game.state == GameStates.enemyTurn ) {
      for (var actor in game.actors) {
        if (actor is Monster && actor.isAlive) {
          game.addAction(actor.takeTurn());
        }
      }
    }

    game.update();
    game.dungeon.fov.refresh(game.hero.pos);

    if (game.state == GameStates.playerDead) {
print('YOU DEAD!');
    }

    dirty();
    ui.refresh();

    return true;

  } // End of handleInput()

  @override
  void render(Terminal terminal) {
    terminal.clear();

    var dungeon = game.dungeon;

    for (var pos in dungeon.tiles.bounds) {
      var tile = dungeon[pos];
      var wall = tile.blocked;
      var color;
      if (tile.isVisible) {
        if (wall) {
          color = dungeon.colors['lightWall'];
        } else {
          color = dungeon.colors['lightGround'];
        }
      } else if (tile.isExplored) {
        if (wall) {
          color = dungeon.colors['darkWall'];
        } else {
          color = dungeon.colors['darkGround'];
        }
      } else if (game.debug) {
        if (wall) {
          color = dungeon.colors['unexploredWall'];
        } else {
          color = dungeon.colors['unexploredGround'];
        }
      }
      terminal.writeAt(pos.x, pos.y, ' ', color, color);
      if (game.debug) {
        if (dungeon.tiles[pos].isPath) {
          terminal.writeAt(pos.x, pos.y, '*', Color.white, color);
        }
      }
    }

    for (var actor in dungeon.actors) {
      if (dungeon.tiles[actor.pos].isVisible && !actor.isAlive) {
        terminal.writeAt(actor.pos.x, actor.pos.y, actor.icon, actor.color, dungeon.colors['lightGround']);
      }
    }

    for (var actor in dungeon.actors) {
      if (dungeon.tiles[actor.pos].isVisible && actor.isAlive) {
        terminal.writeAt(actor.pos.x, actor.pos.y, actor.icon, actor.color, dungeon.colors['lightGround']);
      } else if (game.debug) {
        terminal.writeAt(actor.pos.x, actor.pos.y, actor.icon, actor.color, Color.red);
      }
    }

    hpBar.render(terminal, game.hero.hp, game.hero.maxHp);
    game.messageLog.render(terminal);

  } // End of render()

} // End of class GameScreen