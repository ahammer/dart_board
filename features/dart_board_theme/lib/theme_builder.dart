import 'package:dart_board_core/dart_board.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeBuilder extends StatefulWidget {
  @override
  State<ThemeBuilder> createState() => _ThemeBuilderState();
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  late final initialTheme = Theme.of(context);
  late Map<String, Color> colors = {
    'background': initialTheme.colorScheme.background,
    'error': initialTheme.colorScheme.error,
    'onBackground': initialTheme.colorScheme.onBackground,
    'onError': initialTheme.colorScheme.onError,
    'onPrimary': initialTheme.colorScheme.onPrimary,
    'onSecondary': initialTheme.colorScheme.onSecondary,
    'onSurface': initialTheme.colorScheme.onSurface,
    'primary': initialTheme.colorScheme.primary,
    'primaryVariant': initialTheme.colorScheme.primaryVariant,
    'secondary': initialTheme.colorScheme.secondary,
    'secondaryVariant': initialTheme.colorScheme.secondaryVariant,
    'surface': initialTheme.colorScheme.surface
  };

  late final Brightness brightness = initialTheme.brightness;

  ThemeData get data => ThemeData.from(
          colorScheme: ColorScheme(
        background: colors['background']!,
        brightness: brightness,
        error: colors['error']!,
        onBackground: colors['onBackground']!,
        onError: colors['onError']!,
        onPrimary: colors['onPrimary']!,
        onSecondary: colors['onSecondary']!,
        onSurface: colors['onSurface']!,
        primary: colors['primary']!,
        primaryVariant: colors['primaryVariant']!,
        secondary: colors['secondary']!,
        secondaryVariant: colors['secondaryVariant']!,
        surface: colors['surface']!,
      ));

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: Card(
                  child: Column(
            children: [
              FittedBox(
                child: Text(
                  'Theme Editor',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                height: 24,
              ),
              ColorPicker(
                color: data.colorScheme.secondary,
                onColorChanged: (color) {
                  colors['surface'] = color;
                  DartBoardCore.instance.dispatchMethodCall(
                      context: context,
                      call: MethodCall('setThemeData', {'themeData': data}));
                },
              ),
            ],
          ))),
          Expanded(
              flex: 5,
              child: Container(
                  child: RouteWidget(
                '/main',
              ))),
        ],
      );
}
