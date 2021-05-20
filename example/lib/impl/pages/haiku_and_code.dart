import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Show a Haiku and some code
class HaikuAndCode extends StatelessWidget {
  final String haiku;

  const HaikuAndCode({Key? key, required this.haiku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final haikuWidget = Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            child: FittedBox(
              child: Text(
                haiku,
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
      if (size.maxWidth > size.maxHeight) {
        final codeWidget;
        codeWidget = Container(
            color: Colors.blue,
            height: double.infinity,
            width: double.infinity);
        return Row(children: [
          Expanded(flex: 1, child: haikuWidget),
          Expanded(flex: 2, child: codeWidget)
        ]);
      } else {
        final codeWidget;
        codeWidget = Container(
            color: Colors.blue,
            height: double.infinity,
            width: double.infinity);
        return Column(children: [
          Expanded(flex: 1, child: haikuWidget),
          Expanded(flex: 4, child: codeWidget)
        ]);
      }
    });
  }
}
