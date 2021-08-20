import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';

class CartFeature extends DartBoardFeature {
  @override
  String get namespace => "Cart";

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            name: "CartOverlay",
            decoration: (ctx, child) => CartOverlay(child: child))
      ];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [LocatorDecoration(() => CartState())];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
}

class CartOverlay extends StatelessWidget {
  final Widget child;

  const CartOverlay({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FloatingActionButton(
                onPressed: locate<CartState>().addItem,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_basket),
                    locate<CartState>().builder<CartState>(
                        (context, value) => Text("${value.items}"))
                  ],
                ),
              ),
            ),
          )
        ],
      );
}

class CartState extends ChangeNotifier {
  int items = 0;
  void addItem() {
    items++;
    notifyListeners();
  }
}
