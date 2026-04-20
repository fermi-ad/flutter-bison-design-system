import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonButton, BisonThemeTokens, BisonSpacingTokens, BisonCornerTokens;
import '../common.dart' show buildScaffold;

Finder _buttonSurfaceFinder(final String label) {
  return find.descendant(
    of: find.widgetWithText(BisonButton, label),
    matching: find.byWidgetPredicate(
      (final Widget widget) =>
          widget is DecoratedBox && widget.decoration is BoxDecoration,
    ),
  );
}

BoxDecoration _buttonSurfaceDecoration(
  final WidgetTester tester,
  final String label,
) {
  final surfaceFinder = _buttonSurfaceFinder(label);
  expect(surfaceFinder, findsOneWidget);
  final decoratedBox = tester.widget<DecoratedBox>(surfaceFinder);
  return decoratedBox.decoration as BoxDecoration;
}

Color? _buttonForegroundColor(final WidgetTester tester, final String label) {
  final styleFinder = find.descendant(
    of: find.widgetWithText(BisonButton, label),
    matching: find.byType(DefaultTextStyle),
  );
  expect(styleFinder, findsOneWidget);
  final defaultTextStyle = tester.widget<DefaultTextStyle>(styleFinder);
  return defaultTextStyle.style.color;
}

void main() {
  group('Testing callback function', () {
    testWidgets('Disabled Button should not call function', (
      final WidgetTester tester,
    ) async {
      final bool callbackCalled = false;

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(buttonLabel: 'Test Button', onPressed: null),
        ),
      );

      final buttonFinder = find.byType(BisonButton);
      await tester.tap(buttonFinder);

      expect(
        callbackCalled,
        isFalse,
        reason: 'Expected callback to set callbackCalled to false',
      );
    });

    testWidgets('Pressing button will trigger callback', (
      final WidgetTester tester,
    ) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(
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
        reason: 'Expected callback to set callbackCalled to true',
      );
    });

    testWidgets('Pressing Enter triggers callback for autofocus button', (
      final WidgetTester tester,
    ) async {
      var callbackCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(
            buttonLabel: 'Keyboard Action',
            autofocus: true,
            onPressed: () {
              callbackCount++;
            },
          ),
        ),
      );

      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump(const Duration(milliseconds: 150));

      expect(callbackCount, 1);
    });

    testWidgets('Pressing Enter does not trigger disabled button', (
      final WidgetTester tester,
    ) async {
      final callbackCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(
            buttonLabel: 'Disabled Keyboard Action',
            autofocus: true,
            onPressed: null,
          ),
        ),
      );

      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(callbackCount, 0);
    });
  });

  group('Testing Styling for Button Types in default state - light mode', () {
    testWidgets('Testing background and foreground for filled BisonButton', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(buttonLabel: 'Filled', onPressed: () {}),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'Filled');
      final foreground = _buttonForegroundColor(tester, 'Filled');

      expect(decoration.color, equals(theme.buttonPrimary));
      expect(foreground, equals(theme.textInverse));
    });

    testWidgets('Testing background and foreground for ghost BisonButton', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.ghost(buttonLabel: 'ghost', onPressed: () {}),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'ghost');
      final foreground = _buttonForegroundColor(tester, 'ghost');

      expect(decoration.color, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.textPrimary));
    });

    testWidgets('Testing background and foreground for outlined BisonButton', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.outlined(buttonLabel: 'Outlined', onPressed: () {}),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'Outlined');
      final foreground = _buttonForegroundColor(tester, 'Outlined');

      expect(decoration.color, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.textPrimary));
    });

    testWidgets(
      'Testing background and foreground for destructive BisonButton',
      (final WidgetTester tester) async {
        final theme = BisonThemeTokens.light();

        await tester.pumpWidget(
          buildScaffold(
            BisonButton.destructive(
              buttonLabel: 'Destructive',
              onPressed: () {},
            ),
          ),
        );

        final decoration = _buttonSurfaceDecoration(tester, 'Destructive');
        final foreground = _buttonForegroundColor(tester, 'Destructive');

        expect(decoration.color, equals(theme.buttonDanger));
        expect(foreground, equals(theme.textInverse));
      },
    );

    testWidgets('Testing padding variables without icon', (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(
            buttonLabel: 'Label',
            onPressed: () => debugPrint('test'),
          ),
        ),
      );

      final paddingFinder = find.byWidgetPredicate((final Widget widget) {
        if (widget is Padding && widget.child is Text) {
          final text = widget.child as Text;
          return text.data == 'Label';
        }
        return false;
      });
      expect(paddingFinder, findsOneWidget);

      final paddingWidget = tester.widget<Padding>(paddingFinder);
      final padding = paddingWidget.padding as EdgeInsets;
      expect(padding.left, equals(spacing.smallSpacing));
      expect(padding.top, equals(spacing.tinySpacing));
    });

    testWidgets('Testing padding variables with icon', (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(
            buttonLabel: 'WithIcon',
            onPressed: () => debugPrint('test'),
            icon: const Icon(Icons.add),
          ),
        ),
      );

      final paddingFinder = find.byWidgetPredicate((final Widget widget) {
        if (widget is Padding && widget.child is Row) {
          final row = widget.child as Row;
          return row.children.any(
            (final Widget child) => child is Text && child.data == 'WithIcon',
          );
        }
        return false;
      });

      expect(paddingFinder, findsOneWidget);

      final paddingWidget = tester.widget<Padding>(paddingFinder);
      final padding = paddingWidget.padding as EdgeInsets;
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

    testWidgets('Testing button uses appropriate corners', (
      final WidgetTester tester,
    ) async {
      final corners = BisonCornerTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(
            buttonLabel: 'Corner',
            onPressed: () => debugPrint(''),
          ),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'Corner');
      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, equals(corners.cornerExtraSmall));
    });
  });

  group('Testing theming for disabled button state - light mode', () {
    testWidgets('Disabled state theme testings - filled button', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.filled(buttonLabel: 'filled', onPressed: null),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'filled');
      final foreground = _buttonForegroundColor(tester, 'filled');

      expect(decoration.color, equals(theme.buttonGhostDisabled));
      expect(foreground, equals(theme.textDisabled));
    });

    testWidgets('Disabled state theme testings - ghost buttons', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(BisonButton.ghost(buttonLabel: 'ghost', onPressed: null)),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'ghost');
      final foreground = _buttonForegroundColor(tester, 'ghost');

      expect(decoration.color, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.textDisabled));
    });

    testWidgets('Disabled state theme testings - outlined buttons', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.outlined(buttonLabel: 'outlined', onPressed: null),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'outlined');
      final foreground = _buttonForegroundColor(tester, 'outlined');

      expect(decoration.color, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.textDisabled));
    });

    testWidgets('Disabled state theme testings - destructive buttons', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonButton.destructive(buttonLabel: 'destructive', onPressed: null),
        ),
      );

      final decoration = _buttonSurfaceDecoration(tester, 'destructive');
      final foreground = _buttonForegroundColor(tester, 'destructive');

      expect(decoration.color, equals(theme.buttonGhostDisabled));
      expect(foreground, equals(theme.textDisabled));
    });
  });
}
