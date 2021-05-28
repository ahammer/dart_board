# Example: How it's Made  

The example doubles as documentation. The development of Dart Board was done via 
Example Drive Development. Essentially I structured the app the way I wanted, and have built the core around it.

Essentially, all features available to DartBoard are used in it's example, and it can be used as a sample framework/scaffolding for a new project with some basic functionality already included

 - Dependency Features
 - App and Page Decorations
 - Features
 - Templates
 - AB Testing/Feature Flags

The goals of the framework was to build a generic loader that can be used for a wide range of features, and handle common Flutter boilerplate (take care of MaterialApp for you).  

### Development History
The realities of this project date back a bit. Throughout my career I've spent a lot of times on White Label applications and have worked on Extensible frameworks as a hobby and in professional settings.

It's been web-only, android white label, etc. As technology has changed, the vision continues to change and mutate. Flutter has been a pretty central part of my development experience for the last two years, and that idea has morphed into this.

This project was started not long ago, actually, at the time of this writing, it's 26 days old. It's birthday is captured by this commit, made 5/01/2021. It's not however a void, it's a clean room implementation of how I handle large scale architecture at work. It's my current patterns, coded from scratch and up to date.

The development started knowing I wanted similar features to work, but with a few improvements, and also made generic. The improvements I wanted to materialize were AB Testing of features, disabling of features at runtime, and an introduction of a decoration system to better enable features to self-integrate.

I basically got up to parity very quickly (the framework isn't that complicated, 


## Core Features

### Features

Everything that you see in your App should be composed of Features. Features can be simple, e.g. providing a single screen, or a state object that can be interacted with, or they can be complicated, brining in multiple other features and providing many screens and decorations.

While technically there is no differentation in structure, it's good to think of features coming in two flavours, Integration and Isolated modes.

### Integration Feature
The class ExampleFeature represents a Feature and also an integration. It's "feature" is gluing all the other features together.

It provides routes related to the content of the example, it also exposes many other features that come in through other extensions.  This integration extension can live with your "flutter app" type project.

### Isolated Features
An isolated feature is something like a Template or Logging that doesn't bring any significant dependencies with it. It's recommended to isolate features as much as possible and then import them into an integration feature.

The more isolated a feature, the less chance we'll be making pasta with the overall system. These features would generally be "flutter module" type projects. They can take other Feature dependencies, but should be done conservatively and only as a specific design decision. 

### Dependency Features
  Example is composed out of many Features. It is Integrated in ExampleFeature, however it uses the following.
  
- ThemeFeature()
- DebugFeature()
- LogFeature(),
- MinesweeperFeature()
- BottomNavTemplateFeature('/main', kMainPageConfig)
- BackgroundAFeature()
- BackgroundBFeature()
  
Features can take config, and you can also register competing Features.

The features themselves can hook into your App, and Dart Board can help you AB test or disable features at runtime. 

### App Decorations
App Decorations are the recommended way to store App State. If your feature needs some dedicated state you can hook it up with these. Various feature hook their own app state up. E.g. the Template has a state object to track it's active tab. Minesweeper has a state object that exposes a Redux store.

These decorations are injected above the navigator, so they persist for all pages. It isn't recommended to put UI here, but it is possible and will span all pages as you navigate.

### Page Decorations
Page Decorations are a way to consistently decorate pages. They are injected right below the navigator. They live for Page scope. How page decorations are applied is controlled by allow/deny lists inside the extensions. 

Some examples of Page Decorations are Background (and it's variants), the Log frame and the Color border in the example.

You'd generally use Page Decorations to "Decorate" an app visually. E.g. you could make an extension that allows you to shake the screen or blur transition pages in, provide particle effects/intelligent overlways, or frames.

### Navigation
To handle Navigation you register routes. You do this within a feature by providing a list of RouteDefinition. NamedRouteDefinition is provided to do simple "name" to "page" mappings, but other implementations of the RouteDefinition interface are possible (e.g. for URL processing).

You can also use RouteWidget(RouteSettings(name: '/my_route')) to inject 'routes" anywhere in the widget tree. Unlocking the ability to use your Routes as fragments.

### Templates

Templates are regular Features, there is nothing special or clevel rules. In general you expose a route, it's good to take the route and settings in via config (as is the case in BottomNavTemplateFeature) so that the feature is easily re-usable/adaptable.

Ultimately, Templates can be just as advanced as any other feature, offering a wide range of capabilities.


## How they come together in the example.

