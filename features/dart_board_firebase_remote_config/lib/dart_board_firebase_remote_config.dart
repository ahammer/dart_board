import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Enabled Firebase RemoteConfig for dart-board apps
class DartBoardFirebaseRemoteConfig extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies => [DartBoardFirebaseAppFeature()];

  @override
  String get namespace => "DartBoardRemoteConfigFeature";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "FirebaseRemoteConfig",
            decoration: (ctx, child) =>
                FirebaseRemoteConfigBinding(child: child))
      ];
}

class FirebaseRemoteConfigBinding extends StatefulWidget {
  final Widget child;

  const FirebaseRemoteConfigBinding({Key? key, required this.child})
      : super(key: key);

  @override
  _FirebaseRemoteConfigBindingState createState() =>
      _FirebaseRemoteConfigBindingState();
}

class _FirebaseRemoteConfigBindingState
    extends State<FirebaseRemoteConfigBinding> {
  @override
  Widget build(BuildContext context) => widget.child;
}
