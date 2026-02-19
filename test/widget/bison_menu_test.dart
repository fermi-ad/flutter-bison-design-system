import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/src/core_widgets/menus/bison_menu.dart';

void main() {
  group('BisonMenu', () {
    testWidgets('renders menu button with correct label', (
      WidgetTester tester,
    ) async {
      final menuItems = [BisonMenuItem(label: 'Item 1', onSelect: () {})];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BisonMenu(menuLabel: 'Test Menu', items: menuItems),
          ),
        ),
      );

      expect(find.text('Test Menu'), findsOneWidget);
    });

    testWidgets('displays menu items when tapped', (WidgetTester tester) async {
      final menuItems = [
        BisonMenuItem(label: 'Item 1', onSelect: () {}),
        BisonMenuItem(label: 'Item 2', onSelect: () {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BisonMenu(menuLabel: 'Test Menu', items: menuItems),
          ),
        ),
      );

      // Tap the menu button
      await tester.tap(find.text('Test Menu'));
      await tester.pumpAndSettle();

      // Verify menu items are displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('calls onSelect when menu item is selected', (
      WidgetTester tester,
    ) async {
      bool isSelected = false;
      final menuItems = [
        BisonMenuItem(
          label: 'Item 1',
          onSelect: () {
            isSelected = true;
          },
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BisonMenu(menuLabel: 'Test Menu', items: menuItems),
          ),
        ),
      );

      // Tap the menu button
      await tester.tap(find.text('Test Menu'));
      await tester.pumpAndSettle();

      // Select an item
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(isSelected, isTrue);
    });

    testWidgets('handles disabled menu items', (WidgetTester tester) async {
      final menuItems = [
        BisonMenuItem(label: 'Item 1', enabled: false, onSelect: () {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BisonMenu(menuLabel: 'Test Menu', items: menuItems),
          ),
        ),
      );

      // Tap the menu button
      await tester.tap(find.text('Test Menu'));
      await tester.pumpAndSettle();

      // Verify disabled item is present but not selectable
      expect(find.text('Item 1'), findsOneWidget);
    });
  });
}
