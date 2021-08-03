import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_locator/dart_board_locator.dart';

/// Provides
class DartBoardAuthenticationFeature extends DartBoardFeature {
  @override
  List<DartBoardDecoration> get appDecorations =>
      [LocatorDecoration<AuthenticationState>(() => AuthenticationState())];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/request_login",
            builder: (builder, settings) => AuthSignInDialog())
      ];
  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];

  @override
  String get namespace => "DartBoardAuthenticationFeature";
}

class DartBoardAuthenticationProviderAppDecoration extends DartBoardDecoration {
  final String name;
  final AuthenticationDelegate delegate;

  DartBoardAuthenticationProviderAppDecoration(this.name, this.delegate)
      : super(
            name: name,
            decoration: (ctx, child) => LifeCycleWidget(
                init: (ctx) {
                  AuthenticationState.registerDelegate(delegate);
                },
                key: ValueKey("auth_plugin_$name"),
                child: child));
}

class AuthSignInDialog extends StatefulWidget {
  AuthSignInDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AuthSignInDialogState createState() => _AuthSignInDialogState();
}

class _AuthSignInDialogState extends State<AuthSignInDialog> {
  late final authState = locate<AuthenticationState>();
  AuthenticationDelegate? _selected;

  @override
  void initState() {
    super.initState();
    if (authState._delegates.length == 1) {
      setState(() {
        /// We've selected an Auth Provider
        _selected = authState._delegates[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _selected == null
                      ? [
                          Text("Choose Provider"),
                          Divider(),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: authState._delegates.length,
                              itemBuilder: (ctx, idx) => ListTile(
                                    title: Text(authState._delegates[idx].name),
                                    onTap: () {
                                      setState(() {
                                        /// We've selected an Auth Provider
                                        _selected = authState._delegates[idx];
                                      });
                                    },
                                  )),
                        ]
                      : [
                          Text(_selected?.name ?? ""),
                          Divider(),
                          _selected?.buildAuthWidget() ?? Container()
                        ],
                ),
              ))),
    );
  }
}

class AuthenticationState extends ChangeNotifier {
  final _delegates = <AuthenticationDelegate>[];

  AuthenticationDelegate? _activeDelegate;

  bool get signedIn => _activeDelegate != null;

  /// Delegates should call this when authenticated
  void setSignedIn(bool val, AuthenticationDelegate? delegate) {
    if (val) {
      _activeDelegate = delegate;
    } else {
      _activeDelegate = null;
    }
    notifyListeners();
  }

  static void requestSignIn() {
    final authState = locate<AuthenticationState>();
    if (authState.signedIn) throw Exception("Already signed in");

    showDialog(
        useSafeArea: true,
        context: navigatorContext,
        barrierDismissible: true,
        builder: (ctx) => RouteWidget("/request_login"));
  }

  static void registerDelegate(AuthenticationDelegate delegate) =>
      locate<AuthenticationState>()._delegates.add(delegate);
}

abstract class AuthenticationDelegate {
  /// The name of this authentication widget
  String get name;
  Widget buildAuthWidget();
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

/// A Login button
class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthenticationGate(
      signedIn: (ctx) => MaterialButton(
          onPressed: () {
            locate<AuthenticationState>().setSignedIn(false, null);
          },
          child: Text("Log Out")),
      signedOut: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Not logged in"),
          MaterialButton(
              onPressed: () {
                AuthenticationState.requestSignIn();
              },
              child: Text("Sign In")),
        ],
      ),
    );
  }
}
