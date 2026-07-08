import 'package:bison_design_system/bison_design_system.dart'
    show BisonRadioGroup, BisonRadioGroupItem;
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

void main() {
  group('BisonRadioGroup', () {
    testWidgets('tapping item label selects that item', (
      final WidgetTester tester,
    ) async {
      int selectedIndex = 0;

      Future<void> pump() async {
        await tester.pumpWidget(
          buildScaffold(
            BisonRadioGroup(
              selectedIndex: selectedIndex,
              items: const [
                BisonRadioGroupItem(label: 'Alpha'),
                BisonRadioGroupItem(label: 'Beta'),
              ],
              onChanged: (index) {
                selectedIndex = index;
              },
            ),
          ),
        );
      }

      await pump();
      await tester.tap(find.text('Beta'));
      await tester.pump();
      await pump();

      expect(selectedIndex, 1);
    });

    testWidgets('disabled item label does not trigger onChanged', (
      final WidgetTester tester,
    ) async {
      int callCount = 0;

      await tester.pumpWidget(
        buildScaffold(
          BisonRadioGroup(
            selectedIndex: 0,
            items: const [
              BisonRadioGroupItem(label: 'Alpha'),
              BisonRadioGroupItem(label: 'Beta', enabled: false),
            ],
            onChanged: (_) {
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
