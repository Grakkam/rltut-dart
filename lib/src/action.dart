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

class IdleAction extends Action {
  IdleAction();
  @override
  void perform() {
    var pos = _actor.pos;
print('${_actor.name} stands idle at ($pos), staring at nothing in particular.');
  }
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
    var monster = _gameMap.monsterAtLocation(pos);
    if (monster != null) {
print('You kick the ${monster.name} at (${monster.pos}) in the shin!');
      return;
    }
    _actor.pos = pos;
  }

}
