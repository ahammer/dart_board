import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeExtension extends DartBoardExtension {
  @override
  get pageDecorations => [
        PageDecoration(
            name: "Theme Applicator",
            decoration: (context, child) => Consumer<ThemeState>(
                  child: child,
                  builder: (ctx, val, child) => Theme(
                      child: child,
                      data: val.isLight ? ThemeData.light() : ThemeData.dark()),
                )),
      ];

  @override
  get routes =>
      <RouteDefinition>[]..addMap({"/theme": (ctx, settings) => ThemePage()});

  static void toggle(BuildContext context) =>
      Provider.of<ThemeState>(context, listen: false).toggleTheme();

  @override
  get appDecorations => [
        (context, child) => ChangeNotifierProvider<ThemeState>(
            create: (ctx) => ThemeState(), child: child)
      ];

  @override
  String get namespace => "ThemeChooser";
}

class ThemePage extends StatelessWidget {
  const ThemePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Theme Selection",
                  style: Theme.of(context).textTheme.headline4,
                )),
            Consumer<ThemeState>(
                builder: (ctx, value, child) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Light Theme? "),
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
  toggleTheme() {
    isLight = !isLight;
    notifyListeners();
  }
}
