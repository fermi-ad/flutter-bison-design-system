import 'package:bison_design_system/bison_design_system.dart'
    show BisonCard, BisonMenuItem;
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

    testWidgets('shows trailing icon button and actions when provided', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonCard.stackedWithImage(
            avatar: const CircleAvatar(child: Text('A')),
            headerText: 'Header',
            media: Container(color: Colors.grey),
            title: 'Title',
            menuItems: [BisonMenuItem(label: 'Edit', onSelect: () {})],
            primaryAction: TextButton(
              onPressed: () {},
              child: const Text('Action'),
            ),
            secondaryAction: TextButton(
              onPressed: () {},
              child: const Text('Cancel'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Action'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    });

    testWidgets('hides trailing icon button and actions when not provided', (
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
