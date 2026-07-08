import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonRadioButton, BisonRadioGroup, BisonRadioGroupItem;

@widgetbook.UseCase(name: 'Default', type: BisonRadioButton)
Widget buildBisonRadioButtonUseCase(BuildContext context) {
  final selected = context.knobs.boolean(label: 'Selected');
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return BisonRadioButton(
    selected: selected,
    onChanged: isEnabled ? (_) {} : null,
  );
}

@widgetbook.UseCase(name: 'All States', type: BisonRadioButton)
Widget buildBisonRadioButtonAllStatesUseCase(BuildContext context) {
  return Wrap(
    spacing: 16,
    runSpacing: 16,
    children: [
      BisonRadioButton(selected: true, onChanged: (_) {}),
      BisonRadioButton(selected: false, onChanged: (_) {}),
      const BisonRadioButton(selected: true, onChanged: null),
      const BisonRadioButton(selected: false, onChanged: null),
    ],
  );
}

@widgetbook.UseCase(name: 'Interactive Group', type: BisonRadioGroup)
Widget buildBisonRadioButtonInteractiveUseCase(BuildContext context) {
  return ValueListenableBuilder<int>(
    valueListenable: _selectedIndex,
    builder: (context, selectedIndex, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BisonRadioGroup(
            selectedIndex: selectedIndex,
            items: _labels
                .map((label) => BisonRadioGroupItem(label: label))
                .toList(),
            onChanged: (index) {
              _selectedIndex.value = index;
            },
          ),
        ],
      );
    },
  );
}

final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
const List<String> _labels = ['Alpha', 'Beta', 'Gamma'];
