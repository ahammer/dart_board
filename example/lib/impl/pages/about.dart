import 'package:flutter/material.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

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
  Widget build(BuildContext context) => EasyRichText(
        "I want blue font. I want bold font. I want italic font.",
        patternList: [
          EasyRichTextPattern(
            targetString: 'blue',
            style: TextStyle(color: Colors.blue),
          ),
          EasyRichTextPattern(
            targetString: 'bold',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          EasyRichTextPattern(
            targetString: 'italic',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      );
}
