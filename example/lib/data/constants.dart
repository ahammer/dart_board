import 'package:dart_board/dart_board.dart';

/// These are the routes that show the code and give haiku's
/// Since they are similar, I store them as data if I want to create more
///
/// And to keep the data outside the widgets to ease comprehension
const kCodeRoutes = <Map<String, String>>[
  {
    'route': '/code_main',
    'haiku': '''Need to integrate?
Dart board will do that for you
It will be simple''',
    'url':
        'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart',
  },
  {
    'route': '/code_features',
    'haiku': '''Features are code bits
They hook into your apps quick
Composed, they are strong''',
    'url':
        'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/example_feature.dart',
  },
];

/// This is the config for the bottom nav template
/// It indicates the bottom buttons, labels icons and routes for the screen
///
const kMainPageConfig = [
  {
    'route': '/home',
    'label': 'Home',
    'color': Colors.orange,
    'icon': Icons.home,
  },
  {'route': '/code', 'label': 'Code', 'color': Colors.blue, 'icon': Icons.help},
  {
    'route': '/debug',
    'label': 'Debug',
    'color': Colors.purple,
    'icon': Icons.plumbing
  },
  {
    'route': '/minesweep',
    'label': 'Mine Sweeper',
    'color': Colors.cyan,
    'icon': Icons.games
  }
];
