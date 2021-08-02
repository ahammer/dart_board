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

class AuthSignInDialog extends StatelessWidget {
  AuthSignInDialog({
    Key? key,
  }) : super(key: key);

  late final authState = locate<AuthenticationState>();

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
                  children: [
                    Text("Choose Provider"),
                    Divider(),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: authState._delegates.length,
                        itemBuilder: (ctx, idx) => ListTile(
                              title: Text(authState._delegates[idx].name),
                              onTap: () {},
                            )),
                  ],
                ),
              ))),
    );
  }
}

class AuthenticationState extends ChangeNotifier {
  final _delegates = <AuthenticationDelegate>[];

  bool signedIn = false;

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
