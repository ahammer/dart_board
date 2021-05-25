import 'package:dart_board/dart_board.dart';
import 'dart:math' as math;

class DebugList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CollapsingList();
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
    final routes = DartBoardCore.featureList.namedRoutes
      ..sort((a, b) => a.route.compareTo(b.route));

    return CustomScrollView(
      slivers: <Widget>[
        makeHeader(context, 'Extensions'),
        SliverGrid.extent(
          childAspectRatio: 3,
          maxCrossAxisExtent: 200,
          children: [
            ...DartBoardCore.featureList.map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      onPressed: () {}, child: Text(e.namespace)),
                ))
          ],
        ),
        makeHeader(context, 'Routes'),
        SliverGrid.extent(
          childAspectRatio: 3,
          maxCrossAxisExtent: 150,
          children: [
            ...routes.map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      onPressed: () {
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
                      child: Text(e.route)),
                ))
          ],
        ),
        makeHeader(context, 'Page Decorations'),
        SliverGrid.extent(
          childAspectRatio: 3,
          maxCrossAxisExtent: 300,
          children: [
            ...DartBoardCore.instance.pageDecorations.map((e) => Material(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: e.decoration(
                        context,
                        MaterialButton(onPressed: () {}, child: Text(e.name)),
                      )),
                ))
          ],
        ),
      ],
    );
  }
}
