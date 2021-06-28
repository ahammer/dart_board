import 'dart:math';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//https://github.com/ahammer/dart_board/blob/master/README.md
//'https://raw.githubusercontent.com/ahammer/dart_board/master/README.md'
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
        .get(Uri.parse(
            'https://raw.githubusercontent.com/ahammer/dart_board/master/${widget.url}'))
        .then((value) => setState(() => fileContents = value.body));
  }

  @override
  void setState(VoidCallback fn) {
    /// Safe setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
      //Trigger a data load (if necessary)
      loadData();
    });

    return LayoutBuilder(builder: (ctx, size) {
      final codeWidget;
      codeWidget = AnimatedContainer(
          width: size.maxWidth,
          height: fileContents.isEmpty ? 0 : size.maxHeight,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInExpo,
          child: fileContents.isNotEmpty
              ? Markdown(data: fileContents)
              : Center(child: CircularProgressIndicator()));

      return Stack(
        children: [
          Align(alignment: Alignment.center, child: codeWidget),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () =>
                              launch('https://github.com/ahammer/dart_board/'),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('GitHub'),
                          )),
                      Container(
                        width: 100,
                        child: Divider(),
                      ),
                      InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => launch(
                              'https://pub.dev/publishers/dart-board.io/packages/'),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Pub.dev'),
                          )),
                    ],
                  )),
            ),
          )
        ],
      );
    });
  }
}
