# dart_board_locator

Service/State Locator Service

## What is a service locator

Simply put, it locates services. And if it can't do that it builds them.

You provide factories in the form of AppDecorations.

You can then use `locate<T>({instance_id=""})` like magic to get the instance anywhere.
`locateAndBuild<YourChangeNotifier>((ctx, value)=>Text(value.someData))`

## When to use it?

When tree heirarchy of your services don't matter (i.e. they are "globals").

However you can store multiple instances if you key them or form a library.

## Usage
Provide factories to construct your objects.
### provide
In your appDecorations
`LocatorDecoration<SomeService>(()=>SomeServiceImpl())`
if you want to use an interface.

or just simply 
`LocatorDecoration(()=>SomeService())`
if type inferrence will do

### find
`locate<SomeService>()`
and
`locateAndBuild<T extends ChangeNotifier>((ctx, t) => yourWidget)`

They will be lazily loaded and initialized as requested.

See Example for Simple Usage