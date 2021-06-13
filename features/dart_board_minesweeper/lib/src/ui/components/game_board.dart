import 'dart:async';

import 'package:dart_board_core/impl/widgets/convertor_widget.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Card(child: MineField()),
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
    var value = "";
    final state = getState<MinesweeperState>();

    //value =
//        "⏲️${(state.mineSweeper.gameOverTime ?? DateTime.now()).difference(state.mineSweeper.startTime).inSeconds}";

    return Text(value, style: Theme.of(context).textTheme.headline5);
  }
}

class BombsRemaining extends StatelessWidget {
  const BombsRemaining();

  @override
  Widget build(BuildContext context) =>
      FeatureStateBuilder<MinesweeperState>((ctx, state) => Text(
          (state.mineSweeper == null)
              ? ""
              : "💣${state.mineSweeper!.bombs! - state.mineSweeper!.flagCount}",
          style: Theme.of(context).textTheme.headline5));
}

class MineField extends StatelessWidget {
  const MineField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FeatureStateBuilder<MinesweeperState>(
      (ctx, state) => BuilderConvertor<MinesweeperState, MineFieldViewModel>(
          convertor: buildVm,
          input: state,
          builder: (ctx, vm) {
            List<Widget> children = [];
            for (int y = 0; y < vm.height; y++) {
              for (int x = 0; x < vm.width; x++) {
                children.add(MineBlock(x: x, y: y));
              }
            }

            return LayoutBuilder(
                builder: (context, constraints) => Stack(children: <Widget>[
                      ...vm.started
                          ? [
                              CustomMultiChildLayout(
                                  delegate: GameBoardLayoutDelegate(
                                      vm.width, vm.height),
                                  children: children),
                            ]
                          : [],
                      GameInfoOverlay(vm: vm)
                    ]));
          }));

  MineFieldViewModel buildVm(MinesweeperState state) {
    return MineFieldViewModel(
        width: state.mineSweeper.width,
        height: state.mineSweeper.height,
        gameOver: state.mineSweeper.isGameOver,
        win: state.mineSweeper.isWin,
        started: true);
  }
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
            opacity: vm.gameOver ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                child: Center(
                    child: Visibility(
                  visible: !vm.started || vm.gameOver,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        vm.started!
                            ? vm.gameOver
                                ? vm.win
                                    ? "🔥You Win🔥"
                                    : "💩Game Over💩"
                                : ""
                            : "Flutter Minesweeper",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ),
                )))));
  }
}

class MineFieldViewModel {
  final bool started;
  final int width;
  final int height;
  final bool gameOver;
  final bool win;

  MineFieldViewModel(
      {required this.width,
      required this.height,
      required this.gameOver,
      required this.win,
      required this.started});

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
  final int width;
  final int height;

  GameBoardLayoutDelegate(this.width, this.height);
  @override
  void performLayout(Size size) {
    final cw = size.width / width;
    final ch = size.height / height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
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
