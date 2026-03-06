import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonButton,
        BisonButtonType,
        BisonThemeTokens,
        BisonSpacingTokens,
        BisonCornerTokens;
import '../common.dart' show buildScaffold, getButtonStyle;

void main() {
  group("Testing callback function", () {
    testWidgets('Disabled Button should not call function', (
      final WidgetTester tester,
    ) async {
      final bool callbackCalled = false;

      await tester.pumpWidget(
        buildScaffold(BisonButton(buttonLabel: 'Test Button', onPressed: null)),
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
        buildScaffold(
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

  group("Testing Styling for Button Types in default state - light mode", () {
    testWidgets("Testing background and foreground for filled BisonButton", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton(
            buttonLabel: 'Filled',
            onPressed: () {},
            buttonType: BisonButtonType.filled,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final element = tester.element(find.byType(FilledButton));
      final filledWidget = element.widget as FilledButton;
      final style = getButtonStyle(element, filledWidget);
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
        buildScaffold(
          BisonButton(
            buttonLabel: 'ghost',
            onPressed: () {},
            buttonType: BisonButtonType.ghost,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final element = tester.element(find.byType(FilledButton));
      final filledWidget = element.widget as FilledButton;
      final style = getButtonStyle(element, filledWidget);
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
        buildScaffold(
          BisonButton(
            buttonLabel: 'Outlined',
            onPressed: () {},
            buttonType: BisonButtonType.outlined,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final element = tester.element(find.byType(FilledButton));
      final filledWidget = element.widget as FilledButton;
      final style = getButtonStyle(element, filledWidget);
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
        buildScaffold(
          BisonButton(
            buttonLabel: 'Destructive',
            onPressed: () {},
            buttonType: BisonButtonType.destructive,
          ),
        ),
      );

      // BisonButton builds off of [FilledButton]
      // finding [FilledButton] allows use of style getters provided by [FilledButton]
      final element = tester.element(find.byType(FilledButton));
      final filledWidget = element.widget as FilledButton;
      final style = getButtonStyle(element, filledWidget);
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
        buildScaffold(
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
        buildScaffold(
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

    testWidgets("Testing button uses appropriate corners", (
      final WidgetTester tester,
    ) async {
      final corners = BisonCornerTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton(buttonLabel: 'Corner', onPressed: () => debugPrint("")),
        ),
      );

      final element = tester.element(find.byType(FilledButton));
      final widgetFinder = element.widget as FilledButton;
      final style = getButtonStyle(element, widgetFinder);
      final shape =
          style.shape?.resolve(<WidgetState>{}) as RoundedRectangleBorder;
      final Radius radius = (shape.borderRadius as BorderRadius).topLeft;
      expect(radius.x, equals(corners.cornerExtraSmall));
    });
  });

  group("Testing theming for disabled button state - light mode", () {
    testWidgets("Disabled state theme testings - filled button", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton(
            buttonLabel: 'filled',
            onPressed: null,
            buttonType: BisonButtonType.filled,
          ),
        ),
      );

      final filledFinder = find.descendant(
        of: find.widgetWithText(BisonButton, 'filled'),
        matching: find.byType(FilledButton),
      );

      expect(filledFinder, findsOneWidget);

      final element = tester.element(filledFinder);
      final filledButton = element.widget as FilledButton;
      final filledStyle = getButtonStyle(element, filledButton);
      final filledBackground = filledStyle.backgroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );
      final filledForeground = filledStyle.foregroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );

      expect(filledBackground, equals(theme.buttonGhostDisabled));
      expect(filledForeground, equals(theme.textDisabled));
    });

    testWidgets("Disabled state theme testings - ghost buttons", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton(
            buttonLabel: 'ghost',
            onPressed: null,
            buttonType: BisonButtonType.ghost,
          ),
        ),
      );

      final ghostFinder = find.descendant(
        of: find.widgetWithText(BisonButton, 'ghost'),
        matching: find.byType(FilledButton),
      );

      expect(ghostFinder, findsOneWidget);

      final element = tester.element(ghostFinder);
      final ghostButton = element.widget as FilledButton;
      final ghostStyle = getButtonStyle(element, ghostButton);
      final ghostBackground = ghostStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final ghostForeground = ghostStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });

      expect(ghostBackground, equals(theme.surfaceTransparent));
      expect(ghostForeground, equals(theme.textDisabled));
    });

    testWidgets("Disabled state theme testings - outlined buttons", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton(
            buttonLabel: 'outlined',
            onPressed: null,
            buttonType: BisonButtonType.outlined,
          ),
        ),
      );

      final outlinedFinder = find.descendant(
        of: find.widgetWithText(BisonButton, 'outlined'),
        matching: find.byType(FilledButton),
      );
      expect(outlinedFinder, findsOneWidget);
      final element = tester.element(outlinedFinder);
      final outlinedButton = element.widget as FilledButton;
      // outlined testing
      final outlinedStyle = getButtonStyle(element, outlinedButton);
      final outlinedBackground = outlinedStyle.backgroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );
      final outlinedForeground = outlinedStyle.foregroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );

      expect(outlinedBackground, equals(theme.surfaceTransparent));
      expect(outlinedForeground, equals(theme.textDisabled));
    });

    testWidgets("Disabled state theme testings - destructive buttons", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton(
            buttonLabel: 'destructive',
            onPressed: null,
            buttonType: BisonButtonType.destructive,
          ),
        ),
      );
      final destructiveFinder = find.descendant(
        of: find.widgetWithText(BisonButton, 'destructive'),
        matching: find.byType(FilledButton),
      );

      expect(destructiveFinder, findsOneWidget);

      final element = tester.element(destructiveFinder);
      final destructiveButton = element.widget as FilledButton;
      final destructiveStyle = getButtonStyle(element, destructiveButton);
      final destructiveBackground = destructiveStyle.backgroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );
      final destructiveForeground = destructiveStyle.foregroundColor?.resolve(
        <WidgetState>{WidgetState.disabled},
      );

      expect(destructiveBackground, equals(theme.buttonGhostDisabled));
      expect(destructiveForeground, equals(theme.textDisabled));
    });
  });
}
