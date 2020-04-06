import 'dart:html' as html;
import 'dart:js';
import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/action.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/input.dart';
import 'package:rltut/src/monster.dart';

const bool debug = false;

enum GameStates { playerTurn, enemyTurn }
var gameState;

Hero hero;
var gameMap;


final _fonts = <TerminalFont>[];
UserInterface<Input> _ui;
TerminalFont _font;

class TerminalFont {
  final String name;
  final html.CanvasElement canvas;
  RenderableTerminal terminal;
  final int charWidth;
  final int charHeight;

  TerminalFont(this.name, this.canvas, this.terminal,
    {this.charWidth, this.charHeight});
}

void _addFont(String name, int charWidth, [int charHeight]) {
  charHeight ??= charWidth;

  var canvas = html.CanvasElement();
  canvas.onDoubleClick.listen((_) {
    _fullscreen();
  });

  var terminal = _makeTerminal(canvas, charWidth, charHeight);
  _fonts.add(TerminalFont(name, canvas, terminal,
      charWidth: charWidth, charHeight: charHeight));

  // Make buttons for toggling fonts.
  var button = html.ButtonElement();
  button.innerHtml = name;
  button.onClick.listen((_) {
    for (var i = 0; i < _fonts.length; i++) {
      if (_fonts[i].name == name) {
        _font = _fonts[i];
        html.querySelector('#game').append(_font.canvas);
      } else {
        _fonts[i].canvas.remove();
      }
    }

    _resizeTerminal();

    // Remember the preference.
    html.window.localStorage['font'] = name;
  });

  html.querySelector('.button-bar').children.add(button);
}


RetroTerminal _makeTerminal(
    html.CanvasElement canvas, int charWidth, int charHeight) {
  var width = (html.document.body.clientWidth - 20) ~/ charWidth;
  var height = (html.document.body.clientHeight - 30) ~/ charHeight;

  width = math.max(width, 80);
  height = math.max(height, 40);

  var scale = html.window.devicePixelRatio.toInt();
  var canvasWidth = charWidth * width;
  var canvasHeight = charHeight * height;
  canvas.width = canvasWidth * scale;
  canvas.height = canvasHeight * scale;
  canvas.style.width = '${canvasWidth}px';
  canvas.style.height = '${canvasHeight}px';

  // Make the terminal.
  var file = 'font_$charWidth';
  if (charWidth != charHeight) {
    file += '_$charHeight';
  }
  return RetroTerminal(width, height, '$file.png',
      canvas: canvas, charWidth: charWidth, charHeight: charHeight);
}

/// Updates the character dimensions of the current terminal to fit the screen
/// size.
void _resizeTerminal() {
  var terminal = _makeTerminal(_font.canvas, _font.charWidth, _font.charHeight);

  _font.terminal = terminal;
  _ui.setTerminal(terminal);
}

/// See: https://stackoverflow.com/a/29715395/9457
void _fullscreen() {
  var div = html.querySelector('#game');
  var jsElement = JsObject.fromBrowserObject(div);

  var methods = [
    'requestFullscreen',
    'mozRequestFullScreen',
    'webkitRequestFullscreen',
    'msRequestFullscreen'
  ];
  for (var method in methods) {
    if (jsElement.hasProperty(method)) {
      jsElement.callMethod(method);
      return;
    }
  }
}


void main() {


  _addFont('8x8', 8);
  _addFont('16x16', 16);

  // Load the user's font preference, if any.
  var fontName = html.window.localStorage['font'];
  _font = _fonts[1];
  for (var thisFont in _fonts) {
    if (thisFont.name == fontName) {
      _font = thisFont;
      break;
    }
  }

  var div = html.querySelector('#game');
  div.append(_font.canvas);

  // Scale the terminal to fit the screen.
  html.window.onResize.listen((_) {
    _resizeTerminal();
  });

  _ui = UserInterface<Input>(_font.terminal);


  // Arrow keys.
  // +Shift for north-...
  // +Alt for south-...
  _ui.keyPress.bind(Input.nw, KeyCode.left, shift: true);
  _ui.keyPress.bind(Input.n, KeyCode.up);
  _ui.keyPress.bind(Input.ne, KeyCode.right, shift: true);
  _ui.keyPress.bind(Input.w, KeyCode.left);
  _ui.keyPress.bind(Input.e, KeyCode.right);
  _ui.keyPress.bind(Input.sw, KeyCode.left, alt: true);
  _ui.keyPress.bind(Input.s, KeyCode.down);
  _ui.keyPress.bind(Input.se, KeyCode.right, alt: true);

  // Numeric keypad.
  _ui.keyPress.bind(Input.nw, KeyCode.numpad7);
  _ui.keyPress.bind(Input.n, KeyCode.numpad8);
  _ui.keyPress.bind(Input.ne, KeyCode.numpad9);
  _ui.keyPress.bind(Input.w, KeyCode.numpad4);
  _ui.keyPress.bind(Input.e, KeyCode.numpad6);
  _ui.keyPress.bind(Input.sw, KeyCode.numpad1);
  _ui.keyPress.bind(Input.s, KeyCode.numpad2);
  _ui.keyPress.bind(Input.se, KeyCode.numpad3);

  gameMap = GameMap(_font.terminal.width, _font.terminal.height);
  gameMap.maxMonstersPerRoom = 3;
  gameMap.makeMap(25, 6, 15);
  hero = Hero(gameMap, 'Swoosh', gameMap.entrance);

  gameMap.actors.add(hero);
  gameMap.actors.addAll(gameMap.monsters);

  gameMap.fov.refresh(hero.pos);
  gameState = GameStates.playerTurn;

  _ui.push(GameScreen());

  _ui.handlingInput = true;
  _ui.running = true;

}

void updateTerminal() {
  _ui.setTerminal(_font.terminal);
}


class GameScreen extends Screen<Input> {

  @override
  bool handleInput(Input input) {

    if (gameState == GameStates.playerTurn) {
      Action action;
      switch (input) {
        case Input.nw:
          action = MoveAction(Direction.nw);
          break;
        case Input.n:
          action = MoveAction(Direction.n);
          break;
        case Input.ne:
          action = MoveAction(Direction.ne);
          break;
        case Input.w:
          action = MoveAction(Direction.w);
          break;
        case Input.e:
          action = MoveAction(Direction.e);
          break;
        case Input.sw:
          action = MoveAction(Direction.sw);
          break;
        case Input.s:
          action = MoveAction(Direction.s);
          break;
        case Input.se:
          action = MoveAction(Direction.se);
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
      for (var actor in gameMap.actors) {
        if (actor is Monster) {
          actor.setNextAction(actor.takeTurn());
        }
      }
      gameState = GameStates.playerTurn;
    }

    for (var i = 0; i < gameMap.actors.length; i++) {
      // if (gameMap.actors[i] is Monster && !gameMap.actors[i].isAlive) {
      if (!gameMap.actors[i].isAlive) {
        gameMap.actors.removeAt(i);
        i--;
      }
      while (gameMap.actors[i].action != null && !gameMap.actors[i].action.perform()) {

      }
      gameMap.actors[i].setNextAction(null);
    }

    gameMap.fov.refresh(hero.pos);

    updateTerminal();
    // _ui.refresh();


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

    for (var actor in gameMap.actors) {
      if (gameMap.tiles[actor.pos].isVisible && actor.isAlive) {
        terminal.writeAt(actor.x, actor.y, actor.glyph, actor.color, gameMap.colors['lightGround']);
      }
    }

  }

}




