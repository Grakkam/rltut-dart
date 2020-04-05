import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actor.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/monster.dart';

abstract class Action {
  Actor _actor;
  Actor get actor => _actor;
  GameMap _gameMap;

  void bind(Actor actor) {
    _actor = actor;
    _gameMap = actor.gameMap;
  }

  bool perform();
}

class IdleAction extends Action {
  IdleAction();
  @override
  bool perform() {
    var pos = _actor.pos;
print('${_actor.name} stands idle at ($pos), staring at nothing in particular.');
    return true;
  }
}

class MoveAction extends Action {
  final Direction dir;

  MoveAction(this.dir);

  @override
  bool perform() {
    var pos = _actor.pos + dir;
    if (!_gameMap.tiles.bounds.contains(pos)) {
      return true;
    }
    if (_gameMap.isBlocked(pos)) {
      return true;
    }
    var monster = _gameMap.monsterAtLocation(pos);
    if (monster != null) {
      _actor.setNextAction(HitAction(monster, pos));
      return false;
    }
    _actor.pos = pos;

    return true;
  }

}

class HitAction extends Action {
  final Actor _target;
  final Vec _pos;

  HitAction(this._target, this._pos);

  @override
  bool perform() {
    if (_actor is Hero && _pos == _target.pos) {
print('${_actor.name} hits ${_target.name} for ${_actor.melee.power - _target.defense.toughness} points of damage!');
      var targetIsDead = _target.takeDamage(_actor.melee.power);
      if (targetIsDead) {
print('${_target.name} is dead!');
      }
      return true;

    }

    return true;
  }
}