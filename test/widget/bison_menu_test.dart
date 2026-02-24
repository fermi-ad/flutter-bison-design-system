import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart';

/// Helper to build a minimal app with the given widget as the body.
Widget _buildTestApp(final Widget widget) {
  return MaterialApp(
    theme: ThemeData(
      extensions: [
        BisonThemeTokens.light(),
        BisonSpacingTokens.standard(),
        BisonCornerTokens.standard(),
        BisonTypographyTokens.fromTokens(BisonThemeTokens.light()),
      ],
    ),
    home: Scaffold(body: Center(child: widget)),
  );
}

void main() {
  group('BisonMenu basic interactions', () {
    testWidgets('left-click opens menu and displays items', (
      final WidgetTester tester,
    ) async {
      final items = [
        const BisonMenuItem(label: 'Item 1'),
        const BisonMenuItem(label: 'Item 2'),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Open Menu'),
            items: items,
            menuLabel: 'Test Menu',
          ),
        ),
      );

      // Tap the anchor (primary click).
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Verify that menu items are now in the widget tree.
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
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

      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Open'),
            items: items,
            menuLabel: 'Menu',
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select Me'));
      await tester.pumpAndSettle();

      expect(callbackCalled, isTrue);
    });

    testWidgets('right-click (secondary tap) opens menu', (
      final WidgetTester tester,
    ) async {
      final items = [const BisonMenuItem(label: 'Right Item')];

      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Right Click'),
            items: items,
            menuLabel: 'Menu',
            triggerAction: BisonMenuTriggerAction.secondary,
          ),
        ),
      );

      // Perform a secondary tap (right‑click) on the anchor.
      await tester.tap(find.text('Right Click'), buttons: 2);
      await tester.pumpAndSettle();

      expect(find.text('Right Item'), findsOneWidget);
    });

    testWidgets('menu items with icons render the icon', (
      final WidgetTester tester,
    ) async {
      final items = [
        const BisonMenuItem(label: 'Icon Item', icon: Icon(Icons.add)),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Icon Test'),
            items: items,
            menuLabel: 'Menu',
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
      final items = [const BisonMenuItem(label: 'Item')];

      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Focus Anchor'),
            items: items,
            menuLabel: 'Menu',
          ),
        ),
      );

      // Open the menu.
      await tester.tap(find.text('Focus Anchor'));
      await tester.pumpAndSettle();

      // Close the menu by tapping the anchor again (toggle behavior).
      await tester.tap(find.text('Focus Anchor'));
      await tester.pumpAndSettle();

      // The anchor should have focus now.
      final focusNode = Focus.of(tester.element(find.text('Focus Anchor')));
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('menu becomes scrollable when many items are present', (
      final WidgetTester tester,
    ) async {
      // Create many items to exceed typical menu height.
      final items = List.generate(
        30,
        (final i) => BisonMenuItem(label: 'Item $i'),
      );
      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Scroll Test'),
            items: items,
            menuLabel: 'Menu',
          ),
        ),
      );
      await tester.tap(find.text('Scroll Test'));
      await tester.pumpAndSettle();
      // The menu should contain a Scrollable widget (e.g., ListView).
      expect(find.byType(Scrollable), findsOneWidget);
    });

    /// Tests that disabled menu items are displayed correctly.
    ///
    /// This test verifies:
    /// 1. Disabled menu items are displayed in the UI
    /// 2. Disabled menu items are stylistically distinguished
    testWidgets('disabled menu items are displayed correctly', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      final items = [
        BisonMenuItem(label: 'Enabled Item', onSelect: () => {}),
        BisonMenuItem(label: 'Disabled Item', icon: Icon(Icons.info)),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          BisonMenu(
            anchorWidget: const Text('Open Menu'),
            items: items,
            menuLabel: 'Test Menu',
          ),
        ),
      );

      // Tap the anchor to open the menu
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Verify both items are displayed
      expect(find.text('Enabled Item'), findsOneWidget);
      expect(find.text('Disabled Item'), findsOneWidget);

      // Verify that disabled item is visually distinguishable as disabled
      // by checking that it has the disabled styling
      final disabledItemFinder = find.text('Disabled Item');
      expect(disabledItemFinder, findsOneWidget);

      // Find the MenuItemButton widget for the disabled item
      final menuItemButtonFinder = find.ancestor(
        of: disabledItemFinder,
        matching: find.byType(MenuItemButton),
      );
      expect(menuItemButtonFinder, findsOneWidget);

      // Get the widget and verify its disabled styling
      final menuItemButton = tester.widget<MenuItemButton>(
        menuItemButtonFinder,
      );
      final style = menuItemButton.style!;

      // Check that the foreground color is set to the disabled color
      final disabledForegroundColor = style.foregroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );
      expect(disabledForegroundColor, equals(theme.textDisabled));

      // Also check that the icon color is set to the disabled color
      final disabledIconColor = style.iconColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      expect(disabledIconColor, equals(theme.iconDisabled));
    });
  });

  // ---------------------------------------------------------------------------
  // The following tests are placeholders for features that are not yet
  // implemented in BisonMenu. They are included to guide future TDD work.
  // ---------------------------------------------------------------------------
  group('BisonMenu advanced features (TODO)', () {
    testWidgets('keyboard navigation and shortcuts work', (
      final WidgetTester tester,
    ) async {
      // TODO: Verify that arrow keys navigate items and Enter activates the
      // selected item.
    });

    testWidgets('appropriate ARIA roles are set via Semantics', (
      final WidgetTester tester,
    ) async {
      // TODO: Use SemanticsTester to verify role = "menu" and "menuitem".
    });
  });
}
