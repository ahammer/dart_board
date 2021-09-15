import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeChooserDropdown(),
        ],
      ),
    );
  }
}

class ThemeChooserDropdown extends StatefulWidget {
  const ThemeChooserDropdown({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeChooserDropdown> createState() => _ThemeChooserDropdownState();
}

class _ThemeChooserDropdownState extends State<ThemeChooserDropdown> {
  int selection = -1;
  late bool dark = Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final items = FlexScheme.values
        .map((scheme) => DropdownMenuItem<int>(
              value: scheme.index,
              child: Text(scheme.toString().replaceAll('FlexScheme.', '')),
            ))
        .toList();

    return Row(
      children: [
        Text('Dark'),
        Switch(
          onChanged: (val) {
            dark = val;
            applyTheme(context);
            setState(() {});
          },
          value: dark,
        ),
        Expanded(
          child: DropdownButton<int>(
            items: [
              DropdownMenuItem<int>(value: -1, child: Text('Select a Theme')),
              ...items
            ],
            value: selection,
            onChanged: (value) {
              if (value != -1 && value != null) {
                selection = value;
                applyTheme(context);
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }

  void applyTheme(BuildContext context) {
    if (selection == -1) {
      DartBoardCore.instance.dispatchMethodCall(
          context: context,
          call: MethodCall('setThemeData',
              {'themeData': dark ? ThemeData.dark() : ThemeData.light()}));
      return;
    }
    final theme = FlexScheme.values[selection];
    final themeData = dark
        ? FlexColorScheme.dark(scheme: theme).toTheme
        : FlexColorScheme.light(scheme: theme).toTheme;

    DartBoardCore.instance.dispatchMethodCall(
        context: context,
        call: MethodCall('setThemeData', {
          'themeData': themeData,
        }));
  }
}
