# Dart Board Feature Guide

So you want to develop a feature that can be integrated into other apps.

To do this, you must implement the DartBoardFeature interface

To illustrate the process, lets discuss a theoretical "analytics" feature.

First we set up some use cases
 - Developers should be able to log events
 - Events should be kept in memory for debugging
 - We want an optional page decoration that shows the last event
 - There should be a route /analytics that can view the analytics timeline locally

 We would start by creating a Feature. E.g. AnalyticsFeature.

 First, we would want some sort of interface/state object to interact with.

 We can use an AppProvider to provide an Analytics object in the tree to work with.

 We can then also create a static interface in the Feature to interact with the AppProvider.
 
 E.g.
 static trackClick(String target) => Provider.of<Analytics>(dartBoardNavKey.currentContext!, listen: false).trackClick(target);

 Usage
 AnalyticsExtension.trackClick('buy_button');


 At this point, you also have the State in memory, so you can work with it in other ways. You can register a new page and use 
 Consumer<Analytics>() to rebuild it as the analytics changes. You can use your Analytics object to populate the UI etc on
 your pages.

 You can also add a PageDecoration that adds a Column or a Frame that can place an overlay or toolbar to work with the analytics.


 Additionally, you can configure your extension when you create it however is necessary. 
 E.g. 
  - Pass in API keys for your analytics provider
  - Enable/Disable/Rename Routes and Page Decorations
  - configure up addition features (e.g. Analytics Target/Transforms)




  That pretty much wraps up the story of creating a feature from scratch. Since features can bring in other features as dependencies, you can then include
  this feature into other features, register it as a dependency, and use analytics.

  Config should always be pushed up to the top, ultimately things like API Keys should be not stored in the extensions and should get injected right at the main.dart. 
  Other config should use sensible defaults whenever possible.