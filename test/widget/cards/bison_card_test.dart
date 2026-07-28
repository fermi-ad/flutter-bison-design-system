import 'package:bison_design_system/bison_design_system.dart' show BisonCard;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart' show buildScaffold;

void main() {
  group('BisonCard', () {
    testWidgets('renders required content', (final WidgetTester tester) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonCard.stackedWithImage(
            avatar: const CircleAvatar(child: Text('A')),
            headerText: 'Header',
            media: Container(color: Colors.grey),
            title: 'Title',
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('hides optional fields when null', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonCard.stackedWithImage(
            avatar: const CircleAvatar(child: Text('A')),
            headerText: 'Header',
            media: Container(color: Colors.grey),
            title: 'Title',
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });
  });
}
