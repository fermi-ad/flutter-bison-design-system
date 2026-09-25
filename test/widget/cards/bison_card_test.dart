import 'package:bison_design_system/bison_design_system.dart'
    show BisonCard, BisonMenu, BisonMenuItem;
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

    testWidgets('tapping the trailing menu icon opens BisonMenu with the '
        'supplied items', (final WidgetTester tester) async {
      var editSelected = false;

      await tester.pumpWidget(
        buildScaffold(
          BisonCard.stackedWithImage(
            avatar: const CircleAvatar(child: Text('A')),
            headerText: 'Header',
            media: Container(color: Colors.grey),
            title: 'Title',
            menuItems: [
              BisonMenuItem(label: 'Edit', onSelect: () => editSelected = true),
              BisonMenuItem(label: 'Delete', onSelect: () {}),
            ],
          ),
        ),
      );

      expect(find.byType(BisonMenu), findsOneWidget);

      // Menu items are not visible until the menu is opened.
      expect(find.text('Edit'), findsNothing);
      expect(find.text('Delete'), findsNothing);

      // Tap the trailing three-dot icon to open the menu.
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Selecting an item invokes its onSelect callback.
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(editSelected, isTrue);
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

  group('BisonCard.horizontalWithImage', () {
    testWidgets('renders header content and media thumbnail', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonCard.horizontalWithImage(
            avatar: const CircleAvatar(child: Text('B')),
            headerText: 'Header',
            subheadText: 'Subhead',
            media: Container(key: const Key('media'), color: Colors.grey),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Subhead'), findsOneWidget);

      final mediaSize = tester.getSize(find.byKey(const Key('media')));
      expect(mediaSize, const Size(80, 80));
    });

    testWidgets('respects narrow parent constraints instead of forcing a '
        '400px width', (final WidgetTester tester) async {
      const parentWidth = 300.0;

      await tester.pumpWidget(
        buildScaffold(
          SizedBox(
            width: parentWidth,
            child: BisonCard.horizontalWithImage(
              avatar: const CircleAvatar(child: Text('B')),
              headerText: 'Header',
            ),
          ),
        ),
      );

      final cardSize = tester.getSize(find.byType(BisonCard));
      expect(cardSize.width, lessThanOrEqualTo(parentWidth));
      expect(cardSize.height, 120);
      expect(tester.takeException(), isNull);
    });

    testWidgets('caps its width at 400 in wide parents', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonCard.horizontalWithImage(
            avatar: const CircleAvatar(child: Text('B')),
            headerText: 'Header',
          ),
        ),
      );

      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .descendant(
              of: find.byType(BisonCard),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(constrainedBox.constraints.maxWidth, 400);
    });
  });
}
