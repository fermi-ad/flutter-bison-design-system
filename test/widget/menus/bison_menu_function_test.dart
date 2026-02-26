import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:bison_design_system/bison_design_system.dart';
import '../common.dart';
import './bison_menu_common.dart' show buildStandardMenu, buildMenuWithItems;

void main() {
  group('BisonMenu basic interactions', () {
    testWidgets('deferred trigger action works correctly', (
      final WidgetTester tester,
    ) async {
      final menu = buildStandardMenu(2);

      await tester.pumpWidget(buildScaffold(menu));

      // Tap the anchor (deferred trigger action).
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('primary trigger action works correctly', (
      final WidgetTester tester,
    ) async {
      final items = [
        const BisonMenuItem(label: 'Item 1'),
        const BisonMenuItem(label: 'Item 2'),
      ];

      await tester.pumpWidget(
        buildScaffold(
          BisonMenu(
            builder:
                (
                  final context,
                  final focusNode, {
                  required final isOpen,
                  required final toggleMenu,
                }) => Focus(focusNode: focusNode, child: Text('Primary Click')),
            items: items,
            triggerAction: BisonMenuTriggerAction.primary,
          ),
        ),
      );

      // Perform a primary (left) click on the anchor.
      await tester.tap(find.text('Primary Click'));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('secondary trigger action works correctly', (
      final WidgetTester tester,
    ) async {
      final items = [const BisonMenuItem(label: 'Right Item')];

      await tester.pumpWidget(
        buildScaffold(
          BisonMenu(
            builder:
                (
                  final context,
                  final focusNode, {
                  required final isOpen,
                  required final toggleMenu,
                }) => Focus(focusNode: focusNode, child: Text('Right Click')),
            items: items,
            triggerAction: BisonMenuTriggerAction.secondary,
          ),
        ),
      );

      // Perform a secondary tap (right‑click) on the anchor.
      await tester.tap(find.text('Right Click'), buttons: 2);
      await tester.pumpAndSettle();

      expect(find.text('Right Item'), findsOneWidget);
    });

    testWidgets('selecting a menu item triggers its callback', (
      final WidgetTester tester,
    ) async {
      bool callbackCalled = false;
      final items = [
        BisonMenuItem(
          label: 'Select Me',
          onSelect: () => callbackCalled = true,
        ),
      ];

      await tester.pumpWidget(buildMenuWithItems(items));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select Me'));
      await tester.pumpAndSettle();

      expect(callbackCalled, isTrue);
    });

    testWidgets('menu items with icons render the icon', (
      final WidgetTester tester,
    ) async {
      final items = [
        const BisonMenuItem(label: 'Icon Item', icon: Icon(Icons.add)),
      ];

      await tester.pumpWidget(
        buildScaffold(
          BisonMenu(
            builder:
                (
                  final context,
                  final focusNode, {
                  required final isOpen,
                  required final toggleMenu,
                }) => FilledButton(
                  focusNode: focusNode,
                  onPressed: toggleMenu,
                  child: const Text('Icon Test'),
                ),
            items: items,
          ),
        ),
      );

      await tester.tap(find.text('Icon Test'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('focus returns to anchor after menu is closed', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildStandardMenu(2));

      // Open the menu.
      final menuButton = find.text('Open Menu');
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Close the menu by tapping the anchor again (toggle behavior).
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // The anchor should have focus now.
      final focusNode = Focus.of(tester.element(menuButton));
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('menu becomes scrollable when many items are present', (
      final WidgetTester tester,
    ) async {
      // Create many items to exceed typical menu height.
      await tester.pumpWidget(buildStandardMenu(30));
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();
      // The menu should contain a Scrollable widget (e.g., ListView).
      expect(find.byType(Scrollable), findsOneWidget);
    });
  });

  group('keyboard navigation and shortcuts', () {
    testWidgets('arrow keys navigate menu items', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildStandardMenu(3));

      // Open the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Test Arrow Down: Move focus to next item
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      // Verify focus moves to Item 2
      final item2Finder = find.text('Item 2');
      expect(item2Finder, findsOneWidget);
      final item2Element = tester.element(item2Finder);
      final item2Focus = Focus.of(item2Element);
      expect(item2Focus.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      // Verify focus moves to Item 3
      final item3Finder = find.text('Item 3');
      expect(item3Finder, findsOneWidget);
      final item3Element = tester.element(item3Finder);
      final item3Focus = Focus.of(item3Element);
      expect(item3Focus.hasFocus, isTrue);

      // Test Arrow Up: Move focus to previous item
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
      // Verify focus moves to Item 2
      expect(item2Finder, findsOneWidget);
      final item2Element2 = tester.element(item2Finder);
      final item2Focus2 = Focus.of(item2Element2);
      expect(item2Focus2.hasFocus, isTrue);
    });

    testWidgets('home/end keys navigate to first/last items', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildStandardMenu(3));

      // Open the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Test End: Focus last item
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      // Verify focus moves to Item 3
      final item3Finder = find.text('Item 3');
      expect(item3Finder, findsOneWidget);
      final item3Element = tester.element(item3Finder);
      final item3Focus = Focus.of(item3Element);
      expect(item3Focus.hasFocus, isTrue);

      // Test Home: Focus first item
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      // Verify focus moves to Item 1
      final item1Finder = find.text('Item 1');
      expect(item1Finder, findsOneWidget);
      final item1Element = tester.element(item1Finder);
      final item1Focus = Focus.of(item1Element);
      expect(item1Focus.hasFocus, isTrue);
    });

    testWidgets('enter/space keys activate menu items', (
      final WidgetTester tester,
    ) async {
      int callback1Called = 0;
      int callback2Called = 0;
      final items = [
        BisonMenuItem(label: 'Item 1', onSelect: () => callback1Called += 1),
        BisonMenuItem(label: 'Item 2', onSelect: () => callback2Called += 1),
      ];

      await tester.pumpWidget(buildMenuWithItems(items));

      // Open the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Test Enter: Activate first item (Item 1)
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      // Verify the first callback was called and the second wasn't
      expect(callback1Called, equals(1));
      expect(callback2Called, isZero);
      // Verify the menu is closed after activation
      expect(find.text('Item 1'), findsNothing);

      // Reopen the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Test Enter: Activate first item (Item 1)
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      // Verify the first callback was called and the second wasn't
      expect(callback1Called, equals(2));
      expect(callback2Called, isZero);
    });

    testWidgets('escape/tab keys close menu', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildStandardMenu(2));

      // Open the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();
      // Verify menu is open
      expect(find.text('Item 1'), findsOneWidget);

      // Test Esc: Close menu & return focus
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      // Verify menu is closed
      expect(find.text('Item 1'), findsNothing);

      // Open the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();
      // Verify menu is open
      expect(find.text('Item 1'), findsOneWidget);

      // Test Esc: Close menu & return focus
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      // Verify menu is closed
      expect(find.text('Item 1'), findsNothing);
    });
  });
}
