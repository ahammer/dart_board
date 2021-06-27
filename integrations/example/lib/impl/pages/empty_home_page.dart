import 'package:dart_board_core/dart_board.dart';

class EmptyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
          child: Center(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Text(
            'Dart Board',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'Flutter Feature Framework',
            style: Theme.of(context).textTheme.headline4,
          ),
          Divider(),
          MaterialButton(
            onPressed: () => DartBoardCore.instance
                .setFeatureImplementation('template', 'bottomNav'),
            child: Text('Enable Template'),
          ),
        ],
      )));
}
