import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
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
              text: 'About This Project!\n\n',
              style: Theme.of(context).textTheme.headline2,
            ),
            TextSpan(
                text:
                    """Have you ever wanted to just "integrate" a 3rd party library?

Dart Board is designed exactly for that. The core framework itself is just a blank canvas. You dictate what gets painted there by what you include and how you configure it.                    

Adding a Dart Board Extension could expose new State objects, Services, Page Decorations, Routes and Widgets that
can automatically integrate into your app.

Some example use cases
- Page decorations for page commonalities (e.g. appbar/scaffold, floating controls, debug windows/frames).
- Navigation setup and assistance
- Support for 3rd party packages
- Plugable features/Feature isolation


This is a re-imagining of how we handle things at my work, with a different focus.
The motivation of the structure is to provide an architecture that allows multiple teams to work on 
features without stepping on each other's toes. The extension kernel (Dart Board) is responsible 
for only providing equal access and infrastructure to integrate.

In our context, it was for our Add2App integration, however an extension based approach
has some advantages over a bare pub approach, in that you can get a certain level of integration
for free because the kernel knows when and how to delegate to the extensions.

"""),
          ],
        ),
      );
}
