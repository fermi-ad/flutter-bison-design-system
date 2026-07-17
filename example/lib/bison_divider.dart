import 'package:bison_design_system/core_widgets.dart'
    show BisonDivider, BisonDividerOrientation;
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: BisonDivider)
Widget buildBisonDivider(BuildContext context) {
  final orientation = context.knobs.object.dropdown<BisonDividerOrientation>(
    label: 'Orientation',
    options: BisonDividerOrientation.values,
    initialOption: BisonDividerOrientation.horizontal,
    labelBuilder: (o) => o.name,
  );

  const sizes = [100.0, 200.0, 400.0];
  const spacing = 16.0;

  if (orientation == BisonDividerOrientation.vertical) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacing,
      children: [
        for (final size in sizes)
          SizedBox(
            height: size,
            child: BisonDivider(orientation: orientation),
          ),
      ],
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: spacing,
    children: [
      for (final size in sizes)
        SizedBox(
          width: size,
          child: BisonDivider(orientation: orientation),
        ),
    ],
  );
}
