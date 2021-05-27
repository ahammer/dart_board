# App Development Guidance.

So you want to make an App with Dart Board?

To do so, you'll want to create and configure a new 
"app" type project.

Create the Project
1) flutter create -t app --platforms android,ios,macos,linux,windows your_flutter_app


2) Include dart_board in your project
pubspec.yaml

3) Create a basic Extension
This will serve as the "integration" extension.

Provide some routes in the extension, these will be your screens.

4) Run DartBoard with your extension, and set your entry point, run your App.

Generally speaking, the app project should serve as an integration.
Whenever possible, Features should be kept small and focussed.

To add more /routes and other features to your app (e.g. page/state decorations)
check the Feature Guide
