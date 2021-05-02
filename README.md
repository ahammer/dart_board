# dart_board

A modular designed UI framework for flutter

# What is it?

It's a framework designed to be extended by adding modules or combining them.

Modules can plug into the system in a variety of ways and add features to the overal system.

It can be used as the Basis For many apps.

# Goal

The use-case of this is to create an "app" project, import the extensions you want and set up a runner. This can then be deployed on a variety of platforms (e.g. web/chrome/etc).

The idea is to provide a framdwork that can provide a ecosystem on top of pub that can be used to compose larger applications out of modules and a runner setup.

# Features

- Extensions Support
  - Routing
  - Decorations
  - Services
  - State

# Routing 

The ability to find pages and move around.

Adding an extension should allow exposing new pages.

# Decorations

You want all your pages to share a nav/appbar? Put a fancy frame around them? Add debugging or development tools?

Decorations allow you to globally inject widgets on all your navigation routes.

# Services

Occasionally you need long running services, the framework allows you to add new ones to your app.

# State
