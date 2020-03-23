import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/tile.dart';


class GameMap {
  int _width;
  int _height;
  Array2D _tiles;
  Map _colors = {
    'darkWall': Color.blue,
    'darkGround': Color.darkBlue,
  };

  GameMap(int width, int height) {
    _width = width;
    _height = height;
    _tiles = Array2D(width, height);
    
    InitializeTiles();
  }

  Array2D get tiles => _tiles;
  Map get colors => _colors;

  void InitializeTiles() {
    for (var x=0; x<_width; x++) {
      for (var y=0; y<_height; y++) {
        _tiles[Vec(x, y)] = Tile(false, false);
      }
    }

    _tiles[Vec(2, 2)] = Tile(true, true);
    
  }

  bool isBlocked(Vec pos) {
    var tile = _tiles[pos];
    return tile.blocked;
  }
}