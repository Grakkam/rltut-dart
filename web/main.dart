import 'dart:html' as html;
import 'dart:js';
import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:rltut/src/dungeon/dungeon.dart';
import 'package:rltut/src/dungeon/fov.dart';
import 'package:rltut/src/engine/core/combat.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/engine/hero/hero.dart';
import 'package:rltut/src/ui/game_screen.dart';
import 'package:rltut/src/ui/input.dart';

var maxMonstersPerRoom = 3;
var maxItemsPerRoom = 2;
var maxRoomSize = 10;
var minRoomSize = 6;
var maxRooms = 30;


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
} // End of class TerminalFont

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
} // End of _addFont()

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
} // End of _fullscreen()

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
} // End of _makeTerminal()

/// Updates the character dimensions of the current terminal to fit the screen
/// size.
void _resizeTerminal() {
  var terminal = _makeTerminal(_font.canvas, _font.charWidth, _font.charHeight);

  _font.terminal = terminal;
  _ui.setTerminal(terminal);
  _ui.refresh();
} // End of _resizeTerminal()

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

  _ui.keyPress.bind(Input.pickUp, KeyCode.g);
  _ui.keyPress.bind(Input.drop, KeyCode.d);
  _ui.keyPress.bind(Input.use, KeyCode.u);

  _ui.keyPress.bind(Input.cancel, KeyCode.escape);

  var terminalWidth = _font.terminal.width;
  var terminalHeight = _font.terminal.height;
  var mapWidth = terminalWidth;
  var mapHeight = terminalHeight - 6;

  var game = Game();
  game.dungeon = Dungeon(game, mapWidth, mapHeight, maxMonstersPerRoom, maxItemsPerRoom);
  game.dungeon.makeMap(maxRoomSize, minRoomSize, maxRooms);

  game.hero = Hero(game, 'Grakk', '@', Color.white, 30, Attack(5), Defense(2));
  game.actors.add(game.hero);
  game.actors.addAll(game.dungeon.monsters);
  game.hero.pos = game.dungeon.entrance;
  game.dungeon.fov = Fov(game.dungeon);
  game.dungeon.fov.refresh(game.hero.pos);

  _ui.push(GameScreen(game, terminalWidth, terminalHeight));

  _ui.handlingInput = true;

} // End of main()
