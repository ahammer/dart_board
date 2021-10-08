# Dart Board Add2App Example

* Android Only, for now *

This module is the core-plugin, for more reference see
https://github.com/ahammer/dart_board_add2app

For an example.


## Adding Flutter to your DartBoard app

Googles Guide - https://flutter.dev/docs/development/add-to-app

1) Create a Flutter Module in your Host repo (Android or iOS)

- `flutter create -t module flutter_module`
- You can bring in your Features from another repo via Git or Pub
- This project should contain config/registration but no features itself


2) Configure the project's `pubspec.yaml` to bring in your features

```
dependencies:
  flutter:
    sdk: flutter

  dart_board_core:
  dart_board_core_plugin:
  dart_board_spacex_ui:
  dart_board_minesweeper:
  dart_board_spacex_plugin:
    git:
      url: https://github.com/ahammer/dart_board.git
      path: features/dart_board_spacex_feature/dart_board_spacex_plugin
```

Bring in `dart_board_core`, `dart_board_core_plugin` and any features you are using.


3) Configure you `main.dart` entry point

```
import 'package:dart_board_core_plugin/dart_board_core_plugin.dart';
import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';
import 'package:dart_board_spacex_plugin/spacex_plugin_feature.dart';
import 'package:dart_board_spacex_ui/spacex_ui_feature.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_core/dart_board.dart';

void main() {
  runApp(DartBoard(
    features: [
      MinesweeperFeature(),
      SpaceXUIFeature(),
      Add2AppFeature(),
      SpaceXPluginFeature()
    ],
    initialPath: '/minesweep',
  ));
}
```

For add2app, the initialPath does not matter, as you request an path when you launch a flutter screen.

However, at this point you can run the module directly to test it (e.g. verify the routes work).

The `Add2AppFeature()` is critica for this to work. It provides the bindings for Navigation within DartBoard. 

4) Add flutter to your main Android Project.

Recommended Approach: https://flutter.dev/docs/development/add-to-app/android/project-setup#option-b---depend-on-the-modules-source-code

5) (Optional/Recommended) Warm Up the Engine

The Flutter Engine is where Flutter runs. Think of it as a phone inside your phone or an app inside your app. There is some startup cost but you can hide it by warming the engine. This will also allow you to use Headless flutter (e.g. Pigeon calls) without displaying flutter on the screen.


```
class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        DartBoardCorePlugin.warmup(this)
    }
}
```

Congrats, you are now full integrated. The following tips will explain how to actually use it.

## Navigation

`DartBoardCorePlugin.launchScreen(context, path)`

This will Launch `DartBoardFlutterActivity` and Navigate flutter to the corresponding path. It will provide you with a clear nav stack.

If you want to exit (e.g. with a button) use `SystemNavigator.pop()` at any time. E.g. with a leading back button on the entry point.

The system back button should transparently work between your flutter and native nav stacks.

## Pigeons

Pigeon: https://pub.dev/packages/pigeon

Pigeon is a library that marshalls and unmarshalls requests between the host app and flutter. You can think of it like "RetroFit" for flutter.

You specify pigeons as classes/methods that the Host or Flutter can call to sync/asynchronously return data.

For Pigeon's you can bind the Flutter side in a AppDecoration/LifecycleWidget. See the `dart_board_spacex_plugin` for an example.

## Features as Plugins

If you are using Pigeon's, you'll need to also be using Plugin typed projects. This allows you to bundle android and iOS code within your feature.

Dart Board transparently works with plugin feature types and will automatically include the Android/iOS bindings as well as registering your plugin.

## iOS Support

I don't have an Mac that I can use for this at this time, but adding support should be easily. I may pick a new macbook up in the future.

- Generate Objective C Pigeons
- Implement Swift/ObjC Plugin interface to register the pigeon interface with the messenger
- Implement any @HostAPI interfaces on the native side
- Create a FlutterViewController that shows Flutter and Navigates before it does

We only support 1 Pigeon over the `dart_board_core_plugin` so the implementation should be relatively straightforward. As a frame of reference, the original plugin and design for android took about 2 days. 
