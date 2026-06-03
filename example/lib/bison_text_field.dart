import 'package:bison_design_system/core_widgets.dart' show BisonTextField;
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Text Field', type: BisonTextField)
Widget buildBisonTextField(BuildContext context) {
  return BisonTextField(
    label: "Test Label",
    helperText: 'Help me!!',
    placeholder: "Placeholder Text",
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
  );
}
