# Dart Board
https://dart-board.io

Playground: https://dartboard-playground.firebaseapp.com/#/

Starter Demo: https://dartboard-blank.firebaseapp.com/#/



Flutter Architecture/Framework for Feature based development


- [Dart Board](#dart-board)
- [Introduction](#introduction)
- [Repo Setup:](#repo-setup)
- [What is it?](#what-is-it)
  - [How it works?](#how-it-works)
  - [What is a Feature?](#what-is-a-feature)
  - [What is Dart Board Core](#what-is-dart-board-core)
  - [How is an App Built?](#how-is-an-app-built)
  - [What features are included?](#what-features-are-included)
  - [Repo Structure](#repo-structure)
    - [core](#core)
    - [features](#features)
    - [templates](#templates)
    - [integrations](#integrations)
    - [homepage](#homepage)


![Dependency Graph](https://www.dart-board.io/assets/img/screenshots/dart_board_2.jpg)

# Introduction

Dart Board is a Framework/Architecture pattern for Flutter applications.

The premise is "feature management and encapsulation"

The advantages of adopting a pattern like this are the following
- App as Config/Integration
- Features as standalone modules
- AB Testing
- Feature Gates
- Feature Isolation
- Feature Developer autonomy 
- Easy to port existing flutter code


This lets you structure you code as fundamental building blocks of "features", and then integrate them into a consistent application with config only. At compile and runtime you can mix/match and switch feature implementations. 

It's designed for squad-based development where multiple teams may work on the same app or code, however any developer can use it to generate a library of features they can re-use across multiple apps with minimal integration.

What is a feature? Many are offered out of the box, including Debugging, Full Features like Chat and MineSweeper, and tons of supporting features like Analytics, Realtime Database, State Management options, Canvas and Particle effects and more. There is no pre-set definition of what a feature can be.

| Chat             |  Minesweeper | Logging |
:-------------------------:|:-------------------------:|:-------------------------:
![Chat](https://www.dart-board.io/assets/img/screenshots/dart_board_3.jpg) | ![MineSweeper](https://www.dart-board.io/assets/img/screenshots/dart_board_4.jpg) | ![Logging](https://www.dart-board.io/assets/img/screenshots/dart_board_7.jpg)


# Repo Setup:

1) Clone the repo
2) Flutter pub global activate melos
3) melos bootstrap

Melos is mandatory for local dev, if you use pub dependencies for dev, they won't link changes correctly locally. Melos handles it so I don't need to install overrides.
More info @ https://pub.dev/packages/melos

Most features contain a main.dart that can be run on an Android or iOS device/simulator.

Integrations folder contains "starter" and "example". They both have main.dart and are primarily developed on desktop and web to maximize compat across all platforms.

# What is it? 

- A Core Framework + Utilities

- Optional features that can be enabled.

- Starter templates and Examples.


It's a ready to use Framework for building a flutter app today.


## How it works?

Dart Board provides an entry point to your Flutter Application.

You are able to register your features into it's registry and they become available to your application. 

Features have the ability to hook into your app in a variety of ways, such as: Router support, app and page decorations, remote method call handlers and more.

You start it by giving your features and initialRoute and it's good to go.

```
void main() => runApp(DartBoard(
  features:[MainFeature(), SomeOtherFeature(), ....], 
  initialRoute: '/main']))
```


## What is a Feature?

![Features](https://www.dart-board.io/assets/img/screenshots/dart_board_6.jpg)

In Dart Board everything the user does is conveyed through features. Core's existence is only to load them.

Features expose screens and API's that you can export, or use indirectly for loose coupling between components.

For example, a feature can do the following.
- Decorate the App or Page
- Provide Named Routes
- Dispatch MethodCalls between 

Decorations are widgets injected at the App or Page level. They can be UI or non  UI components.   

![Decorations](https://www.dart-board.io/assets/img/screenshots/dart_board_3.jpg)


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

https://pub.dev/publishers/dart-board.io/packages

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

- [Authentication](features/dart_board_authentication/README.md)

Auth Facade that allows registration/interfacing with Auth Providers (e.g. Firebase, or your own).

- [Firebase Authentication](features/dart_board_firebase_authentication)

Firebase plugin for auth-layer (initialize Firebase with standard FlutterFire docs, e.g. include Firebase JS in your html, or set up your Mobile Runners) Web + Mobile + MacOS is suppoerted by flutter fire.

- [Firebase Core](features/dart_board_firebase_core)

Marker/init package for Firebase Core. Dependency for all Firebase/FlutterFire projects.


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

- Example/Playground: Integrates everything, demonstrates it all at once.
- Blank: A minimal template with no major features. This can be adapted as a starting template.

### homepage

This is the "dart-board.io" website.

The template is SplashKit (Bootstrap) and is not licensed for re-use.

For all intents and purposes, this is outside the open source components due to license restrictions.
