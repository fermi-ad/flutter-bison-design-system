import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonChip, ObjectChipStyle;

@widgetbook.UseCase(name: 'Default', type: BisonChip)
Widget buildBisonChipUseCase(BuildContext context) {
  return BisonChip.object(
    label: context.knobs.string(label: 'Chip Label', initialValue: 'Label'),
    leftIcon: Icon(Icons.circle_outlined),
    onLeftPressed: () => {},
    onRightPressed: () => {},
    objectChipStyle: context.knobs.object.dropdown(
      label: 'Object Style',
      labelBuilder: (value) => value.name,
      options: [
        ObjectChipStyle.normal,
        ObjectChipStyle.warning,
        ObjectChipStyle.danger,
      ],
    ),
  );
}
