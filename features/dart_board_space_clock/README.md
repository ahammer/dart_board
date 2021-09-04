# Time and Space clock
## !UPDATED TO FLUTTER 2.X and Null Safety!

Should work with modern flutter now as well as Dart Board!

## How to run

    flutter create .
    flutter run
    
## Time and Space 

![6:30:30 Light](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/light063030.png) 
![Adams Clock](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/preview.webp)

This clock was an experiment in iterative development. As it progressed it gained a clear goal of the Time and Space clock. The entire thing is a function of time, completely deterministic. Two devices will show the same image at the same time. The goal was to visually push Flutter's limits, while not pushing a devices limits. There is roughly 25-30 draw calls for the entire scene. 

Highlights
- Some Canvas, Some Widget System
- No 3rd party libraries (pure flutter 1.12)
- All ClockModel data utilized
- Easily configurable
- Strict Mode Enabled (lots of lint checks)
- Extension Function APIs for various things


### Project Iterations 

1) Original Design - Fixed hand clock with 3 discs (hands point up, discs spin)
2) Experimented with design, ended up with planets on the dials because it looked kind of cheesy.
3) Ran with concept or orbits and positioning of objects to tell the time more
4) Added a starfield for some 3D effect
5) Added a static/rotating background for atmosphere and infinity
6) Added a perlin noise to create the sun
7) Lots of tweaking to sun parameters/images to make the sun look the way I want.
8) Added shadowing to the moon/earth to give the images 3D depth
9) Added the "ticker" to show the time/date/weather at a glance.
10) Extracted "config" from the drawing code. Built a light and dark config
11) Optimization on older devices
12) Fine tuning, lint checks, code cleanup
13) Extracted "viewmodel" from render code, to help organize it better

### Architectural OverView

#### Top Level
Main -> ClockScaffold

At the top level we create the ClockScaffold which places the 2 clocks we have in here (Digital + Analog)

#### Clock Scaffold
ClockCustomizer -> Stack[SpaceClockScene, TickerClock]

Here we pass the ClockModel to the Clocks and get everything on the screen.

#### Space Clock Scene

AnimatedPaint(SpaceClockPainter)

Animated Painter is just an extension on CustomPainter to allow automatic animation. The actual Painting is in SpaceClockPainter.

#### Space Clock Draw Call
1) Generate View Model
2) Draw Background
3) Draw Stars
4) Draw Sun
5) Draw Earth & Moon

#### Space Clock View Model Generation
Inputs: Time, Config, View Size
1) Calculate "orbits" between 0-360 that map to an analog clock
2) Calculate size of background to fill the screen
3) Calculate the size of sun/earth/moon
4) Calculate locations of sun/earth/moon


#### Star Field
1) Immutable state
2) zForTime on a Star offsets by time and loops
3) Transformed from 3d to 2d points using Matrix/Vector
4) Drawn to screen in batches with drawPoints (for performance)

There is 500 stars, and they are split into 16 batches (to adjust opacity without visual banding/flick)

There is a fair bit of headroom here, you can easily boost this number way up on modern hardware. But I felt 500 looked right.


#### Ticker Clock
Generic component for buiding a UI agnostic ticker out of a string and AnimatedSwitcher

Customized Component to build the ticker text (date/time/weather) and UI I want for the ticker.

Ticker updates every 1 second. A random factor is applied to each element to make the animation a bit "analog" looking.




## Notes

Only very partial web support due to canvas support needing some work, run main_web to get the simplified "web" version of
the digital clock only.

- Supported Platforms (Android, iOS, Desktop) 
- The subset that works on the web can be run from web_main.dart (it's missing a lot)
- Optimized on a HTC One (2013) device.
- Code here is slightly ahead of contest submission zip code. No UI changes however documentation, more lint checks, non-functional refactoring have been added. Last commit will be before contest end time.

#### Licensed Apache 2

| Light | Dark |
| ----- | ---- |
| 12:00:00 |
| ![12:00:00 Dark](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/dark000000.png) | ![12:00:00 Light](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/light000000.png) |
| 3:15:15 |
| ![03:15:15 Dark](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/dark031515.png) | ![3:15:15 Light](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/light031515.png) |
| 6:30:30 |
| ![6:30:30 Dark](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/dark063030.png) | ![6:30:30 Light](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/light063030.png) |
| 9:45:45 |
| ![9:45:45 Dark](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/dark094545.png) | ![9:45:45 Light](https://raw.githubusercontent.com/ahammer/adams_clock/master/screenshots/light094545.png) |


