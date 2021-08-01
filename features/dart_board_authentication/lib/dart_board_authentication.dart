import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_locator/dart_board_locator.dart';

/// Provides 
class DartBoardAuthenticationFeature extends DartBoardFeature {
  @override
  List<DartBoardDecoration> get appDecorations =>
      [LocatorDecoration<AuthenticationState>(() => AuthenticationState())];
}


class AuthenticationState extends ChangeNotifier {  
  bool signedIn = false;
}

abstract class AuthenticationDelegate {
  String get name;
  Future<void> authenticate();  
}