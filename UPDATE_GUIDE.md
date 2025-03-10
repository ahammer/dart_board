# Dart Board Update Guide

This guide provides detailed instructions for updating Dart Board projects to the latest Flutter and Dart versions, along with best practices for maintaining compatibility and handling deprecations.

## Current Version Information

- **Dart SDK**: `>=3.0.0 <4.0.0`
- **Flutter**: `>=3.10.0`
- **dart_board_core**: `0.9.17`
- **dart_board_widgets**: `1.10.0`
- **dart_board_core_plugin**: `1.3.0`

## Update Process

Follow these steps to update your Dart Board project:

### 1. Update Dependencies

Update your `pubspec.yaml` files to use the latest package versions:

```yaml
# Core packages
dart_board_core: ^0.9.17
dart_board_widgets: ^1.10.0
dart_board_core_plugin: ^1.3.0 # For Add2App

# Firebase packages (if used)
dart_board_firebase_core: ^1.5.0
dart_board_firebase_authentication: ^1.5.0
dart_board_firebase_database: ^1.1.0
dart_board_firebase_analytics: ^1.3.0

# Supporting packages
dart_board_authentication: ^1.3.0
dart_board_locator: ^0.9.12
dart_board_tracking: ^1.4.0
```

### 2. Update SDK Constraints

Ensure your `pubspec.yaml` has appropriate SDK constraints:

```yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"
```

### 3. Run the Update Script

For Dart Board repository contributors, use the provided update script:

```bash
./update_dart_board.sh
```

This script:
- Bootstraps the monorepo with Melos
- Cleans cached dependencies
- Updates all packages to latest compatible versions
- Runs the analyzer to check for issues
- Verifies dependency constraints

### 4. Address Deprecations and API Changes

Several APIs have been updated in Flutter 3.x. Here are common changes to look for:

#### Flutter 3.x Changes

- **Theme API Changes**: `primaryVariant` is deprecated, use `primaryContainer` instead
- **Material 3**: Consider migrating to Material 3 design where appropriate
- **Navigation API**: Some changes to Navigator 2.0 and routing APIs
- **Null Safety**: Ensure all code properly handles nullable types

#### Firebase Changes

Firebase libraries have undergone significant API changes:

- **Firebase Auth**: 
  ```dart
  // Old
  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  
  // New - works the same but returns UserCredential instead of FirebaseUser
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  ```

- **Firebase Database**:
  ```dart
  // Old
  final ref = FirebaseDatabase.instance.reference().child('path');
  
  // New
  final ref = FirebaseDatabase.instance.ref('path');
  ```

### 5. Testing After Update

1. **Build and Run Test Projects**
   ```bash
   cd integrations/example
   flutter pub get
   flutter run
   ```

2. **Verify Features Work Correctly**
   - Test each feature individually
   - Check for any runtime warnings or errors
   - Verify visual appearance with Flutter 3.x

3. **Run the Analyzer**
   ```bash
   flutter analyze
   # or with Melos
   melos analyze
   ```

4. **Run Tests**
   ```bash
   flutter test
   # or with Melos
   melos test
   ```

## Common Issues and Solutions

### 1. Null Safety Errors

**Issue:** Errors related to null safety, such as "The parameter 'x' can't be null".

**Solution:** 
- Add null checks or provide default values
- Use nullable types (e.g., `String?`) where appropriate
- Use the null-aware operators (`?.`, `??`, `!`)

Example:
```dart
// Before
void processUser(User user) {
  final name = user.name;
  // ...
}

// After
void processUser(User? user) {
  final name = user?.name ?? 'Guest';
  // ...
}
```

### 2. Widget API Changes

**Issue:** Constructor parameters may have changed or been added.

**Solution:**
- Check updated API documentation
- Use the IDE's quick fix suggestions
- Consult the Flutter migration guides

Example:
```dart
// Before
ElevatedButton(
  child: Text('Button'),
  onPressed: () {},
);

// After
ElevatedButton(
  child: Text('Button'),
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
  ),
);
```

### 3. Package Conflicts

**Issue:** Dependency resolution conflicts during pub get.

**Solution:**
- Check for outdated package constraints
- Temporarily use dependency_overrides for problematic packages
- Use `flutter pub outdated` to identify packages that need updating

Example in `pubspec.yaml`:
```yaml
dependency_overrides:
  package_name: ^x.y.z
```

### 4. Firebase Plugin Compatibility

**Issue:** Firebase plugins require specific configurations for Flutter 3.x.

**Solution:**
- Ensure all Firebase plugins are updated to compatible versions
- Update platform-specific configurations (iOS, Android, web)
- Follow FlutterFire migration guides

For Android (`android/app/build.gradle`):
```gradle
dependencies {
  // Make sure this is up to date
  implementation "com.google.firebase:firebase-bom:31.1.0"
}
```

## Future Compatibility

To maintain compatibility with future Flutter updates:

1. **Avoid Deprecated APIs**: Check Flutter documentation for deprecated APIs and their replacements
2. **Use Semantic Versioning**: Specify version constraints with flexibility (e.g., `^1.0.0` rather than `1.0.0`)
3. **Run Periodic Updates**: Regularly update dependencies and test with beta Flutter channels
4. **Follow Flutter Release Notes**: Stay informed about upcoming changes

## Additional Resources

- [Flutter Release Notes](https://flutter.dev/docs/development/tools/sdk/release-notes)
- [Breaking Changes in Flutter](https://docs.flutter.dev/release/breaking-changes)
- [Firebase Flutter Codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter)
- [Material 3 Migration Guide](https://m3.material.io/develop/flutter/migration-guide)

---

If you encounter any issues not covered in this guide, please report them on the [Dart Board issue tracker](https://github.com/ahammer/dart_board/issues).
