import 'package:flutter/material.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonThemeTokens,
        BisonSpacingTokens,
        BisonCornerTokens,
        BisonTypographyTokens;

/// Provides different styling options for the `BisonButton` widget.
///
/// The different styling options inluded
/// - [BisonButtonType.filled] The most prominent styling option. This is the default option
/// - [BisonButtonType.outlined]
/// - [BisonButtonType.ghost]
/// - [BisonButtonType.destructive]
enum _BisonButtonType {
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
  final _BisonButtonType _buttonType;
  final Icon? icon;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;

  const BisonButton._({
    required this.buttonLabel,
    required this.onPressed,
    required _BisonButtonType buttonType,
    this.icon,
    this.focusNode,
    this.autofocus = false,
  }) : _buttonType = buttonType;

  /// A Filled button with the primary color. The most promininent styling option.
  factory BisonButton.filled({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.filled,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// A transparent button without an outline. The least prominent option
  factory BisonButton.ghost({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.ghost,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// A transparent button with an outline
  factory BisonButton.outlined({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.outlined,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// A button to signify a destructive action
  factory BisonButton.destructive({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.destructive,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final padding = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typo = Theme.of(context).extension<BisonTypographyTokens>()!;

    return FilledButton(
      focusNode: focusNode,
      autofocus: autofocus,
      style: switch (_buttonType) {
        _BisonButtonType.filled => getFilledBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonButtonType.ghost => getGhostBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonButtonType.outlined => getOutlinedBisonButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonButtonType.destructive => getDestructiveBisonButtonStyle(
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
  // remove default padding given to button
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
  // remove default padding given to button
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
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle getDestructiveBisonButtonStyle(
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
