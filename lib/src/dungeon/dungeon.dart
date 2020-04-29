import 'dart:math' as math;
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine/core/actor.dart';
import 'package:rltut/src/engine/core/game.dart';
import 'package:rltut/src/engine/item/item.dart';
import 'package:rltut/src/engine/monster/monster.dart';
import 'fov.dart';
import 'tile.dart';

class Dungeon {
  final Game _game;
  final int _width;
  final int _height;
  final int _maxMonstersPerRoom;
  final int _maxItemsPerRoom;

  Dungeon(this._game, this._width, this._height, this._maxMonstersPerRoom, this._maxItemsPerRoom) {
    _tiles = Array2D(_width, _height);
    
    InitializeTiles();
  }

  List get actors => _game.actors;
  List get items => _game.items;

  Array2D _tiles;
  Fov fov;

  bool withinBounds(Vec pos) => _tiles.bounds.contains(pos);
  bool isBlocked(Vec pos) => _tiles[pos].blocked;
  bool validDestination(Vec pos) => withinBounds(pos) && !isBlocked(pos);

  bool isEmpty(Vec pos) {
    if (isOccupied(pos) != null) return false;
    for (var item in items) {
      if (pos == item.pos) return false;      
    }
    return true;
  }

  //
  // This needs to return a bool instead
  //
  Actor isOccupied(Vec pos) {
    for (var actor in actors) {
      if (pos == actor.pos && actor.isAlive && actor.isBlocking) {
        return actor;
      }
    }
    return null;
  }

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

  List monsters = <Actor>[];

  Vec get entrance => _firstRoomCenter;

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

  void makeMap(int maxRoomSize, int minRoomSize, int maxRooms) {
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
        intersect = this.intersect(newRoom, otherRoom);
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
          placeItems(newRoom, _maxItemsPerRoom);
        }
        rooms.add(newRoom);
        numRooms++;
      }

    }

  } // End of makeMap()

  bool intersect(Rect room1, Rect room2) {
    return room1.topLeft.x <= room2.topRight.x && room1.topRight.x >= room2.topLeft.x &&
           room1.topLeft.y <= room2.bottomRight.y && room1.bottomRight.y >= room2.topLeft.y;
  } // End of intersect()

  void clearPaths() {
    for (var tile in tiles) {
      tile.isPath = false;
    }
  } // End of clearPaths()

  Vec randomEmptySpot(Rect room) {
    // Maximum nr of tries, so we don't get stuck in a loop
    for (var i = 0; i < 20; i++) {
      var x = rand.nextInt(room.width - 1) + room.left + 1;
      var y = rand.nextInt(room.height - 1) + room.top + 1;
      var pos = Vec(x, y);

      if (isEmpty(pos)) {
        return pos;
      }

    }
    // If no empty spot is found, return null
    return null;
  }

  void placeItems(Rect room, int maxItemsPerRoom) {
    var numberOfItems = rand.nextInt(maxItemsPerRoom);

    for (var i = 0; i < numberOfItems; i++) {
      var pos = randomEmptySpot(room);
      if (pos != null) {
        var item = HealingPotion('Healing Potion', '!', Color.purple, pos, 4);
        items.add(item);
      }
    }
  } // End of placeItems()

  void placeMonsters(Rect room, int maxMonstersPerRoom) {
    var numberOfMonsters = rand.nextInt(maxMonstersPerRoom);

    for (var i = 0; i < numberOfMonsters; i++) {
      var pos = randomEmptySpot(room);
      if (pos != null) {
        var monster;
        if (rand.nextInt(100) < 80) {
          monster = Monster(_game, _game.breeds['orc'], pos);
        } else {
          monster = Monster(_game, _game.breeds['troll'], pos);
        }

        monsters.add(monster);      
      }
    }
  } // End of placeMonsters()

}