import 'package:dart_board/dart_board.dart';

/// These are the routes that show the code and give haiku's
/// Since they are similar, I store them as data if I want to create more
///
/// And to keep the data outside the widgets to ease comprehension
const codeRoutes = <Map<String, String>>[
  {
    'route': '/about',
    'haiku': '''Need to integrate?
Dart board will do that for you
It will be simple''',
    'url':
        'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart',
  },
  {
    'route': '/decorations',
    'haiku': '''Painting your project
At the app and page level
is quick and easy''',
    'url':
        'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/impl/decorations/scaffold_appbar_decoration.dart',
  },
  {
    'route': '/routing',
    'haiku': '''Navigate your app
Features provide named pages
Custom transitions''',
    'url':
        'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart',
  },
  {
    'route': '/features',
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
  {
    'route': '/about',
    'label': 'About',
    'color': Colors.blue,
    'icon': Icons.help
  },
  {
    'route': '/decorations',
    'label': 'Decorations',
    'color': Colors.amber,
    'icon': Icons.brush
  },
  {
    'route': '/routing',
    'label': 'Routing',
    'color': Colors.green,
    'icon': Icons.call_merge
  },
  {
    'route': '/features',
    'label': 'Features',
    'color': Colors.orange,
    'icon': Icons.add_box
  },
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
