import 'package:flutter/material.dart';
import 'package:bison_design_system/bison_design_system.dart';
import '../common.dart';

/// Builds a menu with the specified list of items.
///
/// This helper function creates a menu with the provided items.
Widget buildMenuWithItems(final List<BisonMenuItem> items) {
  return buildScaffold(
    BisonMenu(
      builder:
          (
            final context,
            final focusNode, {
            required final toggleMenu,
            required final isOpen,
          }) => FilledButton(
            focusNode: focusNode,
            onPressed: toggleMenu,
            child: const Text('Open Menu'),
          ),
      items: items,
    ),
  );
}

/// Builds a standard menu with N items.
///
/// This helper function creates N standard menu items and builds a menu
/// containing them.
Widget buildStandardMenu(final int itemCount) {
  final items = List.generate(
    itemCount,
    (final index) => BisonMenuItem(label: 'Item ${index + 1}', onSelect: () {}),
  );
  return buildMenuWithItems(items);
}
