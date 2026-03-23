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
  final ObjectChipStyle? _objectChipStyle;

  const BisonChip.filter({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
  }) : _objectChipStyle = null;

  const BisonChip.input({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
  }) : _objectChipStyle = null;

  const BisonChip.suggestion({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
  }) : _objectChipStyle = null;

  const BisonChip.object({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
    ObjectChipStyle objectChipStyle = ObjectChipStyle.normal,
  }) : _objectChipStyle = objectChipStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final spacing = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typography = Theme.of(context).extension<BisonTypographyTokens>()!;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onLeftPressed,
        onSecondaryTap: onRightPressed,
        child: Container(
          decoration: BoxDecoration(
            color: switch (_objectChipStyle) {
              ObjectChipStyle.normal => theme.chipUnselectedActive,
              ObjectChipStyle.warning => theme.chipWarningActive,
              ObjectChipStyle.danger => theme.chipDangerActive,
              _ => theme.chipUnselectedActive,
            },
            border: Border.all(color: theme.borderPlain),
            borderRadius: BorderRadius.circular(corners.cornerExtraSmall),
          ),
          padding: EdgeInsets.symmetric(
            vertical: spacing.microSpacing,
            horizontal: spacing.tinySpacing,
          ),
          child: Text(label, style: typography.bodySmall),
        ),
      ),
    );
  }
}
