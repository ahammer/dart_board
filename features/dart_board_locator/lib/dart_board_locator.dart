import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:flutter/material.dart';

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
  final Map<Type, Map<String, dynamic>> objectCache = {};
  final Map<Type, dynamic Function()> builders = {};

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

  @override
  String get namespace => "Locator";
}

/// This decoration applies
class LocatorDecoration<T> extends DartBoardDecoration {
  final T Function() builder;

  LocatorDecoration(this.builder)
      : super(
            name: "Loc${T.toString()}",
            decoration: (BuildContext context, Widget child) => LifeCycleWidget(
                key: ValueKey("LocatorDecoration_${T.toString()}"),
                preInit: () => (DartBoardCore.instance.findByName("Locator")
                        as DartBoardLocatorFeature)
                    .registerBuilder<T>(builder),
                child: Builder(builder: (ctx) => child)));
}

/// Globally Locate a type via the Locator
T locate<T>({String instanceId = ""}) =>
    (DartBoardCore.instance.findByName("Locator") as DartBoardLocatorFeature)
        ._locate(T, instanceId: instanceId);

/// Locate a ChangeNotifier and Build it.
Widget locateAndBuild<T extends ChangeNotifier>(
        Widget Function(BuildContext, T) builder,
        {String instanceId = ""}) =>
    locate<T>(instanceId: instanceId).builder<T>(builder);

Widget locateAndBuild2<T extends ChangeNotifier, V extends ChangeNotifier>(
    Widget Function(BuildContext, T, V) builder,
    {String instanceId1 = "",
    String instanceId2 = ""}) {
  return Container();
}
