# Dart Board
### An extensible flutter-framework

! [Demo](https://media3.giphy.com/media/Yo9eqMoEBYB1S45A92/giphy.gif)

## Summary

Dart Board lets you combine and build features to integrate into a larger app. 

## How it works?

```
void main() => runApp(DartBoard(
  features:[YourIntegration()], 
  initialRoute: '/main']))
```


When you Launch your app, you Launch DartBoard() widget, provide it your Features and your initial route and you are good to go.

Dart board loads your features and installs them as you go.

## What is a Feature?

In Dart Board, everything is a Feature. It can be an Atomic feature with no dependencies, or can be an integration of multiple other features.

Features will expose screens and API's that you can use within other features.

For example, a feature can do the following.
- Decorate the App or Page
- Provide Named Routes

Decorations are widgets injected at the App or Page level. They can be UI or non  UI components.   


## What is Dart Board Core 

Core provide integration and manages features. It is able to facilitate features like AB testing. The `DartBoard` widget will serve the trunk when working with Dart Board.

- Feature Loading
- AB Testing
- Feature Flags/Disabling
- Entry Point setup
- Named Navigation
- Helpful Widgets (General Utilities)
  - RouteWidget
  - Convertor<In, Out>
  - LifecycleWidget


## How is an App Built?

In Dart Board the app is run by launching an integration Feature with a named entry point.

The integration feature specifies the other Features you use, Configure's them and allows you to run it.


## What features are included?

As of now, some basic features are implemented with more to come.

- [Debug](features/dart_board_debug/README.md)

Provides a /debug route to play with the internals/registry.

- [Image Background Decoration](features/dart_board_image_background/README.md)

A simple example to provide a global image background that spans all pages.

- [Logging](features/dart_board_log/README.md)

Basic logging features, including a Log Footer and `/log` route + overlay.

- [Redux](features/dart_board_redux/README.md)

Flutter Redux Bindings. Provides features a consistent way to use a shared Redux store in a feature agnostic way.

Provides a AppDecoration API + Function API to Create and Dispatch states.

- [Locator](features/dart_board_locator/README.md)

Object/Service Locator Framework. Lazy loading + Caching. App Decoration based API to register types and services to the App.



- [Theme](features/dart_board_theme/README.md)

Light/Dark Theming, very basic at the moment.

- [Minesweeper](features/dart_board_minesweeper/README.md)

You probably don't need it. But provides a `/minesweep` route. Deeper example of `dart_board_redux` use case in action.

- [Dart Board Core](core/dart_board_core/README.md) 

The Core Framework. Everything brings this in. It provides basic general flutter utilities and the `DartBoard` widget. 

## Repo Structure

### core

Contain's core framework features. Currently 1 library. dart_board_core

### features

Contain's reusable features that can be included in your integrations (or other features)

### templates

Contain's features that are designed to be UI templates

They are pre-made templates that get filled in via config.

- Configurable Route
- Configurable Feature Name
- UI Config (e.g. Embedded Route Names, or Widgets, etc).

The idea being that you should be able to register a Temlate multiple times, for multiple screens with varying configs.

You access the template by navigating to the route you select.

### integrations

This is a place to see Integrations of multiple features into a larger app.

The only "example" right now is dart-board.io website, and the official example for the platform

