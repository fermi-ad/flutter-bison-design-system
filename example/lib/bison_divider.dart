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

  return BisonDivider(
    orientation: orientation,
  );
}
