import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:bison_design_system/theme.dart'
    show
        BisonCornerTokens,
        BisonSpacingTokens,
        BisonThemeTokens,
        BisonTypographyTokens;

enum ObjectChipStyle { normal, warning, danger }

class BisonChip extends StatelessWidget {
  final String label;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  const BisonChip._({
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
  });

  BisonChip.object({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
  }) {
    BisonChip._(
      label: label,
      onLeftPressed: onLeftPressed,
      onRightPressed: onRightPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final spacing = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final Typography = Theme.of(context).extension<BisonTypographyTokens>()!;
    // TODO: implement build
    throw UnimplementedError();
  }
}
