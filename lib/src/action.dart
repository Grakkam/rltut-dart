import 'package:rltut/src/actor.dart';

abstract class Action {
  Actor _actor;
  Actor get actor => _actor;

  void bind(Actor actor) {
    _actor = actor;
  }

  void perform();
}

class MoveAction extends Action {
  var _dirX;
  var _dirY;

  MoveAction(int dirX, int dirY) {
    _dirX = dirX;
    _dirY = dirY;
  }

  @override
  void perform() {
    _actor.xpos = _actor.xpos + _dirX;
    _actor.ypos = _actor.ypos + _dirY;
  }

}
