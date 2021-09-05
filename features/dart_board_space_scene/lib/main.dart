import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'clocks/clock_scaffolding.dart';
import 'customizer.dart';

void main() {
  /// Fuschia should run fine all around here
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(const MainWidget());
}

///
/// We broke out the "Main" widget into it's own
///
/// So we can "Navigate" to it
class MainWidget extends StatelessWidget {
  /// Main Screen
  const MainWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClockCustomizer(
      (model) => Builder(builder: (context) => ClockScaffolding(model: model)));
}
