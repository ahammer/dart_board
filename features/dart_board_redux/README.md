# dart_board_redux

Redux Capabilities for Dart Board

## Usage

Expose States and Middleware with Decorations in features
Dispatch as necessary. Use FeatureStateBuilder<T> to hook into UI.

## API

 API:
 # Functions
 T getState<T>()
 dispatch(FeatureAction<T>())
 dispatchFunc(T action(T))

 # Classes
 class FeatureAction<T>

 # Decorations
 ReduxStateDecoration
 ReduxMiddlewareDecoration

 # Widget
 FeatureStateBuilder<T>((context, state) => Text(state.toString()))

## Usage

For usage, see Exampl
