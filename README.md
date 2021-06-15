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


## Features

Features all implement DartBoardFeature class. They can include other features in their usage.

## How to use it?



or play with the sample at [dart-board.io](https://dart-board.io)



### Why 0.9.x for now

I think the API and basic features are complete for a 1.0 release.

However, until test coverage it won't be marked 1.x. Use at your own risk.

Tests will come soon, or feel free to contribute.
