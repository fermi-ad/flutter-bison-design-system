import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/src/core_widgets/menus/bison_menu.dart';

@widgetbook.UseCase(name: 'Default', type: BisonMenu)
Widget buildBisonMenuUseCase(BuildContext context) {
  final menuItems = [
    BisonMenuItem(label: 'Save', onSelect: () => debugPrint('Save selected')),
    BisonMenuItem(
      label: 'Settings',
      icon: Icon(Icons.settings),
      onSelect: () => debugPrint('Settings selected'),
    ),
    BisonMenuItem(
      label: 'Help',
      icon: Icon(Icons.help),
      onSelect: () => debugPrint('Help selected'),
    ),
    BisonMenuItem(
      label: 'Delete',
      icon: Icon(Icons.delete),
      enabled: false,
      onSelect: () => debugPrint('Delete selected'),
    ),
  ];

  return BisonMenu(
    menuLabel: context.knobs.string(
      label: 'Menu Label',
      initialValue: 'Actions',
    ),
    items: menuItems,
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
  );
}
