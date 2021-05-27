import 'package:dart_board/dart_board.dart';
import 'dart:math' as math;

class DebugList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          ),
          CollapsingList(),
        ],
      );
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

class CollapsingList extends StatelessWidget {
  SliverPersistentHeader makeHeader(BuildContext context, String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 20.0,
        maxHeight: 50.0,
        child: Material(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
            elevation: 1,
            child: FittedBox(fit: BoxFit.contain, child: Text(headerText))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = DartBoardCore.instance.allFeatures.namedRoutes
      ..sort((a, b) => a.route.compareTo(b.route));

    return CustomScrollView(
      slivers: <Widget>[
        ///-------------------------------------------------------------------
        makeHeader(context, 'Extensions'),
        SliverGrid.extent(
          childAspectRatio: 3,
          maxCrossAxisExtent: 300,
          children: [
            ...DartBoardCore.instance.allFeatures.map((e) {
              final implementations =
                  DartBoardCore.instance.detectedImplementations[e.namespace]!;

              return Card(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: [
                        Text('Namespace: ${e.namespace}'),
                        Text('Active: ${implementations[0]}'),
                        if (implementations.length > 1)
                          DropdownButton(
                              onChanged: (value) {},
                              value: DartBoardCore.instance
                                  .selectedImplementations[e.namespace],
                              items: implementations
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text('$e')))
                                  .toList()),
                      ],
                    )),
              );
            })
          ],
        ),

        ///-------------------------------------------------------------------
        makeHeader(context, 'Routes'),
        SliverGrid.extent(
          childAspectRatio: 3,
          maxCrossAxisExtent: 150,
          children: [
            ...routes.map((e) => Card(
                  child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Material(
                                    child: RouteWidget(
                                        settings: RouteSettings(name: e.route)),
                                  ),
                                ));
                      },
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
    );
  }
}

class DebugLabelText extends StatelessWidget {
  final String text;

  const DebugLabelText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      );
}
