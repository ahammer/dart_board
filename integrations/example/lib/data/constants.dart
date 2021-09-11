import 'package:flutter/material.dart';

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
    'color': null,
    'icon': Icons.home,
  },
  {
    'route': '/chat',
    'label': 'Chat',
    'color': null,
    'icon': Icons.chat,
  },
  {
    'route': '/theme_editor',
    'label': 'Theme',
    'color': null,
    'icon': Icons.palette,
  },
  {
    'route': '/dependency_tree',
    'label': 'Dependencies',
    'color': null,
    'icon': Icons.usb_sharp,
  },
  {
    'route': '/debug',
    'label': 'Debug',
    'color': null,
    'icon': Icons.plumbing,
  },
  {
    'route': '/minesweep',
    'label': 'Mine Sweeper',
    'color': null,
    'icon': Icons.games
  }
];
