import 'dart:math';
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/tile.dart';


class GameMap {
  int _width;
  int _height;
  Array2D _tiles;
  final _colors = {
    'darkWall': Color.blue,
    'darkGround': Color.darkBlue,
  };
  Vec _firstRoomCenter;

  Vec get entrance => _firstRoomCenter;

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
        _tiles[Vec(x, y)] = Tile(true, true);
      }
    }

  }

  bool isBlocked(Vec pos) {
    var tile = _tiles[pos];
    return tile.blocked;
  }

  void createRoom(Rect room) {
    for (var x = 0; x < room.width; x++) {
      for (var y = 0; y < room.height; y++) {
        var tileX = room.x+x+1;
        var tileY = room.y+y+1;
        _tiles[Vec(tileX, tileY)] = Tile(false, false);
      }
    }
  }

  // void createHTunnel(int x1, int x2, int y) {
  //   var tunnel = Rect.row(x1, y, x2-x1);
  //   createRoom(tunnel);
  // }

  // void createVTunnel(int y1, int y2, int x) {
  //   var tunnel = Rect.column(x, y1, y2-y1);
  //   createRoom(tunnel);
  // }
  void createHTunnel(int x, int y, int length) {
    var tunnel = Rect.row(x, y, length);
    createRoom(tunnel);
  }

  void createVTunnel(int x, int y, int length) {
    var tunnel = Rect.column(x, y, length);
    createRoom(tunnel);
  }

  List makeMap(int maxRooms, int minRoomSize, int maxRoomSize) {
    var rooms = [];
    var numRooms = 0;
    var rand = Random();


    for (var r = 0; r < maxRooms; r++) {
      var w = rand.nextInt(maxRoomSize);
      if (w < minRoomSize) {
        w = minRoomSize;
      }
      var h = rand.nextInt(maxRoomSize);
      if (h < minRoomSize) {
        h = minRoomSize;
      }

      var x = rand.nextInt(_width - w - 1);
      var y = rand.nextInt(_height - h - 1);

      var newRoom = Rect(x, y, w, h);

      var intersect = false;
      for (var otherRoom in rooms) {
        // var intersect = Rect.intersect(newRoom, otherRoom).size;
        intersect = this.intersect(newRoom, otherRoom);
        // if (intersect > 0) {
        if (intersect) {
          break;
        }
      }
      if (!intersect) {
        createRoom(newRoom);
        if (numRooms == 0) {
          // First room!
          _firstRoomCenter = newRoom.center;
        }
        else {
          // Connect new room to the last room.
          var prevRoom = rooms[numRooms - 1];

          int x1 = newRoom.center.x;
          int y1 = newRoom.center.y;
          int x2 = prevRoom.center.x;
          int y2 = prevRoom.center.y;
          int lengthX = (x1 - x2).abs() + 1;
          int lengthY = (y1 - y2).abs() + 1;

          // Flip a coin
          if (rand.nextBool()) {
            // First move horizontally then vertically
            createHTunnel(min(x1, x2), y2, lengthX);
            createVTunnel(x1, min(y1, y2), lengthY);
          }
          else {
            // First move vertically then horizontally
            createVTunnel(x1, min(y1, y2), lengthY);
            createHTunnel(min(x1, x2), y2, lengthX);
          }
        }
        rooms.add(newRoom);
        numRooms++;
      }

    }

    return rooms;
  }

  bool intersect(Rect room1, Rect room2) {
    return room1.topLeft.x <= room2.topRight.x && room1.topRight.x >= room2.topLeft.x &&
           room1.topLeft.y <= room2.bottomRight.y && room1.bottomRight.y >= room2.topLeft.y;
  }
}