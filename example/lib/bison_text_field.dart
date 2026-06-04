import 'package:bison_design_system/core_widgets.dart'
    show BisonTextField, BisonTextFieldSize;
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Text Field', type: BisonTextField)
Widget buildBisonTextField(BuildContext context) {
  final BisonTextFieldSize size = context.knobs.object
      .dropdown<BisonTextFieldSize>(
        label: 'Size',
        options: BisonTextFieldSize.values,
        initialOption: BisonTextFieldSize.medium,
        labelBuilder: (value) => value.name,
      );

  return BisonTextField(
    label: "Test Label",
    helperText: 'Help me!!',
    placeholder: "Placeholder Text",
    size: size,
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    hasWarning: context.knobs.boolean(label: 'Warning'),
    hasError: context.knobs.boolean(label: 'Error'),
    obscureText: context.knobs.boolean(label: 'Obscure Text'),
  );
}
