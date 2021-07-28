# dart_board_particles

A particle system for Dart Board

Do you ever want sparkly things happening on the screen? Trails? Rainbows? Bubbles? Flames? Of course you do, if you can't show fake fire on the screen, what's the point of your app.


Include DartBoardParticlesFeature() and you are good to go.

Usage/Implementation is quite easy. A few built in examples are included in fire/lighting/rainbow/water particles.

The API is dead simple `Particles.instance.addLayer(particleLayer)`

What is a `ParticleLayer<T extends Particle>`?

A layer is a fixed group of `Particles`. It includes logic to do before the layer, after the layer, and for each particle.

What is a `particle`? In the context of the bare api, it's almost nothing.

```
abstract class Particle {
  void step(double time, Size size);
}
```

The only thing a particle must be able to do is `step` through it's simulation.


## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).
