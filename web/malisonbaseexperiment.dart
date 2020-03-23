import 'dart:html' as html;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

const width = 80;
const height = 30;

final ui = UserInterface<String>();
final terminal = RetroTerminal.dos(width, height);

void main() {
  // querySelector('#output').text = 'Your Dart app is running, so you better catch it!';

  updateTerminal();

  ui.push(MainScreen());

  // ui.handlingInput = true;
  // ui.running = true;

}

void updateTerminal() {
  html.document.body.children.clear();
  ui.setTerminal(terminal);

}

class MainScreen extends Screen<String> {

  @override
  void render(Terminal terminal) {
    terminal.clear();

    void colorBar(int y, String name, Color light, Color medium, Color dark) {
      terminal.writeAt(2, y, name, Color.gray);
      terminal.writeAt(10, y, 'light', light);
      terminal.writeAt(16, y, 'medium', medium);
      terminal.writeAt(23, y, 'dark', dark);

      terminal.writeAt(28, y, ' light ', Color.black, light);
      terminal.writeAt(35, y, ' medium ', Color.black, medium);
      terminal.writeAt(43, y, ' dark ', Color.black, dark);
    }

    terminal.writeAt(0, 0, 'Predefined colors:');
    terminal.writeAt(59, 0, '---', Color.darkGray);
    terminal.writeAt(76, 0, '<<<', Color.lightGray);
    colorBar(1, 'gray', Color.lightGray, Color.gray, Color.darkGray);
    colorBar(2, 'red', Color.lightRed, Color.red, Color.darkRed);
    colorBar(3, 'orange', Color.lightOrange, Color.orange, Color.darkOrange);
    colorBar(4, 'gold', Color.lightGold, Color.gold, Color.darkGold);
    colorBar(5, 'yellow', Color.lightYellow, Color.yellow, Color.darkYellow);
    colorBar(6, 'green', Color.lightGreen, Color.green, Color.darkGreen);
    colorBar(7, 'aqua', Color.lightAqua, Color.aqua, Color.darkAqua);
    colorBar(8, 'blue', Color.lightBlue, Color.blue, Color.darkBlue);
    colorBar(9, 'purple', Color.lightPurple, Color.purple, Color.darkPurple);
    colorBar(10, 'brown', Color.lightBrown, Color.brown, Color.darkBrown);

    terminal.writeAt(0, 12, 'Code page 437:');
    var lines = [
      ' ☺☻♥♦♣♠•◘○◙♂♀♪♫☼',
      '►◄↕‼¶§▬↨↑↓→←∟↔▲▼',
      ' !"#\$%&\'()*+,-./',
      '0123456789:;<=>?',
      '@ABCDEFGHIJKLMNO',
      'PQRSTUVWXYZ[\\]^_',
      '`abcdefghijklmno',
      'pqrstuvwxyz{|}~⌂',
      'ÇüéâäàåçêëèïîìÄÅ',
      'ÉæÆôöòûùÿÖÜ¢£¥₧ƒ',
      'áíóúñÑªº¿⌐¬½¼¡«»',
      '░▒▓│┤╡╢╖╕╣║╗╝╜╛┐',
      '└┴┬├─┼╞╟╚╔╩╦╠═╬╧',
      '╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀',
      'αßΓπΣσµτΦΘΩδ∞φε∩',
      '≡±≥≤⌠⌡÷≈°∙·√ⁿ²■'
    ];

    var y = 13;
    for (var line in lines) {
      terminal.writeAt(3, y++, line, Color.lightGray);
    }
  }

}


