# Getting Started with Dart Board

## Run the workspace

Use Flutter 3.29.3 (Dart 3), the version used by CI. From the repository root:

```bash
flutter pub global activate melos 6.3.2
melos bootstrap
melos exec --dir-exists=test -- flutter test --coverage
```

Run the playground on Linux:

```bash
cd integrations/example
flutter run -d linux
```

Melos links the packages in this checkout through `pubspec_overrides.yaml`.
Keep the starter app inside the workspace while learning: copying only
`integrations/starter` elsewhere leaves those relative dependency paths pointing
at missing directories. To make a standalone app, remove the workspace overrides
and select compatible published dependencies, or provide paths to your own checkout.

## Create a feature

In an app with `dart_board_core` as a dependency, this complete `main.dart` defines
a route and opens it:

```dart
import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';

class HelloWorldFeature extends DartBoardFeature {
  @override
  String get namespace => 'HelloWorld';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/hello_world',
          builder: (context, settings) => const Scaffold(
            body: Center(child: Text('Hello World')),
          ),
        ),
      ];
}

void main() => runApp(DartBoard(
      features: [HelloWorldFeature()],
      initialPath: '/hello_world',
    ));
```

`namespace` identifies a feature. Features sharing a namespace can provide different
`implementationName` values; one implementation is active at a time. Use
`featureOverrides` to select an implementation, or `null` to disable a namespace.
Dependencies are registered before the features that depend on them.

## Learn from the starter app

The [starter entry point](integrations/starter/lib/main.dart) combines these working examples:

| Feature | What it demonstrates |
| --- | --- |
| [Repository](integrations/starter/lib/features/repository_feature.dart) | Registering a shared service with `DartBoardLocatorFeature` and `LocatorDecoration`. |
| [Listing](integrations/starter/lib/features/listing_feature.dart) | Reading the repository and exposing `/listings`. |
| [Details](integrations/starter/lib/features/details_feature.dart) | Passing route arguments and displaying an item. |
| [Cart](integrations/starter/lib/features/cart_feature_complete.dart) | `ChangeNotifier` state, a page overlay, embedded routes, and an `addItemToCart` method handler. |
| [Checkout](integrations/starter/lib/features/mock_checkout_feature.dart) | Handling the cart's `startCheckout` method call. |

Use these source files together with the starter's `pubspec.yaml` for a runnable
cart example. Its `main.dart` also shows `BottomNavTemplateFeature` configuration.

## Compose features

Declare required services in a feature's `dependencies`. Use `appDecorations` to
install providers around the app, and `pageDecorations` for page-level UI.
`RouteWidget('/route', args: arguments)` embeds another feature's route.
Method handlers let features communicate without importing one another's state.

For larger integrations, place the feature list and configuration in one top-level
feature, as in [ExampleFeature](integrations/example/lib/example_feature.dart).
See the [Feature Guide](FEATURE_GUIDE.md) for the available packages and APIs.
