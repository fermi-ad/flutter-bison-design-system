import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonCheckbox, BisonCheckboxValue;

@widgetbook.UseCase(name: 'Default', type: BisonCheckbox)
Widget buildBisonCheckboxUseCase(BuildContext context) {
  final isInteractive = context.knobs.boolean(
    label: 'Interactive',
    initialValue: true,
  );

  return BisonCheckbox(
    value: context.knobs.object.dropdown(
      label: 'Value',
      labelBuilder: (value) => value.name,
      options: BisonCheckboxValue.values,
    ),
    onChanged: isInteractive ? (_) {} : null,
  );
}

@widgetbook.UseCase(name: 'All States', type: BisonCheckbox)
Widget buildBisonCheckboxAllStatesUseCase(BuildContext context) {
  return Wrap(
    spacing: 16,
    runSpacing: 16,
    children: [
      ...BisonCheckboxValue.values.map(
        (value) => BisonCheckbox(value: value, onChanged: (_) {}),
      ),
      ...BisonCheckboxValue.values.map(
        (value) => BisonCheckbox(value: value, onChanged: null),
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'Interactive', type: BisonCheckbox)
Widget buildBisonCheckboxInteractiveUseCase(BuildContext context) {
  final isInteractive = context.knobs.boolean(
    label: 'Interactive',
    initialValue: true,
  );
  return ValueListenableBuilder<BisonCheckboxValue>(
    valueListenable: _interactiveCheckboxValue,
    builder: (context, value, _) {
      return BisonCheckbox(
        value: value,
        onChanged: isInteractive
            ? (_) {
                _interactiveCheckboxValue.value = _nextInteractiveCheckboxValue(
                  value,
                );
              }
            : null,
      );
    },
  );
}

final ValueNotifier<BisonCheckboxValue> _interactiveCheckboxValue =
    ValueNotifier(BisonCheckboxValue.unselected);

BisonCheckboxValue _nextInteractiveCheckboxValue(BisonCheckboxValue value) {
  switch (value) {
    case BisonCheckboxValue.unselected:
      return BisonCheckboxValue.selected;
    case BisonCheckboxValue.selected:
      return BisonCheckboxValue.indeterminate;
    case BisonCheckboxValue.indeterminate:
      return BisonCheckboxValue.unselected;
  }
}
