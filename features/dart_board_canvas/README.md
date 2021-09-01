# dart_board_canvas

This one is for fun. It provides a way to expose a Route which reveals an indeterminate animated canvas.

This is meant for physics/visual simulations and demo's. If you want access to the canvas to draw something cool, this is it.

It's similar to the flutter "funvas" project, and is designed for quick and dirty graphics work. It does not provide shorthand like funvas does.

## Getting Started


### Adding to your App

Add `DartBoardCanvasFeature` to your application, it is configured to be registered multiple times under many namespaces if necessary. It binds an animated widget to a route.

params
`showFpsOverlay` enable an app decoration that will show your canvas/draw performance/fps
`implementationName & namespace` feature registration details
`route` the route this feature will expose
`stateBuilder` Builds the `AnimatedCanvasState` instance


### Implementing canvas effects.

1. Extend `AnimatedCanvasState`
2. implement `init(BuildContext context)` and `dispose()` if necessary.
2. implement `paint(Canvas, Size)` to draw your thing
3. EITHER Use `DartBoardCanvaFeature` to mount your Animation
4. OR use `AnimatedCanvasWidget` and give it your state object.


built-in fields/getters accessible in paint()
`time` - The current simulation time
`timeDelta` - The delta time of the frame
`fps` - 1/timeDelta
`context` the active BuildContext this painter is operating in



### Funvas Support
https://github.com/creativecreatorormaybenot/funvas

Funvas code can be dropped in as is usually, the shorthand API is supported, and a small amount of code ported.
However, we don't bring in funvas directly.

Just drop the funvas code into the paint() method.

I know it's strange to have 2 api's (e.g. time and t), but funvas is really nice, and the programming style of brevity and hacking is nicely
in the spirit of this kind of graphics programming. So use the shorthand for fun, use the full names if your writing more readable code.

Ultimately, up to you.