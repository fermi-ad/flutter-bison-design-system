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
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extension<BisonThemeTokens>()!;
    return FilledButton(
      style: switch (buttonType) {
        ButtonType.filled => _filledButtonStyle(theme),
        ButtonType.ghost => _ghostButtonStyle(theme),
        ButtonType.outlined => _outlinedButtonStyle(theme),
        ButtonType.destructive => _destructiveButtonStyle(theme),
      },
      onPressed: onPressed,
      child: icon == null
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
              child: Text(buttonLabel),
            )
          : Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 24.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, SizedBox(width: 8.0), Text(buttonLabel)],
              ),
            ),
    );
  }
}

ButtonStyle _filledButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  // TODO: Add more styling for focused state
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
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
    Set<WidgetState> states,
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
  side: WidgetStateProperty.resolveWith<BorderSide?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  elevation: WidgetStatePropertyAll(0.0),
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle _ghostButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
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
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.textDisabled;
    }
    return theme.textPrimary;
  }),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
  side: WidgetStateProperty.resolveWith<BorderSide?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  elevation: WidgetStatePropertyAll(0.0),
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle _outlinedButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
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
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.textDisabled;
    }
    return theme.textPrimary;
  }),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
  side: WidgetStateProperty.resolveWith<BorderSide?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(color: theme.borderPlain);
  }),
  elevation: WidgetStatePropertyAll(0.0),
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

ButtonStyle _destructiveButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
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
    Set<WidgetState> states,
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
  side: WidgetStateProperty.resolveWith<BorderSide?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  elevation: WidgetStatePropertyAll(0.0),
  // remove default padding given to button
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);
