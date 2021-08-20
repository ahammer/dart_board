# Getting Started with Dart Board

This "blank" template in `integrations/blank` provides a good starting point with Dart-Board.

However you can also start from scratch.

This guide will work through "building" this blank template up
and then we'll proceed with it to make it a bit more full featured.

This guide has an expectation that you know the basics of Flutter and the Dart language.

## Initial Setup

### Option A) New Project

You want to create your own project from scratch.

1. `flutter create -t app [your_project_name]`
2. Edit the pubspec.yaml
   1. Set up your project description
   2. add `dart_board_core`, `dart_board_debug` and `dart_board_template_bottomnav`  (no versions) to your `dependencies:` block in your `pubspec.yaml`
   3. save file and run `flutter packages get` to retrieve the dependencies
3. Delete example/counter code
   1. Empty main.dart
   2. Delete tests
4. Install Dart Board in your main.dart.
   ```
   void main() => runApp(
       DartBoard(
           features:[DebugFeature()], 
           initial_route:"/debug"))
   ```

You can also reference the [main.dart](https://github.com/ahammer/dart_board/blob/master/integrations/blank/lib/main.dart)


This will give you a Flutter app that launches right into the built in debug().


### Option B) Port `Blank`

1. Copy `blank` from integrations into your own directory/project. Rename the directory to your project name. (e.g. `blank` -> `MyStore`)
2. Edit the pubspec.yaml and update the name, it should match the folder (i.e. `MyStore`)
3. Run and Build.


## The first 3 Features

Now I'll give a run down of the 3 Features used in "Blank" to give some scaffolding. If you chose option A, you should work to re-implement this code. If you chose option B, this will serve as a detailed explanation of these steps.

For this section, I'm going to recommend checking out each file and reading the comments, as it'll guide you through them in the most up to date way.

### RepositoryFeature

Provides a repository for the Listings and Details features to use. The repository can be easily mocked for test purposes.

The way this feature works is by providing a `DartBoardDecoration` to the `appDecorations` scope. This decoration uses `Provider`
to serve up a `Repository` interface that is supplied to the feature.

[repository_feature.dart](https://github.com/ahammer/dart_board/blob/master/integrations/blank/lib/features/repository_feature.dart)


### ListingsFeature

Provides the `/listings` route that shows the results

The way this feature works is by getting the repository and doing a `search` then putting the results in a `ListView`

[listing_feature.dart](https://github.com/ahammer/dart_board/blob/master/integrations/blank/lib/features/listing_feature.dart)


### DetailsFeature

Provides the `/details` route, and also provides app-level state to track the current selection.

[details_feature.dart](https://github.com/ahammer/dart_board/blob/master/integrations/blank/lib/features/details_feature.dart)


### How it all comes together.

The main ends up looking like this

```
void main() {
  runApp(DartBoard(
    features: [
      /// We load our repository with mock data
      RepositoryFeature(repository: MockRepository()),
      DetailsFeature(),
      ListingFeature(),
      DebugFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig)
    ],
    initialRoute: '/home',
  ));
}

/// Template Config for the BottomNav template
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

We have registered all of our features, include a Template we are going to mount at `/home`. This particular template composes multiple
routes into a single screen, (e.g. tabs with the bottom nav). You provide it a config and it's able to pull the `/listings` and `/details` routes provided by the application.

## Implementing some stories.

At this point you should have the app running. But lets say that we want to add a few new stories.

1. As a user I'd like to add items to a cart
2. As a user I'd like to be able to sign in with google
3. As a user I'd like to start a checkout flow

So lets work through these features together.

### Cart Feature

#### Overview

So a cart itself is going to have a few sub-tasks/components.

1. A cart should show as a floating action button when items are in it
2. Items should be able to be added to the cart on both screens
3. You should be able to view your cart

To do this, we are going to introduce a new `DartBoardFeature` this time we'll call it `CartFeature`

`CartFeature` will export some routes. 
- `/cart` To show the contents of a cart
- `/add_to_cart` To expose a add to cart button


It'll also need to export some *app state* for tracking the cart. For this we can use Locator to export a `CartState` class that keeps track of the items in the cart. To add locator we'll need to also add `dart_board_locator` to our pubspec.yaml

Then we need to show the UI, for this we'll add a PageDecoration that will display the Cart using a `Stack` widget, so we can overlay
the existing pages, and exclude it from other's later (like our login flow)

#### Implementation

1. Create the file and class

```
import 'package:dart_board_core/dart_board.dart';

class CartFeature extends DartBoardFeature {
  @override
  String get namespace => "Cart";
}
```

We want a new feature, with it's own namespace.

Next, we'll want to add the PageDecoration that will apply the cart.

`DartBoardDecoration` class is used to apply a decoration. To do this you provide a Builder function that also gives a Child `WidgetWithChildBuilder` aka `Widget function(BuildContext context, Widget child)`. The contract is that the child must be returned, but you can wrap it or "decorate" it.

For this, we'll want a widget that takes a child, applies it in a Stack with a button for the Cart.

```
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
                onPressed: () {},
                child: Icon(Icons.shopping_basket),
              ),
            ),
          )
        ],
      );
}
```

This widget puts a Floating Action Button, with a Shopping Basket in the bottom Right of the Screen.

To activate this widget in our application, first we need to add the pageDecoration to the `CartFeature` class

```
  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            name: "CartOverlay",
            decoration: (ctx, child) => CartOverlay(child: child))
      ];
```

Now is also a good time to register the Cart Feature. 

Go back to your `main.dart` and add `CartFeature()` to your lists of features. Restart your application and you should see the cart icon.



Currently, there is no State to this Cart though, and we are going to want to interact with it. Next lets create a model.

```
class CartState extends ChangeNotifier {
  int items = 0;
  void addItem() {
    items++;
    notifyListeners();
  }
}
```

Now to actually use the Locator, add `dart_board_locator` to your pubspec.yaml and fetch dependencies

And now to make an instance of this globally accessible, back in your `CartFeature` add the following.

```
  @override
  List<DartBoardDecoration> get appDecorations =>
      [LocatorDecoration(() => CartState())];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
```

This applies a `LocatorDecoration` in your feature at that app level, which can provide the `CartState` class. Simply use `Locate<CartState>()` and you'll get the global instance from anywhere.

Next we can hook that up to the UI

in our `FloatingActionButton` that lives in the `CartOverlay` class we created before, you can wire up to addItem now by replacing 
`onPressed:locate<CartState>().addItem` which will trigger the method.

underneath the shopping cart, we want to show a count. Ultimately our FloatingActionButton ends up looking like this.

```
FloatingActionButton(   
   /// Trigger the "Cart Counter" for now
   onPressed: locate<CartState>().addItem,
   child: Column(
   mainAxisSize: MainAxisSize.min,
   children: [
      Icon(Icons.shopping_basket),
      locate<CartState>().builder<CartState>(
         (context, value) => Text("${value.items}"))
   ],
   ),
)
```            

Of note is how we handle the updating.

```
locate<CartState>()
   .builder<CartState>((context, value) => Text("${value.items}"))
```

Is where that magic happens.

1) Locator finds your class
2) `.builder((ctx, value) => widget)` is a extension on ChangeNotifier. It automatically constructs a "RebuildingWidget" around it.
3) Each time it triggers a build, you show the new value.


Although, this is definitely not what we want the cart to do. It's nice to see it on a screen at this point and know that you can click and tap it.

From here, our goals shift to implementing some more useful features.

1) We want to actually get ID's and Quantities into our cart, of real items.
2) When the cart is triggered, we want to probably show it as a dialog/popup or another route.
3) We want the cart to be able to actually render each item as well.