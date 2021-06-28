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

  const FeatureGate({Key? key, required this.gatedFeature, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DartBoardCore.instance.isFeatureActive(gatedFeature)) {
      return child;
    } else {
      return Card(
        child: Center(
          child: MaterialButton(
              onPressed: () => DartBoardCore.instance
                  .setFeatureImplementation(gatedFeature, 'default'),
              child: Text(
                  '$gatedFeature is required for this\nclick to attempt to enable')),
        ),
      );
    }
  }
}

/// Feature Gate Page Decoration
///
/// The name (for filtering will be `FeatureGate+namespace`)
class FeatureGatePageDecoration extends DartBoardDecoration {
  FeatureGatePageDecoration(String feature)
      : super(
            decoration: (ctx, child) =>
                FeatureGate(gatedFeature: feature, child: child),
            name: 'FeatureGate+$feature');
}
