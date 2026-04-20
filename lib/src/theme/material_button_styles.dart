import 'package:flutter/material.dart';

import 'color_tokens.g.dart' show BisonThemeTokens;
import 'shape_spacing_tokens.g.dart' show BisonSpacingTokens, BisonCornerTokens;
import 'typography_tokens.g.dart' show BisonTypographyTokens;

ButtonStyle getFilledBisonButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.buttonGhostDisabled;
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
      return theme.textDisabled;
    }
    return theme.textInverse;
  }),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(corners.cornerExtraSmall)),
    ),
  ),
  side: WidgetStateProperty.resolveWith<BorderSide?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  textStyle: WidgetStatePropertyAll(typo.bodyLarge),
  elevation: WidgetStatePropertyAll(0.0),
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle getGhostBisonButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.pressed)) {
      return theme.buttonGhostPressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonGhostHovered;
    }
    return theme.surfaceTransparent;
  }),
  foregroundColor: WidgetStateProperty.resolveWith<Color?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.textDisabled;
    }
    return theme.textPrimary;
  }),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(corners.cornerExtraSmall)),
    ),
  ),
  side: WidgetStateProperty.resolveWith<BorderSide?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  textStyle: WidgetStatePropertyAll(typo.bodyLarge),
  elevation: WidgetStatePropertyAll(0.0),
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle getOutlinedBisonButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.pressed)) {
      return theme.buttonGhostPressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonGhostHovered;
    }
    return theme.surfaceTransparent;
  }),
  foregroundColor: WidgetStateProperty.resolveWith<Color?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.textDisabled;
    }
    return theme.textPrimary;
  }),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(corners.cornerExtraSmall)),
    ),
  ),
  side: WidgetStateProperty.resolveWith<BorderSide?>((
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(color: theme.borderPlain);
  }),
  textStyle: WidgetStatePropertyAll(typo.bodyLarge),
  elevation: WidgetStatePropertyAll(0.0),
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);
