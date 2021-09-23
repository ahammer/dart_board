# Dart Board
TRY NOW @
https://dart-board.io

Playground: https://dartboard-playground.firebaseapp.com/#/

Flutter Architecture/Framework for Feature based development


- [Dart Board](#dart-board)
- [Introduction](#introduction)
- [Feature List](#feature-list)
- [Getting Started](#getting-started)
  - [Your own App (Hello World)](#your-own-app-hello-world)
  - [Work on the Framework](#work-on-the-framework)
- [What is included](#what-is-included)
  - [How it works](#how-it-works)
- [Features](#features)
  - [Decorations](#decorations)
    - [Page Decorations](#page-decorations)
    - [App Decorations](#app-decorations)
- [Dart Board Core](#dart-board-core)
  - [Feature Loading](#feature-loading)
  - [AB Testing](#ab-testing)
  - [Feature Flags/Disabling](#feature-flagsdisabling)
  - [Named Navigation](#named-navigation)
- [Helpful Widgets (General Utilities)](#helpful-widgets-general-utilities)
  - [RouteWidget (embedded routes)](#routewidget-embedded-routes)
  - [Convertor<In, Out>](#convertorin-out)
  - [LifecycleWidget](#lifecyclewidget)
- [How App is run](#how-app-is-run)
- [Repo Structure](#repo-structure)
  - [core](#core)
  - [features](#features-1)
  - [templates](#templates)
  - [integrations](#integrations)
  - [homepage](#homepage)
- [Special Thanks](#special-thanks)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>



![Dependency Graph](https://www.dart-board.io/assets/img/screenshots/dart_board_2.jpg)

# Release Plan

- Navigator 2.0 support and examples (ongoing, ETA in the next week)
- Advanced deep-linking (e.g. params)
- Integrations/Hooks for other arch patterns (e.g. bloc/provider/etc decorations for features to use)
- Refined Tutorials
- Videos

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



# Feature List

| Feature             |  Description |
:-------------------------:|:-------------------------:|
| [Authentication](features/dart_board_authentication/README.md) | Auth Facade that allows registration/interfacing with Auth Providers (e.g. Firebase, or your own). |
| [Debug](features/dart_board_debug/README.md) | Provides a /debug and /dependency_graph route's to play with the internals/registry. |
| [Firebase Authentication](features/dart_board_firebase_authentication) | Firebase plugin for auth-layer (initialize Firebase with standard FlutterFire docs, e.g. include Firebase JS in your html, or set up your Mobile Runners) Web + Mobile + MacOS is suppoerted by flutter fire. |
| [Firebase Core](features/dart_board_firebase_core) | Marker/init package for Firebase Core. Dependency for all Firebase/FlutterFire projects. |
| [Image Background Decoration](features/dart_board_image_background/README.md) | Allows you to Apply images or widgets as backgrounds (page decoration) |
| [Locator](features/dart_board_locator/README.md) | Object/Service Locator Framework. Lazy loading + Caching. App Decoration based API to register types and services to the App. |
| [Logging](features/dart_board_log/README.md) | Basic logging features, including a Log Footer and `/log` route + overlay. |
| [Minesweeper](features/dart_board_minesweeper/README.md) | You probably don't need it. But provides a `/minesweep` route. Deeper example of `dart_board_redux` use case in action. |
| [Redux](features/dart_board_redux/README.md) | Flutter Redux Bindings. Provides features a consistent way to use a shared Redux store in a feature agnostic way. Provides a AppDecoration API + Function API to Create and Dispatch states. |
| [Theme](features/dart_board_theme/README.md) | Theme support with FlexColorScheme package |


# Getting Started

## Your own App (Hello World)

1) in `pubspec.yaml` add `dart_board_core:` to your dependencies
2) Create `YourFeature extends DartBoardFeature` class.
3) add a desired Route, e.g. 
```
routes => [
 NamedRouteDefinition("/hello_world", 
   (context, settings) => Material(child: Center(child: Text("Hello World)))]
```

4. Implement your `main.dart` and set your starter route
```
void main() => runApp(DartBoard(
  features:[HelloWorldFeature()], 
  initialRoute: '/Hello_World']))
```

5. Add features with `pub.dev` register them in your Features and Apps to gain access. Many require zero config and expose routes and method calls to use.

## Work on the Framework

1) Clone the repo
2) Flutter pub global activate melos
3) melos bootstrap

Melos is mandatory for local dev, if you use pub dependencies for dev, they won't link changes correctly locally. Melos handles it so I don't need to install overrides.
More info @ https://pub.dev/packages/melos

Most features contain a main.dart that can be run on an Android or iOS device/simulator.

Integrations folder contains "starter" and "example". They both have main.dart and are primarily developed on desktop and web to maximize compat across all platforms.

# What is included

- A Core Framework + Utilities

- Optional features that can be enabled.

- Starter templates and Examples.


It's a ready to use Framework for building a flutter app today.


## How it works

Dart Board provides an entry point to your Flutter Application.

You are able to register your features into it's registry and they become available to your application. 

Features have the ability to hook into your app in a variety of ways, such as: Router support, app and page decorations, remote method call handlers and more.

You start it by giving your features and initialRoute and it's good to go.

```
void main() => runApp(DartBoard(
  features:[MainFeature(), SomeOtherFeature(), ....], 
  initialRoute: '/main']))
```


# Features

Features are the meat of your application. By building and composing features you build a larger application.

The built in debugging tools and integration make it very easy to see how your app is built, what features are used and what implementation is currently running.

![Features](https://www.dart-board.io/assets/img/screenshots/dart_board_6.jpg)

In *Dart Board* everything if handled through features. Core services as a foundational framework and feature loader.

Features expose screens and API's that you can export, or use indirectly for loose coupling between components.

For example, a feature can do the following.
- Decorate the App or Page
- Provide Named Routes
- Dispatch MethodCalls between 

Decorations are widgets injected at the App or Page level. They can be UI or non  UI components.   

## Decorations

Decoration's are Dart Boards way of injecting state and UI into your application. 

These come in two scopes. App and Page. They inject their widgets right above and below the navigator respectively.

![Decorations](https://www.dart-board.io/assets/img/screenshots/dart_board_5.jpg)

### Page Decorations

Common use cases for a Page Decoration might be something like
 - Page tracking, UI frames and overlays that aren't global 
 - Page scoped state management solutions
 - Templating/Scaffolding
 - Can be managed with allow/deny list exposed to the features

### App Decorations

Common use cases are things like 
 - Global overlays (particles/background).
 - Global state solutions (Locator/Redux)
 - Hooks for other extensions (e.g. `LocatorDecoration(()=>SomeType())`)


# Dart Board Core

Core provide integration and manages features. It is able to facilitate features like AB testing. The `DartBoard` widget will serve the trunk when working with Dart Board.

## Feature Loading

Features have a `namespace` and a `implementationName`

The `namespace` is what uniquely identifies the feature. You can load one `implementationName` per namespace.

`implementationName` (default: "default") is the name of the implementation, e.g. `namespace = feature` and `implementationName in [feature_impl_a, feature_impl_b]`



Features are loaded via a graph-walk, in order, depth first. There is potentially multiple root nodes (e.g. say you define 3 Features in your main()), They will be walked in order.

E.g. 
`[FeatureA, FeatureB, FeatureC, FeatureA_IMPL2]`

In this case, FeatureA will be loaded, then B and C. A_IMPL2 will be shuffled away, because A already has an implementation

For each feature root a depth first in-order walk of the dependencies are registered. Everytime there is a namespace conflict, it's pushed to the side as a registered implementation.

In simpler terms, the first feature to a namespace wins. Whether it's walking the tree or going over the list, left to right. This means things registered first take the namespace slot.

Only 1 implementation can be active in a namespace at time.

## AB Testing

Setting a feature at runtime is easy, just `DartBoardCore.instance.setFeatureImplementation('FeatureNamespace', 'FeatureImplementationName');`

Just give it your Namespace, and the implementationName and DartBoard will reboot with the new features/tree, salvaging what it can on the way.

## Feature Flags/Disabling

Again, super easy
DartBoardCore.instance.setFeatureImplementation('FeatureNamespace', null);

Note: Disabling features incorrectly can lead to breakage. E.g. disabling the template or /route you are on will leave you stranded.

## Named Navigation

Navigation is still V1, but with sanity and order added to the router.

Out of the box you have 
` get routes = [NamedRouteDefinition("/route", (ctx, settings)=> Widget())]`

You can have as many routes as you want.

Named route also take priority. First to resolve gets delivered. So in the case of conflicts whatever route from whatever feature is hit first will fill the route.

`NamedRouteDefinition` extends `RouteDefinition` which you can use for more advanced deeplinking.

```
abstract class RouteDefinition {
  /// If this route definition matches a RouteSettings object
  bool matches(RouteSettings settings);

  /// This is the builder for the content
  RouteWidgetBuilder get builder;

  ///This is an optional RouteBuilder
  RouteBuilder? routeBuilder;
}
```

In this case. `matches` is to verify if this RouteDefinition can build the route. You can look at the `RouteSettings.name` object to know the route name.

`RouteWidgetBuilder` is what builds the page itself (sans page decorations).

`RouteBuilder` is an optional value to create a specific Route for navigation transition. E.g. `MaterialPageRoute` or `CupertinoPageRoute`. This will go platform-default normally. Over-ride for specific behaviors. When used, first the Page will be built, and then passed to RouteBuilder to wrap with the Route.

# Helpful Widgets (General Utilities)

## RouteWidget (embedded routes)

Want to use your named routes anywhere? E.g. in a Dialog, or as a small portion of a screen?

```
    showDialog(
        useSafeArea: true,
        context: navigatorContext,
        barrierDismissible: true,
        builder: (ctx) => RouteWidget("/request_login"));
```
and pass arguments `RouteWidget(itemPreviewRoute, args: {"id": id})`

RouteWidget can handle that for you, enabling you to break screens up into multiple decoupled features that share a common core and state.

## Convertor<In, Out>

Conversion in the widget tree

```
              Convertor<MinesweeperState, MineFieldViewModel>(
                  convertor: (input) => buildVm(input),
                  builder: (ctx, out) => MineField(vm: out),
                  input: state)))
```                  

Will only trigger an update if the VM changes/doesn't hit equality. 

Ideal for ViewModel generation from a DataSource, to help reduce the number of builds to relevant changes.

## LifecycleWidget

```
LifeCycleWidget(
                key: ValueKey("LocatorDecoration_${T.toString()}"),
                preInit: () => doSomethingBeforeCtx,
                
                    
                child: Builder(builder: (ctx) => child))
```

This widget can tap into life cycle

3 hooks
```
  /// Called in initState() before super.initState()
  final Function() preInit;

  /// Called after initState()  (with context)
  final Function(BuildContext context) init;

  /// Called in onDispose
  final Function(BuildContext context) dispose;
```

You can use this with something like a PageDecoration to start a screen time counter, or to periodically set a reminder/start/stop a service etc.

It's very useful within the context of features and setting up integrations.


# How App is run

```
/// App Entry Point.
///
/// Features are defined here, along with config.
void main() {
  runApp(DartBoard(
    features: [
      DetailsFeature(),
      ListingFeature(),
      CartFeature(itemPreviewRoute: "/details_by_id"),
      DebugFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig),
      MockCheckoutFeature()
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

This is a Dart Board App. It has a Details, Listing, Cart, Debug, a Template and a Mock checkout feature. It loads `/home` initially. Home is resolved by the Template feature, and has tabs for listing and details roughts from their features.

Alternatively, and encouraged for larger projects is to build an `integration` feature, as how the main example is done.

```
/// Entry Point for the Example
///
/// All the registration and details are in ExampleFeature.
///
/// the FeatureOverrides are to disable certain features by default
void main() {
  runApp(DartBoard(
    featureOverrides: {
      'Snow': null,
      'FireCursor': null,
      'background': 'ClockEarth'
    },
    features: [ExampleFeature()],
    initialRoute: '/main',
  ));
}
```

In this example, I am delegating to ExampleFeature which has Feature's listed in it's "dependencies".

I'd recommend to generally to an Integration, as it'll make it easier to experiment with various integrations and configs. However for starter work, don't worry, you can skip the Integration Feature, and introduce it later easily if necessary.

https://pub.dev/publishers/dart-board.io/packages


# Repo Structure

## core

Contain's core framework features. Currently 1 library. dart_board_core

## features

Contain's reusable features that can be included in your integrations (or other features)

## templates

Contain's features that are designed to be UI templates

They are pre-made templates that get filled in via config.

- Configurable Route
- Configurable Feature Name
- UI Config (e.g. Embedded Route Names, or Widgets, etc).

The idea being that you should be able to register a Temlate multiple times, for multiple screens with varying configs.

You access the template by navigating to the route you select.

## integrations

This is a place to see Integrations of multiple features into a larger app.

- Example/Playground: Integrates everything, demonstrates it all at once.
- Blank: A minimal template with no major features. This can be adapted as a starting template.

## homepage

This is the "dart-board.io" website.

The template is SplashKit (Bootstrap) and is not licensed for re-use.

For all intents and purposes, this is outside the open source components due to license restrictions.

# Special Thanks

Many packages are consumed in the  creation of dart-board, however I try and limit them to features so they are optional.

Theme support is largely thanks to FlexColorScheme and FlexColorPicker, amazing packages that really bring that feature to life.

The NIL packages is imported as well, to use in place of empty containers for some render optimization.
