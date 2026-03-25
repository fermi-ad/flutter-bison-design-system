import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

void main() {
  group('BisonChip.object style', () {
    testWidgets('normal style uses expected default colors', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonChip.object(
            label: 'Object chip',
            objectChipStyle: ObjectChipStyle.normal,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(BisonChip),
          matching: find.byType(Container),
        ),
      );

      final BoxDecoration decoration = container.decoration! as BoxDecoration;
      final Border border = decoration.border! as Border;
      final Text text = tester.widget<Text>(find.text('Object chip'));
      final IconTheme iconTheme = tester.widget<IconTheme>(
        find.byType(IconTheme),
      );

      expect(decoration.color, equals(theme.chipUnselectedActive));
      expect(border.top.color, equals(theme.borderPlain));
      expect(text.style?.color, equals(theme.textPlain));
      expect(iconTheme.data.color, equals(theme.textPlain));
    });

    testWidgets('warning style uses expected default colors', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonChip.object(
            label: 'Warning chip',
            objectChipStyle: ObjectChipStyle.warning,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(BisonChip),
          matching: find.byType(Container),
        ),
      );

      final BoxDecoration decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, equals(theme.chipWarningActive));
    });

    testWidgets('danger style uses expected default colors', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonChip.object(
            label: 'Danger chip',
            objectChipStyle: ObjectChipStyle.danger,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(BisonChip),
          matching: find.byType(Container),
        ),
      );

      final BoxDecoration decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, equals(theme.chipDangerActive));
    });

    testWidgets('disabled warning style uses disabled background and text', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          const BisonChip.object(
            label: 'Disabled warning',
            objectChipStyle: ObjectChipStyle.warning,
            enabled: false,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(BisonChip),
          matching: find.byType(Container),
        ),
      );

      final BoxDecoration decoration = container.decoration! as BoxDecoration;
      final Text text = tester.widget<Text>(find.text('Disabled warning'));
      final IconTheme iconTheme = tester.widget<IconTheme>(
        find.byType(IconTheme),
      );

      expect(decoration.color, equals(theme.chipWarningDisabled));
      expect(text.style?.color, equals(theme.textDisabled));
      expect(iconTheme.data.color, equals(theme.textDisabled));
    });
  });
}
