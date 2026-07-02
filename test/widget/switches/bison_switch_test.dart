import 'package:bison_design_system/bison_design_system.dart'
    show BisonSwitch, BisonSwitchSize, BisonThemeTokens;
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
  // Default (interactive) state
  // -------------------------------------------------------------------------
  group('BisonSwitch - interactive (onChanged non-null)', () {
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

    testWidgets('no border in interactive state', (
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
  // Disabled state (onChanged == null)
  // -------------------------------------------------------------------------
  group('BisonSwitch - disabled (onChanged null)', () {
    testWidgets('track uses selectorSelectorSwitchFillDisabled', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonSwitch(value: true, onChanged: null)),
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
        buildScaffold(const BisonSwitch(value: true, onChanged: null)),
      );

      expect(
        _thumbDecoration(tester).color,
        equals(theme.selectorSelectorSwitchDisabled),
      );
    });

    testWidgets('label and offLabel use textDisabled color', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(
            value: false,
            onChanged: null,
            label: 'My label',
            offLabel: 'Off',
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

    testWidgets('onChanged is not called when tapped in disabled state', (
      final WidgetTester tester,
    ) async {
      // onChanged is null — there is nothing to call, and no GestureDetector
      // is wired up. Tapping should not throw.
      await tester.pumpWidget(
        buildScaffold(const BisonSwitch(value: false, onChanged: null)),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();
      // No assertion needed – test passes if no exception is thrown.
    });
  });

  // -------------------------------------------------------------------------
  // Read-only state
  // -------------------------------------------------------------------------
  group('BisonSwitch - readOnly constructor', () {
    testWidgets('track is transparent', (final WidgetTester tester) async {
      await tester.pumpWidget(
        buildScaffold(const BisonSwitch.readOnly(value: true)),
      );

      expect(_trackDecoration(tester).color, equals(const Color(0x00FFFFFF)));
    });

    testWidgets('track has 1px borderPlain border', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonSwitch.readOnly(value: false)),
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
        buildScaffold(const BisonSwitch.readOnly(value: true)),
      );

      expect(_thumbDecoration(tester).color, equals(theme.iconPlain));
    });

    testWidgets('tapping a readOnly switch does not throw', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(const BisonSwitch.readOnly(value: false)),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();
      // No assertion needed – test passes if no exception is thrown.
    });
  });

  // -------------------------------------------------------------------------
  // Loading skeleton (isLoading: true)
  // -------------------------------------------------------------------------
  group('BisonSwitch – isLoading skeleton', () {
    testWidgets('renders two Containers with skeleton background color', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: false, onChanged: null, isLoading: true),
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

    testWidgets('no AnimatedContainer (no interactive track) when loading', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(value: false, onChanged: null, isLoading: true),
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

    testWidgets('renders three Containers when label is provided', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch(
            value: false,
            onChanged: null,
            isLoading: true,
            label: 'Notifications',
          ),
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

      // track skeleton + label skeleton + label-above skeleton = 3
      expect(containers.length, equals(3));
      for (final c in containers) {
        final decoration = c.decoration! as BoxDecoration;
        expect(decoration.color, equals(theme.miscellaneousSkeletonBackground));
      }
    });

    testWidgets('readOnly switch can also be in loading state', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          const BisonSwitch.readOnly(value: false, isLoading: true),
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
    testWidgets('onChanged fires with current value on tap', (
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

      expect(received, isFalse);
    });

    testWidgets('onChanged fires true when value starts true', (
      final WidgetTester tester,
    ) async {
      bool? received;

      await tester.pumpWidget(
        buildScaffold(BisonSwitch(value: true, onChanged: (v) => received = v)),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();

      expect(received, isTrue);
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

      expect(received, isFalse);
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

      expect(received, isFalse);
    });

    testWidgets('tapping a disabled switch (onChanged null) does not throw', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(const BisonSwitch(value: false, onChanged: null)),
      );

      await tester.tap(find.byType(BisonSwitch));
      await tester.pump();
      // No assertion needed – test passes if no exception is thrown.
    });
  });

  // -------------------------------------------------------------------------
  // Label and onLabel / offLabel
  // -------------------------------------------------------------------------
  group('BisonSwitch - label and onLabel/offLabel', () {
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

    testWidgets('onLabel is rendered when value is true', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: true,
            onChanged: (_) {},
            onLabel: 'On',
            offLabel: 'Off',
          ),
        ),
      );

      expect(find.text('On'), findsOneWidget);
      expect(find.text('Off'), findsNothing);
    });

    testWidgets('offLabel is rendered when value is false', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) {},
            onLabel: 'On',
            offLabel: 'Off',
          ),
        ),
      );

      expect(find.text('Off'), findsOneWidget);
      expect(find.text('On'), findsNothing);
    });

    testWidgets('both label and offLabel render together', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: false,
            onChanged: (_) {},
            label: 'Notifications',
            onLabel: 'On',
            offLabel: 'Off',
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Off'), findsOneWidget);
    });

    testWidgets('track position stays stable when label length changes', (
      final WidgetTester tester,
    ) async {
      var value = false;

      await tester.pumpWidget(
        buildScaffold(
          StatefulBuilder(
            builder: (final context, final setState) {
              return BisonSwitch(
                value: value,
                onChanged: (final currentValue) {
                  setState(() => value = !currentValue);
                },
                onLabel: 'Enabled',
                offLabel: 'Off',
              );
            },
          ),
        ),
      );

      final before = tester.getTopLeft(
        find
            .descendant(
              of: find.byType(BisonSwitch),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );

      await tester.tap(
        find
            .descendant(
              of: find.byType(BisonSwitch),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      await tester.pumpAndSettle();

      // Guard against false positives if the tap target ever changes.
      expect(find.text('Enabled'), findsOneWidget);

      final after = tester.getTopLeft(
        find
            .descendant(
              of: find.byType(BisonSwitch),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );

      expect(after.dx, equals(before.dx));
    });

    testWidgets('long onLabel is truncated with ellipsis', (
      final WidgetTester tester,
    ) async {
      const longLabel =
          'This is a very long state label that should truncate with ellipsis';

      await tester.pumpWidget(
        buildScaffold(
          BisonSwitch(
            value: true,
            onChanged: (_) {},
            onLabel: longLabel,
            offLabel: 'Off',
          ),
        ),
      );

      final labelFinder = find.text(longLabel);
      expect(labelFinder, findsOneWidget);

      final labelWidget = tester.widget<Text>(labelFinder);
      expect(labelWidget.overflow, equals(TextOverflow.ellipsis));
      expect(labelWidget.maxLines, equals(1));

      final labelSize = tester.getSize(labelFinder);
      expect(labelSize.width, greaterThan(0));
      expect(labelSize.height, greaterThan(0));
    });

    testWidgets('label uses textPlain color in interactive state', (
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
