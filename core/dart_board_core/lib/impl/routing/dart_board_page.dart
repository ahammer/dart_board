import 'package:flutter/material.dart';

class DartBoardPage extends MaterialPage {
  DartBoardPage({
    required Widget child,
    bool maintainState = true,
    bool fullscreenDialog = false,
    required ValueKey key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
          child: child,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) =>
      other is DartBoardPage &&
      other.runtimeType == runtimeType &&
      other.key == key;
}
