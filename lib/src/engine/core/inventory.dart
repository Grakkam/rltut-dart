import 'package:rltut/src/engine/item/item.dart';

class Inventory {
  int _capacity;
  List contents = <Item>[];

  Inventory({int capacity = 26}) {
    _capacity = capacity;
  }

  bool add(Item item) {
    if (contents.length < _capacity) {
      contents.add(item);
      return true;
    }
    return false;
  }

  Item remove(int index) {
    return contents.removeAt(index);
  }
}