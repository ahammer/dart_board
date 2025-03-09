# Dart Board Flutter 3.x Update Guide

This guide outlines the changes made to update Dart Board to work with the latest Flutter (3.x) and Dart (3.x).

## Changes Made

### Core Package Updates
- Updated Dart SDK constraints to `>=3.0.0 <4.0.0` across all packages
- Updated Flutter constraints to `>=3.10.0` where applicable
- Updated `dart_board_core` to version 0.9.17
- Updated `dart_board_widgets` to version 1.10.0
- Updated `dart_board_core_plugin` to version 1.3.0
- Added stronger linting rules in analysis_options.yaml files

### Firebase Package Updates
- Updated `dart_board_firebase_core` to version 1.5.0
- Updated `dart_board_firebase_authentication` to version 1.5.0
- Updated `dart_board_firebase_database` to version 1.1.0
- Updated `dart_board_firebase_analytics` to version 1.3.0
- Updated all Firebase packages to latest compatible versions:
  - firebase_core: ^2.24.2
  - firebase_auth: ^4.15.3
  - cloud_firestore: ^4.13.6
  - firebase_analytics: ^10.7.4
  - google_sign_in: ^6.1.6

### Supporting Package Updates
- Updated `dart_board_authentication` to version 1.3.0
- Updated `dart_board_locator` to version 0.9.12
- Updated `dart_board_tracking` to version 1.4.0
- Updated intl to version 0.18.1
- Updated logging to version 1.2.0

### Example App Updates
- Updated SDK constraints and dependencies in the example app
- Added version constraints for core packages

## Update Script

A bash script `update_dart_board.sh` has been created to help with ongoing updates. This script:

1. Bootstraps the monorepo with Melos
2. Cleans up cached dependencies
3. Updates all dependencies to their latest compatible versions
4. Runs the analyzer to check for issues
5. Verifies dependency constraints

To use the script:
```bash
./update_dart_board.sh
```

## Testing After Update

1. **Build and Run the Example App**
   ```bash
   cd integrations/example
   flutter pub get
   flutter run
   ```

2. **Verify Firebase Functionality** (if configured)
   - Test authentication
   - Test database operations
   - Verify analytics events are being tracked

3. **Check for Deprecated API Usage**
   Run the analyzer and fix any warnings about deprecated APIs:
   ```bash
   melos analyze
   ```

## Common Issues and Fixes

1. **Null Safety Errors**
   - All packages now require sound null safety
   - Make sure all code properly handles nullable types

2. **Breaking API Changes in Firebase**
   - Firebase APIs may have changed in newer versions
   - Refer to the Firebase documentation for API changes

3. **Flutter 3.x Widget Changes**
   - Some widgets may have new required parameters
   - Some widget constructors may be deprecated

## Next Steps

1. Update any feature-specific code that might use deprecated APIs
2. Run tests across all packages to ensure functionality
3. Consider updating other dependencies to their latest versions

If you encounter any issues not covered in this guide, please report them on the [Dart Board issue tracker](https://github.com/ahammer/dart_board/issues).
