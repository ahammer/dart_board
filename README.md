# dart_board

A modular designed UI framework for flutter

# What is it?

It is a framework for Flutter architecture/integration.

It can be considered a "feature management" solution.

# What is Feature Management?

The goal here is to keep features loosely coupled, so they can be easily 
developed in isolation and mixed/matched.

This means that you are provided a lot of flexibility in what
the integration would look like, and don't have to handle
nearly as much boilerplate.

Existing projects can be easily adapted and contained inside a Dart Board
feature.

# Short Technical Version

Integrations and Features are delivered as "feature modules"

These are Flutter modules that provide the DartBoardFeature interface.

This interface provides multiple integration points to apps built on DartBoard.
Such as App and Page decorations + Routing, as well as a the DartBoard() entry point widget.

# How it works

First it takes your extensions.

Then it walks the dependency tree and collects an ordered list of what to init.

It then collects all the routes and decorations. It creates the MaterialApp()
for you, and sets up the routing and decoration features, as well as injecting all your App Decoration's near the trunk of the Tree.

From here, you can use named routing to access any registered feature route, or
RouteView. Additionally features can provide API's to the app and page level components.

# Component Walkthrough

There is a dart board theme extension. This is really basic and allows switching between light and dark. It's implemented as a Dart Board Feature. It is as follows.

1) App Decoration provides a State object that holds the isLight boolean.
2) Page Decoration listens to that State and applies the correct theme
3) Developer calls ThemeFeature.toggle() to turn the lights on/off

With a very simple, 2 point integration, we are able to add theming to any app that simply registers the extension and calls the toggle() method.


# Integrating existing code

As long as the interface is supplied, it can integrate.

1) Extends DartBoardFeature
2) Provide routes (NamedRouteDefinition is the current only supported option)
3) Create an AppDecorator widget to define app level state.
4) Create any PageDecorators to decorate the named routes

At this point a user of your Feature can navigate to your route with RouteWidget or pushNamed()
If necessary, the Feature can provide additional API to interact with it's app state via the tree.


Release Checklist
1) Fix Android URL loader
8) Logging Everywhere
9) Document at least the files in the Demo
13) Put up all the demo's on dart-board.io
14) Publish all to pub