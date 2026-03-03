import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart';
import '../common.dart'
    show buildScaffold, getButtonStyle, getMenuItemButtonStyle, getMenuStyle;

void main() {
  group('BisonThemeData Widget Styling Tests', () {
    testWidgets('FilledButton uses theme styling from BisonThemeData', (
      final WidgetTester tester,
    ) async {
      final themeTokens = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          FilledButton(onPressed: () {}, child: const Text('Test Button')),
        ),
      );

      final element = tester.element(find.byType(FilledButton));
      final filledButton = element.widget as FilledButton;

      // Get the resolved style from the theme
      final mergedStyle = getButtonStyle(element, filledButton);

      // Test background color (should use buttonPrimary from theme)
      final backgroundColor = mergedStyle.backgroundColor?.resolve(
        <WidgetState>{},
      );
      expect(backgroundColor, equals(themeTokens.buttonPrimary));

      // Test foreground color (should use textInverse from theme)
      final foregroundColor = mergedStyle.foregroundColor?.resolve(
        <WidgetState>{},
      );
      expect(foregroundColor, equals(themeTokens.textInverse));
    });

    testWidgets('MenuAnchor uses theme styling from BisonThemeData', (
      final WidgetTester tester,
    ) async {
      final themeTokens = BisonThemeTokens.light();
      final spacingTokens = BisonSpacingTokens.standard();
      final cornerTokens = BisonCornerTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          MenuAnchor(
            menuChildren: [
              MenuItemButton(onPressed: () {}, child: const Text('Item 1')),
            ],
            builder: (final context, final controller, final child) {
              return TextButton(
                onPressed: () => controller.open(),
                child: const Text('Open Menu'),
              );
            },
          ),
        ),
      );

      // Open the menu to access styling
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final element = tester.element(find.byType(MenuAnchor));
      final menuAnchorWidget = element.widget as MenuAnchor;

      // Use helper function to get merged style
      final style = getMenuStyle(element, menuAnchorWidget);

      // Test background color (should use surfaceDefault from theme)
      final backgroundColor = style.backgroundColor?.resolve(<WidgetState>{});
      expect(backgroundColor, equals(themeTokens.surfaceDefault));

      // Test border radius (should use cornerExtraSmall from theme)
      final shape =
          style.shape?.resolve(<WidgetState>{}) as RoundedRectangleBorder;
      final borderRadius = shape.borderRadius;
      final radius = (borderRadius as BorderRadius).topLeft;
      expect(radius.x, equals(cornerTokens.cornerExtraSmall));

      // Test vertical padding (should use tinySpacing * 2 from theme)
      final padding = style.padding?.resolve(<WidgetState>{});
      expect(padding?.vertical, equals(spacingTokens.tinySpacing * 2));
    });

    testWidgets('MenuItemButton uses theme styling from BisonThemeData', (
      final WidgetTester tester,
    ) async {
      final themeTokens = BisonThemeTokens.light();
      final spacingTokens = BisonSpacingTokens.standard();
      final typographyTokens = BisonTypographyTokens.fromTokens(themeTokens);

      await tester.pumpWidget(
        buildScaffold(
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {},
                leadingIcon: Icon(Icons.add),
                child: const Text('Item 1'),
              ),
            ],
            builder: (final context, final controller, final child) {
              return TextButton(
                onPressed: () => controller.open(),
                child: const Text('Open Menu'),
              );
            },
          ),
        ),
      );

      // Open the menu to access styling
      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final element = tester.element(find.byType(MenuItemButton).first);
      final menuItemWidget = element.widget as MenuItemButton;

      // Get the resolved style from the theme using helper function
      final style = getMenuItemButtonStyle(element, menuItemWidget);

      // Test background color (should be transparent in default state)
      final backgroundColor = style.backgroundColor?.resolve(<WidgetState>{});
      expect(backgroundColor?.a, isZero);

      // Test foreground color (should use textPlain from theme)
      final foregroundColor = style.foregroundColor?.resolve(<WidgetState>{});
      expect(foregroundColor, equals(themeTokens.textPlain));

      // Test icon color (should use iconPlain from theme)
      final iconColor = style.iconColor?.resolve(<WidgetState>{});
      expect(iconColor, equals(themeTokens.iconPlain));

      // Test text style (should use bodyLarge from typography tokens)
      final textStyle = style.textStyle?.resolve(<WidgetState>{});
      expect(textStyle, equals(typographyTokens.bodyLarge));

      // Test padding (should use xSmallSpacing * 2 horizontal and tinySpacing * 2 vertical)
      final padding = style.padding?.resolve(<WidgetState>{});
      expect(padding?.horizontal, equals(spacingTokens.xSmallSpacing * 2));
      expect(padding?.vertical, equals(spacingTokens.tinySpacing * 2));
    });
  });
}
