import 'dart:async';
import 'package:flutter/material.dart';
import '../../dart_board.dart';

/// FeatureGate Widget
///
/// When you know a feature will fail if a namespace isn't filled
/// you can use FeatureGate to sort that out.
///
class FeatureGate extends StatelessWidget {
  /// The list of features we require
  final String gatedFeature;

  /// The builder we want to call if we have the required features
  final Widget child;

  ///
  final bool autoEnable;

  const FeatureGate(
      {Key? key,
      required this.gatedFeature,
      required this.child,
      this.autoEnable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DartBoardCore.instance.isFeatureActive(gatedFeature)) {
      return child;
    } else {
      if (autoEnable) {
        return _FeatureEnabler(
          gatedFeature,
          key: UniqueKey(),
          messenger: ScaffoldMessenger.of(context),
        );
      }
      return Card(
        child: Center(
          child: MaterialButton(
              key: ValueKey('EnableFeatureButton'),
              onPressed: () => DartBoardCore.instance
                  .setFeatureImplementation(gatedFeature, 'default'),
              child: Text(
                  '$gatedFeature is required for this\nclick to attempt to enable',
                  key: ValueKey('RequiredFeatureText'))),
        ),
      );
    }
  }
}

class _FeatureEnabler extends StatefulWidget {
  final String feature;
  final ScaffoldMessengerState messenger;

  const _FeatureEnabler(this.feature, {Key? key, required this.messenger})
      : super(key: key);

  @override
  __FeatureEnablerState createState() => __FeatureEnablerState();
}

class __FeatureEnablerState extends State<_FeatureEnabler> {
  @override
  void initState() {
    super.initState();

    Timer.run(() {
      DartBoardCore.instance
          .setFeatureImplementation(widget.feature, 'default');
      widget.messenger.showSnackBar(
          SnackBar(content: Text('Enabled feature ${widget.feature}')));
    });
  }

  @override
  Widget build(BuildContext context) => Container();
}

/// Feature Gate Page Decoration
///
/// The name (for filtering will be `FeatureGate+namespace`)
class FeatureGatePageDecoration extends DartBoardDecoration {
  final bool autoEnable;
  FeatureGatePageDecoration(String feature, {this.autoEnable = true})
      : super(
            decoration: (ctx, child) => FeatureGate(
                  gatedFeature: feature,
                  autoEnable: autoEnable,
                  child: child,
                ),
            name: 'FeatureGate+$feature');
}
