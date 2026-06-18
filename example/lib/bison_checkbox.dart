import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonCheckbox, BisonCheckboxValue;

@widgetbook.UseCase(name: 'Default', type: BisonCheckbox)
Widget buildBisonCheckboxUseCase(BuildContext context) {
  return BisonCheckbox(
    value: context.knobs.object.dropdown(
      label: 'Value',
      labelBuilder: (value) => value.name,
      options: BisonCheckboxValue.values,
    ),
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    onChanged: (_) {},
  );
}

@widgetbook.UseCase(name: 'All States', type: BisonCheckbox)
Widget buildBisonCheckboxAllStatesUseCase(BuildContext context) {
  return Wrap(
    spacing: 16,
    runSpacing: 16,
    children: [
      ...BisonCheckboxValue.values.map(
        (final value) => BisonCheckbox(value: value, onChanged: (_) {}),
      ),
      ...BisonCheckboxValue.values.map(
        (final value) => BisonCheckbox(value: value, enabled: false),
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'Interactive', type: BisonCheckbox)
Widget buildBisonCheckboxInteractiveUseCase(BuildContext context) {
  return _InteractiveBisonCheckboxExample();
}

class _InteractiveBisonCheckboxExample extends StatefulWidget {
  const _InteractiveBisonCheckboxExample();

  @override
  State<_InteractiveBisonCheckboxExample> createState() =>
      _InteractiveBisonCheckboxExampleState();
}

class _InteractiveBisonCheckboxExampleState
    extends State<_InteractiveBisonCheckboxExample> {
  BisonCheckboxValue _value = BisonCheckboxValue.unselected;

  BisonCheckboxValue _nextValue(BisonCheckboxValue value) {
    switch (value) {
      case BisonCheckboxValue.unselected:
        return BisonCheckboxValue.selected;
      case BisonCheckboxValue.selected:
        return BisonCheckboxValue.indeterminate;
      case BisonCheckboxValue.indeterminate:
        return BisonCheckboxValue.unselected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

    return BisonCheckbox(
      value: _value,
      enabled: enabled,
      onChanged: enabled
          ? (newValue) {
              setState(() {
                _value = _nextValue(_value);
              });
            }
          : null,
    );
  }
}
