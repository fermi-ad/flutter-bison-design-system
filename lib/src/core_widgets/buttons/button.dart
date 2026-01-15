import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
// import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).extension<ColorsTheme>()!;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(theme.textPrimary),
      ),
      onPressed: () => print("Button pressed!"),
      child: Text("Button!"),
    );
  }
}

class ButtonStyles {
  static ButtonStyle filled(ColorsTheme colors) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.textDisabled;
        return colors.textPrimary;
      }),
    );
  }
}
