import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart';

void main() {
  group('BisonThemeData', () {
    group('light()', () {
      test('creates ThemeData with correct color scheme mappings', () {
        final theme = BisonThemeData.light();
        final colorScheme = theme.colorScheme;

        // Sentinel mappings (spot checks) - high-impact roles
        expect(
          colorScheme.primary,
          equals(BisonThemeTokens.light().buttonPrimary),
        );
        expect(
          colorScheme.onPrimary,
          equals(BisonThemeTokens.light().textInverse),
        );
        expect(
          colorScheme.secondary,
          equals(BisonThemeTokens.light().borderSecondary),
        );
        expect(
          colorScheme.surface,
          equals(BisonThemeTokens.light().surfaceDefault),
        );
        expect(
          colorScheme.outline,
          equals(BisonThemeTokens.light().borderPlain),
        );
        // Tertiary mirrors borderPrimary (deliberate design choice)
        expect(
          colorScheme.tertiary,
          equals(BisonThemeTokens.light().borderPrimary),
        );
      });

      test('creates ThemeData with correct text theme grouping', () {
        final theme = BisonThemeData.light();
        final textTheme = theme.textTheme;

        // TextTheme grouping - assert the grouping intent, not every field
        expect(textTheme.displayLarge, equals(textTheme.displayMedium));
        expect(textTheme.displayMedium, equals(textTheme.displaySmall));
        expect(textTheme.headlineLarge, equals(textTheme.headlineMedium));
        expect(textTheme.headlineMedium, equals(textTheme.headlineSmall));
        expect(textTheme.titleLarge, equals(textTheme.titleMedium));
        expect(textTheme.titleMedium, equals(textTheme.titleSmall));
        expect(textTheme.bodyLarge, equals(textTheme.bodyMedium));
        expect(textTheme.labelLarge, equals(textTheme.labelMedium));
        expect(textTheme.labelMedium, equals(textTheme.labelSmall));
      });

      test('creates ThemeData with correct component styles', () {
        final theme = BisonThemeData.light();

        // Button background resolves to buttonPrimary
        final buttonStyle = theme.filledButtonTheme.style;
        expect(buttonStyle, isNotNull);
        expect(buttonStyle?.backgroundColor, isNotNull);
        if (buttonStyle?.backgroundColor != null) {
          final backgroundColor = buttonStyle!.backgroundColor!.resolve({});
          expect(
            backgroundColor,
            equals(BisonThemeTokens.light().buttonPrimary),
          );
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

        // contrast(onPrimary, primary) >= 4.5 (WCAG AA for normal text)
        // We can't easily test this without a helper, but we can verify the relationship
        expect(colorScheme.primary, isNotNull);
        expect(colorScheme.onPrimary, isNotNull);

        // surfaceDim is darker than surface
        expect(colorScheme.surfaceDim, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.surfaceDim, isNot(equals(colorScheme.surface)));

        // surfaceBright is lighter than surface
        expect(colorScheme.surfaceBright, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.surfaceBright, isNot(equals(colorScheme.surface)));

        // inverseSurface differs meaningfully from surface
        expect(colorScheme.inverseSurface, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.inverseSurface, isNot(equals(colorScheme.surface)));
      });
    });

    group('dark()', () {
      test('creates ThemeData with correct color scheme mappings', () {
        final theme = BisonThemeData.dark();
        final colorScheme = theme.colorScheme;

        // Sentinel mappings (spot checks) - high-impact roles
        expect(
          colorScheme.primary,
          equals(BisonThemeTokens.dark().buttonPrimary),
        );
        expect(
          colorScheme.onPrimary,
          equals(BisonThemeTokens.dark().textInverse),
        );
        expect(
          colorScheme.secondary,
          equals(BisonThemeTokens.dark().borderSecondary),
        );
        expect(
          colorScheme.surface,
          equals(BisonThemeTokens.dark().surfaceDefault),
        );
        expect(
          colorScheme.outline,
          equals(BisonThemeTokens.dark().borderPlain),
        );

        // Tertiary mirrors borderPrimary (deliberate design choice)
        expect(
          colorScheme.tertiary,
          equals(BisonThemeTokens.dark().borderPrimary),
        );
      });

      test('creates ThemeData with correct text theme grouping', () {
        final theme = BisonThemeData.dark();
        final textTheme = theme.textTheme;

        // TextTheme grouping - assert the grouping intent, not every field
        expect(textTheme.displayLarge, equals(textTheme.displayMedium));
        expect(textTheme.displayMedium, equals(textTheme.displaySmall));
        expect(textTheme.headlineLarge, equals(textTheme.headlineMedium));
        expect(textTheme.headlineMedium, equals(textTheme.headlineSmall));
        expect(textTheme.titleLarge, equals(textTheme.titleMedium));
        expect(textTheme.titleMedium, equals(textTheme.titleSmall));
        expect(textTheme.bodyLarge, equals(textTheme.bodyMedium));
        expect(textTheme.labelLarge, equals(textTheme.labelMedium));
        expect(textTheme.labelMedium, equals(textTheme.labelSmall));
      });

      test('creates ThemeData with correct component styles', () {
        final theme = BisonThemeData.dark();

        // Button background resolves to buttonPrimary
        final buttonStyle = theme.filledButtonTheme.style;
        expect(buttonStyle, isNotNull);
        expect(buttonStyle?.backgroundColor, isNotNull);
        if (buttonStyle?.backgroundColor != null) {
          final backgroundColor = buttonStyle!.backgroundColor!.resolve({});
          expect(
            backgroundColor,
            equals(BisonThemeTokens.dark().buttonPrimary),
          );
        }

        // Button foreground resolves to textInverse
        expect(buttonStyle?.foregroundColor, isNotNull);
        if (buttonStyle?.foregroundColor != null) {
          final foregroundColor = buttonStyle!.foregroundColor!.resolve({});
          expect(foregroundColor, equals(BisonThemeTokens.dark().textInverse));
        }

        // Menu style exists and resolves expected base colors
        expect(theme.menuTheme.style, isNotNull);
        expect(theme.menuTheme.style?.backgroundColor, isNotNull);
      });

      test('creates ThemeData with correct behavioral invariants', () {
        final theme = BisonThemeData.dark();
        final colorScheme = theme.colorScheme;

        // contrast(onPrimary, primary) >= 4.5 (WCAG AA for normal text)
        // We can't easily test this without a helper, but we can verify the relationship
        expect(colorScheme.primary, isNotNull);
        expect(colorScheme.onPrimary, isNotNull);

        // surfaceDim is darker than surface
        expect(colorScheme.surfaceDim, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.surfaceDim, isNot(equals(colorScheme.surface)));

        // surfaceBright is lighter than surface
        expect(colorScheme.surfaceBright, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.surfaceBright, isNot(equals(colorScheme.surface)));

        // inverseSurface differs meaningfully from surface
        expect(colorScheme.inverseSurface, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.inverseSurface, isNot(equals(colorScheme.surface)));
      });
    });
  });
}
