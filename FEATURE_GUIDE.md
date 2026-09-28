# Dart Board Feature Guide

Add features to `DartBoard.features` or to another feature's `dependencies`.
Add decorations to that feature's `appDecorations` or `pageDecorations`.
The links below point to the implementations and their constructor arguments.

## State management

| Package | API | Usage |
| --- | --- | --- |
| [Locator](features/dart_board_locator/lib/dart_board_locator.dart) | `DartBoardLocatorFeature`, `LocatorDecoration<T>` | Register a factory with `LocatorDecoration(() => YourService())`, then access it with `locate<YourService>()`. |
| [Redux](features/dart_board_redux/lib/dart_board_redux.dart) | `DartBoardRedux`, `ReduxStateDecoration<T>` | Register state with `ReduxStateDecoration<YourState>(name: 'state', factory: () => YourState())`. Dispatch with `dispatch(action)` or `dispatchFunc<YourState>(reducer)`. |
| [Bloc/Cubit](features/dart_board_bloc/lib/dart_board_bloc.dart) | `BlocDecoration<T, V>`, `CubitDecoration<T, V>` | These decorations install `flutter_bloc` providers; no separate feature is required. Factories receive a `BuildContext`. Use `BlocProvider.of<T>(context)` and `BlocBuilder` from `flutter_bloc`. |

For Redux actions, extend `FeatureAction<T>` and implement `T featureReduce(T state)`.
`FeatureStateBuilder<T>((context, state) => YourWidget())` takes a positional builder.
See [Minesweeper](features/dart_board_minesweeper/lib/dart_board_minesweeper.dart) for a complete Redux integration.
The [starter cart](integrations/starter/lib/features/cart_feature_complete.dart) uses Locator and `ChangeNotifier`.

## Development tools

| Feature | Routes and behavior |
| --- | --- |
| [DebugFeature](features/dart_board_debug/lib/debug_feature.dart) | `/debug` lists features and lets you change implementations; `/dependency_tree` shows dependencies. |
| [LogFeature](features/dart_board_log/lib/dart_board_log.dart) | `/log` displays records from `package:logging`. Write records with `Logger('YourFeature').info('message')`. |
| [DiagnosticFeature](core/dart_board_core/lib/impl/features/diagnostic_feature.dart) | `/diagnostics` displays an initialization report. Exported by `dart_board_core`. |

## UI features

| Feature | Configuration |
| --- | --- |
| [DartBoardCanvasFeature](features/dart_board_canvas/lib/dart_board_canvas.dart) | Supply `namespace`, `implementationName`, `route`, and `stateBuilder`. The state extends `AnimatedCanvasState` and implements `paint(Canvas canvas, Size size)`; elapsed seconds are available as `time`. |
| [ImageBackgroundFeature](features/dart_board_image_background/lib/dart_board_image_background.dart) | Supply `namespace`, `implementationName`, and either `filename` (a declared asset) or `widget`. Applies a page decoration. |
| [DartBoardSplashFeature](features/dart_board_splash/lib/dart_board_splash.dart) | Takes a splash widget as a positional argument. `FadeOutSplashScreen` supplies timed dismissal. |
| [ThemeFeature](features/dart_board_theme/lib/dart_board_theme.dart) | Takes `data: ThemeData(...)` and optional `middleware`. Provides `/theme_editor` and the `setThemeData` method handler. |

The [example integration](integrations/example/lib/example_feature.dart) configures each of these features,
including multiple background implementations and an [animated splash](integrations/example/lib/impl/splash/splash.dart).

## Firebase

Configure Firebase for your app before enabling these features. The example's Apple targets require
iOS 13 or macOS 10.15. Native initialization uses the platform configuration; web initialization
reads `window.firebaseConfig`, as shown in [index.html](integrations/example/web/index.html).

| Feature | Purpose |
| --- | --- |
| [DartBoardFirebaseCoreFeature](features/dart_board_firebase_core/lib/dart_board_firebase_core.dart) | Initializes Firebase before building dependent app content on supported platforms. |
| [DartBoardAuthenticationFlutterFireFeature](features/dart_board_firebase_authentication/lib/dart_board_firebase_authentication.dart) | Connects Firebase Authentication to the Dart Board authentication facade. |
| [DartBoardFirebaseDatabaseFeature](features/dart_board_firebase_database/lib/dart_board_firebase_database.dart) | Cloud Firestore helpers: `CollectionView` and `QueryListView` render query snapshots. This package does not wrap Realtime Database. |
| [DartBoardFirebaseAnalytics](features/dart_board_firebase_analytics/lib/dart_board_firebase_analytics.dart) | Connects Firebase Analytics to Dart Board tracking. |

The authentication, database, and analytics features declare Firebase Core as a dependency.

## Complete examples

- [DartBoardChatFeature](features/dart_board_chat/lib/dart_board_chat.dart) provides `/chat` and requires Firebase configuration and authentication.
- [MinesweeperFeature](features/dart_board_minesweeper/lib/dart_board_minesweeper.dart) provides `/minesweep` and demonstrates Redux state management.
- The [starter app](integrations/starter/lib/main.dart) combines repository, listing, details, cart, and checkout features.

See [Getting Started](GETTING_STARTED.md) to run the workspace and create a feature.
