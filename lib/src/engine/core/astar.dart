import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/dungeon/dungeon.dart';

class Node {
  Node parent;
  Vec pos;

  Node(this.parent, this.pos);

  int g = 0;
  int h = 0;
  int f = 0;

  @override
  String toString() {
      parent ??= Node(null, null);
    return 'Pos: $pos | g: $g, h: $h, f: $f (Parent pos: ${parent.pos})';
  }

  @override
  bool operator ==(Object other) {
    if (other is Node) {
      return pos == other.pos;
    }

    return false;
  }

}

int square(num n) => (n * n).round();

class Astar {
  /// Returns a List of [Vec]s as a path from the given start to
  /// the given end in the given maze.

  static List findPath(Dungeon dungeon, Vec startPos, Vec endPos) {

    // Create start and end nodes
    var startNode = Node(null, startPos);
    var endNode = Node(null, endPos);

    // Initialize open and closed lists
    var openList = <Node>[];
    var closedList = <Node>[];

    // Add the start node
    openList.add(startNode);

    // Loop counter used to break out if we work too hard
    var loopCount = 0;
    while (openList.isNotEmpty) {
      loopCount++;
      if (loopCount > 50) {
        // Too hard, give up
        return null;
      }

      // Get the current node
      var currentNode = openList.first;
      var currentIndex = 0;
      for (var index = 0; index < openList.length; index++) {
        var node = openList[index];
        if (node.f < currentNode.f) {
          currentNode = node;
          currentIndex = index;
        }
      }

      // Pop current off open list, add to closed list
      openList.removeAt(currentIndex);
      closedList.add(currentNode);

      dungeon.tiles[currentNode.pos].isPath = true;

      // Found the goal
      if (currentNode.pos == endNode.pos) {
        var path = [];
        for (var node in closedList) {
          path.add(node.pos);
        }
        return path;
        // return path.reversed.toList();
      }

      // Generate children
      var neighbours = [  Vec(0, -1),
                          Vec(0, 1),
                          Vec(-1, 0),
                          Vec(1, 0),
                          Vec(-1, -1),
                          Vec(-1, 1),
                          Vec(1, -1),
                          Vec(1, 1)
        ];

      var children = [];
      for (var neighbour in neighbours) {
        // Get node position
        var nodePosition = currentNode.pos + neighbour;
        
        if (!dungeon.validDestination(nodePosition)) {
          continue;
        }

        // Create new node
        var newNode = Node(currentNode, nodePosition);

        // Add node
        children.add(newNode);
      }

      // Loop through children
      for (var child in children) {

        // Child is on the closedList
        for (var closedChild in closedList) {
          if (child == closedChild) {
            continue;
          }
        }

        // Create f, g, and h values
        child.g = currentNode.g + 1;
        child.h = square((child.pos.x - endNode.pos.x)) +
            square((child.pos.y - endNode.pos.y));
        child.f = child.g + child.h;

        // Child is already in the open list
        for (var openNode in openList) {
          if (child == openNode && child.g > openNode.g) {
            continue;
          }
        }

        openList.add(child);
      }

    }

    return null;
  }
}
