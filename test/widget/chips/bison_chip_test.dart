import 'package:bison_design_system/bison_design_system.dart' show BisonChip;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

Color? _getChipBackgroundColor(WidgetTester tester) {
  final container = tester.widget<Container>(find.byType(Container).first);
  final decoration = container.decoration as BoxDecoration;
  return decoration.color;
}

void main() {
  group('BisonChip', () {
    testWidgets(
      'filter chip background differs between selected and unselected',
      (final WidgetTester tester) async {
        await tester.pumpWidget(
          buildScaffold(const BisonChip.filter(label: 'Test', selected: false)),
        );
        final unselectedColor = _getChipBackgroundColor(tester);

        await tester.pumpWidget(
          buildScaffold(const BisonChip.filter(label: 'Test', selected: true)),
        );
        final selectedColor = _getChipBackgroundColor(tester);

        expect(selectedColor, isNot(equals(unselectedColor)));
      },
    );

    testWidgets(
      'input chip background differs between selected and unselected',
      (final WidgetTester tester) async {
        await tester.pumpWidget(
          buildScaffold(const BisonChip.input(label: 'Test', selected: false)),
        );
        final unselectedColor = _getChipBackgroundColor(tester);

        await tester.pumpWidget(
          buildScaffold(const BisonChip.input(label: 'Test', selected: true)),
        );
        final selectedColor = _getChipBackgroundColor(tester);

        expect(selectedColor, isNot(equals(unselectedColor)));
      },
    );

    testWidgets(
      'suggestion chip background differs between selected and unselected',
      (final WidgetTester tester) async {
        await tester.pumpWidget(
          buildScaffold(
            const BisonChip.suggestion(label: 'Test', selected: false),
          ),
        );
        final unselectedColor = _getChipBackgroundColor(tester);

        await tester.pumpWidget(
          buildScaffold(
            const BisonChip.suggestion(label: 'Test', selected: true),
          ),
        );
        final selectedColor = _getChipBackgroundColor(tester);

        expect(selectedColor, isNot(equals(unselectedColor)));
      },
    );
  });
}
