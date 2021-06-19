# dart_board

A feature management framework for flutter

### Feature management, what is that?

It's a way of isolating features so that they can be managed. E.g. Mix and match/AB Test/Disable at run time or build time.

It provides architectural guidance and structure so that you can cleanly build an app.

While providing structure on how to integrate and isolate features, Dart Board is agnostic when it comes to actual 
state management of architectural patterns of the features themselves.

Even existing projects can be easily ported to love within a Dart Board Feature.

## Getting Started

*NOTE: Still not released, these instructions are preliminary/TBD*

### App Developer

- Make a new flutter app project `flutter create -t app --platforms=android,ios,web,linux,macos,windows your_project`
- Add dart_board to your `pubspect.yaml`
- Extend `DartBoardFeature` to create an *integration feature*
- Add a `/` or `/main` or any other appropriate entry point to your feature
- `main() => runApp(DartBoard(features:[YourIntegrationFeature()], initialRoute:'/main'));`

That's it, you should be ready to add more features to your app. 

You can play around with the framework by adding `Page/App Decoration` and `Routes` to your integration extension. It's recommended though to try and isolate your features and keep them small. For example, if you have a Search feature and 2 UI's you might want a `SearchManager` feature, and then `SearchUI_VariantA` and `SearchUI_VariantB` that can bring `SearchManager` in as a dependency. This would let you trivially swap UI's on a shared backend.  Each feature holds 1 small part. The data/api for searching, and 1 UI each for the feature, bound to a route (e.g. */search*)


### Feature Developer
- Make a new flutter module or plugin project (e.g. `flutter create -t module my_feature)
- Add *Dart Board* to your `pubspec.yaml`
- Create your Feature
- To test your feature, you can use the Module and it's own `main.dart`. 
- Recommended to make an `example` for each feature, following the *App Developer* steps above.


Setting up an Example will let you instrument your Feature and also enable Features you would not want to ship with your feature. (e.g. DebugFeature, LogFeature).

Generally it's a good idea to also set up routes dedicated to development tasks and portions of the app, since you can change the initialRoute in the main, it's easy to jump around parts of a feature while doing development.

### Porting/Adapting existing libraries
- Extends DartBoardFeature
- Provide routes (NamedRouteDefinition is the current only supported option)
- Create an AppDecorator widget to define app level state.
- Create any PageDecorators to decorate the named routes

At this point a user of your Feature can navigate to your route with RouteWidget or pushNamed()
If necessary, the Feature can provide additional API to interact with it's app state via the tree.

Routes do not need to be used full-screen by integrators, they can also use RouteWidget anywhere in the UI tree

## How it works
You give it extensions, it unwraps, sorts and organizes them, then injects them back into your app.

First it walks the dependency tree and collects an ordered list of what to init.

It then collects all the routes and decorations. It creates the MaterialApp()
for you, and sets up the routing and decoration features, as well as injecting all your App Decoration's near the trunk of the Tree.

From here, you can use named routing to access any registered feature route, or
RouteView. Additionally features can provide API's to the app and page level components.

## Some things to try in this Example
- Play with the Debug Screen (Caution, you can break the app if you disable something you need).
- Play MineSweeper
- Read the Documentation (This File + Example Readme + Selected Files)

## What is in the Repo
### ./dart_board

The core framework, brought in by all Features and Apps

### ./example

The integration example, documentation of all features.
visible at https://dart-board.io

### ./features/dart_board_debug

Debug feature. Includes the /debug route that gives you insight into DartBoard
and it's current integration.

It also allows you to toggle variants of features, and disable features at run time.

### ./features/dart_board_log

Basic logging features. Includes a PageDecoration that will show the last log message
as a toolbar.

Tapping the toolbar will open the larger log.

### ./features/dart_board_minesweeper

A minesweeper implementation in Dart. This is a standalone redux application. It's been ported
to a feature container so that you can play Minesweeper, and persist it's state through the app.

### ./features/dart_board_theme

Minimal theming feature, supports a boolean for light/dark


## How to help.

1) Contribute via Patreon (https://www.patreon.com/AdamHammer), pledging support 
2) Contribute Code
  - New features (E.g. Auth would be a huge next target)
  - Build out core features (Log, Debug, Theme) could all use significant work.
  - Tests (I'll get to them eventually, but if you want to help, please do)