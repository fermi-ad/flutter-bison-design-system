import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, ghost, outlined, destructive }

class Button extends StatelessWidget {
  final String buttonLabel;
  final ButtonType buttonType;
  final Icon? icon;
  final VoidCallback? onPressed;

  const Button({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonType = ButtonType.filled,
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
        ButtonType.filled => _filledButtonStyle(theme, padding, corners, typo),
        ButtonType.ghost => _ghostButtonStyle(theme, padding, corners, typo),
        ButtonType.outlined => _outlinedButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        ButtonType.destructive => _destructiveButtonStyle(
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

ButtonStyle _filledButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) => ButtonStyle(
  // TODO: Add more styling for focused state
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

ButtonStyle _ghostButtonStyle(
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
    return Colors.transparent;
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

ButtonStyle _outlinedButtonStyle(
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
    return Colors.transparent;
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

ButtonStyle _destructiveButtonStyle(
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
