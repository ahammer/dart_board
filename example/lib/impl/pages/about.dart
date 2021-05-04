import 'package:flutter/material.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:dart_board/impl/utils/collect.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Container()),
            Expanded(
              flex: 5,
              child: Card(
                elevation: 10,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.90),
                child: Container(
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(child: AboutTextWidget()),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      );
}

class AboutTextWidget extends StatelessWidget {
  const AboutTextWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: EasyRichText("""
About the Platform

Dart Board
A flutter-based extension framework/app scaffold

Problem Statement
Integrating is work, make it less work.

Solution
By organizing around an extension based API
component plugability can be maximized.

Is this an app?
It is an app and extension framework. It is designed to either consume directly
as the starting point for an App, or extend in ways others can use.

For App Developers, it provides a way to compose a larger application
out of pre-built parts. It also provides a scalable structure towards app
development.

Extenders can be anyone who'd like to provide a feature/service
on the platform.

Just like flutter, composition is the goal here. Combining extensions
and features to compose a larger product.

What can an Extension do?

- Provide Screens (routes)
- Inject app-level widgets
  - E.g. a service, persistent state, etc.
- Inject page-level widgets
  - E.g. An overlay, Frame, Transform Layer (e.g. Screen Shake), Theming and Scaffoling.

Some practical example extensions might be the following.

- Forum addon
- Authentication
- Search & Details
- Debug Frames/Runtime Analysis
- Theme Changer

How would I build an App with this?

This example is a good starting point. 

Import via pub, add extension via pub
in main.dart, start the widget with the extensions
and point it at a route that exists.

There is no 3rd party extensions at the time of writing this, but I'm
hoping to publish a few basic extensions

          """,
            selectable: true,
            patternList: <String, TextStyle>{
              "About the Platform": kHeaderStyle.copyWith(
                  fontSize: 30,
                  color: Colors.orange,
                  decoration: TextDecoration.underline),
              "Dart Board": kHeaderStyle,
              "Problem Statement": kHeaderStyle,
              "Solution": kHeaderStyle,
              "Is this an app?": kHeaderStyle,
              "App Developers": kHighlightStyle,
              "Extenders": kHighlightStyle,
              "app": kHighlightStyle,
              "framework": kHighlightStyle,
              "extension": kHighlightStyle,
              "What can an Extension do?": kHeaderStyle,
              "How would I build an App with this?": kHeaderStyle,
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
