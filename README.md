# Dart Board

Flutter Architecture/Scaffolding for App Development.

This is project organization/feature management. Ever wonder how you can build your app and keep it clean? Separate code into smaller modules and have 
the modules install themselves into your app? This is the architecture for you.

Dart Board cuts the complexity by allowing you to slice features how you want, and install them into a larger more cohesive app. Keeping your app organized and nimble and ready to adapt as necessary.

TRY NOW @
https://dart-board.io

Playground: https://dartboard-playground.firebaseapp.com/#/

Flutter Architecture/Framework for Feature based development


- [Dart Board](#dart-board)
- [Introduction](#introduction)
- [Repo Structure](#repo-structure)
  - [core](#core)
  - [features](#features)
  - [templates](#templates)
  - [integrations](#integrations)
  - [homepage](#homepage)
- [Contributing](#contributing)
  - [Steps](#steps)
  - [Conventional Commits](#conventional-commits)
  - [Melos](#melos)
- [Getting Started (Hello World)](#getting-started-hello-world)
- [Dart Board Core](#dart-board-core)
  - [Feature Loading](#feature-loading)
  - [AB Testing](#ab-testing)
  - [Feature Flags/Disabling](#feature-flagsdisabling)
- [Features](#features-1)
  - [Decorations](#decorations)
    - [Page Decorations](#page-decorations)
    - [App Decorations](#app-decorations)
  - [Routes](#routes)
  - [Method Calls](#method-calls)
  - [Feature List](#feature-list)
- [Add2App](#add2app)
  - [Limitations](#limitations)
  - [General Advice](#general-advice)
- [Navigation](#navigation)
  - [Router concept](#router-concept)
  - [How to Use](#how-to-use)
  - [Route Types in DartBoard](#route-types-in-dartboard)
  - [Anonymous Routes](#anonymous-routes)
  - [Routing Demonstration in the SpaceX Example](#routing-demonstration-in-the-spacex-example)
- [State Management](#state-management)
  - [Locator](#locator)
    - [Usage:](#usage)
    - [Use Case](#use-case)
  - [Redux](#redux)
    - [Usage](#usage-1)
    - [Use Case](#use-case-1)
  - [Bloc/Cubit](#bloccubit)
    - [Usage](#usage-2)
    - [Use Case](#use-case-2)
  - [Provider / RiverPod](#provider--riverpod)
    - [Usage](#usage-3)
- [Helpful Widgets (General Utilities)](#helpful-widgets-general-utilities)
  - [RouteWidget (embedded routes)](#routewidget-embedded-routes)
  - [Convertor<In, Out>](#convertorin-out)
  - [LifecycleWidget](#lifecyclewidget)
- [How App is run](#how-app-is-run)
- [General App Guidance](#general-app-guidance)
  - [Keep Features Small](#keep-features-small)
  - [Coupling is OK, Sometimes](#coupling-is-ok-sometimes)
  - [Develop in Isolation](#develop-in-isolation)
  - [Integrate Last](#integrate-last)
  - [Configuration Tips](#configuration-tips)
- [Special Thanks](#special-thanks)
- [Architectural Recipe](#architectural-recipe)
  - [Locator](#locator-1)
  - [Redux/Bloc](#reduxbloc)
  - [Convertor](#convertor)
  - [Widget Stream](#widget-stream)
- [TODO - Release Roadmap](#todo---release-roadmap)


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
- Plugs gracefully into your Apps routing code.
- Eases Add2App integrations

This lets you structure you code as fundamental building blocks of "features", and then integrate them into a consistent application with config only. At compile and runtime you can mix/match and switch feature implementations. 

It's designed for squad-based development where multiple teams may work on the same app or code, however any developer can use it to generate a library of features they can re-use across multiple apps with minimal integration.

What is a feature? Many are offered out of the box, including Debugging, Full Features like Chat and MineSweeper, and tons of supporting features like Analytics, Realtime Database, State Management options, Canvas and Particle effects and more. There is no pre-set definition of what a feature can be.

| Chat             |  Minesweeper | Logging |
:-------------------------:|:-------------------------:|:-------------------------:
![Chat](https://www.dart-board.io/assets/img/screenshots/dart_board_3.jpg) | ![MineSweeper](https://www.dart-board.io/assets/img/screenshots/dart_board_4.jpg) | ![Logging](https://www.dart-board.io/assets/img/screenshots/dart_board_7.jpg)



# Repo Structure

## core

Contain's core framework features. Currently 3 libraries: 
- dart_board_core = Kernel
- dart_board_widgets = Simple Widgets
- dart_board_core_plugin = Add2App usages


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


# Contributing

To contribute or develop on the repo you'll need to use `melos` and `conventional commits`. Melos is a tool to link the mono-repo and allow for local development. Conventional commits are a commit format that help facilitate versioning and releases.

## Steps 

1) Clone the repo
2) Flutter pub global activate melos
3) melos bootstrap

Most features contain a main.dart that can be run on an Android or iOS device/simulator.

Integrations folder contains "starter" and "example". They both have main.dart and are primarily developed on desktop and web to maximize compat across all platforms.

The repo is setup to to integrate into VsCode and allow running of many examples from the IDE directly.

## Conventional Commits

Use CommitLint (and conventional commit format)
https://github.com/conventional-changelog/commitlint

## Melos

Use Melos
https://pub.dev/packages/melos


Make a PR to the Repo & Get my Attention (Adam Hammer)


# Getting Started (Hello World)

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
  initialRoute: '/hello_world']))
```

5. Add features with `pub.dev` register them in your Features and Apps to gain access. Many require zero config and expose routes and method calls to use.

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


## Routes

Features can include "Routes/Paths" these are essentially screens or UI blocks that can be added by path to your application. You can add routes by overrides the `routes` getter in a feature.

## Method Calls

Method Calls are the mechanism to decouple features, but still allow interaction. By using Flutter's `MethodCall` class typically reserved for Add2App/Host/Flutter communication, we can also decouple features using named methods at a distance.

These can be used to loosely connect features without a direct dependency.

## Feature List

| Feature             |  Description |
:-------------------------:|:-------------------------:|
| [Authentication](features/dart_board_authentication/README.md) | Auth Facade that allows registration/interfacing with Auth Providers (e.g. Firebase, or your own). |
| [Block](features/dart_board_bloc/README.md) | Bloc/Cubit bindings for features |
| [Canvas](features/dart_board_canvas/README.md) | Easy to integrate animated canvas features |
| [Chat](features/dart_board_chat/README.md) | Example Chat feature built on top of Firebase |
| [Debug](features/dart_board_debug/README.md) | Provides a /debug and /dependency_graph route's to play with the internals/registry. |
| [Firebase Analytics](features/dart_board_firebase_analytics/README.md) | Firebase analytics options for Dart Board |
| [Firebase Authentication](features/dart_board_firebase_authentication) | Firebase plugin for auth-layer (initialize Firebase with standard FlutterFire docs, e.g. include Firebase JS in your html, or set up your Mobile Runners) Web + Mobile + MacOS is suppoerted by flutter fire. |
| [Firebase Core](features/dart_board_firebase_core) | Marker/init package for Firebase Core. Dependency for all Firebase/FlutterFire projects. |
| [Firebase Database](features/dart_board_firebase_database/README.md) | Firebase Database features/helpers |
| [Image Background](features/dart_board_image_background/README.md) | Allows you to Apply images or widgets as backgrounds (page decoration) |
| [Locator](features/dart_board_locator/README.md) | Object/Service Locator Framework. Lazy loading + Caching. App Decoration based API to register types and services to the App. |
| [Log](features/dart_board_log/README.md) | Basic logging features, including a Log Footer and `/log` route + overlay. |
| [Minesweeper](features/dart_board_minesweeper/README.md) | You probably don't need it. But provides a `/minesweep` route. Deeper example of `dart_board_redux` use case in action. |
| [Particles](features/dart_board_particles/README.md) | Particle Overlay/Features |
| [Redux](features/dart_board_redux/README.md) | Flutter Redux Bindings. Provides features a consistent way to use a shared Redux store in a feature agnostic way. Provides a AppDecoration API + Function API to Create and Dispatch states. |
| [space_scene](features/dart_board_space_scene/README.md) | Originally my Flutter Clock Challenge entry, now exposed as a feature |
| [SpaceX Plugin](features/dart_board_spacex_feature/dart_board_spacex_plugin/README.md) | Space X Add2App plugin (headless flutter example) |
| [SpaceX Repository](features/dart_board_spacex_feature/dart_board_spacex_repository/README.md) | Space X GraphQL bindings and repository |
| [SpaceX UI](features/dart_board_spacex_feature/dart_board_spacex_ui/README.md) | Space X UI bindings (list/details) Nav2.0 example |
| [Splash](features/dart_board_splash/README.md) | Splash Screen Support |
| [Theme](features/dart_board_theme/README.md) | Theme support with FlexColorScheme package |
| [Tracking](features/dart_board_tracking/README.md) | Generic Tracking Interfaces (requires delegate to actually track) |

# Add2App

Want to add flutter to an existing App? Generally a daunting task fraught with limitations. However, with routing and native API's to abstract the difficulty it's completely feasible.

For example check the [Add2App Example](https://github.com/ahammer/dart_board_add2app)

Or checkout the [Add2App feature](https://github.com/ahammer/dart_board/core/dart_board_core_plugin/readme.md)

## Limitations
- One Active flutter activity in the stack.
- Full Screen only

The first is because Flutter on Native can be multi-engine or single-engine. By being multi-engine a lot of difficulties are lost. You can run multiple screens and navigate back and forth. However this approach uses more memory and the  isolates can not share data in a clean and easy way. By using a single engine we can pre-warm it, use it headless, preserve state etc. However, navigation stack is state, and having multiple screens native + flutter complicates this. Having flutter run as a "single top" with it's own stack simplifies this considerably. This means it's ill advise to navigate between platform->flutter->platform->flutter. If there is enough demand for this functionality the router can be modified to allow context switching (e.g. multiple nav stacks). It should be easy to avoid this scenario with careful planning and risk management.

The second is more a suggestion. FlutterFragment and FlutterViewController can easily handle it. However, it does open the door to layout and transition issues. It's better to understand the difficulty and avoid it. However it's possible, just don't expect to know the size of your flutter content in the host, and don't expect to easily transition to full screen. As such Dart-Board will only support full-screen, single-top scenerios out of the box.

## General Advice

- Go leaves in, not trunk out (i.e. About Us, leaf. Landing Screen, trunk.) Start with small targets and build your confidence.
- Use Pigeon to manage your MC bindings and calls for type safety across Android/iOS/Flutter)
- Convert your Feature Modules to Plugins to bundle your own Java/Kotlin/Swift/ObjC code.
- Bring in dart_board_core_plugin instead of dart_board_core to get the Android bindings (iOS in the future)


# Navigation

Navigation with DartBoard is handled via a Custom Navigator 2.0 Router. This allows Dart Board applications to support deep linking and Add2App integrations.

## Router concept

The router has these rules. 

1) You have a stack of "paths" (e.g. [/, /somepage, /store/details/32])
2) No duplicate paths in the stack, pushing a duplicate will move it to the front
3) All routes must be URL reproducable
4) pushDynamic (builder) routes can not be shared, but are temporarily named.
5)  `/` is a mirror of a `Route` from a feature. Configured with `/initialRoute` (no change)

## How to Use

You can access the nav globally with `DartBoardCore.nav` instance.

```

abstract class DartBoardNav {
  /// The currently active (foreground) route
  String get currentPath;

  /// Change Notifier to listen to changes in nav
  ChangeNotifier get changeNotifier;

  /// Get the current stack
  List<DartBoardPath> get stack;

  /// Push a route onto the stack
  /// expanded will push sub-paths (e.g. /a/b/c will push [/a, /a/b, /a/b/c])
  void push(String path, {bool expanded});

  /// Pop the top most route
  void pop();

  /// Pop routers until the predicate clears
  void popUntil(bool Function(DartBoardPath path) predicate);

  /// Clear all routes in the stack that match the predicate
  void clearWhere(bool Function(DartBoardPath path) predicate);

  /// Pop & Push (replace top of stack)
  /// Does not work on '/'
  void replaceTop(String path);

  /// Append to the current route (e.g. /b appended to /a = /a/b)
  void appendPath(String path);

  // Replace the Root (Entry Point)
  // Generally for Add2App
  void replaceRoot(String path);

  /// Push a route with a dynamic route name
  void pushDynamic(
      {required String dynamicPathName, required WidgetBuilder builder});
}
```

## Route Types in DartBoard

These route types should allow you to match a wide range of URI patterns for your features.

`NamedRouteDefinition` -> Matches a portion of a path for a specific name, i.e. `/page` `/details`
`MapRoute` -> Named Route that allows multiple pages (Syntactic sugar)
`UriRoute` -> Matches everything that hits it. Can globally handle routing, or can be used with PathedRoute to provide detailed parsing of the resource.
`PathedRoute` -> Use this for deep-linked trees. E.g. `/category/details/50` it takes a List of Lists of RouteDefinitions. Each level of depth represents the tree.

How to fulfill complicated roots?
`NamedRouteDefinition` works good for static, fixed targets. But what if you want something more advanced?

E.g. you want /store/pots/2141 to resolve.

`UriRoute` and `PathedRoute` solve those issues for you.

`PathedRoute` will handle directory structures. You do this with a list of lists. Each level can hold any number of matchers. If a path matches up to that level, the lowest matcher will take it.

```
// PsuedoCode
[
  [
    NamedRoute('/store', (ctx,settings)=>StorePage()),    
  ],
  [
    NamedRoute('/pots', (ctx,settings)=>PotsPage()),
    NamedRoute('/pans'  (ctx,settings)=>PotsPage()),
  ],
  [
    UriRoute((context, uri)=>Parse and Display)
  ]
]
```

This PathedRoute config would respond to many routes: `[/store, /store/pots, /store/pans, /store/pots/*, /store/pans/*]`

The * is the UriRoute. You can use this to manage all your Routing, or you can use it with a Pathed route to parse the information.

UriRoute will parse the resource request and let you access query params, path segments and anything else encoded in the page request.


## Anonymous Routes

Sometimes you want to just push a screen right? Like you didn't register it in a feature, you want it to be dynamic for whatever reason.

`void pushDynamic({required String dynamicRouteName, required WidgetBuilder builder});`

is what you can use here. Give it a unique name which will be prefixed with _, e.g. `/_YourDynamicRoute3285` If you see the `_` that means you can not share this route. If you give it to someone else it's going to 404 for them. It's dynamically allocated for the users session.



## Routing Demonstration in the SpaceX Example

The SpaceX features are designed as demonstrations of Add2App and Navigator 2.0 usage.

```
  @override
  List<RouteDefinition> get routes => [
        PathedRouteDefinition([
          [
            NamedRouteDefinition(
                route: '/launches', builder: (ctx, settings) => LaunchScreen())
          ],
          [UriRoute((ctx, uri) => LaunchDataUriShim(uri: uri))]
        ]),
      ];
```

This matches `/launches` and also `/launches/[ANY_ROUTE_NAME]`

`/launches` appends the name of the mission to the URL, and you end up with something like `/launches/Starlink%207`

UriRoute can then pull the data from the URI and pass it to the page to load what it needs to.


# State Management

Dart Board is compatible with the full suite of State Management solutions. When convenient bindings are provided to ease state management. For the initial release the focus will be on 3 primary State Management Solutions, with some footnotes about the usage of other solutions.

## Locator

Simple state management for basic applications and features. Provides a universal global store that is lazily initialized as required, and provides support for instancing.

### Usage:

1) Import and register `DartBoardLocatorFeature` in your feature.
2) Register states/services/repositories with `LocatorDecoration(()=>YourObject())`
3) Find states/services/repositories with `locate<YourObject>()`
4) If you are using a change notifier, you can use `locateAndBuild<YourObject>((context, yourObject)=>WidgetBuilder)`

Since things are lazily initialized, you can use `locate<>` calls in your `LocatorDecoration` and values will be initialized in the correct order.

You do not need to use `context` when using locator. The locatable objects are stored inside LocatorFeature which represents a source of truth near the root of your tree.

### Use Case
Locator is ideal for simple states and things like ChangeNotifier's, to quickly put together features.


## Redux

Flutter Redux bindings for dart_board. Redux is abstracted to allow each feature to have it's own State objects. The SSOT store is located inside the Feature itself.

The bindings help you dispatch and listen to the right objects. Like locator it's a universal store that can have sub-states installed in it by features.

### Usage

1) Import and register `DartBoardReduxFeature` into the features that use it
2) Register initial states with `ReduxStateDecoration`
3) Register middleware with `ReduxMiddlewareDecoration`
4) Reducer's are Class and Function based. Implement `FeatureAction<T>` to create a reducer that you can dispatch and use to generate a new state.
5) `FeatureStateBuilder<T>(builder:(ctx, state) => YourWidget(state))` Widget is provided to hook up to reactive state changes to your state.

### Use Case

Redux is ideal for observability and history management of state. It's a more advanced use case that can generate safer code with a very predictable state management. It's recommended for medium to advanced state management requirements.


## Bloc/Cubit

Bloc Cubit bindings don't require a feature, but an extension is available that provides 2 Decorations

### Usage 

1) Add BlocDecoration<T> or CubitDecoration<T> to your Features to expose Cubits/Blocs to your App or Pages.

### Use Case

Bloc is a robust state management similar to redux in that it allows actions and mutation of states. It's more heavily reliant on Streams internally and in some cases may feel foreign to developers from outside the dart ecosystem, but is fairly popular within it. Originally adopted from examples Google used in some open source projects.

Cubits are `Bloc` light, and a good for small to medium state management, while `Bloc`'s themselves are more robust and while come with more overhead to implement, but are suitable for advanced use cases.

## Provider / RiverPod

Provider is syntatic sugar around `InherittedWidget`. It can be though of a tree-based DI injector.

There is not much value in a DartBoardFeature or bindings for Provider, but if you like it you can easily import it, use it in your `DartBoardDecorations` or features using it's standard API.

### Usage

Use as normally, just refer to the Provider documentation.

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

# General App Guidance

## Keep Features Small

The smaller and more focussed a feature, the easier it is to develop, test and debug. If you feel that a feature is doing too many things, consider breaking it down into seperate flutter modules/plugins and retain the single-responsibility principle. 

## Coupling is OK, Sometimes

If you need to have a feature that has a directly accessible API, that's ok. Just remember the single responsibility principle when doing so. When you directly couple a feature, it can become challenging to decouple it later, so make sure that your coupling's are necessary.

There is a complexity/safety trade off between tight coupling and lose coupling. I can't make that decision for you, but it is something you should think about when cutting up your features and how you'd like to put them back together.

## Develop in Isolation

When building a feature, build it in isolation. Test it in isolation. Set up runners/demo's to show what the feature is supposed to do and how it works in isolation. Code that runs in multiple places is portable, code that runs in one place is not.

This will make it easier to verify things, create smaller test cases to reproduce bugs and increase the turn around time for new features and fixes.

## Integrate Last

Adding features to your app should happen after you've built the feature in isolation. Building things in an already integrated fashion increases your risk of coupling and reduces your code portability. By integrating last you naturally keep portability high.

## Configuration Tips

Dart Board handles configuration eagerly. This means that Features that are registered before others take precedence. You can exploit this to force a config. E.g. If you want a mock repository with `SpaceX` you can simply register the `spacex_data_layer` with a mock repository before it's bicked up by `spacex_ui`.

Generally your configuration can belong in your `main.dart` where you initialize `DartBoard` and your features.

Features themselves should have safe default configs to use, so that they work out of the box whenever possible.

# Special Thanks

Many packages are consumed in the  creation of dart-board, however I try and limit them to features so they are optional.

Theme support is largely thanks to FlexColorScheme and FlexColorPicker, amazing packages that really bring that feature to life.

The NIL packages is imported as well, to use in place of empty containers for some render optimization.

# Architectural Recipe

- Locator = Service Locator (Repositories, API's)
- Redux/Bloc = State Management (Local state and maintaining it)
- Convertor = View Model Generation
- WidgetStream = Asyncronous widget building

## Locator

Locator is a service locator pattern. It's most useful for global black boxes. E.g. API's and Services such as repositories.

It's easy to add services to a Locator from within a feature (`LocatorDecoration(()=>YourService())`)

It's also easy to consume services with `locate<t>()` or `locateAndBuild<t extends ChangeNotifier>()`

## Redux/Bloc

If you have complicated state that you worry about modifying. You can have more safety by using Redux or Bloc.

## Convertor

Widget that maps between types, and optimizes builds. Use this to convert from a data-model to a view-model.

## Widget Stream

For asynchronous blocks of the widget tree. Use `async *` method to yield widgets, allowing for pretty clean loading flows.

E.g.

```
WidgetStream(
        (BuildContext context) async* {
          yield CircularProgressIndicator();
          yield LaunchList(await locate<SpaceXRepository>().getPastLaunches());
        },
      );
```

Nice right? No need for a StatefulWidget, Future, FutureBuilder, Snapshots or any of that. Just a circular progress indicator, and the LaunchList when it's done.
      


# TODO - Release Roadmap

- Work through each modules README.MD TODO section
- Navigation/Routing result codes (allow Future)
- Publish to Android store
