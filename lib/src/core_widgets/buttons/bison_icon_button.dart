import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';

class BisonIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;

  const BisonIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final padding = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typo = Theme.of(context).extension<BisonTypographyTokens>()!;
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: 24.0,
      style: _filledButtonStyle(theme, padding, corners, typo),
    );
  }
}

ButtonStyle _filledButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.surfaceTransparent;
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return theme.buttonPrimaryFocusedPressed;
      }
      if (states.contains(WidgetState.hovered)) {
        return theme.buttonPrimaryHovered;
      }
      return theme.buttonPrimary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.iconDisabled;
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return theme.iconPrimary;
      }
      return theme.iconInverse;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    side: WidgetStateProperty.resolveWith<BorderSide?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: theme.borderDisabled, width: 2.0);
      }
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: theme.borderPrimary, width: 2.0);
      }
      return BorderSide(style: BorderStyle.none);
    }),
    // remove default padding given to button
    padding: WidgetStatePropertyAll(
      EdgeInsetsGeometry.all(padding.tinySpacing),
    ),
  );
}
