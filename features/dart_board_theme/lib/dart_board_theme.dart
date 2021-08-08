import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/widgets/timer_widgets.dart';
import 'package:flutter/material.dart';

class ThemeFeature extends DartBoardFeature {
  @override
  String get implementationName => 'Theme';

  final bool isDarkByDefault;
  ThemeFeature({this.isDarkByDefault = false});

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
                create: (ctx) => ThemeState(isLight: !isDarkByDefault),
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
  bool isLight;

  ThemeState({this.isLight = true});

  void toggleTheme() {
    isLight = !isLight;
    notifyListeners();
  }
}

class RainbowThemeFeature extends DartBoardFeature {
  @override
  String get namespace => 'theme';

  @override
  String get implementationName => 'rainbowTheme';

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            name: 'RainbowTheme',
            decoration: (ctx, child) {
              return RainbowApplier(child: child);
            })
      ];
}

class RainbowApplier extends StatelessWidget {
  final Widget child;
  const RainbowApplier({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PeriodicWidget(
      builder: (ctx, child, idx) => Theme(
          data: idx % 2 == 0 ? ThemeData.dark() : ThemeData.light(),
          child: child),
      duration: Duration(seconds: 1),
      callback: (idx) {},
      child: child);
}
