import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// A factory for states
typedef StateFactory<T> = T Function();

/// State Factories
final Map<Type, StateFactory<Type>> _factories = {};

/// This is a delegate for Reducing.
///
/// This is actually what we'll dispatch
typedef ReductionDelegate<T> = T Function<T>(T oldState);

/// A class container for a Reducer function
abstract class Reducable<T> {
  abstract final ReductionDelegate<T> reduce;
}

/// This is our app-level State
class DartBoardState {
  /// We track data for the extensions
  /// Type => Instance => Data
  final Map<Type, Map<String, dynamic>> data;

  /// Constructor, takes the data
  DartBoardState({required this.data});
}

/// This is our store in global scope accessible everywhere
final Store<DartBoardState> store =
    Store(_reducer, initialState: DartBoardState(data: {}));

class DartBoardRedux extends DartBoardFeature {
  @override
  String get namespace => "redux";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "redux store",
            decoration: (ctx, child) => StoreProvider(
                key: Key("redux_store"), store: store, child: child))
      ];
}

ReductionDelegate<DartBoardState> wrapFeatureAction<T>(
        ReductionDelegate<T> featureReducer) =>
    <T>(T featureState) => featureReducer(featureState);

/// This is the main reducer, It'll handle creating a new DartBoardState
DartBoardState _reducer(DartBoardState state, action) {
  if (action is ReductionDelegate<DartBoardState>) {
    return action(state);
  }
  return state;
}

/// This will need to be the real dispatch
void _dispatch_internal<T>(ReductionDelegate<T> reducer) =>
    store.dispatch(reducer);

// Dynamic Dispatch
void dispatch<T>(dynamic dispatchable, {String instance = ""}) {
  if (dispatchable is ReductionDelegate<T>) {
    _dispatch_internal<T>(dispatchable);
  } else if (dispatchable is Reducable<T>) {
    _dispatch_internal<T>(dispatchable.reduce);
  } else {
    throw Exception(
        "What are you trying to dispatch? Reducer and Reducable only");
  }
}
