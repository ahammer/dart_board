# Dart Board
https://dart-board.io

Playground: https://dartboard-playground.firebaseapp.com/#/

Starter Demo: https://dartboard-blank.firebaseapp.com/#/

Flutter Architecture/Framework for Feature based development

# Introduction

In software development there is always a strong desire to know the "best way". But the reality is that there isn't a best way. The best way is constantly changing.

In order to keep up with the change of pace and demands of modern software development, adopting a feature framework allows you to isolate and contain features. This provides a lot of flexibility to gate new feature's, run AB tests, or swap aging components.

# What is it? 

- A Core Framework + Utilities

- Optional features that can be enabled.

- Starter templates and Examples.


It's a ready to use Framework for building a flutter app today.


## How it works?

Dart Board provides an entry point to your Flutter Application.

You are able to register your features into it's registry and they become available to your application. 

Features have the ability to hook into your app in a variety of ways, such as: Expose Route's, Decorate the App or each Page with a variety of decorations.

You start it by giving your features and initialRoute and it's good to go.

```
void main() => runApp(DartBoard(
  features:[MainFeature(), SomeOtherFeature(), ....], 
  initialRoute: '/main']))
```


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
