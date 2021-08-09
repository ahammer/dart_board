# dart_board_locator

Service/State Locator Service

## What is a service locator

Simply put, it locates services. And if it can't do that it builds them.

You provide factories in the form of AppDecorations.

You can then use locate<T>({instance_id=""}) like magic to get the instance anywhere.

## When to use it?

When tree heirarchy of your services don't matter (i.e. they are "globals").

It doesn't impose anything.

A convenient way of using it would be to pair it with `ChangeNotifer.builder()` extension method to convert state into widgets. 

E.g.
`locate<YourChangeNotifier>().builder((ctx, value)=>Text(value.someData))`

## Usage
Provide factories to construct your objects.
Find with Locate<T>()

They will be lazily loaded and initialized as requested.

See Example for Simple Usage