# Dart Board Debug

Debug route for Dart Board.

Provides /debug that can provide insights, toggle features and switch AB tests

## Usage

1) Include `DebugFeature` in your DartBoard app
2) Navigate to `/debug` for introspective report
3) Navigate to `/dependency_tree` to see the estimated dependency links

## Todo

- UI refinement to dependency_tree
- Clearer "wires"
- Hover+Highlight (e.g. Hovering or selecting a feature will show it's connections clearly).
- Nicer "Feature" list
- "Site Map" e.g. sorted list of supported paths