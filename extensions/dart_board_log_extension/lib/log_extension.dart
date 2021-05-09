import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

final logState = LogState();

class LogExtension extends DartBoardExtension {
  LogExtension.internal();

  factory LogExtension() {
    /// Attach to the Logger at time of construction
    /// Side effect I know, but this is the earlierst
    /// hook. For logging I think it's OK
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen(logState.onRecord);
    return LogExtension.internal();
  }
  @override
  get pageDecorations => [
        (context, child) => LogWrapper(child: child),
      ];

  @override
  get routes =>
      <RouteDefinition>[]..addMap({"/log": (ctx, settings) => LogPage()});

  /// Here we inject a Log-State into the App Scope
  @override
  get appDecorations => [
        (context, child) => ChangeNotifierProvider<LogState>(
            create: (ctx) => logState, child: child)
      ];

  @override
  String get namespace => "ThemeChooser";
}

class LogWrapper extends StatelessWidget {
  final Widget child;

  const LogWrapper({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.dark(),
        child: Column(
          children: [
            Expanded(child: Theme(data: Theme.of(context), child: child)),
            MaterialButton(
                onPressed: () {},
                child: Container(
                  child: Consumer<LogState>(
                      builder: (context, value, child) => AnimatedSwitcher(
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
                                  record: value.lastLogRecord)))),
                )),
          ],
        ),
      );
}

class LogMessageWidget extends StatelessWidget {
  final LogRecord record;

  const LogMessageWidget({
    Key key,
    this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(record.message);
  }
}

class LogPage extends StatelessWidget {
  const LogPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Text("Blah"),
      );
}

class LogState extends ChangeNotifier {
  final messages = <LogRecord>[];

  LogRecord get lastLogRecord =>
      messages.isNotEmpty ? messages.last : LogRecord(Level.INFO, "aa", "aa");

  void onRecord(LogRecord event) {
    messages.add(event);
    notifyListeners();
  }
}
