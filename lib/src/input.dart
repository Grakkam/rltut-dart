/// Enum class defining the high-level inputs from the user.
/// 
/// Physical keys on the keyboard are mapped to these, which the user interface
/// then interprests.
class Input {
  final String name;

  const Input(this.name);

  /// Directional inputs.
  /// These are used both for navigating in the level and the menu screens.
  static const n = Input('n');
  static const ne = Input('ne');
  static const e = Input('e');
  static const se = Input('se');
  static const s = Input('s');
  static const sw = Input('sw');
  static const w = Input('w');
  static const nw = Input('nw');
}