import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonMenu, BisonMenuItem, BisonMenuTriggerAction;

@widgetbook.UseCase(name: 'Default', type: BisonMenu)
Widget buildBisonMenuUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 130,
      height: 32,
      child: BisonMenu(
        builder: (_, final focusNode, {required toggleMenu, required isOpen}) {
          return FilledButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
            focusNode: focusNode,
            onPressed: toggleMenu,
            child: Center(child: Text(isOpen ? "Close Menu" : "Open Menu")),
          );
        },
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
            onSelect: null,
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
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Right Click (Context Menu)', type: BisonMenu)
Widget buildRightClickContextMenuUseCase(BuildContext context) {
  return BisonMenu(
    builder: (_, final focusNode, {required toggleMenu, required isOpen}) {
      return Focus(
        focusNode: focusNode,
        child: Container(
          width: 250,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('Right-click to open context menu')],
          ),
        ),
      );
    },
    triggerAction: BisonMenuTriggerAction.secondary,
    items: [
      BisonMenuItem(
        label: context.knobs.string(
          label: 'Item 1 Label',
          initialValue: 'Copy',
        ),
        icon: const Icon(Icons.copy),
        onSelect: () => debugPrint("Item 1 selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(
          label: 'Item 2 Label',
          initialValue: 'Paste',
        ),
        icon: const Icon(Icons.paste),
        onSelect: () => debugPrint("Item 2 selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(label: 'Item 3 Label', initialValue: 'Cut'),
        icon: const Icon(Icons.cut),
        onSelect: () => debugPrint("Item 3 selected"),
      ),
      BisonMenuItem(
        label: context.knobs.string(
          label: 'Item 4 Label',
          initialValue: 'Delete',
        ),
        icon: const Icon(Icons.delete),
        onSelect: () => debugPrint("Item 4 selected"),
      ),
    ],
  );
}
