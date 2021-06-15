import 'package:dart_board_core/dart_board.dart';

class DartBoardLocatorFeature extends DartBoardFeature {
  @override
  String get namespace => "locator";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "locator",
            decoration: (BuildContext context, Widget child) => _Locator(
                  child: child,
                  key: _locatorKey,
                ))
      ];
}

/// This decoration applies
class LocatorDecoration<T> extends DartBoardDecoration {
  final T Function() builder;

  LocatorDecoration(this.builder)
      : super(
            name: "LocatorDecoration_${T.toString()}",
            decoration: (BuildContext context, Widget child) => LifeCycleWidget(
                preInit: () =>
                    _locatorKey.currentState!.registerBuilder<T>(builder),
                child: child));
}

class _Locator extends StatefulWidget {
  final Widget child;

  const _Locator({Key? key, required this.child}) : super(key: key);

  @override
  _LocatorState createState() => _LocatorState();
}

class _LocatorState extends State<_Locator> {
  final Map<Type, dynamic> objectCache = {};
  final Map<Type, dynamic Function()> builders = {};

  @override
  Widget build(BuildContext context) => widget.child;
  @override
  void initState() {
    super.initState();
  }

  T _locate<T>(Type type) {
    /// Return from cache
    if (objectCache.containsKey(T)) {
      return objectCache[T] as T;
    }

    ///
    if (builders.containsKey(T)) {
      objectCache[T] = builders[T]!.call() as T;
      return objectCache[T] as T;
    }
    throw Exception("Can not instantiate $T");
  }

  registerBuilder<T>(T Function() builder) {
    builders[T] = builder;
  }
}

final _locatorKey = GlobalKey<_LocatorState>();

T locate<T>() {
  return _locatorKey.currentState!._locate(T);
}
