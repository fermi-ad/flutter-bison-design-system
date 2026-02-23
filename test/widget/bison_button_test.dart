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

      expect(bg, equals(theme.surfaceTransparent));
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

      expect(bg, equals(theme.surfaceTransparent));
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

    testWidgets("Testing padding variables without icon", (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'Label',
            onPressed: () => debugPrint('test'),
          ),
        ),
      );

      final paddingFinder = find.byWidgetPredicate((final Widget widget) {
        if (widget is Padding && widget.child is Text) {
          final Text t = widget.child as Text;
          return t.data == 'Label';
        }
        return false;
      });
      expect(paddingFinder, findsOneWidget);

      final Padding paddingWidget = tester.widget<Padding>(paddingFinder);
      final EdgeInsets padding = paddingWidget.padding as EdgeInsets;
      expect(padding.left, equals(spacing.smallSpacing));
      expect(padding.top, equals(spacing.tinySpacing));
    });

    testWidgets("Testing padding variables with icon", (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(
        _buildOutScaffold(
          BisonButton(
            buttonLabel: 'WithIcon',
            onPressed: () => debugPrint('test'),
            icon: Icon(Icons.add),
          ),
        ),
      );

      final paddingFinder = find.byWidgetPredicate((final Widget widget) {
        if (widget is Padding && widget.child is Row) {
          final Row row = widget.child as Row;
          return row.children.any(
            (final Widget c) => c is Text && (c).data == 'WithIcon',
          );
        }
        return false;
      });

      expect(paddingFinder, findsOneWidget);

      final Padding paddingWidget = tester.widget<Padding>(paddingFinder);
      final EdgeInsets padding = paddingWidget.padding as EdgeInsets;
      expect(padding.left, equals(spacing.smallSpacing));
      expect(padding.top, equals(spacing.tinySpacing));

      final sizedBoxFinder = find.descendant(
        of: paddingFinder,
        matching: find.byType(SizedBox),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(sizedBoxFinder).toList();
      expect(
        sizedBoxes.any(
          (final sizedBox) => sizedBox.width == spacing.tinySpacing,
        ),
        isTrue,
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
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
