import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_theme/theme_chooser.dart';
import 'package:dart_board_tracking/dart_board_tracking.dart';
import 'package:flutter/material.dart';

enum TemplateOptions { plain, bottom_nav, side_nav }
enum BackgroundOptions { white, image, animated, space, space_earth, space_all }

class HomePageWithToggles extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TrackedScopeWidget(
        pageName: 'HomePageWithToggles',
        scopeId: 'HomePageWithToggles',
        child: Material(
            color: Colors.transparent,
            child: Center(
                child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.surface,
                    child: Container(
                      width: 275,
                      child: Column(
                        children: [
                          LoginButton(),
                          ListTile(
                            title: Text('Template'),
                            trailing: PopupMenuButton<TemplateOptions>(
                              onSelected: (TemplateOptions result) {
                                switch (result) {
                                  case TemplateOptions.plain:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'template', 'direct');
                                    break;
                                  case TemplateOptions.bottom_nav:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'template', 'bottomNav');
                                    break;
                                  case TemplateOptions.side_nav:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'template', 'sideNav');
                                    break;
                                }
                                ;
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<TemplateOptions>>[
                                const PopupMenuItem<TemplateOptions>(
                                  value: TemplateOptions.side_nav,
                                  child: Text('AppBar+Drawer Nav'),
                                ),
                                const PopupMenuItem<TemplateOptions>(
                                  value: TemplateOptions.bottom_nav,
                                  child: Text('Bottom Navigation'),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text('Background'),
                            trailing: PopupMenuButton<BackgroundOptions>(
                              onSelected: (BackgroundOptions result) {
                                switch (result) {
                                  case BackgroundOptions.white:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'background', null);
                                    break;
                                  case BackgroundOptions.image:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'background', 'City Image');
                                    break;
                                  case BackgroundOptions.animated:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'background', 'Relaxing Waves');
                                    break;
                                  case BackgroundOptions.space:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'background', 'ClockStars');
                                    break;
                                  case BackgroundOptions.space_earth:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'background', 'ClockEarth');
                                    break;
                                  case BackgroundOptions.space_all:
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'background', 'ClockAll');
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<BackgroundOptions>>[
                                const PopupMenuItem<BackgroundOptions>(
                                  value: BackgroundOptions.white,
                                  child: Text('Solid'),
                                ),
                                const PopupMenuItem<BackgroundOptions>(
                                  value: BackgroundOptions.image,
                                  child: Text('Image'),
                                ),
                                const PopupMenuItem<BackgroundOptions>(
                                  value: BackgroundOptions.animated,
                                  child: Text('Animated'),
                                ),
                                const PopupMenuItem<BackgroundOptions>(
                                  value: BackgroundOptions.space,
                                  child: Text('Space'),
                                ),
                                const PopupMenuItem<BackgroundOptions>(
                                  value: BackgroundOptions.space_earth,
                                  child: Text('Space+Earth'),
                                ),
                                const PopupMenuItem<BackgroundOptions>(
                                  value: BackgroundOptions.space_all,
                                  child: Text('Space+All'),
                                ),
                              ],
                            ),
                          ),
                          SwitchListTile.adaptive(
                              title: Text('Logging'),
                              value: DartBoardCore.instance
                                  .isFeatureActive('Logging'),
                              onChanged: (result) => {
                                    DartBoardCore.instance
                                        .setFeatureImplementation('Logging',
                                            result ? 'default' : null)
                                  }),
                          SwitchListTile.adaptive(
                              title: Text('Rainbow Cursor'),
                              value: DartBoardCore.instance
                                  .isFeatureActive('RainbowCursor'),
                              onChanged: (result) => {
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'RainbowCursor',
                                            result ? 'default' : null)
                                  }),
                          SwitchListTile.adaptive(
                              title: Text('Fire Cursor'),
                              value: DartBoardCore.instance
                                  .isFeatureActive('FireCursor'),
                              onChanged: (result) => {
                                    DartBoardCore.instance
                                        .setFeatureImplementation('FireCursor',
                                            result ? 'default' : null)
                                  }),
                          SwitchListTile.adaptive(
                              title: Text('Snow Overlay'),
                              value: DartBoardCore.instance
                                  .isFeatureActive('Snow'),
                              onChanged: (result) => {
                                    DartBoardCore.instance
                                        .setFeatureImplementation(
                                            'Snow', result ? 'default' : null)
                                  }),
                          ListTile(
                            title: Text('See the Splash'),
                            onTap: () {
                              context.dispatchMethod('showSplashScreen');
                            },
                          ),
                          ListTile(
                            title: Text('Nav 2 Space X Launches'),
                            onTap: () {
                              Nav.pushRoute('/launches');
                            },
                          ),
                          ListTile(
                            title: ThemeChooserDropdown(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))),
      );
}
