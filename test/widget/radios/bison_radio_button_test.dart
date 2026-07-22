import 'package:bison_design_system/bison_design_system.dart'
    show BisonRadioButton, BisonThemeTokens;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

void main() {
  group('BisonRadioButton', () {
    testWidgets('selected interactive uses plain selector ring and dot', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(BisonRadioButton(selected: true, onChanged: (_) {})),
      );

      final outerCircle = tester.widget<Container>(
        find.byKey(const Key('bison_radio_outer_circle')),
      );
      final innerDot = tester.widget<Container>(
        find.byKey(const Key('bison_radio_inner_dot')),
      );

      final BoxDecoration outerDecoration =
          outerCircle.decoration! as BoxDecoration;
      final Border border = outerDecoration.border! as Border;
      final BoxDecoration dotDecoration = innerDot.decoration! as BoxDecoration;

      expect(border.top.color, equals(theme.selectorSelectorPlain));
      expect(dotDecoration.color, equals(theme.selectorSelectorPlain));
    });

    testWidgets('disabled uses disabled selector colors', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonRadioButton(selected: true, onChanged: null)),
      );

      final outerCircle = tester.widget<Container>(
        find.byKey(const Key('bison_radio_outer_circle')),
      );
      final innerDot = tester.widget<Container>(
        find.byKey(const Key('bison_radio_inner_dot')),
      );

      final BoxDecoration outerDecoration =
          outerCircle.decoration! as BoxDecoration;
      final Border border = outerDecoration.border! as Border;
      final BoxDecoration dotDecoration = innerDot.decoration! as BoxDecoration;

      expect(border.top.color, equals(theme.selectorSelectorDisabled));
      expect(dotDecoration.color, equals(theme.selectorSelectorDisabled));
    });

    testWidgets('focused state uses primary focus border', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildScaffold(
          BisonRadioButton(
            selected: false,
            onChanged: (_) {},
            focusNode: focusNode,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      final focusLayer = tester.widget<Container>(
        find.byKey(const Key('bison_radio_focus_layer')),
      );
      final BoxDecoration decoration = focusLayer.decoration! as BoxDecoration;
      final Border border = decoration.border! as Border;

      expect(border.top.color, equals(theme.borderPrimary));

      focusNode.dispose();
    });

    testWidgets('space triggers onChanged for unselected radio only', (
      final WidgetTester tester,
    ) async {
      int callCount = 0;
      bool selected = false;

      Future<void> pump() async {
        await tester.pumpWidget(
          buildScaffold(
            BisonRadioButton(
              autofocus: true,
              selected: selected,
              onChanged: (final currentValue) {
                callCount += 1;
                selected = !currentValue;
              },
            ),
          ),
        );
      }

      await pump();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      await pump();

      expect(callCount, 1);
      expect(selected, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      await pump();

      expect(callCount, 1);
      expect(selected, isTrue);
    });

    testWidgets('enter does not trigger onChanged', (
      final WidgetTester tester,
    ) async {
      int callCount = 0;
      bool selected = false;

      Future<void> pump() async {
        await tester.pumpWidget(
          buildScaffold(
            BisonRadioButton(
              autofocus: true,
              selected: selected,
              onChanged: (final currentValue) {
                callCount += 1;
                selected = !currentValue;
              },
            ),
          ),
        );
      }

      await pump();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await pump();

      expect(callCount, 0);
      expect(selected, isFalse);
    });
  });
}
