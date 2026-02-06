import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, ghost, outlined, destructive }

class Button extends StatelessWidget {
  final String buttonLabel;
  final ButtonType buttonType;
  final bool disabled;

  const Button({
    super.key,
    required this.buttonLabel,
    this.buttonType = ButtonType.filled,
    this.disabled = false,
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
      onPressed: disabled ? null : () => print("Button PRESSED!"),
      child: Text(buttonLabel),
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
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonPrimaryHovered;
    }
    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return theme.buttonPrimaryFocusedPressed;
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
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  elevation: WidgetStatePropertyAll(0.0),
);

ButtonStyle _ghostButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonGhostHovered;
    }
    if (states.contains(WidgetState.pressed)) {
      return theme.buttonGhostPressed;
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
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  elevation: WidgetStatePropertyAll(0.0),
);

ButtonStyle _outlinedButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonGhostHovered;
    }
    if (states.contains(WidgetState.pressed)) {
      return theme.buttonGhostPressed;
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
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(color: theme.borderPlain);
  }),
  elevation: WidgetStatePropertyAll(0.0),
);

ButtonStyle _destructiveButtonStyle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.buttonGhostDisabled;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonDangerHovered;
    }
    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return theme.buttonDangerFocusedPressed;
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
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.focused)) {
      return BorderSide(color: theme.borderPrimary, width: 2.0);
    }
    return BorderSide(style: BorderStyle.none);
  }),
  elevation: WidgetStatePropertyAll(0.0),
);
