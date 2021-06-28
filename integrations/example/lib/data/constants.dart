import 'package:dart_board_core/dart_board.dart';

/// These are the routes that show the code and give haiku's
/// Since they are similar, I store them as data if I want to create more
///
/// And to keep the data outside the widgets to ease comprehension
const kCodeRoutes = <Map<String, String>>[
  {
    'title': 'Project',
    'route': '/readme',
    'haiku': 'Readme.md',
    'url': 'README.md',
  },
  {
    'title': 'Example',
    'route': '/readme_example',
    'haiku': 'Readme.md',
    'url': 'integrations/example/README.md',
  },
];

/// This is the config for the bottom nav template
/// It indicates the bottom buttons, labels icons and routes for the screen
///
const kMainPageConfig = [
  {
    'route': '/homepage',
    'label': 'Main',
    'color': Colors.blue,
    'icon': Icons.home
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
