import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';

/// Provides different styling options for the `BisonButton` widget.
///
/// The different styling options inluded
/// - [BisonButtonType.filled] The most prominent styling option. This is the default option
/// - [BisonButtonType.outlined]
/// - [BisonButtonType.ghost]
/// - [BisonButtonType.destructive]
enum BisonButtonType {
  /// The most prominent styling option. This is the default option
  filled,

  /// An outlined button with a transparent background.
  ghost,

  /// The least prominent option. It has no outline and a transparent background
  outlined,

  /// Used to signify a destructive action such as delete
  destructive,
}

/// Provides a set of button types
class BisonButton extends StatelessWidget {
  final String buttonLabel;
  final BisonButtonType buttonType;
  final Icon? icon;
  final VoidCallback? onPressed;

  /// Provides various types of button types for different use cases.
  /// By default, a `filled` button will be returned. See [BisonButtonType] for different options
  const BisonButton({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonType = BisonButtonType.filled,
    this.icon,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final padding = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typo = Theme.of(context).extension<BisonTypographyTokens>()!;
    return FilledButton(
      style: switch (buttonType) {
        BisonButtonType.filled => _filledBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        BisonButtonType.ghost => _ghostBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        BisonButtonType.outlined => _outlinedBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        BisonButtonType.destructive => _destructiveBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
      },
      onPressed: onPressed,
      child: icon == null
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding.smallSpacing,
                vertical: padding.tinySpacing,
              ),
              child: Text(buttonLabel),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding.smallSpacing,
                vertical: padding.tinySpacing,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  SizedBox(width: padding.tinySpacing),
                  Text(buttonLabel),
                ],
              ),
            ),
    );
  }
}

ButtonStyle _filledBisonButtonStyle(
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
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle _ghostBisonButtonStyle(
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
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle _outlinedBisonButtonStyle(
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
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle _destructiveBisonButtonStyle(
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
      return theme.buttonDangerFocusedPressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonDangerHovered;
    }
    return theme.buttonDanger;
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
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);
