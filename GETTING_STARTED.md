# Getting Started with Dart Board

This guide will help you understand how to create and organize applications using the Dart Board architecture. Whether you're starting from scratch or using the starter template, you'll learn how to create decoupled features that work together in a modular application.

## Prerequisites

- Basic knowledge of Flutter and Dart
- Flutter SDK installed and configured

## Development Setup

If you're working directly with the Dart Board repository, you'll need to set up Melos to link packages locally:

```bash
# Install Melos globally
flutter pub global activate melos

# From the repository root, bootstrap all packages
melos bootstrap
```

## Starting a New Project

### Option 1: From Scratch

1. Create a new Flutter project:
   ```bash
   flutter create -t app my_dart_board_app
   ```

2. Add the core dependencies to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     dart_board_core: ^0.9.17
     dart_board_debug: ^1.3.0  # Optional but helpful for debugging
   ```

3. Run `flutter pub get` to fetch dependencies

4. Replace your `main.dart` with a minimal Dart Board setup:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:dart_board_core/dart_board_core.dart';
   import 'package:dart_board_debug/debug_feature.dart';

   void main() {
     runApp(DartBoard(
       features: [DebugFeature()],
       initialRoute: '/debug',
     ));
   }
   ```

5. Run your app, which will launch directly into the built-in debug panel

### Option 2: Using the Starter Template

1. Clone the Dart Board repository:
   ```bash
   git clone https://github.com/ahammer/dart_board.git
   ```

2. Copy the `integrations/starter` directory to your own project location
   
3. Rename the directory to your project name

4. Update the `pubspec.yaml` file to match your project name

5. Run `flutter pub get` and then build/run the app

## Understanding the Starter Project Structure

The starter project includes three core features:

### Repository Feature

Provides a data repository that other features can access. This demonstrates how to create a shared service that multiple features can depend on.

```dart
// Simplified example from repository_feature.dart
class RepositoryFeature extends DartBoardFeature {
  @override
  String get namespace => "Repository";
  
  @override
  List<DartBoardDecoration> get appDecorations => 
      [LocatorDecoration(() => YourRepository())];
}
```

### Listings Feature

Provides a route to display a list of items from the repository:

```dart
// Simplified example from listing_feature.dart
class ListingFeature extends DartBoardFeature {
  @override 
  List<RouteDefinition> get routes => [
    NamedRouteDefinition('/listings', 
      (context, settings) => ListingsScreen())
  ];
  
  @override
  List<DartBoardFeature> get dependencies => [RepositoryFeature()];
}
```

### Details Feature

Provides a route to display details for a selected item:

```dart
// Simplified example from details_feature.dart
class DetailsFeature extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
    NamedRouteDefinition('/details', 
      (context, settings) => DetailsScreen()),
    NamedRouteDefinition('/details_by_id', 
      (context, settings) => DetailsById(id: settings.arguments['id']))
  ];
  
  @override
  List<DartBoardFeature> get dependencies => [RepositoryFeature()];
}
```

## Building Your First Feature

Let's create a simple feature that adds a cart functionality to the app.

### 1. Create a Cart Feature

Create a new file `lib/features/cart_feature.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_locator/dart_board_locator.dart';

class CartFeature extends DartBoardFeature {
  final String itemPreviewRoute;
  
  CartFeature({this.itemPreviewRoute = "/stub_item_preview"});
  
  @override
  String get namespace => "Cart";
  
  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
  
  @override
  List<DartBoardDecoration> get appDecorations => 
      [LocatorDecoration(() => CartState())];
  
  @override
  List<DartBoardDecoration> get pageDecorations => [
    DartBoardDecoration(
      name: "CartOverlay",
      decoration: (ctx, child) => CartOverlay(
        child: child, 
        itemPreviewRoute: itemPreviewRoute
      )
    )
  ];
  
  @override
  List<RouteDefinition> get routes => [
    NamedRouteDefinition(
      route: "/view_cart", 
      builder: (ctx, settings) => CartView(itemPreviewRoute: itemPreviewRoute)
    ),
    NamedRouteDefinition(
      route: "/stub_item_preview",
      builder: (ctx, settings) => Text("${settings.arguments}")
    )
  ];
  
  @override
  Map<String, MethodCallHandler> get methodHandlers => {
    "addItemToCart": (ctx, call) async => 
        locate<CartState>().addItem(call.arguments["id"])
  };
}
```

### 2. Create a Cart State

```dart
class CartState extends ChangeNotifier {
  Map<int, int> _quantities = {};

  List<int> get items => _quantities.keys.toList();
  int getQuantity(int id) => _quantities[id] ?? 0;
  int get count => _quantities.values.fold(0, (prev, qty) => prev + qty);

  void addItem(int id) {
    _quantities[id] = (_quantities[id] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(int id) {
    if (_quantities.containsKey(id)) {
      _quantities[id] = _quantities[id]! - 1;
      if (_quantities[id] == 0) {
        _quantities.remove(id);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _quantities.clear();
    notifyListeners();
  }
}
```

### 3. Create UI Components

```dart
class CartOverlay extends StatelessWidget {
  final Widget child;
  final String itemPreviewRoute;

  const CartOverlay({
    Key? key, 
    required this.child,
    required this.itemPreviewRoute
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: locate<CartState>().builder<CartState>(
            (context, cartState) => cartState.count > 0 
              ? FloatingActionButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: RouteWidget("/view_cart"),
                  )
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_basket),
                    Text("${cartState.count}")
                  ],
                ),
              )
              : SizedBox.shrink(),
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
    .builder<CartState>((context, cartState) => cartState.items.isEmpty
      ? Center(child: Material(child: Text("Nothing in cart")))
      : Material(
        child: Stack(
          children: [
            ListView.builder(
              itemBuilder: (ctx, idx) => CartItem(
                itemPreviewRoute: itemPreviewRoute,
                id: cartState.items[idx],
              ),
              itemCount: cartState.items.length
            ),
            CartActionButtons()
          ],
        )
      )
    );
}

class CartItem extends StatelessWidget {
  final String itemPreviewRoute;
  final int id;

  const CartItem({
    Key? key,
    required this.itemPreviewRoute,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
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
                  " x ${locate<CartState>().getQuantity(id)} ",
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(
                  onPressed: () => locate<CartState>().removeItem(id),
                  child: Text("remove")
                )
              ],
            )
          )
        ),
      ],
    ),
  );
}

class CartActionButtons extends StatelessWidget {
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
              Navigator.of(context).pop();
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
                DartBoardCore.instance.dispatchMethodCall(
                  context: context, 
                  call: MethodCall("startCheckout")
                );
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
```

### 4. Register the Feature

Update your `main.dart` to include the new Cart feature:

```dart
import 'package:flutter/material.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_template_bottomnav/bottomnav_template_feature.dart';
import 'features/repository_feature.dart';
import 'features/listing_feature.dart';
import 'features/details_feature.dart';
import 'features/cart_feature.dart';

void main() {
  runApp(DartBoard(
    features: [
      DetailsFeature(),
      ListingFeature(),
      CartFeature(itemPreviewRoute: "/details_by_id"),
      DebugFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig)
    ],
    initialRoute: '/home',
  ));
}

const _templateConfig = [
  {
    'route': '/listings',
    'label': 'Search',
    'color': Colors.blue,
    'icon': Icons.search
  },
  {
    'route': '/details',
    'label': 'Details',
    'color': Colors.red,
    'icon': Icons.file_present
  }
];
```

## Feature Development Best Practices

### 1. Keep Features Small

Focus each feature on a single responsibility. Smaller features are easier to develop, test, and debug.

### 2. Develop in Isolation

Build and test each feature independently before integrating it into the larger application. This approach produces more portable code and simplifies debugging.

### 3. Use Loose Coupling

When features need to interact, prefer using:

- **Method Calls**: For service-like interactions without direct dependencies
- **Route Widgets**: For embedding UI components from other features
- **Locator**: For shared services and state

### 4. Configuration Over Code

Design features to be configurable through their constructors rather than hardcoding behaviors. This enables flexibility when integrating with different applications.

### 5. Feature Organization

Consider organizing larger projects with:

- **Integration Feature**: A top-level feature that composes and configures other features
- **Core Features**: Foundation services and utilities
- **UI Features**: Components and screens
- **Business Features**: Domain-specific functionality

## Next Steps

- Explore the [example app](integrations/example) to see more complex features in action
- Read the [FEATURE_GUIDE.md](FEATURE_GUIDE.md) for detailed information about available features
- Check out the [API documentation](https://pub.dev/documentation/dart_board_core/latest/) for more advanced usage
