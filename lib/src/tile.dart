

class Tile {
  bool _blocked;
  bool _blockSight;
  bool _isLit = false;
  bool _isExplored = false;

  Tile(blocked, blockSight) {
    _blocked = blocked;
    if (!blockSight) {
      blockSight = blocked;
    }
    _blockSight = blockSight;
  }

  set blocked(bool blocked) => _blocked = blocked;
  set blockSight(bool blockSight) => _blockSight = blockSight;
  set isLit(bool isLit) => _isLit = isLit;
  set isExplored(bool isExplored) => _isExplored = isExplored;

  bool get blocked => _blocked;
  bool get blockSight => _blockSight;
  bool get isLit => _isLit;
  bool get isExplored => _isExplored;


}