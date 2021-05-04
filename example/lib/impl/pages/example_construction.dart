import 'package:flutter/material.dart';

class ExampleConstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "About",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                elevation: 4,
              ),
            ),
            Expanded(
              child: Card(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.90),
                child: Container(
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(child: AboutTextWidget()),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}

class AboutTextWidget extends StatelessWidget {
  const AboutTextWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: 'How is the Example Made?\n\n',
              style: Theme.of(context).textTheme.headline2,
            ),
            TextSpan(
                text:
                    """This example is the dog-food experience of the platform itself. If you are looking at this, you are looking at Dart Board.

When you first run the app, you launch a main.dart() that calls out to DartBoard.
It will tell dart board what extensions it's using, and what the default route is.

void main() {
  runApp(DartBoard(
    extensions: [ExampleExtension()],
    initialRoute: "/home",
  ));


Note: Without a default route, it'll not be able to show anything. But there is a 404 page

In this Example, and ExampleExtension.dart is provided.


class ExampleExtension implements DartBoardExtension {
  @override
  get routes => <RouteDefinition>[]..addMap({
      "/home": (ctx) => HomePage(),
      "/about": (ctx) => AboutPage(),
      "/example": (ctx) => ExampleConstruction()
    });

  @override
  get pageDecorations => <WidgetWithChildBuilder>[
        (context, child) => ScaffoldWithDrawerDecoration(child: child),
        (context, child) => DarkColorBorder(child: child),
        (context, child) => AnimatedBackgroundDecoration(
              color: Theme.of(context).accentColor,
              child: child,
            )
      ];
}

This extension offers a variety of things. It offers Routes and Decorations.

A larger app can be composed of these Extension out of the functionality provided.                    
"""),
          ],
        ),
      );
}
