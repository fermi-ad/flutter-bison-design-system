import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonDialog, BisonDialogAction, BisonThemeTokens;

import '../common.dart' show buildScaffold;

void main() {
  group('BisonDialog widget', () {
    testWidgets('renders title, body, and all three typed action roles', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonDialog(
            title: 'Confirm delete',
            body: 'This action cannot be undone.',
            destructiveAction: BisonDialogAction(
              label: 'Delete',
              onPressed: () {},
            ),
            secondaryAction: BisonDialogAction(
              label: 'Archive',
              onPressed: () {},
            ),
            primaryAction: BisonDialogAction(label: 'Cancel', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Confirm delete'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Archive'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('uses tokenized surface styling', (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonDialog(
            title: 'Dialog title',
            body: 'Dialog body',
            primaryAction: BisonDialogAction(label: 'Okay', onPressed: () {}),
          ),
        ),
      );

      final surfaceFinder = find.byKey(
        const ValueKey<String>('bison-dialog-surface'),
      );
      final decoratedBox = tester.widget<DecoratedBox>(surfaceFinder);
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(decoration.color, equals(theme.surfaceDefault));
      expect(decoration.border?.top.color, equals(theme.borderPlain));
    });
  });

  group('BisonDialog.show', () {
    testWidgets('shows above the view and dismisses from barrier tap', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          Builder(
            builder: (final context) {
              return FilledButton(
                onPressed: () {
                  BisonDialog.show(
                    context: context,
                    title: 'Dialog title',
                    body: 'Dialog body',
                    primaryAction: BisonDialogAction(
                      label: 'Okay',
                      onPressed: () {},
                    ),
                  );
                },
                child: const Text('Open dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open dialog'));
      await tester.pump();

      expect(find.byType(BisonDialog), findsOneWidget);

      expect(
        find.byKey(const ValueKey<String>('bison-dialog-barrier')),
        findsOneWidget,
      );

      await tester.tapAt(const Offset(16, 16));
      await tester.pump();

      expect(find.byType(BisonDialog), findsNothing);
    });

    testWidgets('runs action callback and dismisses by default', (
      final WidgetTester tester,
    ) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        buildScaffold(
          Builder(
            builder: (final context) {
              return FilledButton(
                onPressed: () {
                  BisonDialog.show(
                    context: context,
                    title: 'Save changes',
                    body: 'Apply the pending updates?',
                    primaryAction: BisonDialogAction(
                      label: 'Save',
                      onPressed: () {
                        callbackCalled = true;
                      },
                    ),
                  );
                },
                child: const Text('Open dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open dialog'));
      await tester.pump();

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(callbackCalled, isTrue);
      expect(find.byType(BisonDialog), findsNothing);
    });
  });
}
