import 'package:dart_board_core/dart_board.dart';
import 'package:firebase_core/firebase_core.dart';

/// Initialization Hook for Firebase App
/// For firebase-capable features to use
class DartBoardFirebaseAppFeature extends DartBoardFeature {
  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "FirebaseApp",
            decoration: (ctx, child) => LifeCycleWidget(
                key: ValueKey("FirebaseApp"),
                preInit: () async {
                  await Firebase.initializeApp();
                },
                child: child))
      ];

  @override
  String get namespace => "DartBoardFirebaseCore";
}
