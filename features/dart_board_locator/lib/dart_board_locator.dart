import 'package:dart_board_core/dart_board.dart';

/// Simple Locator/DI/Service Injector for DartBoard
///
/// In your Features.
///
/// Register Factories in the AppDecorations
///   [LocatorDecoration(()=>YourType())];
///
/// Use YourType Anywhere
///
/// YourType obj = locate();
///
/// or
///
/// locate<YourType>()
///   ..width = 10
///   ..doSomethingElse()
///
///
/// Optionally, with instanceId
///
/// locate<YourType>(instance_id: "unique state id")
///
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
                key: ValueKey("LocatorDecoration_${T.toString()}"),
                preInit: () =>
                    _locatorKey.currentState!.registerBuilder<T>(builder),
                child: Builder(builder: (ctx) => child)));
}

class _Locator extends StatefulWidget {
  final Widget child;

  const _Locator({Key? key, required this.child}) : super(key: key);

  @override
  _LocatorState createState() => _LocatorState();
}

class _LocatorState extends State<_Locator> {
  final Map<Type, Map<String, dynamic>> objectCache = {};
  final Map<Type, dynamic Function()> builders = {};

  @override
  Widget build(BuildContext context) => widget.child;
  @override
  void initState() {
    super.initState();
  }

  T _locate<T>(Type type, {String instanceId = ""}) {
    /// Return from cache
    if (objectCache.containsKey(T) && objectCache[T]!.containsKey(instanceId)) {
      return objectCache[T]![instanceId] as T;
    }

    /// Build it if we can
    if (builders.containsKey(T)) {
      objectCache.putIfAbsent(T, () => {});
      objectCache[T]![instanceId] = builders[T]!.call() as T;
      return objectCache[T]![instanceId] as T;
    }

    throw Exception("Can not instantiate $T");
  }

  registerBuilder<T>(T Function() builder) {
    builders[T] = builder;
  }
}

/// Global Key we use to Track the store.
final _locatorKey = GlobalKey<_LocatorState>();

/// Globally Locate a type
T locate<T>({String instanceId = ""}) =>
    _locatorKey.currentState!._locate(T, instanceId: instanceId);
