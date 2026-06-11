import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart' show BisonScrim;
import 'package:bison_design_system/bison_design_system.dart' show BisonContext;

@widgetbook.UseCase(name: 'Default', type: BisonScrim)
Widget buildBisonScrimUseCase(BuildContext context) {
  final bison = context.bison;

  return Stack(
    children: [
      Center(
        child: Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            color: bison.theme.surfaceInverse,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Content behind scrim',
              style: TextStyle(color: bison.theme.textInverse),
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: BisonScrim(onDismiss: () {}, barrierDismissible: false),
      ),
    ],
  );
}
