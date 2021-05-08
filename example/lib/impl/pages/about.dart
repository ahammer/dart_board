import 'package:example/impl/pages/about_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

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
          key: Key("intro"),
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(ctx).colorScheme.surface.withOpacity(0.7),
          child: WelcomeToAbout(),
        ),
    (ctx) => Container(
          key: Key("page1"),
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(ctx).colorScheme.surface.withOpacity(0.7),
          child: Page1Content(),
        ),
    (ctx) => Container(
        key: Key("page2"),
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(ctx).colorScheme.surface.withOpacity(0.7),
        child: Page2Content()),
    (ctx) => Container(
          key: Key("page3"),
          width: double.infinity,
          height: double.infinity,
          child: Page3Content(),
          color: Theme.of(ctx).colorScheme.surface.withOpacity(0.7),
        ),
    (ctx) => Container(
          key: Key("page4"),
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(ctx).colorScheme.surface.withOpacity(0.7),
        ),
    (ctx) => Container(
          key: Key("page5"),
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(ctx).colorScheme.surface.withOpacity(0.7),
        ),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            child: AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
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
