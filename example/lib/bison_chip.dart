import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart' show BisonChip;

@widgetbook.UseCase(name: 'Default', type: BisonChip)
Widget buildBisonChipUseCase(BuildContext context) {
  return BisonChip.object(
    label: context.knobs.string(label: 'Chip Label', initialValue: 'Label'),
    onLeftPressed: () {},
    onRightPressed: () {},
  );
}
