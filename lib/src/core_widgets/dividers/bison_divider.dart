import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart' show BisonContext;

/// The orientation of a [BisonDivider].
enum BisonDividerOrientation {
  /// Horizontal divider (full width, fixed height).
  horizontal,

  /// Vertical divider (full height, fixed width).
  vertical,
}

/// A divider line that follows the Bison design system.
///
/// ## Basic usage
/// ```dart
/// BisonDivider()  // Horizontal by default
/// ```
///
/// ## Vertical divider
/// ```dart
/// BisonDivider(
///   orientation: BisonDividerOrientation.vertical,
/// )
/// ```
///
class BisonDivider extends StatelessWidget {
  /// orientation of the divider.
  final BisonDividerOrientation orientation;

  const BisonDivider({super.key, this.orientation = BisonDividerOrientation.horizontal});

  @override
  Widget build(BuildContext context) {
    final bison = context.bison;
    const dividerThickness = 1.0;
    final dividerColor = bison.theme.borderPlain;

    if (orientation == BisonDividerOrientation.vertical) {
      return SizedBox(
        width: dividerThickness,
        height: double.infinity,
        child: ColoredBox(color: dividerColor),
      );
    }

    // Horizontal (default)
    return SizedBox(
      height: dividerThickness,
      width: double.infinity,
      child: ColoredBox(color: dividerColor),
    );
  }
}
