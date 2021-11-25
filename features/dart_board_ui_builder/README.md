# dart_board_ui_builder

The concept of this widget is to turn a JSON document into a Flutter Widget.

The JSON part is for serialization/saving of the state in a mutable format

It'll also allow either Binding a JSON UI to a Data Model or Generating flutter code.

Concepts

- DynamicUI (Widget)
- DynamicData (Data representing the widget table)


User Cases:

- Route that can mount JSON
- Editor to walk the JSON Data and modify it
- Support Basic Types (Column, Row, Padding, Text, Card, Material)

Implementation

1) Create the Route/Widget/Object type and Hardcode data
2) Create JSON Loader/Saver
3) Create a build_runner plugin that can convert .json files to .dart widget files
4) Create a UI to delete elements
5) Create a UI to add elements
6) 