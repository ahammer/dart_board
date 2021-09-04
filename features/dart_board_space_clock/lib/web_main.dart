import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'clocks/ticker/ticker_clock.dart';
import 'customizer.dart';
import 'main.dart' as full_main;
import 'model.dart';

///
/// This is the Canvas free version of the clock
///
/// I wanted to give the web something, even if not a full experience.
void main() {
  //We have no inputs, so Fuschia should be fine all around
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  // Run the app
  // We use a Builder to pass the scaffolding, so Theme.of() works
  runApp(ClockCustomizer((model) =>
      Builder(builder: (context) => ClockScaffolding(model: model))));
}

///
/// The scaffolding of this clock
///
/// It's a Stack
/// Layer 1: The space scene
/// Layer 2: The DateTimeAndWeatherTicker the draws in the top left
///
class ClockScaffolding extends StatelessWidget {
  /// Construct a clock scaffolding given a model
  const ClockScaffolding({required this.model, Key? key}) : super(key: key);

  /// The ClockModel, needed by things to make decisions about what to draw
  final ClockModel model;

  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/stars.png"), fit: BoxFit.cover)),
          child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DateTimeAndWeatherTicker(
                  clockModel: model,
                  fontSize: 32,
                  height: 64,
                ),
              )),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "🚧 This is NOT the full clock\n"
                      "👉Only the Widget Based Ticker is demo'd for web.\n"
                      "👉Canvas drawing not well supported on web.\n"
                      "To see Space/Stars/Sun, run on 📱 or 🖥️",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RaisedButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<Widget>(
                              builder: (context) =>
                                  const full_main.MainWidget())),
                      child: const Text(
                          "Try the full clock\n(NOT SUPPORTED ON WEB/FLUTTER 1.12)"),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]);
}
