import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonMenu, BisonMenuItem, BisonMenuTriggerAction;

@widgetbook.UseCase(name: 'Default', type: BisonMenu)
Widget buildBisonMenuUseCase(BuildContext context) {
  return BisonMenu(
    menuLabel: context.knobs.string(label: 'Menu Label', initialValue: 'Menu'),
    anchorWidget: Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(child: Text('Open Menu')),
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

@widgetbook.UseCase(name: 'Right Click Context Menu', type: BisonMenu)
Widget buildRightClickContextMenuUseCase(BuildContext context) {
  return BisonMenu(
    menuLabel: context.knobs.string(
      label: 'Menu Label',
      initialValue: 'Context Menu',
    ),
    anchorWidget: Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('Right-click to open menu')],
      ),
    ),
    triggerAction: BisonMenuTriggerAction.secondary,
    items: [
      BisonMenuItem(
        label: context.knobs.string(label: 'Copy', initialValue: 'Copy'),
        icon: const Icon(Icons.copy),
        onSelect: () => debugPrint("Copy selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(label: 'Paste', initialValue: 'Paste'),
        icon: const Icon(Icons.paste),
        onSelect: () => debugPrint("Paste selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(label: 'Cut', initialValue: 'Cut'),
        icon: const Icon(Icons.cut),
        onSelect: () => debugPrint("Cut selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(label: 'Delete', initialValue: 'Delete'),
        icon: const Icon(Icons.delete),
        onSelect: () => debugPrint("Delete selected"),
      ),
    ],
  );
}
