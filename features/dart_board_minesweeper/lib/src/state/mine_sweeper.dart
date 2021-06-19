import 'dart:math';

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import 'mine_sweeper_node.dart';

part 'mine_sweeper.g.dart';

//This will represent the App State
abstract class MineSweeper implements Built<MineSweeper, MineSweeperBuilder> {
  MineSweeper._();

  factory MineSweeper([void Function(MineSweeperBuilder)? updates]) =
      _$MineSweeper;

  //Factory constructor to create a new game
  factory MineSweeper.newGame(
      {int width = 10, int height = 10, int bombs = 10}) {
    //Build the node list
    final nodes = <MineSweeperNode>[];
    for (int i = 0; i < width * height; i++) {
      nodes.add(MineSweeperNode((b) => b
        ..neighbours = 0
        ..isVisible = false
        ..isTagged = false
        ..random = Random().nextDouble()));
    }

    //Build the MineSweeper game object
    return MineSweeper((b) => b
      ..height = height
      ..width = width
      ..bombs = bombs
      ..startTime = DateTime.now()
      ..nodes.replace(nodes));
  }

  int get width;
  int get height;
  int get bombs;
  DateTime get startTime;

  DateTime? get gameOverTime;

  BuiltList<MineSweeperNode> get nodes;

  int get flagCount =>
      nodes!.fold(0, (value, node) => value + (node.isTagged! ? 1 : 0));

  int get notFlipped =>
      nodes!.fold(0, (value, node) => value + (node.isVisible! ? 0 : 1));
  //Check for Visible Bombs (That's game over)

  bool get isWin => flagCount == bombs && notFlipped == bombs;
  bool get isGameOver {
    if (gameOverTime != null) {
      return true;
    }
    //Win condition
    if (isWin) {
      return true;
    }

    return false;
  }

  bool isInBounds(int x, int? y) =>
      x >= 0 && y! >= 0 && x < width && y < height;

  MineSweeperNode getNode({required int x, required int y}) {
    final idx = x + y * width;
    if (idx >= nodes.length) return emptyNode;
    return nodes[x + y * width];
  }
}

final MineSweeperNode emptyNode = MineSweeperNode.emptyNode();
