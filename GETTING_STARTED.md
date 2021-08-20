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