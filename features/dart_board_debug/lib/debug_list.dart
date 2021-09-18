import 'package:dart_board_core/dart_board.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class DebugList extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Material(color: Colors.transparent, child: CollapsingDebugList());
}

class CollapsingDebugList extends StatefulWidget {
  @override
  State<CollapsingDebugList> createState() => _CollapsingDebugListState();
}

class _CollapsingDebugListState extends State<CollapsingDebugList> {
  final _controller = ScrollController();

  SliverPersistentHeader makeHeader(BuildContext context, String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 20.0,
        maxHeight: 50.0,
        child: Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 1,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  headerText,
                  style: Theme.of(context).textTheme.headline5,
                ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = DartBoardCore.instance.allFeatures.namedRoutes
      ..sort((a, b) => a.route.compareTo(b.route));
    final impls = DartBoardCore.instance.detectedImplementations.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return Scrollbar(
      controller: _controller,
      isAlwaysShown: true,
      child: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          ///-------------------------------------------------------------------
          makeHeader(context, 'Features'),
          SliverGrid.extent(
            childAspectRatio: 4,
            maxCrossAxisExtent: 300,
            children: [
              ...impls.map((e) {
                final feature = DartBoardCore.instance.findByName(e);

                return Card(
                  elevation: 10,
                  child: InkWell(
                    onTap: () {
                      showDetails(feature);
                    },
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          feature.namespace,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Builder(builder: (context) {
                          /// B
                          final i =
                              ' Impls(${DartBoardCore.instance.detectedImplementations[feature.namespace]?.length ?? 0})';
                          final r = ' Routes(${feature.routes.length})';
                          final m =
                              ' Methods(${feature.methodHandlers.length})';
                          final a = ' App(${feature.appDecorations.length})';
                          final p = ' Page(${feature.pageDecorations.length})';

                          return FittedBox(
                            child: Text(
                              '${DartBoardCore.instance.detectedImplementations[feature.namespace] != null ? i : ""}${feature.routes.isEmpty ? "" : r}${feature.methodHandlers.isEmpty ? "" : m}${feature.appDecorations.isEmpty ? "" : a}${feature.pageDecorations.isEmpty ? "" : p}'
                                  .trimLeft(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        })
                      ],
                    )),
                  ),
                );
              })
            ],
          ),

          ///-------------------------------------------------------------------
          makeHeader(context, 'Routes'),
          SliverGrid.extent(
            childAspectRatio: 4,
            maxCrossAxisExtent: 300,
            children: [
              ...routes.map((e) => Card(
                    elevation: 10,
                    child: InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Material(
                                  child: RouteWidget(e.route),
                                ))),
                        child: FittedBox(
                            fit: BoxFit.scaleDown, child: Text(e.route))),
                  ))
            ],
          ),

          ///-------------------------------------------------------------------
          makeHeader(context, 'App Decorations'),
          SliverGrid.extent(
            childAspectRatio: 4,
            maxCrossAxisExtent: 300,
            children: [
              ...DartBoardCore.instance.appDecorations
                  .map((e) => DebugLabelText(e.name))
            ],
          ),

          ///-------------------------------------------------------------------
          makeHeader(context, 'Page Decorations'),
          SliverGrid.extent(
            childAspectRatio: 2,
            maxCrossAxisExtent: 300,
            children: [
              ...DartBoardCore.instance.pageDecorations.map((e) => Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Text(e.name),
                        Expanded(
                            child: e.decoration(
                          context,
                          Container(),
                        )),
                      ],
                    ),
                  )),
            ],
          ),

          ///-------------------------------------------------------------------
          makeHeader(context, 'Page Decorations - Allow List'),
          SliverGrid.extent(
              childAspectRatio: 4,
              maxCrossAxisExtent: 300,
              children: [
                ...DartBoardCore.instance.pageDecorationAllowList
                    .map((e) => DebugLabelText(e))
              ]),

          ///-------------------------------------------------------------------
          makeHeader(context, 'Page Decorations - Deny List'),
          SliverGrid.extent(
              childAspectRatio: 4,
              maxCrossAxisExtent: 300,
              children: [
                ...DartBoardCore.instance.pageDecorationDenyList
                    .map((e) => DebugLabelText(e))
              ]),

          ///-------------------------------------------------------------------
          makeHeader(context, 'Page Decorations - Allow List Activated'),
          SliverGrid.extent(
              childAspectRatio: 4,
              maxCrossAxisExtent: 300,
              children: [
                ...DartBoardCore.instance.whitelistedPageDecorations
                    .map((e) => DebugLabelText(e))
              ])
        ],
      ),
    );
  }

  void showDetails(DartBoardFeature feature) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(child: FeatureControls(feature: feature)),
    );
  }
}

class FeatureControls extends StatefulWidget {
  const FeatureControls({
    Key? key,
    required this.feature,
  }) : super(key: key);

  final DartBoardFeature feature;

  @override
  State<FeatureControls> createState() => _FeatureControlsState();
}

class _FeatureControlsState extends State<FeatureControls> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.feature.namespace,
            style: Theme.of(context).textTheme.headline4,
          ),
          SelectImplementationRow(feature: widget.feature),
          if (widget.feature.methodHandlers.isNotEmpty) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Methods '),
                DropdownButton<String>(
                    onChanged: (value) {
                      if (value == null) return;

                      /// Lets dispatch this with no-args to test remote
                      /// call
                      context.dispatchMethod(value);
                    },
                    value: null,
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text('Select to Trigger')),
                      ...widget.feature.methodHandlers.keys
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text('$e')))
                          .toList()
                    ]),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class SelectImplementationRow extends StatelessWidget {
  const SelectImplementationRow({
    Key? key,
    required this.feature,
  }) : super(key: key);

  final DartBoardFeature feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Implementation  '),
        SelectImplementationDropDownButton(feature: feature)
      ],
    );
  }
}

class SelectImplementationDropDownButton extends StatelessWidget {
  final DartBoardFeature feature;

  const SelectImplementationDropDownButton({Key? key, required this.feature})
      : super(key: key);
  @override
  Widget build(BuildContext context) => DropdownButton<String>(
          onChanged: (value) async {
            if (value == null) {
              /// Lets warn before disabling
              await disableWarningPrompt(context, feature.namespace);
            } else {
              DartBoardCore.instance
                  .setFeatureImplementation(feature.namespace, value);
            }
            //setState(() {});
          },
          value:
              DartBoardCore.instance.activeImplementations[feature.namespace],
          items: [
            DropdownMenuItem(value: null, child: Text('Disabled')),
            ...DartBoardCore
                .instance.detectedImplementations[feature.namespace]!
                .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                .toList()
          ]);
}

Future<dynamic> disableWarningPrompt(BuildContext context, String namespace) {
  return showDialog(
      builder: (ctx) => AlertDialog(
            title: Text('Warning: Are you sure?'),
            content: Text(
                'Disabling a feature that is currently active can result in breakage. E.g. if your Route becomes unavailable. Please confirm before continuing'),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () {
                  DartBoardCore.instance
                      .setFeatureImplementation(namespace, null);
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          ),
      context: context);
}

class DebugLabelText extends StatelessWidget {
  final String text;

  const DebugLabelText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
}

extension DartBoardFeatureListExtension on List<DartBoardFeature> {
  List<NamedRouteDefinition> get namedRoutes => fold<List<RouteDefinition>>(
      <RouteDefinition>[],
      (previousValue, element) => <RouteDefinition>[
            ...previousValue,
            ...element.routes
          ]).whereType<NamedRouteDefinition>().toList();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
