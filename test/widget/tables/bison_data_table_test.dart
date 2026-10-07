import 'package:bison_design_system/core_widgets.dart' show BisonDataTable;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../common.dart' show buildScaffold;

void main() {
  const headers = ['Name', 'Status'];
  const rows = [
    ['Alpha', 'Active'],
    ['Beta', 'Inactive'],
  ];

  testWidgets('renders the table content and pagination details', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildScaffold(
        const BisonDataTable(
          title: 'Projects',
          description: 'Project status',
          headers: headers,
          rows: rows,
          totalItems: 150,
          currentPage: 2,
          totalPages: 2,
        ),
      ),
    );

    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Project status'), findsOneWidget);
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);
    expect(find.text('101 - 150 of 150 items'), findsOneWidget);
    expect(find.text('2  of 2 pages'), findsOneWidget);
  });

  testWidgets('invokes supplied table actions', (
    final WidgetTester tester,
  ) async {
    var searches = 0;
    var nextPages = 0;

    await tester.pumpWidget(
      buildScaffold(
        BisonDataTable(
          headers: headers,
          rows: rows,
          onSearch: () => searches++,
          onNextPage: () => nextPages++,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.tap(find.byIcon(Icons.chevron_right));

    expect(searches, 1);
    expect(nextPages, 1);
  });

  testWidgets('selects a page size from the pagination menu', (
    final WidgetTester tester,
  ) async {
    var selectedPageSize = 0;

    await tester.pumpWidget(
      buildScaffold(
        BisonDataTable(
          headers: headers,
          rows: rows,
          pageSize: 100,
          pageSizeOptions: const [25, 50, 100],
          onPageSizeChanged: (pageSize) => selectedPageSize = pageSize,
        ),
      ),
    );

    await tester.tap(find.text('100'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, '25'));
    await tester.pumpAndSettle();

    expect(selectedPageSize, 25);
  });
}
