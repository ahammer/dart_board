import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ThemeBuilder extends StatefulWidget {
  @override
  State<ThemeBuilder> createState() => _ThemeBuilderState();
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  @override
  Widget build(BuildContext context) {
    final state = context.read<ThemeState>();
    final theme = Theme.of(context);
    return Container(
      child: Row(
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
                color: theme.primaryColor,
                onColorChanged: (color) {},
              ),
            ],
          ))),
          Expanded(
              flex: 5,
              child: Container(
                  child: Theme(
                      data: ThemeData.light(),
                      child: Builder(builder: (context) {
                        return RouteWidget('/main');
                      })))),
        ],
      ),
    );
  }
}
