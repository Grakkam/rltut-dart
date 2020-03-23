import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';

abstract class Action {
  Actor _actor;
  Actor get actor => _actor;
  GameMap _gameMap;

  void bind(Actor actor) {
    _actor = actor;
    _gameMap = actor.gameMap;
  }

  void perform();
}

class MoveAction extends Action {
  final Direction dir;

  MoveAction(this.dir);

  @override
  void perform() {
    var pos = _actor.pos + dir;
    if (!_gameMap.tiles.bounds.contains(pos)) {
      return;
    }
    if (_gameMap.isBlocked(pos)) {
      return;
    }
    _actor.pos = pos;
  }

}
