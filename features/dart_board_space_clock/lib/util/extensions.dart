/// Shortcut to the Extension API I use

library adams_clock_extensions;

// .chain() method on all objects, similar to map() but global
export 'package:dart_board_space_clock/util/extensions/chain.dart';

// Extensions to the ClockModel (getting the asset name for the current weather)
export 'package:dart_board_space_clock/util/extensions/clock_model.dart';

// To get the fraction/decimal places of a double (val - val.floor)
export 'package:dart_board_space_clock/util/extensions/double.dart';

// I like Java charAt() so I brought over the equivalent
export 'package:dart_board_space_clock/util/extensions/string.dart';

// To mutate TextStyles (and apply the font I want)
export 'package:dart_board_space_clock/util/extensions/text_style.dart';

// Extensions to Draw rotating images to a canvas
export 'package:dart_board_space_clock/util/extensions/ui_image.dart';

// vector.toOffset() because Vector used for math, but Offset used for drawing.
export 'package:dart_board_space_clock/util/extensions/vector.dart';
