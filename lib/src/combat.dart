

class Attack {
  final int _range;
  int get range => _range;

  final int _power;
  int get power => _power;

  Attack(this._range, this._power);
}

class Defense {
  final int _toughness;
  int get toughness => _toughness;

  Defense(this._toughness);
}