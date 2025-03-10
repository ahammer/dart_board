# Dart Board Feature Guide

This guide provides an overview of available features in the Dart Board ecosystem, organized by category. Each feature serves a specific purpose and can be composed with others to build comprehensive applications.

## State Management

Dart Board provides multiple state management solutions to fit different project needs and team preferences.

### Locator

**Purpose**: Simple service location and dependency injection.

**When to use**: For small to medium apps where simplicity is preferred over strict architecture.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_locator/dart_board_locator.dart';

// Include the feature
@override
List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];

// Register a service
@override
List<DartBoardDecoration> get appDecorations => 
    [LocatorDecoration(() => YourService())];
```

**Usage**:
```dart
// Access a service
final service = locate<YourService>();

// With ChangeNotifier, automatically rebuild on changes
locate<YourModel>().builder<YourModel>(
  (context, model) => Text(model.value)
);
```

### Redux

**Purpose**: Predictable state container with unidirectional data flow.

**When to use**: For larger applications with complex state requirements where debugging and traceability are important.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_redux/dart_board_redux.dart';

// Include the feature
@override
List<DartBoardFeature> get dependencies => [DartBoardReduxFeature()];

// Register initial state
@override
List<DartBoardDecoration> get appDecorations => [
  ReduxStateDecoration<YourState>(YourState.initial())
];

// Add middleware (optional)
@override
List<DartBoardDecoration> get appDecorations => [
  ReduxMiddlewareDecoration<YourState>((store, action, next) {
    // Your middleware logic
    return next(action);
  })
];
```

**Usage**:
```dart
// Create actions
class IncrementAction extends FeatureAction<CounterState> {
  @override
  CounterState reduce(CounterState state) => 
      CounterState(count: state.count + 1);
}

// Dispatch actions
DartBoardCore.instance.dispatchAction(IncrementAction());

// Connect to the UI
FeatureStateBuilder<CounterState>(
  builder: (context, state) => Text('Count: ${state.count}')
);
```

### Bloc/Cubit

**Purpose**: Stream-based state management with reactive approach.

**When to use**: For reactive applications with asynchronous operations.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_bloc/dart_board_bloc.dart';

// Include the feature
@override
List<DartBoardFeature> get dependencies => [DartBoardBlocFeature()];

// Register a bloc
@override
List<DartBoardDecoration> get appDecorations => [
  BlocDecoration<YourBloc>(() => YourBloc())
];
```

**Usage**:
```dart
// Access a bloc
final bloc = locateBloc<YourBloc>();

// With BlocBuilder
BlocBuilder<YourBloc, YourState>(
  bloc: locateBloc<YourBloc>(),
  builder: (context, state) => Text(state.value)
);
```

## Development Tools

Dart Board includes several features to aid in development and debugging.

### Debug

**Purpose**: Runtime inspection of Dart Board features and states.

**When to use**: During development to help understand feature loading, dependencies, and current state.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_debug/debug_feature.dart';

// Include the feature
DebugFeature()
```

**Usage**:
- Navigate to `/debug` to see loaded features
- Navigate to `/dependency_graph` to visualize feature dependencies
- Use the debug panel to enable/disable features at runtime

### Log

**Purpose**: In-app logging viewer with configurable log levels.

**When to use**: For tracking app behavior and debugging issues, especially on devices where console logs are hard to access.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_log/dart_board_log.dart';

// Include the feature
DartBoardLogFeature()
```

**Usage**:
```dart
// Log messages
DartBoardLog.info('User logged in');
DartBoardLog.error('Login failed', exception);

// View logs
// Navigate to `/log` or enable the log overlay
```

## UI Components

Dart Board provides various UI features to enhance your application's visual experience.

### Canvas

**Purpose**: Custom rendering with efficient animated canvas elements.

**When to use**: For custom animations, visualizations, or interactive graphics.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_canvas/dart_board_canvas.dart';

// Include the feature
DartBoardCanvasFeature()
```

**Usage**:
```dart
// Create a canvas painter
class YourPainter extends DartBoardCanvasPainter {
  @override
  void paint(Canvas canvas, Size size, double time) {
    // Your custom painting logic
  }
}

// Use in your routes
@override
List<RouteDefinition> get routes => [
  NamedRouteDefinition(
    '/your_animation',
    (context, settings) => DartBoardCanvas(
      builder: () => YourPainter(),
    )
  )
];
```

### Image Background

**Purpose**: Apply background images or widgets to any page.

**When to use**: For consistent background styling across multiple screens.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_image_background/dart_board_image_background.dart';

// Include the feature with configuration
ImageBackgroundFeature(
  backgroundImage: 'assets/background.jpg'
)
```

**Usage**:
- The background is automatically applied to all pages
- Can be configured to apply only to specific routes

### Splash

**Purpose**: Show a splash screen on app startup.

**When to use**: To provide a branded launch experience while the app initializes.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_splash/dart_board_splash.dart';

// Include the feature
SplashFeature(
  splashWidget: YourSplashWidget(),
  duration: Duration(seconds: 2)
)
```

**Usage**:
- The splash screen is automatically shown on app start
- Can be combined with Canvas for animated splash screens

### Theme

**Purpose**: Configurable app themes with light/dark mode support.

**When to use**: To provide consistent styling and support for theme switching.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_theme/dart_board_theme.dart';

// Include the feature
ThemeFeature(
  lightTheme: FlexColorScheme.light(...).toTheme,
  darkTheme: FlexColorScheme.dark(...).toTheme
)
```

**Usage**:
```dart
// Switch theme
DartBoardTheme.of(context).setDarkMode(true);

// Access theme
final isDark = DartBoardTheme.of(context).isDarkMode;
```

## Firebase Integration

Dart Board offers several features for Firebase integration.

### Firebase Core

**Purpose**: Initializes Firebase for your application.

**When to use**: As a prerequisite for any Firebase-based features.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';

// Include the feature
FirebaseCoreFeature()
```

### Firebase Authentication

**Purpose**: Implements authentication using Firebase Auth.

**When to use**: When you need user authentication with Firebase.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_firebase_authentication/dart_board_firebase_authentication.dart';

// Include the feature
FirebaseAuthenticationFeature()
```

**Usage**:
```dart
// Check auth state
final user = FirebaseAuth.instance.currentUser;

// Login with email/password
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password'
);
```

### Firebase Database

**Purpose**: Provides helpers for Firebase Realtime Database.

**When to use**: When you need real-time data synchronization.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_firebase_database/dart_board_firebase_database.dart';

// Include the feature
FirebaseDatabaseFeature()
```

**Usage**:
```dart
// Get a database reference
final ref = FirebaseDatabase.instance.ref('path/to/data');

// Read data
final snapshot = await ref.get();
final value = snapshot.value;

// Write data
await ref.set({'key': 'value'});

// Listen to changes
ref.onValue.listen((event) {
  final data = event.snapshot.value;
});
```

### Firebase Analytics

**Purpose**: Track user events and app usage with Firebase Analytics.

**When to use**: When you need insights into user behavior.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_firebase_analytics/dart_board_firebase_analytics.dart';

// Include the feature
FirebaseAnalyticsFeature()
```

**Usage**:
```dart
// Log an event
FirebaseAnalytics.instance.logEvent(
  name: 'button_clicked',
  parameters: {'button_id': 'login'}
);
```

## Complete Features

Dart Board includes some fully-featured modules that demonstrate more complex implementations.

### Chat

**Purpose**: Provides a real-time chat interface using Firebase.

**When to use**: When you need a messaging component in your app.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_chat/dart_board_chat.dart';

// Include the feature
ChatFeature()
```

**Usage**:
- Navigate to `/chat` to access the chat interface
- Requires Firebase setup and authentication

### Minesweeper

**Purpose**: A complete Minesweeper game implementation using Redux.

**When to use**: As a reference for building feature-complete applications with state management.

**Setup**:
```dart
// Add the dependency
import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';

// Include the feature
MinesweeperFeature()
```

**Usage**:
- Navigate to `/minesweep` to play the game
- Demonstrates Redux state management in action

## Building Your Own Features

Creating custom features is at the heart of Dart Board development. A well-designed feature:

1. Has a clear, single responsibility
2. Exposes functionality through routes, method calls, or decorations
3. Minimizes direct dependencies on other features
4. Is configurable through its constructor

Basic feature template:

```dart
class YourFeature extends DartBoardFeature {
  final String configOption;
  
  YourFeature({this.configOption = 'default'});
  
  @override
  String get namespace => "YourFeature";
  
  @override
  List<DartBoardFeature> get dependencies => [
    // Include features this depends on
  ];
  
  @override
  List<RouteDefinition> get routes => [
    // Define routes this feature provides
  ];
  
  @override
  Map<String, MethodCallHandler> get methodHandlers => {
    // Define method calls this feature handles
  };
  
  @override
  List<DartBoardDecoration> get appDecorations => [
    // Define app-level decorations
  ];
  
  @override
  List<DartBoardDecoration> get pageDecorations => [
    // Define page-level decorations
  ];
}
```

For more details on building features, see the [GETTING_STARTED.md](GETTING_STARTED.md) guide.
