import 'package:flutter/material.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:dart_board/impl/utils/collect.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              elevation: 0.5,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.50),
              child: AboutGallery(),
            ),
          ),
        ),
      );
}

class AboutGallery extends StatefulWidget {
  @override
  _AboutGalleryState createState() => _AboutGalleryState();
}

class _AboutGalleryState extends State<AboutGallery> {
  int page = 0;
  List<WidgetBuilder> pageBuilders = [
    (ctx) => Container(
        key: Key("page1"),
        width: double.infinity,
        height: double.infinity,
        color: Colors.green),
    (ctx) => Container(
        key: Key("page2"),
        width: double.infinity,
        height: double.infinity,
        color: Colors.red),
    (ctx) => Container(
        key: Key("page3"),
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue),
    (ctx) => Container(
        key: Key("page4"),
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellow),
    (ctx) => Container(
        key: Key("page5"),
        width: double.infinity,
        height: double.infinity,
        color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: pageBuilders[page](context)),
          )),
          Container(
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(width: 48),
                MaterialButton(
                  elevation: 12,
                  onPressed: incrementPage,
                  child:
                      Container(child: Center(child: Icon(Icons.arrow_back))),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                  "${page + 1}",
                  style: Theme.of(context).textTheme.headline4,
                ))),
                MaterialButton(
                  elevation: 2,
                  onPressed: decrementPage,
                  child: Container(
                      child: Center(child: Icon(Icons.arrow_forward))),
                ),
                Container(width: 48),
              ],
            ),
          )
        ],
      );

  incrementPage() => setState(() {
        page--;
        if (page < 0) page = 0;
      });
  decrementPage() => setState(() {
        page++;
        if (page >= pageBuilders.length) page = pageBuilders.length - 1;
      });
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
