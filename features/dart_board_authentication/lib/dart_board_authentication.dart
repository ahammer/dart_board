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

// A widget that shows 1 of two widgets, signed in or out.
// It'll update with the authentication state
class AuthenticationGate extends StatefulWidget {
  final WidgetBuilder signedOut;
  final WidgetBuilder signedIn;

  const AuthenticationGate(
      {Key? key, required this.signedOut, required this.signedIn})
      : super(key: key);

  @override
  _AuthenticationGateState createState() => _AuthenticationGateState();
}

class _AuthenticationGateState extends State<AuthenticationGate> {
  late final Widget signedIn = widget.signedIn(context);
  late final Widget signedOut = widget.signedOut(context);
  late final authState = locate<AuthenticationState>();
  @override
  void initState() {
    super.initState();
    authState.addListener(onAuthStateChanged);
  }

  @override
  void dispose() {
    authState.removeListener(onAuthStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      authState.signedIn ? signedIn : signedOut;

  void onAuthStateChanged() => setState(() {});
}
