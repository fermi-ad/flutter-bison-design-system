import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';

class BisonIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const BisonIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(final BuildContext context) {
    return IconButton(onPressed: onPressed, icon: icon);
  }
}
