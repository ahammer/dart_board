# Dart Board

![Dart Board Logo](assets/db_128.png)

Flutter Architecture for Modular App Development

## Overview

Dart Board is a framework that helps you build modular, maintainable Flutter applications by organizing code into cohesive features. It allows you to:

- **Slice your app into independent features** that can be developed and tested in isolation
- **Compose features** into a cohesive application with minimal integration effort
- **Enable/disable features** at runtime for A/B testing and feature flagging
- **Decouple components** for cleaner architecture and better code organization

[Try the Playground →](https://dartboard-playground.firebaseapp.com/#/)

[Visit dart-board.io →](https://dart-board.io)

## Key Benefits

- **App as Configuration**: Your main app becomes a simple composition of features
- **Feature Isolation**: Develop and test features independently
- **Developer Autonomy**: Multiple teams can work on the same app with minimal conflicts
- **Easy Integration**: Port existing Flutter code with minimal changes
- **Flexible Routing**: Plugs gracefully into your app's routing code
- **Add2App Support**: Simplifies Flutter integration into existing native apps

## Getting Started

1. Add the core dependency to your `pubspec.yaml`:
   ```yaml
   dependencies:
     dart_board_core: ^0.9.17
   ```

2. Create a feature class:
   ```dart
   class HelloWorldFeature extends DartBoardFeature {
     @override
     String get namespace => "HelloWorld";
     
     @override
     List<RouteDefinition> get routes => [
       NamedRouteDefinition("/hello_world", 
         (context, settings) => Material(child: Center(child: Text("Hello World"))))
     ];
   }
   ```

3. Set up your `main.dart`:
   ```dart
   void main() => runApp(DartBoard(
     features:[HelloWorldFeature()], 
     initialRoute: '/hello_world'
   ));
   ```

4. Check out [GETTING_STARTED.md](GETTING_STARTED.md) for a complete walkthrough.

## Repository Structure

- **[core/](core/)**: Core framework components
  - `dart_board_core`: Main framework kernel
  - `dart_board_widgets`: Reusable widgets
  - `dart_board_core_plugin`: Add2App support

- **[features/](features/)**: Reusable feature modules
  - State management (Locator, Redux, Bloc)
  - UI components (Canvas, Theme, Splash)
  - Integrations (Firebase, Authentication)
  - Complete features (Chat, Minesweeper)

- **[templates/](templates/)**: Pre-made UI templates with configurable routes

- **[integrations/](integrations/)**: Example apps showing features in action
  - `example`: Playground demonstrating all features
  - `starter`: Minimal template to build from

- **[homepage/](homepage/)**: Source for the dart-board.io website

## Feature Highlights

| Feature | Description |
|:-------:|:------------|
| **[Debug](features/dart_board_debug/)** | Provides debugging tools and feature inspection |
| **[Theme](features/dart_board_theme/)** | Theming support with FlexColorScheme |
| **[Canvas](features/dart_board_canvas/)** | Easy animated canvas effects |
| **[Firebase](features/dart_board_firebase_core/)** | Firebase integration |
| **[Authentication](features/dart_board_authentication/)** | Auth framework with provider support |
| **[State Management](features/dart_board_locator/)** | Multiple state management options |

See the [complete feature list](#features-1) below for more.

| Chat | Minesweeper | Debug Panel |
|:----:|:-----------:|:-----------:|
| ![Chat](https://www.dart-board.io/assets/img/screenshots/dart_board_3.jpg) | ![MineSweeper](https://www.dart-board.io/assets/img/screenshots/dart_board_4.jpg) | ![Logging](https://www.dart-board.io/assets/img/screenshots/dart_board_7.jpg) |

## How Dart Board Works

![Dependency Graph](https://www.dart-board.io/assets/img/screenshots/dart_board_2.jpg)

### Feature Loading

Features have a `namespace` and an `implementationName`. Only one implementation per namespace can be active at a time.

Features are loaded via a graph-walk in order, depth first. The first feature registered for a namespace wins, allowing for configuration control.

### Decorations

Decorations inject widgets into your application at either the App or Page level.

![Decorations](https://www.dart-board.io/assets/img/screenshots/dart_board_5.jpg)

- **App Decorations**: Global overlays, state management, etc.
- **Page Decorations**: Page-scoped UI frames, state, templates

### Routes

Features can provide named routes that integrate with Dart Board's Navigator 2.0 router, supporting deep linking and Add2App integration.

### Method Calls

Features can communicate without direct dependencies using the `MethodCall` mechanism, enabling loose coupling between components.

## Contributing

To contribute to Dart Board:

1. Clone the repo
2. Install Melos: `flutter pub global activate melos`
3. Bootstrap: `melos bootstrap`

See [contribute.MD](contribute.MD) for more details.

## Feature List

| Feature | Description |
|:--------|:------------|
| [Authentication](features/dart_board_authentication/) | Auth facade for provider interfaces |
| [Bloc](features/dart_board_bloc/) | Bloc/Cubit state management |
| [Canvas](features/dart_board_canvas/) | Animated canvas effects |
| [Chat](features/dart_board_chat/) | Example chat feature (Firebase) |
| [Debug](features/dart_board_debug/) | Debugging tools and feature inspection |
| [Firebase Analytics](features/dart_board_firebase_analytics/) | Firebase analytics integration |
| [Firebase Authentication](features/dart_board_firebase_authentication/) | Firebase auth provider |
| [Firebase Core](features/dart_board_firebase_core/) | Firebase core initialization |
| [Firebase Database](features/dart_board_firebase_database/) | Firebase database helpers |
| [Image Background](features/dart_board_image_background/) | Background image support |
| [Locator](features/dart_board_locator/) | Service locator framework |
| [Log](features/dart_board_log/) | Logging and log viewer |
| [Minesweeper](features/dart_board_minesweeper/) | Example game using Redux |
| [Particles](features/dart_board_particles/) | Particle effects |
| [Redux](features/dart_board_redux/) | Redux state management |
| [Space Scene](features/dart_board_space_scene/) | Space animation background |
| [Splash](features/dart_board_splash/) | Splash screen support |
| [Theme](features/dart_board_theme/) | Theming with FlexColorScheme |
| [Tracking](features/dart_board_tracking/) | Analytics tracking interfaces |

## Navigation

Dart Board uses a custom Navigator 2.0 router with these principles:

- Stack-based path navigation
- No duplicate paths (pushing duplicates moves to front)
- URL-reproducible routes
- Dynamic route support

Access navigation with `DartBoardCore.nav`:

```dart
// Push a route
DartBoardCore.nav.push('/some_route');

// Pop the top route
DartBoardCore.nav.pop();

// Pop until a condition is met
DartBoardCore.nav.popUntil((path) => path.path == '/home');

// Replace the top route
DartBoardCore.nav.replaceTop('/new_route');

// Push a dynamic route
DartBoardCore.nav.pushDynamic(
  dynamicPathName: 'details',
  builder: (context) => YourWidget()
);
```

## State Management Options

Dart Board supports multiple state management approaches:

### Locator

Simple service locator pattern:

```dart
// Register a service
LocatorDecoration(() => YourService())

// Use a service
locate<YourService>()
```

### Redux

Feature-aware Redux implementation:

```dart
// Register state
ReduxStateDecoration<YourState>(initialState)

// Build with state
FeatureStateBuilder<YourState>((ctx, state) => YourWidget(state))
```

### Bloc/Cubit

Support for Bloc/Cubit:

```dart
// Register bloc
BlocDecoration<YourBloc>(() => YourBloc())
```

## Add2App Support

Dart Board simplifies Add2App integration with Android and iOS. See the [Add2App Example](https://github.com/ahammer/dart_board_add2app).

Recommendations:
- Start with leaf screens, not trunk navigation
- Use Pigeon for type-safe platform channel communication
- Convert features to plugins for native code bundling

## Development Best Practices

- **Keep Features Small**: Focus each feature on a single responsibility
- **Develop in Isolation**: Test features independently before integration
- **Integrate Last**: Build portability by avoiding premature integration
- **Feature Configuration**: Provide sensible defaults but allow override

## License

Dart Board is available under the MIT License. See [LICENSE](LICENSE) for details.

## Special Thanks

- [FlexColorScheme](https://pub.dev/packages/flex_color_scheme) for theming support
- [FlexColorPicker](https://pub.dev/packages/flex_color_picker) for color selection
- The Flutter community for feedback and contributions
