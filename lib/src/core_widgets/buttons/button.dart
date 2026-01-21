import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, ghost, outlined, destructive }

class Button extends StatelessWidget {
  final String buttonLabel;
  final ButtonType buttonType;

  const Button({
    super.key,
    required this.buttonLabel,
    this.buttonType = ButtonType.filled,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extension<BisonThemeTokens>()!;
    return ElevatedButton(
      style: _buttonSytle(theme),
      onPressed: () => print("Button PRESSED!"),
      child: Text(buttonLabel),
    );
  }
}

ButtonStyle _buttonSytle(BisonThemeTokens theme) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonPrimaryHovered;
    }
    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return theme.buttonPrimaryFocusedPressed;
    }
    if (states.contains(WidgetState.disabled)) {
      return theme.buttonGhostDisabled;
    }
    return theme.buttonPrimary;
  }),
  foregroundColor: WidgetStatePropertyAll(theme.textInverse),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
);
