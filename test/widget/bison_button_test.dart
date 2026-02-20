import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  group("Testing callback function", () {
    testWidgets('Disabled Button should not call function', (
      final WidgetTester tester,
    ) async {
      final bool callbackCalled = false;

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(buttonLabel: 'Test Button', onPressed: null),
        ),
      );

      final buttonFinder = find.byType(BisonButton);
      await tester.tap(buttonFinder);

      expect(
        callbackCalled,
        isFalse,
        reason: "Expected callback to set callbackCalled to false",
      );
    });

    testWidgets('Pressing button will trigger callback', (
      final WidgetTester tester,
    ) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'Test Button',
            onPressed: () {
              callbackCalled = true;
            },
          ),
        ),
      );

      final buttonFinder = find.byType(BisonButton);
      await tester.tap(buttonFinder);

      expect(
        callbackCalled,
        isTrue,
        reason: "Expected callback to set callbackCalled to true",
      );
    });
  });

  group("Testing Styling for Button Types - light mode", () {
    testWidgets("Testing background and foreground for filled BisonButton", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'Filled',
            onPressed: () {},
            buttonType: BisonButtonType.filled,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final filledWidget = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final style = filledWidget.style!;
      final bg = style.backgroundColor?.resolve(<WidgetState>{});
      final fg = style.foregroundColor?.resolve(<WidgetState>{});

      expect(bg, equals(theme.buttonPrimary));
      expect(fg, equals(theme.textInverse));
    });

    testWidgets("Testing background and foreground for ghost BisonButton", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'ghost',
            onPressed: () {},
            buttonType: BisonButtonType.ghost,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final filledWidget = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final style = filledWidget.style!;
      final bg = style.backgroundColor?.resolve(<WidgetState>{});
      final fg = style.foregroundColor?.resolve(<WidgetState>{});

      expect(bg, equals(Colors.transparent));
      expect(fg, equals(theme.textPrimary));
    });

    testWidgets("Testing background and foreground for outlined BisonButton", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'Outlined',
            onPressed: () {},
            buttonType: BisonButtonType.outlined,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final filledWidget = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final style = filledWidget.style!;
      final bg = style.backgroundColor?.resolve(<WidgetState>{});
      final fg = style.foregroundColor?.resolve(<WidgetState>{});

      expect(bg, equals(Colors.transparent));
      expect(fg, equals(theme.textPrimary));
    });

    testWidgets("Testing background and foreground for destructive BisonButton", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'Destructive',
            onPressed: () {},
            buttonType: BisonButtonType.destructive,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final filledWidget = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final style = filledWidget.style!;
      final bg = style.backgroundColor?.resolve(<WidgetState>{});
      final fg = style.foregroundColor?.resolve(<WidgetState>{});

      expect(bg, equals(theme.buttonDanger));
      expect(fg, equals(theme.textInverse));
    });
  });
}

Widget _buildOutScaffold(final Widget widget) {
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
