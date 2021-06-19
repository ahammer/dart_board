import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

class ThemeFeature extends DartBoardFeature {
  ThemeFeature();

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            name: 'theme_applicator',
            decoration: (context, child) => Consumer<ThemeState>(
                  builder: (ctx, val, child) => Theme(
                      data: val.isLight ? ThemeData.light() : ThemeData.dark(),
                      child: child!),
                  child: child,
                )),
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/theme', builder: (ctx, settings) => ThemePage())
      ];

  static void toggle(BuildContext context) =>
      Provider.of<ThemeState>(context, listen: false).toggleTheme();

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'theme_state_holder',
            decoration: (context, child) => ChangeNotifierProvider<ThemeState>(
                key: Key('theme_state_holder'),
                create: (ctx) => ThemeState(),
                child: child))
      ];

  @override
  String get namespace => 'theme';

  static bool get isLight =>
      Provider.of<ThemeState>(dartBoardNavKey.currentContext!).isLight;
}

class ThemePage extends StatelessWidget {
  const ThemePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Theme Selection',
                  style: Theme.of(context).textTheme.headline4,
                )),
            Consumer<ThemeState>(
                builder: (ctx, value, child) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Light Theme? '),
                          Checkbox(
                              value: value.isLight,
                              onChanged: (_) => value.toggleTheme()),
                        ],
                      ),
                    )),
          ],
        ),
      );
}

class ThemeState extends ChangeNotifier {
  bool isLight = true;
  void toggleTheme() {
    isLight = !isLight;
    notifyListeners();
  }
}
