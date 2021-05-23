import 'dart:async';

import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

import 'mine_block.dart';

const kBoardEdgePadding = 1.0;

///
///The GameBoard Area
///The board overlay
///The game timer
///The bomb counter

///
///Mine Field
class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(kBoardEdgePadding),
        child: MineField(),
      ),
    );
  }
}

class GameTimer extends StatefulWidget {
  const GameTimer();

  @override
  _GameTimerState createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String value = "";
    Store<AppState> store = Provider.of(context, listen: false);

    if (store.state.mineSweeper != null) {
      value =
          "⏲️${(store.state.mineSweeper!.gameOverTime ?? DateTime.now()).difference(store.state.mineSweeper!.startTime!).inSeconds}";
    }

    return Text(value, style: Theme.of(context).textTheme.title);
  }
}

class BombsRemaining extends StatelessWidget {
  const BombsRemaining();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, String>(
      converter: (store) {
        if (store.state.mineSweeper == null) return "";
        return "💣${store.state.mineSweeper!.bombs! - store.state.mineSweeper!.flagCount}";
      },
      distinct: true,
      builder: (ctx, value) =>
          Text(value, style: Theme.of(context).textTheme.title));
}

class MineField extends StatelessWidget {
  const MineField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) =>
          StoreConnector<AppState, MineFieldViewModel>(
              converter: (store) {
                if (store.state.mineSweeper != null) {
                  return MineFieldViewModel(
                      width: store.state.mineSweeper!.width,
                      height: store.state.mineSweeper!.height,
                      gameOver: store.state.mineSweeper!.isGameOver,
                      win: store.state.mineSweeper!.isWin,
                      started: true);
                } else {
                  return MineFieldViewModel(
                      width: 0,
                      height: 0,
                      gameOver: true,
                      win: false,
                      started: false);
                }
              },
              distinct: true,
              builder: (ctx, vm) {
                List<Widget> children = [];
                for (int y = 0; y < vm.height!; y++) {
                  for (int x = 0; x < vm.width!; x++) {
                    children.add(MineBlock(x: x, y: y));
                  }
                }

                return Stack(
                  children: <Widget>[
                    ...vm.started!
                        ? [
                            CustomMultiChildLayout(
                                delegate: GameBoardLayoutDelegate(
                                    vm.width, vm.height),
                                children: children),
                          ]
                        : [],
                    GameInfoOverlay(vm: vm)
                  ],
                );
              }));
}

class GameInfoOverlay extends StatelessWidget {
  final MineFieldViewModel vm;

  const GameInfoOverlay({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        child: AnimatedOpacity(
            opacity: vm.gameOver! ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                child: Center(
                    child: Visibility(
                  visible: !vm.started! || vm.gameOver!,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        vm.started!
                            ? vm.gameOver!
                                ? vm.win!
                                    ? "🔥You Win🔥"
                                    : "💩Game Over💩"
                                : ""
                            : "Flutter Minesweeper",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ),
                )))));
  }
}

class MineFieldViewModel {
  final bool? started;
  final int? width;
  final int? height;
  final bool? gameOver;
  final bool? win;

  MineFieldViewModel(
      {this.width, this.height, this.gameOver, this.win, this.started});

  //Equals and Hashcode
  bool operator ==(o) =>
      o is MineFieldViewModel &&
      o.width == width &&
      o.height == height &&
      o.gameOver == gameOver;

  @override
  int get hashCode => (width! + height! + (gameOver! ? 1 : 0)).hashCode;
}

class GameBoardLayoutDelegate extends MultiChildLayoutDelegate {
  final int? width;
  final int? height;

  GameBoardLayoutDelegate(this.width, this.height);
  @override
  void performLayout(Size size) {
    final cw = size.width / width!;
    final ch = size.height / height!;

    for (int y = 0; y < height!; y++) {
      for (int x = 0; x < width!; x++) {
        String id = "grid:$x:$y";
        layoutChild(id, BoxConstraints.expand(width: cw, height: ch));
        positionChild(id, Offset(x * cw, y * ch));
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
