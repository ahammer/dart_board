import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:dart_board/impl/utils/collect.dart';

///
/// This file is dedicated to the "pages" in the About page slideshow
///
final kRedBlock = Container(
    width: double.infinity, height: double.infinity, color: Colors.red);
final kGreenBlock = Container(
    width: double.infinity, height: double.infinity, color: Colors.green);
final kBlueBlock = Container(
    width: double.infinity, height: double.infinity, color: Colors.blue);

class PaneModelA extends StatelessWidget {
  final Widget childA, childB, childC;

  const PaneModelA(
      {Key key,
      @required this.childA,
      @required this.childB,
      @required this.childC})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              children: [childB, Expanded(child: childC)],
            ),
          ),
          Expanded(child: childA),
        ],
      );
}

class PaneModelB extends StatelessWidget {
  final Widget childA, childB;

  const PaneModelB({
    Key key,
    @required this.childA,
    @required this.childB,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: childA),
          Expanded(child: childB),
        ],
      );
}

class Page1Content extends StatelessWidget {
  const Page1Content({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PaneModelB(
        childA: Container(height: double.infinity, child: SystemChart()),
        childB: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AboutTextWidget(),
        ),
      );
}

class SystemChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: SystemChartPainter(context));
}

class SystemChartPainter extends CustomPainter {
  final BuildContext context;

  Paint outlinePaint = Paint()
    ..color = Colors.black38
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

  Paint modulePaint = Paint()
    ..color = Colors.orangeAccent
    ..style = PaintingStyle.fill;

  Paint integrationPaint = Paint()
    ..color = Colors.blueAccent
    ..style = PaintingStyle.fill;

  Paint runnerPaint = Paint()
    ..color = Colors.greenAccent
    ..style = PaintingStyle.fill;

  SystemChartPainter(this.context);

  final spacing = 2.4;

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 8.0;
    var top = size.height / 8;
    final width = size.width - padding * 2;
    final sectionHeight = size.width / 4.1;
    final left = padding;
    final right = size.width - padding;

    /// Draw feature extensions
    TextPainter featureExtensionsTitlePainter = TextPainter(
        text: TextSpan(
            text: "Features", style: Theme.of(context).textTheme.headline4),
        textDirection: TextDirection.rtl)
      ..layout();

    featureExtensionsTitlePainter.paint(
        canvas,
        Offset(size.width / 2 - featureExtensionsTitlePainter.width / 2,
            top - 48));

    /// Draw feature extensions
    TextPainter integrationExtensionTitle = TextPainter(
        text: TextSpan(
            text: "Integration", style: Theme.of(context).textTheme.headline4),
        textDirection: TextDirection.rtl)
      ..layout();

    integrationExtensionTitle.paint(
        canvas,
        Offset(size.width / 2 - integrationExtensionTitle.width / 2,
            (top + sectionHeight * spacing) - 48));

    /// Draw feature extensions
    TextPainter runnerTitle = TextPainter(
        text: TextSpan(
            text: "Runner", style: Theme.of(context).textTheme.headline4),
        textDirection: TextDirection.rtl)
      ..layout();

    runnerTitle.paint(
        canvas,
        Offset(size.width / 2 - runnerTitle.width / 2,
            (top + sectionHeight * spacing * 2) - 48));

    final boxWidth = sectionHeight - padding * 2;

    for (int i = 0; i < 4; i++) {
      final q = width / 4.0;

      [modulePaint, outlinePaint].forEach((p) => canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  left + padding + i * q, top + padding, boxWidth, boxWidth),
              Radius.circular(16)),
          p));
    }

    top += sectionHeight * spacing;
    [integrationPaint, outlinePaint].forEach((p) => canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                left + padding, top + padding, width - 2 * padding, boxWidth),
            Radius.circular(16)),
        p));

    top += sectionHeight * spacing;
    [runnerPaint, outlinePaint].forEach((p) => canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                left + padding, top + padding, width - 2 * padding, boxWidth),
            Radius.circular(16)),
        p));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AboutTextWidget extends StatelessWidget {
  const AboutTextWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: EasyRichText("""
Dart Board Basics

Dart board is an extension-based framework.

You compose a project for deployment out of a 
collection of extensions.

- Official Extensions
- Community Extensions
- Internal Extensions

Dart Board itself is a simple widget at the root 
of your App. It provides the following.

- Adding named routes to the app
- Decorating Pages
- Decorating the App

This is enough to automatically integrate most 
flutter functionaly.

Extensions used in this Example

Example Extension
  - Routes for Home and About
  - 3x Page Decorations 
      Animated BG
      Border
      AppBarDrawerScaffold

Debug Route Extension
  - Debug Route

Theme Extensions
  - App State Decoration 
  - Page Decoration 


          """,
            selectable: true,
            patternList: <String, TextStyle>{
              "Dart Board Basics": kHeaderStyle.copyWith(
                  fontSize: 30, decoration: TextDecoration.underline),
              "Dart Board": kHighlightStyle,
              "app": kHighlightStyle,
              "framework": kHighlightStyle,
              "extension": kHighlightStyle,
              "based": kHighlightStyle,
              "Extensions used in this Example": kHeaderStyle,
            }.collect<EasyRichTextPattern>((key, value) =>
                EasyRichTextPattern(targetString: key, style: value))),
      );
}

const kHeaderStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
);
const kHighlightStyle =
    TextStyle(color: Colors.black54, fontStyle: FontStyle.italic);
