# dart_board

A modular designed UI framework for flutter

# What is it?

It is a framework for Flutter architecture/integration.

The best way to learn is via the interactive example.
It is a way to demonstrate the platform and it's abilities.

# Short Technical Version

Integrations and Features are delivered as "feature modules"

These are Flutter modules that provide the DartBoardFeature interface.

This interface provides multiple integration points to apps built on DartBoard.

# Integrating existing code

As long as the interface is supplied, it can integrate.

1) Extends DartBoardFeature
2) Provide routes (NamedRouteDefinition is the current only supported option)
3) Create an AppDecorator widget to define app level state.
4) Create any PageDecorators to decorate the named routes

At this point a user of your Feature can navigate to your route with RouteWidget or pushNamed()
If necessary, the Feature can provide additional API to interact with it's app state via the tree.


