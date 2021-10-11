import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';

class CartFeature extends DartBoardFeature {
  final String itemPreviewRoute;

  CartFeature({this.itemPreviewRoute = "/stub_item_preview"});

  @override
  String get namespace => "Cart";

  @override
  List<RouteDefinition> get routes => [
        /// Register the route for "viewing the cart"
        NamedRouteDefinition(
            route: "/view_cart",
            builder: (ctx, settings) =>
                CartView(itemPreviewRoute: itemPreviewRoute)),
        NamedRouteDefinition(
            route: "/stub_item_preview",
            builder: (ctx, settings) => Text("${settings.arguments}"))
      ];

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
  Map<String, MethodCallHandler> get methodHandlers => {
        "addItemToCart": (ctx, call) async =>
            locate<CartState>().addItem(call.arguments["id"])
      };

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
                onPressed: () => showDialog(
                    context: context,
                    builder: (ctx) => Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: RouteWidget("/view_cart"),
                        )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_basket),
                    locate<CartState>().builder<CartState>(
                        (context, value) => Text("${value.count}"))
                  ],
                ),
              ),
            ),
          )
        ],
      );
}

class CartView extends StatelessWidget {
  final String itemPreviewRoute;

  const CartView({required this.itemPreviewRoute});

  @override
  Widget build(BuildContext context) => locate<CartState>()
      .builder<CartState>((context, cartState) => cartState.items.length == 0
          ? Center(child: Material(child: Text("Nothing in cart")))
          : Material(
              child: Stack(
              children: [
                ListView.builder(
                    itemBuilder: (ctx, idx) => CartItem(
                          itemPreviewRoute: itemPreviewRoute,
                          id: cartState.items[idx],
                        ),
                    itemCount: cartState.items.length),
                CartActionButtons()
              ],
            )));
}

class CartActionButtons extends StatelessWidget {
  const CartActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            color: theme.colorScheme.primaryVariant,
            onPressed: () {
              /// Close the dialog
              Navigator.of(context).pop();

              /// Clear the cart
              locate<CartState>().clearCart();
            },
            child: Text(
              "Clear Cart",
              style: theme.textTheme.headline4!
                  .copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              color: theme.colorScheme.primary,
              onPressed: () {
                /// Message the system to start the checkout flow
                context.dispatchMethod("startCheckout");
              },
              child: Text(
                "Start Checkout",
                style: theme.textTheme.headline4!
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents a row in the "cart". Delegates to the Preview Routes
/// Shows "remove item" and quantity on stack.
class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.itemPreviewRoute,
    required this.id,
  }) : super(key: key);

  final String itemPreviewRoute;
  final int id;

  @override
  Widget build(BuildContext context) =>
      locateAndBuild<CartState>((ctx, state) => Container(
            height: 300,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: RouteWidget(
                    itemPreviewRoute,
                    args: {"id": id},
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Card(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          " x ${state.getQuantity(id)} ",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        MaterialButton(
                            onPressed: () => state.removeItem(id),
                            child: Text("remove"))
                      ],
                    ))),
              ],
            ),
          ));
}

class CartState extends ChangeNotifier {
  Map<int, int> _quantities = {};

  /// The items we are holding
  List<int> get items => _quantities.keys.toList();

  /// The quantity of an ID we are holding
  int getQuantity(int id) => _quantities[id] ?? 0;

  // To get # of Items in the cart (incl: quantities)
  int get count => _quantities.values
      .fold(0, (previousValue, element) => previousValue + element);

  // Ad an item to the cart
  void addItem(int id) {
    if (_quantities.containsKey(id) && _quantities[id] != null) {
      // Increment the count for this ID
      _quantities[id] = _quantities[id]! + 1;
    } else {
      _quantities[id] = 1;
    }

    notifyListeners();
  }

  // Remove 1 quantity of an item from the cart
  void removeItem(int id) {
    if (_quantities.containsKey(id) && _quantities[id] != null) {
      // Increment the count for this ID
      _quantities[id] = _quantities[id]! - 1;
      if (_quantities[id] == 0) {
        _quantities.remove(id);
      }
    }

    notifyListeners();
  }

  /// Clear the entire cart
  void clearCart() {
    _quantities.clear();
    notifyListeners();
  }
}
