import 'dart:math';

import 'package:dart_board_theme/theme_feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:http/http.dart' as http;

// Show a Haiku and some code
class HaikuAndCode extends StatefulWidget {
  final String haiku;
  final String url;

  const HaikuAndCode({Key? key, required this.haiku, required this.url})
      : super(key: key);

  @override
  _HaikuAndCodeState createState() => _HaikuAndCodeState();
}

class _HaikuAndCodeState extends State<HaikuAndCode> {
  String fileContents = '';
  String lastLoaded = '';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    if (lastLoaded == widget.url) return;

    lastLoaded = widget.url;
    http
        .get(Uri.parse(widget.url))
        .then((value) => setState(() => fileContents = value.body));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
      //Trigger a data load (if necessary)
      loadData();
    });
    final haikuWidget = Center(
      key: Key('haiku'),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                child: Text(
                  widget.haiku,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      shadows: [
                        BoxShadow(
                            blurRadius: 4,
                            offset: Offset(1, 1),
                            color: Colors.black54)
                      ]),
                ),
              ),
            )),
      ),
    );

    return LayoutBuilder(builder: (ctx, size) {
      final codeWidget;
      codeWidget = AnimatedContainer(
          width: fileContents.isEmpty ? 0 : size.maxWidth,
          height: fileContents.isEmpty ? 0 : size.maxHeight,
          duration: Duration(seconds: 10),
          curve: Curves.easeInOut,
          child: fileContents.isNotEmpty
              ? Material(
                  elevation: 5,
                  child: SyntaxView(
                    fontSize: 14,
                    expanded: true,
                    withZoom: false,
                    code: fileContents,
                    syntax: Syntax.DART,
                    syntaxTheme: ThemeFeature.isLight
                        ? SyntaxTheme.gravityLight()
                        : SyntaxTheme.gravityDark(),
                  ),
                )
              : Text('Loading'));

      if (size.maxWidth > size.maxHeight) {
        return Row(
            children: [Expanded(flex: 1, child: haikuWidget), codeWidget]);
      } else {
        return Column(
            children: [Expanded(flex: 1, child: haikuWidget), codeWidget]);
      }
    });
  }
}
