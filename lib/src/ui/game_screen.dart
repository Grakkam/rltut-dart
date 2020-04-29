import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine/action/action.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/engine/monster/monster.dart';
import 'package:rltut/src/ui/bar.dart';
import 'package:rltut/src/ui/drop_item_screen.dart';
import 'package:rltut/src/ui/input.dart';
import 'package:rltut/src/ui/message-log.dart';
import 'package:rltut/src/ui/use_item_screen.dart';

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

    var action;
    switch (input) {
      case Input.nw:
        action = WalkAction(game.hero, game.dungeon, Direction.nw);
        break;
      case Input.n:
        action = WalkAction(game.hero, game.dungeon, Direction.n);
        break;
      case Input.ne:
        action = WalkAction(game.hero, game.dungeon, Direction.ne);
        break;
      case Input.w:
        action = WalkAction(game.hero, game.dungeon, Direction.w);
        break;
      case Input.e:
        action = WalkAction(game.hero, game.dungeon, Direction.e);
        break;
      case Input.sw:
        action = WalkAction(game.hero, game.dungeon, Direction.sw);
        break;
      case Input.s:
        action = WalkAction(game.hero, game.dungeon, Direction.s);
        break;
      case Input.se:
        action = WalkAction(game.hero, game.dungeon, Direction.se);
        break;
      case Input.pickUp:
        action = PickupAction(game.hero, game.dungeon);
        break;
      case Input.drop:
        ui.push(DropItemScreen(this));
        action = 'drop';
        break;
      case Input.use:
        ui.push(UseItemScreen(this));
        action = 'use';
        break;
      
      default:
        return false;
    }

    if (action is Action) game.addAction(action);

    dirty();
    ui.refresh();

    return true;

  } // End of handleInput()

  @override
  void update() {

    for (var actor in game.actors) {
      if (actor is Monster && actor.isAlive) {
        game.addAction(actor.takeTurn());
      }
    }

    game.update();
    game.dungeon.fov.refresh(game.hero.pos);

  }

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

    for (var item in dungeon.items) {
      if (dungeon.tiles[item.pos].isVisible) {
        terminal.writeAt(item.pos.x, item.pos.y, item.icon, item.color, dungeon.colors['lightGround']);
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