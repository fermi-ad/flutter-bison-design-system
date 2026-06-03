import 'package:bison_design_system/bison_design_system.dart'
    show BisonTextField, BisonThemeTokens;
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

/// Returns the [Container] that forms the input box inside [BisonTextField].
Container _inputContainer(WidgetTester tester) {
  return tester.widget<Container>(
    find
        .descendant(
          of: find.byType(BisonTextField),
          matching: find.byType(Container),
        )
        .first,
  );
}

BoxDecoration _decoration(WidgetTester tester) =>
    _inputContainer(tester).decoration! as BoxDecoration;

Border _border(WidgetTester tester) => _decoration(tester).border! as Border;

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

      expect(_decoration(tester).color, equals(theme.inputFieldField));
      expect(_border(tester).bottom.color, equals(theme.borderPlain));
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

      expect(_decoration(tester).color, equals(theme.inputFieldFieldHovered));
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
          _border(tester).bottom.color,
          equals(theme.borderPlain),
          reason: 'border should be plain after first tap-out',
        );

        // Second cycle — this is the case that was broken
        await _tapInThenOut(tester);
        expect(
          _border(tester).bottom.color,
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

      // Focused state uses Border.all — check top side.
      expect(_border(tester).top.color, equals(theme.borderPrimary));
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

      expect(_decoration(tester).color, equals(theme.inputFieldField));
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

        expect(
          _decoration(tester).color,
          equals(theme.inputFieldFieldDisabled),
        );
        expect(_border(tester).bottom.color, equals(theme.borderDisabled));
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

      expect(_border(tester).bottom.color, equals(theme.borderError));
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

      expect(_border(tester).bottom.color, equals(theme.borderError));
    });
  });

  group('BisonTextField — warning state', () {
    testWidgets('uses borderWarning border', (final WidgetTester tester) async {
      final BisonThemeTokens theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonTextField(hasWarning: true)),
      );

      // Warning state uses Border.all — check top side.
      expect(_border(tester).top.color, equals(theme.borderWarning));
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
}
