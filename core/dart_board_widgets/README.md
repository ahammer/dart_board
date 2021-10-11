# dart_board_widgets

Generalized Architecture Widgets

These are the widgets I commonly use to facilitate dart board features. They've been packaged seperately to allow people to use them without the platform.

## Boolean Builder

Conditional Widget that will build one way or another based on a flag.

Useful for breaking out logic into the widget tree.

## ChangeNotifierBuilder

Builder's for change notifiers

## ConvertorWidget

A widget designed for ViewModel generation. Can optimize builds if you implement equals
on your widgets, or cache your converted models.

## LifeCycleWidget

A widget for tapping into a stateful widgets life cycle. Very useful for App and Page decorations with dart board (e.g. fire a tracking event, start loading something, etc.)

## PeriodicWidget

A widget that lets you hook a callback into the widget tree. 

## WidgetStream

The magic of `async*` in widget format. This lets you emit widgets, e.g.

```
WidgetStream((ctx) async * {
    yield Text('Loading');
    yield DetailsWidget(await loadData());
});
```

This is most useful for "loading" flows. E.g. if you need to do a bunch of async stuff you can use this to chain them together.



