import 'package:bison_design_system/bison_design_system.dart'
    show BisonSwitch, BisonSwitchSize, BisonSwitchVariant, BisonThemeTokens;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns the outermost [AnimatedContainer] that represents the switch track.
AnimatedContainer _findTrack(final WidgetTester tester) {
  return tester.widget<AnimatedContainer>(
    find
        .descendant(
          of: find.byType(BisonSwitch),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
}

BoxDecoration _trackDecoration(final WidgetTester tester) =>
    _findTrack(tester).decoration! as BoxDecoration;

/// Returns the [Container] that represents the thumb circle.
Container _findThumb(final WidgetTester tester) {
  return tester.widget<Container>(
    find
        .descendant(
          of: find.byType(BisonSwitch),
          matching: find.byType(Container),
        )
        .last,
  );
}

BoxDecoration _thumbDecoration(final WidgetTester tester) =>
    _findThumb(tester).decoration! as BoxDecoration;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // Default (normal) state
  // -------------------------------------------------------------------------
  group('BisonSwitch - normal variant', () {
    testWidgets('track is selectorSelectorPrimary when value is true', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: true, onChanged: (_) {})),
      );

      expect(
        _trackDecoration(tester).color,
        equals(theme.selectorSelectorPrimary),
      );
    });

    testWidgets('track is selectorSelectorSwitchFill when value is false', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: false, onChanged: (_) {})),
      );

      expect(
        _trackDecoration(tester).color,
        equals(theme.selectorSelectorSwitchFill),
      );
    });

    testWidgets('thumb uses selectorSelectorCheckboxCheck', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: true, onChanged: (_) {})),
      );

      expect(
        _thumbDecoration(tester).color,
        equals(theme.selectorSelectorCheckboxCheck),
      );
    });

    testWidgets('no border in default state', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: false, onChanged: (_) {})),
      );

      expect(_trackDecoration(tester).border, isNull);
    });

    testWidgets('no focus ring when not focused', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: false, onChanged: (_) {})),
      );

      final shadows = _trackDecoration(tester).boxShadow;
      expect(shadows == null || shadows.isEmpty, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // Focus state
  // -------------------------------------------------------------------------
  group('BisonSwitch – focus state', () {
    testWidgets('focus ring appears when switch is focused via Tab key', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: false, onChanged: (_) {})),
      );
      await tester.pump();

      // Tab into the switch to trigger keyboard-focus highlight.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final shadows = _trackDecoration(tester).boxShadow;
      expect(shadows, isNotNull);
      expect(shadows!.isNotEmpty, isTrue);
      expect(shadows.first.color, equals(const Color(0xFF0A30DA)));
      expect(shadows.first.spreadRadius, equals(2.0));
      expect(shadows.first.blurRadius, equals(0.0));
    });
  });

  // -------------------------------------------------------------------------
  // Disabled state
  // -------------------------------------------------------------------------
  group('BisonSwitch - disabled variant', () {
    testWidgets('track uses selectorSelectorSwitchFillDisabled', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: true, variant: BisonSwitchVariant.disabled),
        ),
      );

      expect(
        _trackDecoration(tester).color,
        equals(theme.selectorSelectorSwitchFillDisabled),
      );
    });

    testWidgets('thumb uses selectorSelectorSwitchDisabled', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: true, variant: BisonSwitchVariant.disabled),
        ),
      );

      expect(
        _thumbDecoration(tester).color,
        equals(theme.selectorSelectorSwitchDisabled),
      );
    });

    testWidgets('label uses textDisabled color', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(
            value: false,
            variant: BisonSwitchVariant.disabled,
            label: 'My label',
            stateText: 'Off',
          ),
        ),
      );

      final texts = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(BisonSwitch),
          matching: find.byType(Text),
        ),
      );

      for (final text in texts) {
        expect(text.style?.color, equals(theme.textDisabled));
      }
    });

    testWidgets('onChanged is not called when tapped in disabled variant', (
      final WidgetTester tester,
    ) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) => callCount++,
            variant: BisonSwitchVariant.disabled,
          ),
        ),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();

      expect(callCount, equals(0));
    });
  });

  // -------------------------------------------------------------------------
  // Read-only state
  // -------------------------------------------------------------------------
  group('BisonSwitch - readOnly variant', () {
    testWidgets('track is transparent', (final WidgetTester tester) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: true, variant: BisonSwitchVariant.readOnly),
        ),
      );

      expect(_trackDecoration(tester).color, equals(const Color(0x00FFFFFF)));
    });

    testWidgets('track has 1px borderPlain border', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: false, variant: BisonSwitchVariant.readOnly),
        ),
      );

      final decoration = _trackDecoration(tester);
      expect(decoration.border, isNotNull);
      final border = decoration.border! as Border;
      expect(border.top.color, equals(theme.borderPlain));
      expect(border.top.width, equals(1.0));
    });

    testWidgets('thumb uses iconPlain color', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: true, variant: BisonSwitchVariant.readOnly),
        ),
      );

      expect(_thumbDecoration(tester).color, equals(theme.iconPlain));
    });

    testWidgets('onChanged is not called when tapped in readOnly variant', (
      final WidgetTester tester,
    ) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) => callCount++,
            variant: BisonSwitchVariant.readOnly,
          ),
        ),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();

      expect(callCount, equals(0));
    });
  });

  // -------------------------------------------------------------------------
  // Skeleton state
  // -------------------------------------------------------------------------
  group('BisonSwitch – skeleton variant', () {
    testWidgets('renders two Containers with skeleton background color', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: false, variant: BisonSwitchVariant.skeleton),
        ),
      );

      final containers = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(BisonSwitch),
              matching: find.byType(Container),
            ),
          )
          .toList();

      expect(containers.length, equals(2));
      for (final c in containers) {
        final decoration = c.decoration! as BoxDecoration;
        expect(decoration.color, equals(theme.miscellaneousSkeletonBackground));
      }
    });

    testWidgets('no AnimatedContainer (no interactive track) in skeleton', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: false, variant: BisonSwitchVariant.skeleton),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(BisonSwitch),
          matching: find.byType(AnimatedContainer),
        ),
        findsNothing,
      );
    });
  });

  // -------------------------------------------------------------------------
  // Sizes
  // -------------------------------------------------------------------------
  group('BisonSwitch - sizes', () {
    testWidgets('medium size track is 48 x 24', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) {},
            size: BisonSwitchSize.medium,
          ),
        ),
      );

      final track = _findTrack(tester);
      expect(track.constraints?.maxWidth, equals(48.0));
      expect(track.constraints?.maxHeight, equals(24.0));
    });

    testWidgets('small size track is 32 x 16', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) {},
            size: BisonSwitchSize.small,
          ),
        ),
      );

      final track = _findTrack(tester);
      expect(track.constraints?.maxWidth, equals(32.0));
      expect(track.constraints?.maxHeight, equals(16.0));
    });
  });

  // -------------------------------------------------------------------------
  // Interaction
  // -------------------------------------------------------------------------
  group('BisonSwitch - interaction', () {
    testWidgets('onChanged fires with toggled value on tap', (
      final WidgetTester tester,
    ) async {
      bool? received;

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(value: false, onChanged: (v) => received = v),
        ),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();

      expect(received, isTrue);
    });

    testWidgets('onChanged fires true→false when value starts true', (
      final WidgetTester tester,
    ) async {
      bool? received;

      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: true, onChanged: (v) => received = v)),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();

      expect(received, isFalse);
    });

    testWidgets('Enter key triggers onChanged when focused', (
      final WidgetTester tester,
    ) async {
      bool? received;

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (v) => received = v,
            autofocus: true,
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(received, isTrue);
    });

    testWidgets('Space key triggers onChanged when focused', (
      final WidgetTester tester,
    ) async {
      bool? received;

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (v) => received = v,
            autofocus: true,
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(received, isTrue);
    });

    testWidgets('onChanged is not called when onChanged is null', (
      final WidgetTester tester,
    ) async {
      // Should not throw; just silently ignores the tap.
      await tester.pumpWidget(buildScaffold(const BisonSwitch(value: false)));

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();
      // No assertion needed – test passes if no exception is thrown.
    });
  });

  // -------------------------------------------------------------------------
  // Label and state text
  // -------------------------------------------------------------------------
  group('BisonSwitch - label and stateText', () {
    testWidgets('label text is rendered when provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(value: false, onChanged: (_) {}, label: 'Enable feature'),
        ),
      );

      expect(find.text('Enable feature'), findsOneWidget);
    });

    testWidgets('label is absent when not provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: false, onChanged: (_) {})),
      );

      // Only the switch itself – no extra Text widgets.
      expect(
        find.descendant(
          of: find.byType(BisonSwitch),
          matching: find.byType(Text),
        ),
        findsNothing,
      );
    });

    testWidgets('stateText is rendered when provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(value: true, onChanged: (_) {}, stateText: 'On'),
        ),
      );

      expect(find.text('On'), findsOneWidget);
    });

    testWidgets('both label and stateText render together', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) {},
            label: 'Notifications',
            stateText: 'Off',
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Off'), findsOneWidget);
    });

    testWidgets('label uses textPlain color in normal variant', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(value: false, onChanged: (_) {}, label: 'My label'),
        ),
      );

      final labelText = tester.widget<Text>(find.text('My label'));
      expect(labelText.style?.color, equals(theme.textPlain));
    });
  });
}
