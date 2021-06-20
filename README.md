# Dart Board
### An extensible flutter-framework

! [Demo](https://media3.giphy.com/media/Yo9eqMoEBYB1S45A92/giphy.gif)

## What does it do?

- Integrates `features`
- Provides an app foundation
- Provides structure to create re-usable features

## What comes with it?

As of now, some basic features are implemented with more to come.

- [Debug](features/dart_board_debug/README.md)
- [Image Background Decoration](features/dart_board_image_background/README.md)
- [Logging](features/dart_board_log/README.md)
- [Redux](features/dart_board_redux/README.md)
- [Theme](features/dart_board_theme/README.md)
- [Minesweeper](features/dart_board_minesweeper/README.md)

and it is all supported by 

- [Dart Board Core](core/dart_board_core/README.md) 

## Core 

Core provide integration and manages features. It is able to facilitate features like AB testing.

- Feature Loading
- AB Testing
- Feature Flags/Disabling
- Entry Point setup
- Named Navigation
- Helpful Widgets (General Utilities)
  - RouteWidget
  - Convertor<In, Out>
  - LifecycleWidget


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

