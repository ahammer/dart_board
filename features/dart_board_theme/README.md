# dart_board_theme_extension

Basic theme capabilities for dart board (light/dark)

Initialize the theme with `ThemeFeature(data: ...)`, then change it with the
`setThemeData` method handler:

```dart
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(DartBoard(
      initialPath: '/theme_editor',
      features: [ThemeFeature(data: ThemeData.light())],
    ));

Future<void> setDarkTheme(BuildContext context) async {
  await DartBoardCore.instance.dispatchMethodCall(
    context: context,
    call: MethodCall('setThemeData', {'themeData': ThemeData.dark()}),
  );
}
```

The feature applies the selected theme as a page decoration.
