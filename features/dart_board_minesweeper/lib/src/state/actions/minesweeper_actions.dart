import 'dart:math';
import 'package:built_collection/built_collection.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_minesweeper/src/state/mine_sweeper.dart';
import 'package:dart_board_minesweeper/src/state/mine_sweeper_node.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final difficultyBombPercentages = {
  "Easy": 0.1,
  "Medium": 0.15,
  "Hard": 0.2,
};

final sizes = {
  "Easy": 10,
  "Medium": 15,
  "Hard": 20,
};

//Max cells in one dimension
const kMaxCells1D = 20;

/// Thunks need to be with DartBoardState (because that's the store type)
ThunkAction<DartBoardState> clearTiles = (store) async {
  MineSweeper game = store.state.getState<MinesweeperState>().mineSweeper;

  for (int i = 0; i < game.width + game.height; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    dispatch(CleanBlanksAction());
  }
};

class NewGameAction extends FeatureAction<MinesweeperState> {
  final String difficulty;

  NewGameAction({required this.difficulty});

  get reducer {
    final size = sizes[difficulty]!;

    return (oldState) => oldState.rebuild((b) {
          return b
            ..mineSweeper.replace(MineSweeper.newGame(
                width: size,
                height: size,
                bombs: ((size * size) * difficultyBombPercentages[difficulty]!)
                    .toInt()));
        });
  }

  @override
  MinesweeperState featureReduce(MinesweeperState state) {
    return reducer(state);
  }
}

class CleanBlanksAction extends FeatureAction<MinesweeperState> {
  get reducer => (oldState) => oldState.rebuild((b) {
        if (oldState.mineSweeper == null) return oldState;
        for (int x = 0; x < oldState.mineSweeper!.width!; x++) {
          for (int y = 0; y < oldState.mineSweeper!.height!; y++) {
            final node = oldState.mineSweeper!.getNode(x: x, y: y)!;
            //Bombs aren't generated yet, lets not run this
            if (node.isBomb == null) return b;

            if (node.isVisible! && !node.isBomb! && node.neighbours == 0) {
              flipSurroundingNodes(oldState, b, x, y);
            }
          }
        }

        return b;
      });

  @override
  MinesweeperState featureReduce(MinesweeperState state) => reducer(state);
}

class TouchMineSweeperTileAction extends FeatureAction<MinesweeperState> {
  final int x, y;

  TouchMineSweeperTileAction({required this.x, required this.y});

  MinesweeperState Function(MinesweeperState oldState) get reducer =>
      (oldState) => oldState.rebuild((b) {
            if (!oldState.mineSweeper.isInBounds(x, y) ||
                oldState.mineSweeper.isGameOver) {
              return b;
            }

            //Index position of the node
            final newNode = flipNode(oldState, b, x!, y)!;

            //No bombs yet, lets assign now
            if (newNode.isBomb == null) {
              //Flip the surrounding nodes (so we are in a blank space)
              flipSurroundingNodes(oldState, b, x!, y!);
              _assignBombs(b);
            }

            if (newNode.isBomb ?? false) {
              b.mineSweeper.gameOverTime = DateTime.now();
            }
            return b;
          });

  @override
  MinesweeperState featureReduce(MinesweeperState state) => reducer(state);
}

class FlagMineSweeperTileAction extends FeatureAction<MinesweeperState> {
  final int? x, y;

  FlagMineSweeperTileAction({this.x, this.y});

  MinesweeperState Function(MinesweeperState oldState) get reducer =>
      (oldState) => oldState.rebuild((b) {
            if (!oldState.mineSweeper!.isInBounds(x!, y) ||
                oldState.mineSweeper!.isGameOver) {
              return b;
            }

            flipNode(oldState, b, x!, y, flip: false);
            return b;
          });

  @override
  MinesweeperState featureReduce(MinesweeperState state) => reducer(state);
}

void flipSurroundingNodes(
    MinesweeperState oldState, MinesweeperStateBuilder b, int x, int y) {
  flipNode(oldState, b, x + 1, y + 1);
  flipNode(oldState, b, x + 1, y);
  flipNode(oldState, b, x + 1, y - 1);
  flipNode(oldState, b, x, y + 1);
  flipNode(oldState, b, x, y - 1);
  flipNode(oldState, b, x - 1, y + 1);
  flipNode(oldState, b, x - 1, y);
  flipNode(oldState, b, x - 1, y - 1);
}

//Flip or Tag a node
//If flip = false, a tag will be done
MineSweeperNode? flipNode(
    MinesweeperState oldState, MinesweeperStateBuilder b, int x, int? y,
    {bool flip = true}) {
  //Bounds check
  if ((x >= oldState.mineSweeper!.width!) ||
      (y! >= oldState.mineSweeper!.height!) ||
      (x < 0) ||
      (y < 0)) return MineSweeperNode.emptyNode();

  final nodeIdx = y * oldState.mineSweeper!.width! + x;
  final node = oldState.mineSweeper!.nodes![nodeIdx];
  late MineSweeperNode newNode;
  if (flip) {
    if (!node.isTagged!) {
      newNode = node.rebuild((b) => b..isVisible = true);
    }
  } else {
    newNode = node.rebuild((b) => b..isTagged = !b.isTagged!);
  }
  b.mineSweeper.nodes[nodeIdx] = newNode;
  return newNode;
}

void _assignBombs(MinesweeperStateBuilder b) {
  final nodes = b.mineSweeper.nodes;
  final bombCount = b.mineSweeper.bombs!;
  final width = b.mineSweeper.width!;
  final height = b.mineSweeper.height!;
  final random = Random();

  int remaining = bombCount;

  //Set all the bombs to false
  for (int i = 0; i < width * height; i++) {
    nodes[i] = nodes[i]!.rebuild((b) => b..isBomb = false);
  }

  //Assign bombCount at random
  while (remaining > 0) {
    int x = random.nextInt(width);
    int y = random.nextInt(height);
    final idx = x + y * width;
    final node = nodes[idx]!;
    if (node.isVisible != true && node.isBomb != true) {
      nodes[idx] = node.rebuild((b) => b..isBomb = true);
      remaining--;
    }
  }

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int count = _countNeighbours(x, y, width, height, nodes);
      final idx = x + y * width;
      final node = nodes[idx]!;
      nodes[idx] = node.rebuild((b) => b..neighbours = count);
    }
  }
}

int _countNeighbours(
    int x, int y, int width, int height, ListBuilder<MineSweeperNode> nodes) {
  List<MineSweeperNode> neighbours = [];
  neighbours.add(_getNode(x + 1, y + 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x + 1, y, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x + 1, y - 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x, y + 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x, y - 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x - 1, y + 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x - 1, y, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x - 1, y - 1, width, height, nodes) ?? emptyNode);
  return neighbours.fold(
      0, (value, node) => value + (node.isBomb ?? false ? 1 : 0));
}

MineSweeperNode _getNode(
    int x, int y, int width, int height, ListBuilder<MineSweeperNode> nodes) {
  if (x < 0 || y < 0 || x >= width || y >= height) return emptyNode;
  int idx = x + y * width;

  return nodes[idx];
}
