import 'package:bison_design_system/bison_design_system.dart'
    show BisonThemeTokens, BisonCheckbox, BisonCheckboxValue;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

void main() {
  group('BisonCheckbox', () {
    testWidgets('selected enabled uses plain selector fill and check color', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(const BisonCheckbox(value: BisonCheckboxValue.selected)),
      );

      final container = tester.widget<Container>(
        find.byKey(const Key('bison_checkbox_container')),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.check));

      final BoxDecoration decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, equals(theme.selectorSelectorPlain));
      expect(icon.color, equals(theme.selectorSelectorCheckboxCheck));
    });

    testWidgets('unselected disabled uses disabled selector border', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonCheckbox(
            value: BisonCheckboxValue.unselected,
            enabled: false,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byKey(const Key('bison_checkbox_container')),
      );

      final BoxDecoration decoration = container.decoration! as BoxDecoration;
      final Border border = decoration.border! as Border;

      expect(decoration.color, equals(theme.surfaceTransparent));
      expect(border.top.color, equals(theme.selectorSelectorDisabled));
    });

    testWidgets('focused state uses primary focus border on state layer', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildScaffold(
          BisonCheckbox(
            value: BisonCheckboxValue.selected,
            onChanged: (_) {},
            focusNode: focusNode,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      final stateLayer = tester.widget<Container>(
        find.byKey(const Key('bison_checkbox_state_layer')),
      );
      final BoxDecoration decoration = stateLayer.decoration! as BoxDecoration;
      final Border border = decoration.border! as Border;

      expect(border.top.color, equals(theme.borderPrimary));

      focusNode.dispose();
    });

    testWidgets('space and enter toggle selection when focused', (
      final WidgetTester tester,
    ) async {
      BisonCheckboxValue value = BisonCheckboxValue.unselected;

      Future<void> pump() async {
        await tester.pumpWidget(
          buildScaffold(
            BisonCheckbox(
              autofocus: true,
              value: value,
              onChanged: (final next) {
                value = next;
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

      expect(value, BisonCheckboxValue.selected);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await pump();

      expect(value, BisonCheckboxValue.unselected);
    });
  });
}
