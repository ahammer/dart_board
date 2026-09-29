# Dart Board maintenance guidelines

Dart Board is a Flutter framework for modular apps, published as a melos monorepo: `core/`,
`features/`, `integrations/` (example and starter apps) and `templates/`.

## Toolchain

- Two Flutter SDKs are installed; use the one the package's `pubspec.yaml` SDK constraints need:
  - Flutter 3.29.3 (Dart 3) is on PATH and matches CI.
  - Flutter 3.3.3 (Dart 2.18) is for code that predates the Dart 3 update: run it as
    `mise exec flutter@3.3.3 -- flutter ...` (and the same for `melos`).
- CI (`.github/workflows/core_tests.yml`) runs `flutter pub global activate melos 6.3.2`,
  `melos bootstrap`, then `melos exec --dir-exists=test -- flutter test --coverage`. Pull requests
  must pass that, plus `melos run analyze` for the packages they touch.
- Linux is the native target: prove app changes with `flutter build linux` for the affected example
  app, under the machine lease (`machine-lease run -- <command>`).

## Boundaries

- Never publish packages (`flutter pub publish`, `melos publish`) or change version numbers unless
  an issue asks for a release.
- Never deploy the playground or website (`deploy.sh`, Firebase).

## Conventions

- Each feature package stays independent: it depends on `dart_board_core`, not on other features,
  unless it is an explicit integration.
- Package READMEs are the public docs on pub.dev; keep their examples compiling.
