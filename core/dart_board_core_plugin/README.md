# dart_board_core_plugin

Plugin Interface for Dart Board

Just Dart Board + Custom Android code for Add2App integrations

If you are using Add2App you can include this along side Core to gain access to useful platform interfaces for navigation and screen launching.

## Usage

1. Register `DartBoardAdd2AppFeature()` in your DartBoard Features list
2. `DartBoardNav.launchRoute(this,"/your_route")` to show flutter in Android

## Installation

Refer to Add2App for exact instructions, but in short for Android

1. Create a flutter module in your android project.
2. In your `settings.gradle` include the `flutter_module/.android/include_flutter.groovy` file
3. Include `:flutter` dependency in your projects build.gradle

Your flutter_module should run DartBoard. The initial route does not matter for Add2App

The `launchRoute()` will give you a clean stack with that route at the root of your nav when it launches flutter.

