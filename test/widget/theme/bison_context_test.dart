import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonThemeData,
        BisonThemeTokens,
        BisonSpacingTokens,
        BisonCornerTokens,
        BisonTypographyTokens,
        BisonContext;
import 'package:bison_design_system/src/theme/bison_theme_data.dart'
    show BisonTokens;

void main() {
  group('BisonContext and BisonTokens', () {
    testWidgets('context.bison resolves expected light tokens', (
      final WidgetTester tester,
    ) async {
      late BisonTokens tokens;

      await tester.pumpWidget(
        MaterialApp(
          theme: BisonThemeData.light(),
          home: Builder(
            builder: (final context) {
              tokens = context.bison;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final expectedTheme = BisonThemeTokens.light();
      final expectedSpacing = BisonSpacingTokens.standard();
      final expectedCorners = BisonCornerTokens.standard();
      final expectedTypography = BisonTypographyTokens.fromTokens(
        expectedTheme,
      );

      expect(tokens.theme.buttonPrimary, equals(expectedTheme.buttonPrimary));
      expect(
        tokens.spacing.standardSpacing,
        equals(expectedSpacing.standardSpacing),
      );
      expect(tokens.corners.cornerSmall, equals(expectedCorners.cornerSmall));
      expect(tokens.typography.h2, equals(expectedTypography.h2));
    });

    testWidgets('BisonTokens.of matches context.bison values', (
      final WidgetTester tester,
    ) async {
      late BisonTokens fromGetter;
      late BisonTokens fromFactory;

      await tester.pumpWidget(
        MaterialApp(
          theme: BisonThemeData.dark(),
          home: Builder(
            builder: (final context) {
              fromGetter = context.bison;
              fromFactory = BisonTokens.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        fromGetter.theme.surfaceDefault,
        equals(fromFactory.theme.surfaceDefault),
      );
      expect(
        fromGetter.spacing.mediumSpacing,
        equals(fromFactory.spacing.mediumSpacing),
      );
      expect(
        fromGetter.corners.cornerMedium,
        equals(fromFactory.corners.cornerMedium),
      );
      expect(
        fromGetter.typography.bodySmall,
        equals(fromFactory.typography.bodySmall),
      );
    });

    testWidgets(
      'BisonTokens.of throws StateError when extensions are missing',
      (final WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: SizedBox(key: Key('target'))),
          ),
        );

        final context = tester.element(find.byKey(const Key('target')));

        expect(
          () => BisonTokens.of(context),
          throwsA(
            isA<StateError>().having(
              (final error) => error.message,
              'message',
              contains('BisonThemeTokens not found in the current theme.'),
            ),
          ),
        );
      },
    );
  });
}
