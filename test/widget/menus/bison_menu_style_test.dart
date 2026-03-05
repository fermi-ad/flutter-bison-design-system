import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonThemeTokens,
        BisonSpacingTokens,
        BisonCornerTokens,
        BisonTypographyTokens,
        BisonMenuItem;
import 'bison_menu_common.dart' show buildMenuWithItems, buildStandardMenu;

void main() {
  group('BisonMenu Container Styling Tests', () {
    testWidgets('Menu container background color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuAnchor = find.byType(MenuAnchor);
      final menuAnchorWidget = tester.widget<MenuAnchor>(menuAnchor);
      final style = menuAnchorWidget.style!;

      final backgroundColor = style.backgroundColor?.resolve(<WidgetState>{});
      expect(backgroundColor, equals(theme.surfaceDefault));
    });

    testWidgets('Menu container border radius is correct', (
      final WidgetTester tester,
    ) async {
      final corners = BisonCornerTokens.standard();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuAnchor = find.byType(MenuAnchor);
      final menuAnchorWidget = tester.widget<MenuAnchor>(menuAnchor);
      final style = menuAnchorWidget.style!;

      final shape =
          style.shape?.resolve(<WidgetState>{}) as RoundedRectangleBorder;
      final borderRadius = shape.borderRadius;
      final radius = (borderRadius as BorderRadius).topLeft;

      expect(radius.x, equals(corners.cornerExtraSmall));
    });

    testWidgets('Menu container vertical padding is correct', (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuAnchor = find.byType(MenuAnchor);
      final menuAnchorWidget = tester.widget<MenuAnchor>(menuAnchor);
      final style = menuAnchorWidget.style!;

      final padding = style.padding?.resolve(<WidgetState>{});

      expect(padding?.vertical, equals(spacing.tinySpacing * 2));
    });
  });

  group('BisonMenu Menu Item Styling Tests - Default State', () {
    testWidgets('Default background color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final backgroundColor = style.backgroundColor?.resolve(<WidgetState>{});
      expect(backgroundColor, equals(theme.surfaceTransparent));
    });

    testWidgets('Default foreground color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final foregroundColor = style.foregroundColor?.resolve(<WidgetState>{});
      expect(foregroundColor, equals(theme.textPlain));
    });

    testWidgets('Default icon color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final iconColor = style.iconColor?.resolve(<WidgetState>{});
      expect(iconColor, equals(theme.iconPlain));
    });

    testWidgets('Default text styling is correct', (
      final WidgetTester tester,
    ) async {
      final typo = BisonTypographyTokens.fromTokens(BisonThemeTokens.light());

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final textStyle = style.textStyle?.resolve(<WidgetState>{});
      expect(textStyle, equals(typo.bodyLarge));
    });

    testWidgets('Default padding is correct', (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final padding = style.padding?.resolve(<WidgetState>{});

      expect(padding?.horizontal, equals(spacing.xSmallSpacing * 2));
      expect(padding?.vertical, equals(spacing.tinySpacing * 2));
    });
  });

  group('BisonMenu Menu Item Styling Tests - Interactive States', () {
    testWidgets('Hover background color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final backgroundColor = style.overlayColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      expect(backgroundColor, equals(theme.surfaceHovered));
    });

    testWidgets('Focus background color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final backgroundColor = style.overlayColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      expect(backgroundColor, equals(theme.surfaceHovered));
    });

    testWidgets('Selected background color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final backgroundColor = style.overlayColor?.resolve(<WidgetState>{
        WidgetState.selected,
      });
      expect(backgroundColor, equals(theme.navigationSelectedActive));
    });
  });

  group('BisonMenu Menu Item Styling Tests - Disabled State', () {
    testWidgets('Disabled background color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildMenuWithItems([
          const BisonMenuItem(label: 'Item 1', onSelect: null),
        ]),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton);
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final backgroundColor = style.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      expect(backgroundColor, equals(theme.surfaceTransparent));
    });

    testWidgets('Disabled foreground color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildMenuWithItems([
          const BisonMenuItem(label: 'Item 1', onSelect: null),
        ]),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton);
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final foregroundColor = style.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      expect(foregroundColor, equals(theme.textDisabled));
    });

    testWidgets('Disabled icon color is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildMenuWithItems([
          const BisonMenuItem(
            label: 'Item 1',
            icon: Icon(Icons.add),
            onSelect: null,
          ),
        ]),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton);
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final iconColor = style.iconColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      expect(iconColor, equals(theme.iconDisabled));
    });
  });

  group('BisonMenu Icon Support Tests', () {
    testWidgets('Icon color in default state is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildMenuWithItems([
          BisonMenuItem(
            label: 'Item 1',
            onSelect: () {},
            icon: Icon(Icons.add),
          ),
        ]),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton);
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final iconColor = style.iconColor?.resolve(<WidgetState>{});
      expect(iconColor, equals(theme.iconPlain));
    });

    testWidgets('Icon color in disabled state is correct', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildMenuWithItems([
          const BisonMenuItem(
            label: 'Item 1',
            icon: Icon(Icons.add),
            onSelect: null,
          ),
        ]),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton);
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final iconColor = style.iconColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      expect(iconColor, equals(theme.iconDisabled));
    });
  });

  group('BisonMenu Menu Item Spacing Tests', () {
    testWidgets('Horizontal padding is correct', (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final padding = style.padding?.resolve(<WidgetState>{});

      expect(padding?.horizontal, equals(spacing.xSmallSpacing * 2));
    });

    testWidgets('Vertical padding is correct', (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final padding = style.padding?.resolve(<WidgetState>{});

      expect(padding?.vertical, equals(spacing.tinySpacing * 2));
    });
  });

  group('BisonMenu Typography Tests', () {
    testWidgets('Text style is correct', (final WidgetTester tester) async {
      final typo = BisonTypographyTokens.fromTokens(BisonThemeTokens.light());

      await tester.pumpWidget(buildStandardMenu(3));

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      final menuItemButton = find.byType(MenuItemButton).first;
      final menuItemWidget = tester.widget<MenuItemButton>(menuItemButton);
      final style = menuItemWidget.style!;

      final textStyle = style.textStyle?.resolve(<WidgetState>{});
      expect(textStyle, equals(typo.bodyLarge));
    });
  });
}
