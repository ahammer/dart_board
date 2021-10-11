import 'dart:ui';

import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

const kLogRoute = '/log';

///
/// Logfeature
///
/// A basic logging feature for Dart Board
///
/// Including this will attach to the "Logging" package.
/// Logger(name)..info..error
///
/// The last message will show up in a frame in the bottom
/// Touching the frame will bring up the logging overlay panel

final LogState _logState = LogState();

class LogFeature extends DartBoardFeature {
  LogFeature._internal(this.fontSize);

  final double fontSize;
  factory LogFeature({fontSize = 12.0}) {
    /// Attach to the Logger at time of construction
    /// Side effect I know, but this is the earlierst
    /// hook. For logging I think it's OK
    _logState;
    return LogFeature._internal(fontSize);
  }

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            name: 'log_frame',
            decoration: (context, child) =>
                LogWrapper(fontSize: fontSize, child: child)),
      ];

  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        NamedRouteDefinition(
            route: kLogRoute, builder: (ctx, settings) => FullScreenLog())
      ];

  /// Here we inject a Log-State into the App Scope
  @override
  List<DartBoardDecoration> get appDecorations => [
        LocatorDecoration(() => _logState),
      ];

  @override
  List<String> get pageDecorationDenyList => ['/log:log_frame'];

  @override
  String get namespace => 'Logging';

  @override
  Map<String, MethodCallHandler> get methodHandlers =>
      const {'showLogRoute': _showLogOverlay};
}

/// Sample handler to display the log route when this is called.
Future<dynamic> _showLogOverlay(BuildContext context, MethodCall call) async =>
    Navigator.of(context).pushNamed(kLogRoute);

class LogWrapper extends StatelessWidget {
  final Widget? child;
  final double? fontSize;

  const LogWrapper({Key? key, this.child, this.fontSize}) : super(key: key);
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: child!),
          Hero(
            tag: 'LOG_FOOTER',
            child: Container(
              height: 32,
              child: MaterialButton(
                  //padding: EdgeInsets.all(0),
                  color: Theme.of(context).colorScheme.surface,
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,

                      /// We pass a name so we can exclude the debug-log frame
                      settings: RouteSettings(name: kLogRoute),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          RouteWidget('/log'),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ));
                  },
                  child: Container(
                    child: locateAndBuild<LogState>((context, value) =>
                        AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            switchInCurve: Curves.ease,
                            transitionBuilder:
                                (Widget child, Animation<double> animation) =>
                                    SlideTransition(
                                      position: Tween<Offset>(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                          .animate(animation),
                                      child: child,
                                    ),
                            child: Container(
                                key: Key(value.lastLogRecord.message),
                                width: double.infinity,
                                child: LogMessageWidget(
                                    fontSize: fontSize,
                                    record: value.lastLogRecord)))),
                  )),
            ),
          ),
        ],
      );
}

class FullScreenLog extends StatelessWidget {
  final double? fontSize;

  const FullScreenLog({
    Key? key,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => locateAndBuild<LogState>(
        (context, logState) => ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Material(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text('Application Log'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                        itemBuilder: (ctx, idx) => Column(
                              children: [
                                LogMessageWidget(
                                  fontSize: fontSize,
                                  record: logState.messages[idx],
                                ),
                                Divider()
                              ],
                            ),
                        itemCount: logState.messages.length),
                  ),
                )),
          ),
        ),
      );
}

class LogMessageWidget extends StatelessWidget {
  final LogRecord? record;
  final double? fontSize;

  const LogMessageWidget({
    Key? key,
    this.record,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          '${record!.time.hour}:${record!.time.minute}:${record!.time.second}',
          style: textTheme.bodyText1!.copyWith(
            fontSize: fontSize,
          ),
        ),
        Container(width: 20),
        Text(
          record!.loggerName,
          style: textTheme.bodyText1!
              .copyWith(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        Container(width: 20),
        Expanded(
            child: Text(
          record!.message,
          style: textTheme.bodyText1!.copyWith(
            fontSize: fontSize,
          ),
        )),
      ],
    );
  }
}

class LogState extends ChangeNotifier {
  LogState.internal();
  final messages = <LogRecord>[];

  factory LogState() {
    Logger.root.level = Level.ALL;
    final instance = LogState.internal();
    Logger.root.onRecord.listen(instance.onRecord);
    return instance;
  }

  LogRecord get lastLogRecord => messages.isNotEmpty
      ? messages.last
      : LogRecord(Level.INFO, 'No log entries', '');

  void onRecord(LogRecord event) {
    messages.add(event);
    notifyListeners();
  }
}
