import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:dart_board/impl/utils/collect.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

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
      {Key? key,
      required this.childA,
      required this.childB,
      required this.childC})
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
    Key? key,
    required this.childA,
    required this.childB,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PaneModelB(
        childB: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
          child: Container(
            height: double.infinity,
            child: SystemChart(),
          ),
        ),
        childA: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(child: AboutTextWidget()),
        ),
      );
}

class Page2Content extends StatelessWidget {
  const Page2Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FittedBox(
        child: SyntaxView(
          code: """
import 'package:dart_board/dart_board.dart';
import 'package:dart_board/impl/debug/debug_route_feature.dart';
import 'package:dart_board_theme_feature/theme_feature.dart';
import 'package:flutter/material.dart';

import 'example_feature.dart';

void main() {
  
  /// Just Start the DartBoard widget
  runApp(DartBoard(
    features: [

      /// Give it your features
      Themefeature(),       
      Examplefeature(), 
      DebugRoutefeature()
      ],
    
    /// And an Initial Route
    initialRoute: '/about',
  ));
}
""",
          syntax: Syntax.DART,
          syntaxTheme: getCodeTheme(context),
          withZoom: false,
        ),
      );
}

class Page3Content extends StatelessWidget {
  const Page3Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FittedBox(
        child: SyntaxView(
          code: '''
/// The Example feature
class Examplefeature implements DartBoardFeature {
  @override
  get routes => <RouteDefinition>[]..addMap({
      /// Initial Route
      "/": (ctx, settings) => HomePage(),

      /// About Route
      "/about": (ctx, settings) => AboutPage(),
    });

  /// These are page-scoped decorations
  @override
  get pageDecorations => <WidgetWithChildBuilder>[
        /// The AppBar and Nav Drawer
        (context, child) => ScaffoldWithDrawerDecoration(child: child),

        /// The border around the Body
        (context, child) => DarkColorBorder(child: child),

        /// The animated background effect
        (context, child) => AnimatedBackgroundDecoration(
              color: Theme.of(context).accentColor,
              child: child,
            )
      ];

  /// These are app-level decorations (not needed here)
  @override
  get appDecorations => [];
}
''',
          syntax: Syntax.DART,
          syntaxTheme: getCodeTheme(context),
          withZoom: false,
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

    /// Draw feature features
    final featurefeaturesTitlePainter = TextPainter(
        text: TextSpan(
            text: 'Features', style: Theme.of(context).textTheme.headline4),
        textDirection: TextDirection.rtl)
      ..layout();

    featurefeaturesTitlePainter.paint(
        canvas,
        Offset(
            size.width / 2 - featurefeaturesTitlePainter.width / 2, top - 48));

    /// Draw feature features
    final integrationfeatureTitle = TextPainter(
        text: TextSpan(
            text: 'Integration', style: Theme.of(context).textTheme.headline4),
        textDirection: TextDirection.rtl)
      ..layout();

    integrationfeatureTitle.paint(
        canvas,
        Offset(size.width / 2 - integrationfeatureTitle.width / 2,
            (top + sectionHeight * spacing) - 48));

    /// Draw feature features
    final runnerTitle = TextPainter(
        text: TextSpan(
            text: 'Runner', style: Theme.of(context).textTheme.headline4),
        textDirection: TextDirection.rtl)
      ..layout();

    runnerTitle.paint(
        canvas,
        Offset(size.width / 2 - runnerTitle.width / 2,
            (top + sectionHeight * spacing * 2) - 48));

    final boxWidth = sectionHeight - padding * 2;

    for (var i = 0; i < 4; i++) {
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

class WelcomeToAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(64.0),
        child: FittedBox(
          child: EasyRichText('''
Dart Board

Basics
Entry Point
features
App Design
feature Design''',
              textAlign: TextAlign.left,
              patternList: <String, TextStyle>{
                'Dart Board': kHeaderStyle.copyWith(
                    fontSize: 30, decoration: TextDecoration.underline),
                'app': kHighlightStyle,
                'framework': kHighlightStyle,
                'feature': kHighlightStyle,
                'based': kHighlightStyle,
                'features used in this Example': kHeaderStyle,
              }.collect<EasyRichTextPattern>((key, value) =>
                  EasyRichTextPattern(targetString: key, style: value))),
        ),
      );
}

class AboutTextWidget extends StatelessWidget {
  const AboutTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: EasyRichText('''
Dart Board Basics

Dart board is an feature-based framework.

You compose a project for deployment out of a 
collection of features.

- Official features
- Community features
- Internal features

Dart Board itself is a simple widget at the root 
of your App. It provides the following.

- Adding named routes to the app
- Decorating Pages
- Decorating the App

This is enough to automatically integrate most 
flutter functionaly.

features used in this Example

Example feature
  - Routes for Home and About
  - 3x Page Decorations 
      Animated BG
      Border
      AppBarDrawerScaffold

Debug Route feature
  - Debug Route

Theme features
  - App State Decoration 
  - Page Decoration 


          ''',
            selectable: true,
            patternList: <String, TextStyle>{
              'Dart Board Basics': kHeaderStyle.copyWith(
                  fontSize: 30, decoration: TextDecoration.underline),
              'Dart Board': kHighlightStyle,
              'app': kHighlightStyle,
              'framework': kHighlightStyle,
              'feature': kHighlightStyle,
              'based': kHighlightStyle,
              'features used in this Example': kHeaderStyle,
            }.collect<EasyRichTextPattern>((key, value) =>
                EasyRichTextPattern(targetString: key, style: value))),
      );
}

class EntryPointText extends StatelessWidget {
  const EntryPointText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: EasyRichText('''
The main.dart

1) In RunApp, start with the DartBoard() widget
2) Provide the features you are deploying
3) Provide the initial route

          ''',
            selectable: true,
            patternList: <String, TextStyle>{
              'Dart Board Basics': kHeaderStyle.copyWith(
                  fontSize: 30, decoration: TextDecoration.underline),
              'Dart Board': kHighlightStyle,
              'app': kHighlightStyle,
              'framework': kHighlightStyle,
              'feature': kHighlightStyle,
              'based': kHighlightStyle,
              'features used in this Example': kHeaderStyle,
            }.collect<EasyRichTextPattern>((key, value) =>
                EasyRichTextPattern(targetString: key, style: value))),
      );
}

const kHeaderStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
);
const kHighlightStyle = TextStyle(fontStyle: FontStyle.italic);

SyntaxTheme getCodeTheme(BuildContext context) => SyntaxTheme.dracula()
  ..commentStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      decoration: TextDecoration.underline,
      decorationThickness: 2,
      shadows: [
        BoxShadow(color: Colors.black, blurRadius: 8, offset: Offset(4, 4)),
      ],
      color: Colors.lightBlue);
