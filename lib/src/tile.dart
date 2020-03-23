

class Tile {
  bool _blocked;
  bool _blockSight;

  Tile(blocked, blockSight) {
    _blocked = blocked;
    if (!blockSight) {
      blockSight = blocked;
    }
    _blockSight = blockSight;
  }

  set blocked(bool blocked) => _blocked = blocked;
  set blockSight(bool blockSight) => _blockSight = blockSight;

  bool get blocked => _blocked;
  bool get blockSight => _blockSight;


}