import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart';

void main() {
  group('BisonThemeData', () {
    test('creates ThemeData with correct color scheme mappings', () {
      final theme = BisonThemeData.light();
      final colorScheme = theme.colorScheme;
      final themeTokens = BisonThemeTokens.light();

      // Sentinel mappings (spot checks) - high-impact roles
      expect(colorScheme.primary, equals(themeTokens.buttonPrimary));
      expect(colorScheme.onPrimary, equals(themeTokens.textInverse));
      expect(colorScheme.secondary, equals(themeTokens.borderSecondary));
      expect(colorScheme.surface, equals(themeTokens.surfaceDefault));
      expect(colorScheme.outline, equals(themeTokens.borderPlain));
      // Tertiary mirrors borderPrimary
      expect(colorScheme.tertiary, equals(themeTokens.borderPrimary));
    });

    test('creates ThemeData with correct text theme grouping', () {
      final theme = BisonThemeData.light();
      final textTheme = theme.textTheme;
      final typo = BisonTypographyTokens.fromTokens(BisonThemeTokens.light());

      expect(textTheme.displayLarge?.fontSize, equals(typo.h1.fontSize));
      expect(textTheme.headlineLarge?.fontSize, equals(typo.h2.fontSize));
      expect(textTheme.titleLarge?.fontSize, equals(typo.h3.fontSize));
      expect(textTheme.bodyLarge?.fontSize, equals(typo.bodyLarge.fontSize));
      expect(
        textTheme.labelLarge?.fontSize,
        equals(typo.capitalizedLabel.fontSize),
      );
    });

    test('creates ThemeData with correct component styles', () {
      final theme = BisonThemeData.light();

      // Button background resolves to buttonPrimary
      final buttonStyle = theme.filledButtonTheme.style;
      expect(buttonStyle, isNotNull);
      expect(buttonStyle?.backgroundColor, isNotNull);
      if (buttonStyle?.backgroundColor != null) {
        final backgroundColor = buttonStyle!.backgroundColor!.resolve({});
        expect(backgroundColor, equals(BisonThemeTokens.light().buttonPrimary));
      }

      // Button foreground resolves to textInverse
      expect(buttonStyle?.foregroundColor, isNotNull);
      if (buttonStyle?.foregroundColor != null) {
        final foregroundColor = buttonStyle!.foregroundColor!.resolve({});
        expect(foregroundColor, equals(BisonThemeTokens.light().textInverse));
      }

      // Menu style exists and resolves expected base colors
      expect(theme.menuTheme.style, isNotNull);
      expect(theme.menuTheme.style?.backgroundColor, isNotNull);
    });

    test('creates ThemeData with correct behavioral invariants', () {
      final theme = BisonThemeData.light();
      final colorScheme = theme.colorScheme;

      expect(colorScheme.primary, isNotNull);
      expect(colorScheme.onPrimary, isNotNull);

      // surfaceDim is different than surface
      expect(colorScheme.surface, isNotNull);
      expect(colorScheme.surfaceDim, isNotNull);
      expect(colorScheme.surfaceDim, isNot(equals(colorScheme.surface)));

      // surfaceBright is different than
      expect(colorScheme.surfaceBright, isNotNull);
      expect(colorScheme.surfaceBright, isNot(equals(colorScheme.surface)));

      // inverseSurface differs meaningfully from surface
      expect(colorScheme.inverseSurface, isNotNull);
      expect(colorScheme.inverseSurface, isNot(equals(colorScheme.surface)));
    });
  });
}
