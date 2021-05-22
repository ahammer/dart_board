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

  @override
  void initState() {
    http
        .get(Uri.parse(widget.url))
        .then((value) => setState(() => fileContents = value.body));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final haikuWidget = Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
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
            )),
      ),
    );

    return LayoutBuilder(builder: (ctx, size) {
      final codeWidget;
      codeWidget = Container(
          height: double.infinity,
          child: fileContents.isNotEmpty
              ? FittedBox(
                  fit: BoxFit.contain,
                  child: SyntaxView(
                    code: fileContents,
                    syntax: Syntax.DART,
                    syntaxTheme: SyntaxTheme.ayuDark(),
                  ),
                )
              : Text('Loading'));

      if (size.maxWidth > size.maxHeight) {
        return Row(
            children: [Expanded(flex: 1, child: haikuWidget), codeWidget]);
      } else {
        return Column(children: [
          Expanded(flex: 1, child: haikuWidget),
          Expanded(flex: 4, child: codeWidget)
        ]);
      }
    });
  }
}
