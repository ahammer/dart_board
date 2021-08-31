# dart_board_authentication

Authentication Abstraction for Dart-Board

## Getting Started

By itself, this module does nothing. It needs to be paired with an auth-provider.

Firebase is provided for this via the dart_board_firebase_authentication, or you can implement your own

## Usage

### Reading/Listening to stae

You can access AuthenticationState with locator. 
e.g. `locate<AuthenticationState>()` it is stored as a global for your application and available everywhere.

AuthenticationState provides the following

```
bool get signedIn => _activeDelegate != null;
String get photoUrl => _activeDelegate?.photoUrl ?? "";
String get username => _activeDelegate?.username ?? "anon";
```

It is also a `ChangeNotifier` so if you want to listen to updates, you can use `locateAndBuild<AuthenticationState>((ctx, state)=>YourWidget)

### Signing in

Call the static global `AuthenticationState.requestSignIn()` to start the log in flow in a dialog.

### Writing a Delegate

1) Create a new feature in a clean flutter module. 
2) Import dart_board_core and dart_board_authentication.
3) Define authentication feature as a dependency.
4) Implement the AuthenticationDelegate class
5) Notify AuthenticationState of auth changes in your delegate
6) Provide `DartBoardAuthenticationProviderAppDecoration` 
7) Import and register your feature into your integration.
   1) The Auth feature will delegate out to it's auth options
   2) The delegates register themselves via an AppDecoration

The example contains a mock delegate that can be used as a starting point, or refer to `dart_board_firebase_authentication` for a real world example.

