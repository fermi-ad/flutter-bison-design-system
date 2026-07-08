import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonCheckboxGroup, BisonCheckboxGroupItem, BisonCheckboxValue;

@widgetbook.UseCase(name: 'Interactive', type: BisonCheckboxGroup)
Widget buildBisonCheckboxGroupUseCase(BuildContext context) {
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return ValueListenableBuilder<List<BisonCheckboxValue>>(
    valueListenable: _values,
    builder: (context, values, _) {
      return BisonCheckboxGroup(
        items: [
          BisonCheckboxGroupItem(
            label: 'Alpha',
            value: values[0],
            enabled: isEnabled,
          ),
          BisonCheckboxGroupItem(
            label: 'Beta',
            value: values[0],
            enabled: isEnabled,
          ),
          BisonCheckboxGroupItem(
            label: 'Gamma',
            value: values[0],
            enabled: isEnabled,
          ),
        ],
        onChanged: isEnabled
            ? (index, currentValue) {
                final next = List<BisonCheckboxValue>.from(values);
                next[index] = _toggle(currentValue);
                _values.value = next;
              }
            : null,
      );
    },
  );
}

final ValueNotifier<List<BisonCheckboxValue>> _values = ValueNotifier(const [
  BisonCheckboxValue.unselected,
  BisonCheckboxValue.selected,
]);

BisonCheckboxValue _toggle(BisonCheckboxValue current) {
  return switch (current) {
    BisonCheckboxValue.unselected => BisonCheckboxValue.selected,
    BisonCheckboxValue.selected => BisonCheckboxValue.unselected,
    _ => BisonCheckboxValue.selected,
  };
}
