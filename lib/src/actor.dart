import 'package:malison/malison.dart';
// import 'package:malison/malison_web.dart';


class Actor {
  int _xpos;
  int _ypos;
  String _glyph;
  Color _color;

  Actor (int x, int y, String glyph, Color color) {
    _xpos = x;
    _ypos = y;
    _glyph = glyph;
    _color = color;
  }

  set xpos(int x) => _xpos = x;
  int get xpos => _xpos;

  set ypos(int y) => _ypos = y;
  int get ypos => _ypos;

  set color(Color color) => _color = color;
  Color get color => _color;

  set glyph(String input) {
    var rune = input.runes.elementAt(0);
    _glyph = String.fromCharCode(rune);
  }
  String get glyph => _glyph;

}
