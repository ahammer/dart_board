import 'dart:math';
import 'package:built_collection/built_collection.dart';
import 'package:dart_board_minesweeper/src/scaffolding/mine_redux.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_minesweeper/src/state/mine_sweeper.dart';
import 'package:dart_board_minesweeper/src/state/mine_sweeper_node.dart';
import 'package:redux_thunk/redux_thunk.dart';

final difficultySizes = {
  "Easy": 70,
  "Medium": 50,
  "Hard": 40,
};

final difficultyBombPercentages = {
  "Easy": 0.1,
  "Medium": 0.15,
  "Hard": 0.2,
};

//Max cells in one dimension
const kMaxCells1D = 20;

ThunkAction<AppState> clearTiles = (store) async {
  var game = store.state.mineSweeper!;
  for (int i = 0; i < game.width! + game.height!; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    store.dispatch(CleanBlanksAction());
  }
};

class NewGameAction extends Reducer {
  final String? difficulty;
  final int? width;
  final int? height;

  NewGameAction({this.difficulty, this.width, this.height});

  @override
  get reducer {
    var w = (width! ~/ difficultySizes[difficulty!]!);
    var h = (height! ~/ difficultySizes[difficulty!]!);

    //Clamp to a max size (for performance)
    //Basically, if one aspect ratio, scale down the kMaxCells1D on X, otherwise do on Y
    //Maintains aspect ratio, which I want to be squareish.

    if (w > kMaxCells1D) {
      final r = kMaxCells1D / w;
      w = kMaxCells1D;
      h = (h * r).toInt();
    }

    /*
    if (w > h) {
    } else {
      if (h > kMaxCells1D) {
        final r = kMaxCells1D / h;
        h = kMaxCells1D;
        w = (r * kMaxCells1D).toInt();
      } 
    }
    */

    return (oldState) => oldState.rebuild((b) {
          return b
            ..mineSweeper.replace(MineSweeper.newGame(
                width: w,
                height: h,
                bombs: ((w * h) * difficultyBombPercentages[difficulty!]!)
                    .toInt()));
        });
  }
}

class CleanBlanksAction extends Reducer {
  @override
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
}

class TouchMineSweeperTileAction extends Reducer {
  final int? x, y;

  TouchMineSweeperTileAction({this.x, this.y});
  @override
  AppState Function(AppState oldState) get reducer =>
      (oldState) => oldState.rebuild((b) {
            if (!oldState.mineSweeper!.isInBounds(x!, y) ||
                oldState.mineSweeper!.isGameOver) {
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
}

class FlagMineSweeperTileAction extends Reducer {
  final int? x, y;

  FlagMineSweeperTileAction({this.x, this.y});
  @override
  AppState Function(AppState oldState) get reducer =>
      (oldState) => oldState.rebuild((b) {
            if (!oldState.mineSweeper!.isInBounds(x!, y) ||
                oldState.mineSweeper!.isGameOver) {
              return b;
            }

            flipNode(oldState, b, x!, y, flip: false);
            return b;
          });
}

void flipSurroundingNodes(AppState oldState, AppStateBuilder b, int x, int y) {
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
MineSweeperNode? flipNode(AppState oldState, AppStateBuilder b, int x, int? y,
    {bool flip = true}) {
  //Bounds check
  if ((x >= oldState.mineSweeper!.width!) ||
      (y! >= oldState.mineSweeper!.height!) ||
      (x < 0) ||
      (y < 0)) return MineSweeperNode.emptyNode();

  final nodeIdx = y * oldState.mineSweeper!.width! + x;
  final node = oldState.mineSweeper!.nodes![nodeIdx];
  MineSweeperNode? newNode;
  if (flip) {
    if (!node!.isTagged!) {
      newNode = node.rebuild((b) => b..isVisible = true);
    }
  } else {
    newNode = node!.rebuild((b) => b..isTagged = !b.isTagged!);
  }
  b.mineSweeper.nodes[nodeIdx] = newNode;
  return newNode;
}

void _assignBombs(AppStateBuilder b) {
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
    int x, int y, int width, int height, ListBuilder<MineSweeperNode?> nodes) {
  List<MineSweeperNode> neighbours = [];
  neighbours.add(_getNode(x + 1, y + 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x + 1, y, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x + 1, y - 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x, y + 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x, y - 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x - 1, y + 1, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x - 1, y, width, height, nodes) ?? emptyNode);
  neighbours.add(_getNode(x - 1, y - 1, width, height, nodes) ?? emptyNode);
  return neighbours.fold(0, (value, node) => value + (node.isBomb! ? 1 : 0));
}

MineSweeperNode? _getNode(
    int x, int y, int width, int height, ListBuilder<MineSweeperNode?> nodes) {
  if (x < 0 || y < 0 || x >= width || y >= height) return emptyNode;
  int idx = x + y * width;
  try {
    return nodes[idx];
  } catch (e) {
    return emptyNode;
  }
}
