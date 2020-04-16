import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

class Bar {
  Vec position;
  int width;
  String name;
  Color barColor;
  Color backColor;

  Bar(this.position, this.width, this.name, this.barColor, this.backColor);

  void render(Terminal terminal, int value, int maximum) {
    var barWidth = (value / maximum * width).round();

    if (barWidth == 0 && value > 0) barWidth = 1;
    if (barWidth == width && value < maximum) barWidth = width - 1;

    var text = '$name: $value/$maximum';
    // terminal.writeAt(position.x, position.y, text, barColor, backColor);

    for (var i = 0; i < width; i++) {
      var color = (i >= barWidth) ? backColor : barColor;
      terminal.writeAt(position.x + i, position.y, text.padRight(width, ' ')[i], Color.white, color);
    }

  } // End of render()
} // End of class Bar