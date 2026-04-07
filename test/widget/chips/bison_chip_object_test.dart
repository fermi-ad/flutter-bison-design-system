import 'package:bison_design_system/bison_design_system.dart'
    show BisonThemeTokens, BisonChip, ObjectChipStyle;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final DefaultTextStyle defaultTextStyle = tester.widget<DefaultTextStyle>(
        find
            .descendant(
              of: find.byType(BisonChip),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      final IconTheme iconTheme = tester
          .widgetList<IconTheme>(
            find.descendant(
              of: find.byType(BisonChip),
              matching: find.byType(IconTheme),
            ),
          )
          .firstWhere((final iconTheme) => iconTheme.data.color != null);

      expect(decoration.color, equals(theme.chipUnselectedActive));
      expect(border.top.color, equals(theme.borderPlain));
      expect(defaultTextStyle.style.color, equals(theme.textPlain));
      expect(iconTheme.data.color, equals(theme.iconPlain));
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
      final DefaultTextStyle defaultTextStyle = tester.widget<DefaultTextStyle>(
        find
            .descendant(
              of: find.byType(BisonChip),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      final IconTheme iconTheme = tester
          .widgetList<IconTheme>(
            find.descendant(
              of: find.byType(BisonChip),
              matching: find.byType(IconTheme),
            ),
          )
          .firstWhere((final iconTheme) => iconTheme.data.color != null);

      expect(decoration.color, equals(theme.chipWarningDisabled));
      expect(defaultTextStyle.style.color, equals(theme.textDisabled));
      expect(iconTheme.data.color, equals(theme.iconDisabled));
    });

    testWidgets('enter and space trigger the left action when focused', (
      final WidgetTester tester,
    ) async {
      var pressedCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonChip.object(
            label: 'Keyboard chip',
            onLeftPressed: () => pressedCount++,
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(pressedCount, 2);
    });
  });
}
