

class Tile {
  bool _blocked;
  bool _blockSight;
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
  set isExplored(bool isExplored) => _isExplored = isExplored;

  bool get blocked => _blocked;
  bool get blockSight => _blockSight;
  bool get isExplored => _isExplored;

  bool get isWall => _blocked;

  bool _isVisible = false;
  bool get isVisible => _isVisible;
  set isVisible(bool value) {
    _isVisible = value;
    if (value) {
      _isExplored = true;
    }
  }

}