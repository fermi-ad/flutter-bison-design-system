import 'package:bison_design_system/bison_design_system.dart'
    show BisonTextField, BisonThemeTokens;
import 'package:bison_design_system/src/core_widgets/inputs/bison_text_field.dart'
    show BisonTextFieldBorderPainter, BisonTextFieldBorderSpec;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

// ── Focus lifecycle helpers ───────────────────────────────────────────────────

/// Taps the [BisonTextField] to give it focus, then taps outside to unfocus.
Future<void> _tapInThenOut(WidgetTester tester) async {
  await tester.tap(find.byType(BisonTextField));
  await tester.pump();
  // Tap outside the field (top-left corner of the screen)
  await tester.tapAt(Offset.zero);
  await tester.pump();
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Returns the [BisonTextFieldBorderSpec] from the [CustomPaint] border painter
/// inside [BisonTextField].
BisonTextFieldBorderSpec _borderSpec(WidgetTester tester) {
  final customPaint = tester.widget<CustomPaint>(
    find
        .descendant(
          of: find.byType(BisonTextField),
          matching: find.byType(CustomPaint),
        )
        .first,
  );
  return (customPaint.painter! as BisonTextFieldBorderPainter).spec;
}

/// Returns the background [Color] from the inner [Container] inside
/// [BisonTextField].
Color _backgroundColor(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(BisonTextField),
          matching: find.byType(Container),
        )
        .first,
  );
  return (container.decoration! as BoxDecoration).color!;
}

/// Returns the first [Text] widget inside [BisonTextField] whose data matches
/// [text].
Text _findText(WidgetTester tester, String text) {
  return tester.widget<Text>(
    find.descendant(of: find.byType(BisonTextField), matching: find.text(text)),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('BisonTextField — default state', () {
    testWidgets('uses inputFieldField background and borderPlain border', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildScaffold(const BisonTextField()));

      expect(_backgroundColor(tester), equals(theme.inputFieldField));
      expect(_borderSpec(tester).bottomColor, equals(theme.borderPlain));
    });
  });

  group('BisonTextField — hover state', () {
    testWidgets('uses inputFieldFieldHovered background on hover', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();

      await tester.pumpWidget(buildScaffold(const BisonTextField()));

      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(BisonTextField)));
      await tester.pump();

      expect(_backgroundColor(tester), equals(theme.inputFieldFieldHovered));
    });
  });

  group('BisonTextField — focus lifecycle', () {
    testWidgets(
      'border returns to borderPlain after tap-in then tap-out (repeated)',
      (final WidgetTester tester) async {
        final BisonThemeTokens theme = BisonThemeTokens.light();
        final FocusNode focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await tester.pumpWidget(
          buildScaffold(BisonTextField(focusNode: focusNode)),
        );

        // First cycle
        await _tapInThenOut(tester);
        expect(
          _borderSpec(tester).bottomColor,
          equals(theme.borderPlain),
          reason: 'border should be plain after first tap-out',
        );

        // Second cycle — this is the case that was broken
        await _tapInThenOut(tester);
        expect(
          _borderSpec(tester).bottomColor,
          equals(theme.borderPlain),
          reason: 'border should be plain after second tap-out',
        );
      },
    );

    testWidgets(
      'focusNode.hasFocus is false after tap-in then tap-out (repeated)',
      (final WidgetTester tester) async {
        final FocusNode focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await tester.pumpWidget(
          buildScaffold(BisonTextField(focusNode: focusNode)),
        );

        // First cycle
        await _tapInThenOut(tester);
        expect(focusNode.hasFocus, isFalse, reason: 'after first tap-out');

        // Second cycle
        await _tapInThenOut(tester);
        expect(focusNode.hasFocus, isFalse, reason: 'after second tap-out');
      },
    );
  });

  group('BisonTextField — focus state', () {
    testWidgets('uses borderPrimary border when focused', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();
      final FocusNode focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildScaffold(BisonTextField(focusNode: focusNode)),
      );

      focusNode.requestFocus();
      await tester.pump();

      // Focused state uses allColor (all sides uniform).
      expect(_borderSpec(tester).allColor, equals(theme.borderPrimary));
    });

    testWidgets('uses inputFieldField background when focused', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();
      final FocusNode focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildScaffold(BisonTextField(focusNode: focusNode)),
      );

      focusNode.requestFocus();
      await tester.pump();

      expect(_backgroundColor(tester), equals(theme.inputFieldField));
    });
  });

  group('BisonTextField — disabled state', () {
    testWidgets(
      'uses inputFieldFieldDisabled background and borderDisabled border',
      (final WidgetTester tester) async {
        final BisonThemeTokens theme = BisonThemeTokens.light();

        await tester.pumpWidget(
          buildScaffold(const BisonTextField(enabled: false)),
        );

        expect(_backgroundColor(tester), equals(theme.inputFieldFieldDisabled));
        expect(_borderSpec(tester).bottomColor, equals(theme.borderDisabled));
      },
    );

    testWidgets('helper text uses textDisabled color when disabled', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();
      const String helper = 'Helper text';

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(enabled: false, helperText: helper)),
      );

      final Text helperWidget = _findText(tester, helper);
      expect(helperWidget.style?.color, equals(theme.textDisabled));
    });
  });

  group('BisonTextField — error state', () {
    testWidgets('uses borderError border', (final WidgetTester tester) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(hasError: true)),
      );

      // Error state uses allColor (all sides uniform).
      expect(_borderSpec(tester).allColor, equals(theme.borderError));
    });

    testWidgets('helper text uses textError color', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();
      const String helper = 'Something went wrong';

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(hasError: true, helperText: helper)),
      );

      final Text helperWidget = _findText(tester, helper);
      expect(helperWidget.style?.color, equals(theme.textError));
    });

    testWidgets('error takes precedence over warning', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(hasError: true, hasWarning: true)),
      );

      // Error takes precedence — allColor is set.
      expect(_borderSpec(tester).allColor, equals(theme.borderError));
    });
  });

  group('BisonTextField — warning state', () {
    testWidgets('uses borderWarning border', (final WidgetTester tester) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(hasWarning: true)),
      );

      // Warning state uses allColor (all sides uniform).
      expect(_borderSpec(tester).allColor, equals(theme.borderWarning));
    });

    testWidgets('helper text uses textPlain color', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();
      const String helper = 'Check this value';

      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(hasWarning: true, helperText: helper),
        ),
      );

      final Text helperWidget = _findText(tester, helper);
      expect(helperWidget.style?.color, equals(theme.textPlain));
    });
  });

  group('BisonTextField — label', () {
    testWidgets('renders label text when provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(const BisonTextField(label: 'Email address')),
      );

      expect(find.text('Email address'), findsOneWidget);
    });

    testWidgets('does not render label when not provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildScaffold(const BisonTextField()));

      // Only the EditableText should be present — no extra Text widgets
      expect(
        find.descendant(
          of: find.byType(BisonTextField),
          matching: find.byType(Text),
        ),
        findsNothing,
      );
    });
  });

  group('BisonTextField — helper text', () {
    testWidgets('renders helper text when provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(const BisonTextField(helperText: 'Enter your full name')),
      );

      expect(find.text('Enter your full name'), findsOneWidget);
    });

    testWidgets('does not render helper text when not provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildScaffold(const BisonTextField()));

      expect(
        find.descendant(
          of: find.byType(BisonTextField),
          matching: find.byType(Text),
        ),
        findsNothing,
      );
    });

    testWidgets('default helper text uses textMuted color', (
      final WidgetTester tester,
    ) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();
      const String helper = 'Some hint';

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(helperText: helper)),
      );

      final Text helperWidget = _findText(tester, helper);
      expect(helperWidget.style?.color, equals(theme.textMuted));
    });
  });

  group('BisonTextField — placeholder', () {
    testWidgets('shows placeholder when controller is empty', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(const BisonTextField(placeholder: 'Type here...')),
      );

      expect(find.text('Type here...'), findsOneWidget);
    });

    testWidgets('hides placeholder when controller has text', (
      final WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'Hello',
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildScaffold(
          BisonTextField(placeholder: 'Type here...', controller: controller),
        ),
      );

      expect(find.text('Type here...'), findsNothing);
    });
  });

  group('BisonTextField — text preserved across remounts (PageStorage)', () {
    testWidgets(
      'text is restored after remount using the fallback storage key',
      (final WidgetTester tester) async {
        // Simulate widgetbook's ValueKey(uri) pattern: the use-case widget is
        // wrapped in a keyed container. When the key changes, Flutter remounts
        // the subtree — exactly what widgetbook does on every knob change.
        //
        // A single PageStorageBucket is shared across pumpWidget calls so that
        // the saved text survives the remount. No key is set on BisonTextField
        // itself; the implementation falls back to a fixed symbol identifier.
        final PageStorageBucket bucket = PageStorageBucket();

        Widget buildWithKey(int keyValue) {
          return buildScaffold(
            PageStorage(
              bucket: bucket,
              child: KeyedSubtree(
                key: ValueKey(keyValue),
                child: const BisonTextField(placeholder: 'Type here...'),
              ),
            ),
          );
        }

        // Initial mount — key = 0
        await tester.pumpWidget(buildWithKey(0));
        await tester.tap(find.byType(BisonTextField));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'hello');
        await tester.pump();

        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .controller
              .text,
          equals('hello'),
        );

        // Remount with key = 1 (simulates widgetbook knob change)
        await tester.pumpWidget(buildWithKey(1));

        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .controller
              .text,
          equals('hello'),
          reason: 'text must be restored from PageStorage after remount',
        );
      },
    );

    testWidgets(
      'two fields with different widget keys use independent storage slots',
      (final WidgetTester tester) async {
        final PageStorageBucket bucket = PageStorageBucket();

        Widget buildWithKey(int keyValue) {
          return buildScaffold(
            PageStorage(
              bucket: bucket,
              child: Column(
                children: [
                  KeyedSubtree(
                    key: ValueKey('a-$keyValue'),
                    child: const BisonTextField(
                      key: ValueKey('field-a'),
                      placeholder: 'Field A',
                    ),
                  ),
                  KeyedSubtree(
                    key: ValueKey('b-$keyValue'),
                    child: const BisonTextField(
                      key: ValueKey('field-b'),
                      placeholder: 'Field B',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        await tester.pumpWidget(buildWithKey(0));

        // Type into field A
        await tester.tap(find.byType(BisonTextField).first);
        await tester.pump();
        await tester.enterText(find.byType(EditableText).first, 'alpha');
        await tester.pump();

        // Type into field B
        await tester.tap(find.byType(BisonTextField).last);
        await tester.pump();
        await tester.enterText(find.byType(EditableText).last, 'beta');
        await tester.pump();

        // Remount both fields
        await tester.pumpWidget(buildWithKey(1));

        expect(
          tester
              .widget<EditableText>(find.byType(EditableText).first)
              .controller
              .text,
          equals('alpha'),
          reason: 'field A text must survive remount independently',
        );
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText).last)
              .controller
              .text,
          equals('beta'),
          reason: 'field B text must survive remount independently',
        );
      },
    );
  });

  group('BisonTextField — text preserved across state changes', () {
    testWidgets('text is preserved when hasError toggles', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', hasError: false),
        ),
      );

      await tester.tap(find.byType(BisonTextField));
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pump();

      // Toggle hasError → true
      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', hasError: true),
        ),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        equals('hello'),
        reason: 'text must survive hasError toggling to true',
      );

      // Toggle hasError → false
      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', hasError: false),
        ),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        equals('hello'),
        reason: 'text must survive hasError toggling back to false',
      );
    });

    testWidgets('text is preserved when hasWarning toggles', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', hasWarning: false),
        ),
      );

      await tester.tap(find.byType(BisonTextField));
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'world');
      await tester.pump();

      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', hasWarning: true),
        ),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        equals('world'),
        reason: 'text must survive hasWarning toggling to true',
      );
    });

    testWidgets('text is preserved when obscureText toggles', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', obscureText: false),
        ),
      );

      await tester.tap(find.byType(BisonTextField));
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'secret');
      await tester.pump();

      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', obscureText: true),
        ),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        equals('secret'),
        reason: 'text must survive obscureText toggling to true',
      );
    });

    testWidgets('text is preserved when enabled toggles', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', enabled: true),
        ),
      );

      await tester.tap(find.byType(BisonTextField));
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'data');
      await tester.pump();

      await tester.pumpWidget(
        buildScaffold(
          const BisonTextField(placeholder: 'Type here...', enabled: false),
        ),
      );

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        equals('data'),
        reason: 'text must survive enabled toggling to false',
      );
    });
  });
}
