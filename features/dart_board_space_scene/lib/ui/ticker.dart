import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../util/extensions.dart';

/// For building the current string to display
typedef StringBuilder = String Function();

/// For building a widget for a individual character in the string
typedef BuildDigitWidget = Widget Function(String value, bool first, bool last);

///
/// Ticker Widget
///
/// It breaks a String up into it's characters, and displays
/// each character in it's own AnimatedSwitcher, so we can animate as
/// characters change
///
/// BuildDigitWidget => Builds the widget to display a character
/// StringBuilder => Builds the string we want to display
///
/// It updates every 1 seconds
///
/// There is some randomness built into transition time
/// Because it looks cool
///
class TickerWidget extends StatefulWidget {
  /// Construct a Ticker Widget
  const TickerWidget(
      {required this.builder,
      required this.digitBuilder,
      this.tickerRandomnessMs = 500,
      this.tickerBaseTimeMs = 200});

  /// Widget Builder that builds a particular digit/glyph/character
  final BuildDigitWidget digitBuilder;

  /// Function that generates the desired string
  final StringBuilder builder;

  /// Ticker animation randomness in MS
  final int tickerRandomnessMs;

  /// Ticker base animation time
  final int tickerBaseTimeMs;

  @override
  _TickerWidgetState createState() => _TickerWidgetState();
}

///
/// Handles the rebuilding of this widget
///
/// It'll rebuild once a second.
///
class _TickerWidgetState extends State<TickerWidget> {
  late final Timer _timer;

  //100 randoms we can use to offset the Ticker timings
  final List<double> _random =
      List.generate(100, (idx) => Random.secure().nextDouble());

  @override
  void initState() {
    //Each ticker should run once a second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //Trigger a rebuild
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  ///  Build the Widget for the Ticker
  ///
  ///  1) Get the current string to show
  ///  2) Build a row full of _TickerCharacterViews
  ///  3) Return that row.
  @override
  Widget build(BuildContext context) => Semantics(
        header: true,
        value: widget.builder(),
        child: widget.builder().chain((currentString) => Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...List.generate(
                    currentString.length,
                    (idx) => _TickerCharacterView(
                        duration: Duration(
                            milliseconds: widget.tickerBaseTimeMs +
                                (_random[idx % _random.length] *
                                        widget.tickerRandomnessMs)
                                    .toInt()),
                        first: idx == 0,
                        last: idx == (currentString.length - 1),
                        builder: widget.digitBuilder,
                        digit: currentString.charAt(idx)))
              ],
            )),
      );
}

/// Ticker Character View
///
///
class _TickerCharacterView extends StatelessWidget {
  const _TickerCharacterView(
      {required this.digit,
      required this.builder,
      required this.first,
      required this.last,
      this.duration = const Duration(milliseconds: 500),
      Key? key})
      : super(key: key);

  final String digit;
  final bool first, last;
  final BuildDigitWidget builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          AnimatedSwitcher(
              transitionBuilder: (child, animation) =>
                  _TickerCharacterTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: child),
              duration: duration,
              child: builder(digit, first, last)),
        ],
      );
}

///
/// Derived from ScaleTransition
///
/// Changed the X scale to be fixed at 1.
class _TickerCharacterTransition extends AnimatedWidget {
  const _TickerCharacterTransition({
    required this.scale,
    required this.child,
    this.alignment = Alignment.center,
    Key? key,
  })  : assert(scale != null),
        super(key: key, listenable: scale);

  final Animation<double> scale;

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      (Matrix4.identity()..scale(1.0, scale.value, 1))
          .chain((transform) => Transform(
                transform: transform,
                alignment: alignment,
                child: child,
              ));
}
