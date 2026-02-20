import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonMenu, BisonMenuItem;

@widgetbook.UseCase(name: 'Default', type: BisonMenu)
Widget buildBisonMenuUseCase(BuildContext context) {
  return BisonMenu(
    menuLabel: context.knobs.string(label: 'Menu Label', initialValue: 'Menu'),
    anchor: Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(child: Text('Menu Button')),
    ),
    items: [
      BisonMenuItem(
        label: context.knobs.string(
          label: 'Item 1 Label',
          initialValue: 'Item 1',
        ),
        icon: context.knobs.objectOrNull.dropdown(
          label: 'Item 1 Icon',
          labelBuilder: (icon) => switch (icon.icon) {
            Icons.add => "Add",
            Icons.save => "Save",
            Icons.delete => "Delete",
            _ => '',
          },
          options: [Icon(Icons.add), Icon(Icons.save), Icon(Icons.delete)],
        ),
        onSelect: () => debugPrint("Item 1 selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(
          label: 'Item 2 Label',
          initialValue: 'Item 2',
        ),
        icon: context.knobs.objectOrNull.dropdown(
          label: 'Item 2 Icon',
          labelBuilder: (icon) => switch (icon.icon) {
            Icons.add => "Add",
            Icons.save => "Save",
            Icons.delete => "Delete",
            _ => '',
          },
          options: [Icon(Icons.add), Icon(Icons.save), Icon(Icons.delete)],
        ),
        onSelect: () => debugPrint("Item 2 selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(
          label: 'Item 3 Label',
          initialValue: 'Disabled Item',
        ),
        icon: context.knobs.objectOrNull.dropdown(
          label: 'Item 3 Icon',
          labelBuilder: (icon) => switch (icon.icon) {
            Icons.add => "Add",
            Icons.save => "Save",
            Icons.delete => "Delete",
            _ => '',
          },
          options: [Icon(Icons.add), Icon(Icons.save), Icon(Icons.delete)],
        ),
        // No onSelect callback makes this menu item disabled
      ),
    ],
  );
}
