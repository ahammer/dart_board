import 'package:example/impl/pages/haiku_and_code.dart';
import 'package:flutter/material.dart';
import 'package:dart_board/dart_board.dart';

final Logger log = Logger('About');

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      HaikuAndCode(haiku: '''Need to integrate?
Dart board will do that for you
It will be simple''', filename: 'lib/main.dart');
}
