import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/monster.dart';
import 'package:rltut/src/tile.dart';

class GameMap {
  final int _width;
  final int _height;
  Array2D _tiles;
  Fov fov;
  final rand = math.Random();
  final _colors = {
    'darkWall': Color.darkGray,
    'darkGround': Color.gray,
    'lightWall': Color.darkGold,
    'lightGround': Color.gold,
    'unexploredWall': Color.darkBrown,
    'unexploredGround': Color.brown,
  };
  Vec _firstRoomCenter;

  Hero hero;

  int _maxMonstersPerRoom;
  set maxMonstersPerRoom(int maxMonstersPerRoom) => _maxMonstersPerRoom = maxMonstersPerRoom;
  List monsters = <Actor>[];
  List actors = <Actor>[];

  Vec get entrance => _firstRoomCenter;

  GameMap(this._width, this._height) {
    _tiles = Array2D(_width, _height);
    
    InitializeTiles();
    fov = Fov(this);
  }

  Array2D get tiles => _tiles;
  Map get colors => _colors;
  Rect get bounds => _tiles.bounds;

  Tile operator [](Vec pos) => _tiles[pos];

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

  void createHTunnel(int x, int y, int length) {
    var tunnel = Rect.row(x, y, length);
    createRoom(tunnel);
  }

  void createVTunnel(int x, int y, int length) {
    var tunnel = Rect.column(x, y, length);
    createRoom(tunnel);
  }

  void placeMonsters(Rect room, int maxMonstersPerRoom) {
    var numberOfMonsters = rand.nextInt(maxMonstersPerRoom);

    for (var i = 0; i < numberOfMonsters; i++) {
      var x = rand.nextInt(room.width - 1) + room.left + 1;
      var y = rand.nextInt(room.height - 1) + room.top + 1;
      var pos = Vec(x, y);

      var occupied = false;
      for (var monster in monsters) {
        if (pos == monster.pos) {
          occupied = true;
        }
      }

      var monster;
      if (!occupied) {
        if (rand.nextInt(100) < 80) {
          monster = Monster(Orc(), this, pos);
        } else {
          monster = Monster(Troll(), this, pos);
        }

        monsters.add(monster);
      }
    }
  }

  void makeMap(int maxRooms, int minRoomSize, int maxRoomSize) {
    var rooms = [];
    var numRooms = 0;


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

          var x1 = newRoom.center.x;
          var y1 = newRoom.center.y;
          var x2 = prevRoom.center.x;
          var y2 = prevRoom.center.y;
          var lengthX = (x1 - x2).abs() + 1;
          var lengthY = (y1 - y2).abs() + 1;

          // Flip a coin
          if (rand.nextBool()) {
            // First move horizontally then vertically
            createHTunnel(math.min(x1, x2), y2, lengthX);
            createVTunnel(x1, math.min(y1, y2), lengthY);
          }
          else {
            // First move vertically then horizontally
            createVTunnel(x1, math.min(y1, y2), lengthY);
            createHTunnel(math.min(x1, x2), y2, lengthX);
          }

          placeMonsters(newRoom, _maxMonstersPerRoom);
        }
        rooms.add(newRoom);
        numRooms++;
      }

    }

  }

  bool intersect(Rect room1, Rect room2) {
    return room1.topLeft.x <= room2.topRight.x && room1.topRight.x >= room2.topLeft.x &&
           room1.topLeft.y <= room2.bottomRight.y && room1.bottomRight.y >= room2.topLeft.y;
  }

  // Actor monsterAtLocation(Vec pos) {
  //   for (var monster in monsters) {
  //     if (monster.pos == pos && monster.isAlive) {
  //       return monster;
  //     }
  //   }

  //   return null;
  // }

  Actor blockingActorAtLocation(Vec pos) {
    for (var actor in actors) {
      if (actor.isAlive && actor.pos == pos) {
        return actor;
      }
    }

    return null;
  }
}