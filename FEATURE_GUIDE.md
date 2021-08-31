# Dart Board Features

Features and dart-board don't really have any bounds, but they do have categories. This guide will help you pick what you need.

## State Management
### Locator

Simply provide state objects from your features and consume them with locate<T>() 

Low config and easy to get started. Works well with ChangeNotifier and Dart-Boards `.builder()` extention method con ChangeNOtifier.

### Redux

Bindings for flutter-redux, providing "feature" awareness. Features provide their own states and actions, and this serves as a broker.

Minesweeper demo demonstrates Redux usage.

## Dev
### Log

Allows viewing of the logs in an overlay you can enable in your app

### Debug

Shows introspection to the system, e.g. loaded features, enabling/disabling, etc.

## UI
### Canvas

Similar to funvas, designed to easily do indeterminate animations as fast as possible.

It allows you to expose named routes that can run these animations.

### Image Background

Very simple feature, provides a PageDecoration that can apply a background to any page.

### Splash

Adds a Splash Screen to your app. Includes a widget to handle fading/dismissing and timing.

Can provide any widget however, e.g. paired with the Canvas feature to draw an animated splash.

### Theme

Light or Dark? You can choose with this.

## Firebase
Bindings for firebase services
### firebase_auth

Firebase connections for the Auth interfaces

### firebase_core

Firebase core-framework (does nothing on it's own)

### firebase_database

Firebase Database and some helpers

## General Features
### Chat

Chat, built on top of firebase_auth and firebase_database interfaces.

### Minesweeper

Minesweeper, built on top of Redux
