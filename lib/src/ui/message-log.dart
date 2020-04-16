import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

class MessageLog {
  Vec position;
  int width;
  int height;

  MessageLog(this.position, this.width, this.height);

  List messages = [];

  void addMessage(Message message) {
    // Split message text into lines.
    var newMessageLines = wrapText(message.text, width);

    // If the buffer is full, remove the first line to
    // make room for the new one.
    for (var line in newMessageLines) {
      if (messages.length == height) {
        messages.removeAt(0);
      }

      messages.add(Message(line, message.color));
    }
  } // End of addMessage()

  void render(Terminal terminal) {
    var y = 0;
    for (var message in messages) {
      terminal.writeAt(position.x, position.y + y, message.text, message.color);
      y++;
    }

  } // End of render()

  /// Splits a [text] into a list of `String`s no longer than [maxLength]
  List wrapText(String text, int maxLength) {

    var words = text.split(' ');

    var lines = [];
    var lineWidth = maxLength;

    var line = words.removeAt(0);
    while (words.isNotEmpty) {
      if ((line.length + 1 + words[0].length) <= lineWidth) {
        line += ' ' + words.removeAt(0);
        if (words.isEmpty) {
          lines.add(line);
        }
      } else {
        lines.add(line);
        line = words.removeAt(0);
      }
    }

    return lines;

  } // End of wrapText()
} // End of class MessageLog

class Message {
  String text;
  Color color;

  Message(this.text, [this.color = Color.white]);
} // End of class Message