import 'package:bison_design_system/bison_design_system.dart'
    show BisonCheckboxGroup, BisonCheckboxGroupItem, BisonCheckboxValue;
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

void main() {
  group('BisonCheckboxGroup', () {
    testWidgets('tapping item label triggers onChanged with item index', (
      final WidgetTester tester,
    ) async {
      int? changedIndex;
      BisonCheckboxValue? changedValue;

      await tester.pumpWidget(
        buildScaffold(
          BisonCheckboxGroup(
            items: const [
              BisonCheckboxGroupItem(
                label: 'Alpha',
                value: BisonCheckboxValue.unselected,
              ),
              BisonCheckboxGroupItem(
                label: 'Beta',
                value: BisonCheckboxValue.selected,
              ),
            ],
            onChanged: (index, currentValue) {
              changedIndex = index;
              changedValue = currentValue;
            },
          ),
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pump();

      expect(changedIndex, 1);
      expect(changedValue, BisonCheckboxValue.selected);
    });

    testWidgets('disabled item label does not trigger onChanged', (
      final WidgetTester tester,
    ) async {
      int callCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonCheckboxGroup(
            items: const [
              BisonCheckboxGroupItem(
                label: 'Alpha',
                value: BisonCheckboxValue.unselected,
              ),
              BisonCheckboxGroupItem(
                label: 'Beta',
                value: BisonCheckboxValue.selected,
                enabled: false,
              ),
            ],
            onChanged: (_, _) {
              callCount += 1;
            },
          ),
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pump();

      expect(callCount, 0);
    });
  });
}
