# Getting Started with Dart Board
https://dart-board.io

This "starter" template in `integrations/starter` provides a good starting point with Dart-Board.

However you can also start from scratch.

This guide has an expectation that you know the basics of Flutter and the Dart language.

This guide is split into 2 main sections. The first being *Initial Setup* which covers creating a new project and working through it's setup. The second part is *Feature Development* where we will walk through adding a decoupled Cart Feature to the application.

This tutorial is definitely not about making a pretty app. It does not preclude you from making a beautiful app, but I won't be painting the shed here at all. This is about structure of Dart Board


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

You can also reference the [main.dart](https://github.com/ahammer/dart_board/blob/master/integrations/starter/lib/main.dart)


This will give you a Flutter app that launches right into the built in debug().


### Option B) Port `starter`

1. Copy `starter` from integrations into your own directory/project. Rename the directory to your project name. (e.g. `starter` -> `MyStore`)
2. Edit the pubspec.yaml and update the name, it should match the folder (i.e. `MyStore`)
3. Run and Build.


## The first 3 Features

Now I'll give a run down of the 3 Features used in "starter" to give some scaffolding. If you chose option A, you should work to re-implement this code. If you chose option B, this will serve as a detailed explanation of these steps.

For this section, I'm going to recommend checking out each file and reading the comments, as it'll guide you through them in the most up to date way.

### RepositoryFeature

Provides a repository for the Listings and Details features to use. The repository can be easily mocked for test purposes.

The way this feature works is by providing a `DartBoardDecoration` to the `appDecorations` scope. This decoration uses `Provider`
to serve up a `Repository` interface that is supplied to the feature.

[repository_feature.dart](https://github.com/ahammer/dart_board/blob/master/integrations/starter/lib/features/repository_feature.dart)


### ListingsFeature

Provides the `/listings` route that shows the results

The way this feature works is by getting the repository and doing a `search` then putting the results in a `ListView`

[listing_feature.dart](https://github.com/ahammer/dart_board/blob/master/integrations/starter/lib/features/listing_feature.dart)


### DetailsFeature

Provides the `/details` route, and also provides app-level state to track the current selection.

[details_feature.dart](https://github.com/ahammer/dart_board/blob/master/integrations/starter/lib/features/details_feature.dart)


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
2. As a user I'd like to start a checkout flow

So lets work through these features together.

### Cart Feature

Here we will go about "adding" a cart. I've already taken the liberty of coding it up and including it in `cart_feature_complete.dart`
which can be used for reference. As you can see by running the `starter` template, the Cart is already activated, but can be easily removed.

#### Removal of existing `cart` to start this tutorial

1) Remove the import in main.dart
      DELETE: `import 'features/cart_feature_complete.dart';`
2) Remove the feature from the DartBoard registration
      DELETE: `CartFeature(itemPreviewRoute: "/details_by_id"),`

Then start working to rebuild the feature, using this guide and the completed code as a reference to help you work through it. This will help give an understanding on how to build fully decoupled features. This guide is not guaranteed to get you 100% up to where `cart_feature_complete.dart` exactly character by character, but it should get you close. This is definitely written for someone who can follow Dart and Flutter and is not a tutorial of basic concepts like widgets.

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
  int count = 0;
  void addItem() {
    count++;
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
         (context, value) => Text("${value.count}"))
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


Lets start by getting actual item's into the cart. For this I'm going to expose a `MethodCall` api in our feature.

The reason we use MethodCall instead of classes directly is that it increases decoupling. In this case if the Cart
isn't enabled we can handle the call in another way. Additionally we can throw errors or check if a method call is
available before we use it.

To enable one in our `CartFeature` add the following

```
  @override
  Map<String, MethodCallHandler> get methodHandlers =>
      {"addItemToCart": (ctx, call) async => locate<CartState>().addItem()};
```

This will let us call DartBoard and invoke this method, which can call the addItem method.

Now we can connect this to the listings page.

In `_ListingsScreenState` where we build the list, we are going to upgrade the photo.

We are going to place the existing photo in a Stack, and show an "AddToCart" button on top.

```
                          Stack( // <-- New
                            children: [
                              /// Existing
                              Container(
                                width: 200,
                                height: 200,
                                child: Material(
                                  elevation: 2,
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: data[idx].image_url,
                                    fit: BoxFit.cover,
                                    width: 200,
                                  ),
                                ),
                              ),
                              /// New
                              Card(
                                  child: InkWell(
                                      onTap: () {
                                        DartBoardCore.instance
                                            .dispatchMethodCall(
                                                context: context,
                                                call: MethodCall(
                                                    "addItemToCart"));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Add"),
                                      )))
                            ],
                          ),
```

In this case, we are adding a Card and InkWell we can tap, and putting it over the Image with the text "Add".

When tapping the inkwell, we dispatch the method and items added to the cart.

We still need to add item's though, so lets add some data.

For that, lets update the addItemToCart to include a index.
```
   DartBoardCore.instance
      .dispatchMethodCall(
         context: context,
         call: MethodCall(
               "addItemToCart",
               {"id": data[idx].id})); // < Add to Method Call
```

Then we can hope back into `CartState` and update it to handle this addition to it's API

```
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
```

This class now represents a more full features `CartState`. It tracks a map of id:quantity values. You can addItem/removeItem/clearCart and get the count or quantity of any item's, or a list of item's by their ID's.


We have `onPressed: locate<CartState>().addItem`  in the handler of our Floating action button, but it's no longer `Function()`
so we can't directly assign it to the handler.

We can swap that with `onPressed: () => showDialog(context: context, builder: (ctx)=>Text("Placeholder")),` to get Ready to show a dialog that we'll implement shortly.


Finally our methodHandler needs an update to `addItem()` since it expects an item ID. In the steps above we pass that through
the `MethodCall` arguments: `{"id": data[idx].id}`. We can update addItem to pull that in.


```
  @override
  Map<String, MethodCallHandler> get methodHandlers => {
        "addItemToCart": (ctx, call) async =>
            locate<CartState>().addItem(call.arguments["id"])
      };
```

We are just going to pass that ID into addItem to update our Cart State.

Hopefully, all the red is gone now, and we can run the app again.

This should all run, you should be able to add items from the list view. The count should update. However if you click the Cart an unstyled dialog will block the screen. Since we have state backing the UI now we can fill in that part as well.

Back to `CartOverlay` class and that `showDialog()` we added a above. It's time to create a widget for that. We can also grant the ability for decoupled, distant features to use the route to display the cart. We'll add a `CartView` widget, register the route, and integrate it with the popup next.

In your `CartFeature` to expose the route.

```
  @override
  List<RouteDefinition> get routes => [
        /// Register the route for "viewing the cart"
        NamedRouteDefinition(
            route: "/view_cart", builder: (settings, ctx) => const CartView())
      ];
```

And the CartView itself, for now is simple. ID and Quantity is displayed. 
```
class CartView extends StatelessWidget {
  const CartView();

  @override
  Widget build(BuildContext context) =>
      locate<CartState>().builder<CartState>((context, cartState) => Card(
          child: ListView.builder(
              itemBuilder: (ctx, idx) {
                final id = cartState.items[idx];
                final quantity = cartState.getQuantity(id);
                return Text("ID: $id       Quantity: $quantity");
              },
              itemCount: cartState.items.length)));
}
```

And finally, we want it in our Dialog. So find the `showDialog(...)` call we put in the `FloatingActionButton` in our `CartOverlay`

Update it with the following to show that `/view_cart` route we just exposed. You can also use the Widget directly, since it is 
part of your feature, but we'll use RouteWidget for a few features as we go.

```
showDialog(
   context: context,
   builder: (ctx) => Padding(
         padding: const EdgeInsets.all(24.0),
         child: RouteWidget("/view_cart"),
      ))
```

Now you should be able to run it and you should see the cart icon, be able to add items, click it, and see some items printed to the screen.

Here is where we hit a bit of a dilemma. At this point the next logical feature would be to build a row-summary UI. However the problem is that the `CartFeature` doesn't know about `ListingFeature`. We don't want to spaghetti the two together. The Cart and Listing features are different problem scopes. How are we going to get the Listings feature to satisfy the needs of the Cart feature without directly coupling them?

For this, we are going to lean back on some of the concepts we've covered already. `RouteDefinitions`, `RouteWidget` and `MethodHandlers`. We can expose a route in our Listing view that fulfills a contract. E.g. (Show a Listing with {id:id}), and we can pass that Route's name to our feature when we configure it. 

To wire this up, first we'll stub it. We will add a field and constructor for `itemPreviewRoute` in our CartFeature. This route will expect a map of arguments with `{id:id}` and it should render the preview on it's own. The Stub will just simply show the ID, and we can bound it via the the `routes` in your feature.


Our new route is as defined for now. It simply echo's the arguments. This will let us confirm they are correct.
```
   NamedRouteDefinition(
      route: "/stub_item_preview",
      builder: (settings, ctx) => Text("${settings.arguments}"))
```

Then we hop over to our Cart View and it's time for some refactors. We want can finish up the CartView now.

1) I'm going to put a list of items/quantities, with buttons that overlay it to Clear and Submit the cart.
2) 


```
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
```


This also introduces 2 new Widgets for refactoring, because I don't want CartView to get out of hand. `CartItem` and `CartActionButtons`

```
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
                      " x ${locate<CartState>().getQuantity(id)} ",  // <--- Show the Quantity
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    MaterialButton(
                        onPressed: () => locate<CartState>().removeItem(id), // <--- Show and write the "Remove" button
                        child: Text("remove"))
                  ],
                ))),
          ],
        ),
      );
}
```

As for the `CartActionButtons`, we are going to put 2 buttons in the bottom right of the frame. 

The `Start Checkout` button will dispatch the `startCheckout` method which can then pass the torch to another feature.

The `Clear Cart` button does exactly that, and pops the view so you go back to where you came from.

```

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
                DartBoardCore.instance.dispatchMethodCall(
                    context: context, call: MethodCall("startCheckout"));
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


Lastly need to update the Feature to also take in the `itemPreviewRoute` so that the CartView knows what to inflate.

For, that, we'll want to update our CardFeature a bit.

```

class CartFeature extends DartBoardFeature {
  final String itemPreviewRoute; // <--- Allow Config to assign this preview route

  CartFeature({this.itemPreviewRoute = "/stub_item_preview"}); // <--- Set the default to the stub

  @override
  String get namespace => "Cart";

  @override
  List<RouteDefinition> get routes => [
        /// Register the route for "viewing the cart"
        NamedRouteDefinition(
            route: "/view_cart",
            builder: (settings, ctx) =>
                CartView(itemPreviewRoute: itemPreviewRoute)), // <--- Give the feature configuration to the named route.
```

Now when you run it, it should give you the built in Stub to echo the args and ensure they are correct.

We do however want to show a real preview, so for that we'll just use the Details Feature to fulfill the contract. For this, I'll use the "/details_by_id" route that is exposed in the `details_feature.dart`. 

To specify the config is easy. Just go back to your `main.dart` and give the route to the feature when you create it.

`CartFeature(itemPreviewRoute: "/details_by_id")`

Now when you run it all, you should be able to see The cart, click the icon, see the items with a preview that matches the detail page.

Congrat's, at this point your CartFeature is **done** congratulations. At least for this tutorial. There is one final step though. We left the checkout dangling. We dispatch a method, but we don't do anything with it. This is a great entry point into another feature.

In this case, `MockCheckoutFeature` will be created and registered with the DartBoard() widget, this will be able to accept the method
and proceed with checkout. For out Mock/Stub, we'll just be showing a SnackBar to acknowledge we saw it, and popping the checkout dialog from the navigator.

```
class MockCheckoutFeature extends DartBoardFeature {
  @override
  String get namespace => "Checkout";

  @override
  Map<String, MethodCallHandler> get methodHandlers => {
        "startCheckout": (context, call) async {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Checkout Flow Triggered')));
        }
      };
}
```


**Congratulations**. If you made it this far. You've completed the Dart Board tutorial. Have fun crafting. This covered a vast range of the tools at your disposal to create and encapsulate your features and minimize their dependencies. Our little `CartFeature` implemented during this portion of the excercise has 0 direct dependencies on Listings/Details or Repository, despite leveraging them for integration. This feature could be moved to it's own module, and via mocked interfaces and stubs can be developed 100% independently of other features.

Footnote:

This tutorial was organized in a way to cover a lot of topics very quickly, but there are a few "best" practices I'd like to encourage of feature developers.

1) No magic numbers/strings. I know I use them extensively but it's preferred to have config stored in the feature and passed to the children. E.g. for the row-height of the cart-preview or any hard coded strings. This can go as far as configuration options for route, implementation name, namespace etc. It will give you the ability to load the feature more than once if necessary. For example, templates have configurations that allow them to be registered multiple times without conflict.

2) You can have hard and soft dependencies. In the case of Listing/Details features, they both have a hard dependency on repository. This means the code doesn't need indirection. The feature can directly provide code and widgets. Soft features are features like Cart, that don't know about the repository or the details screen, even though they use those features indirectly. Hard features are harder to swap, but in some cases are the right approach. E.g. with a repository, using methodCall would be burdensome if you need access to models. 

Having a soft feature will lessen the amount of dependencies you have, but increase the complexity of your contract between features. There isn't a right or wrong way here. Generally though, soft features whenever viable, and hard features if they have a strong general use case (models, business logic, repositories), or provide framework features (e.g. decorations) for a feature to use.

3) Resolving and configuring dependencies. It's first-come first serve. So in the case of something like the RepositoryFeature() that is defined as a dependency in listing/details feature with the MockRepository(), if you define ReposityFeature(repository: YourRepository()), in the main before Listing/Details feature are loaded, it will take that config. The fact that it's registered as a dependency twice just mean's it's ignored the second time it's seen.

4) I recommend breaking features into flutter modules (don't build a monolithic feature pile). Use pub (git dependencies + melos recommended) to scope your hard and soft dependencies. Your integration/app project should bring in features and contain config, but ideally not contain features itself (outside of an integration feature). The features themselves should be scoped down as much as possible. While the "starter" feature does shoehorn a bunch of features together, things should be more like `PlayGround` where the actual features are brought in, and all that is in the Main.dart is essentially config and feature selection. 

5) I also recommend that each runner/app uses an "Integration" feature, similar to `PlayGround`. Using an integration features can be looked at as the "wiring interface" for the app.


