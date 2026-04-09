import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonDialog, BisonDialogAction, BisonThemeTokens;

import '../common.dart' show buildScaffold, getButtonStyle;

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
      expect(decoration.border?.top.style, equals(BorderStyle.none));
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

      expect(find.byKey(const ValueKey<String>('bison-scrim')), findsOneWidget);

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

    testWidgets('dismisses on escape key press', (
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

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.byType(BisonDialog), findsNothing);
    });

    testWidgets('autofocuses primary action on open', (
      final WidgetTester tester,
    ) async {
      bool primaryPressed = false;

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
                    secondaryAction: BisonDialogAction(
                      label: 'Secondary',
                      onPressed: () {},
                    ),
                    primaryAction: BisonDialogAction(
                      label: 'Primary',
                      onPressed: () {
                        primaryPressed = true;
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

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(primaryPressed, isTrue);
      expect(find.byType(BisonDialog), findsNothing);
    });

    testWidgets('tab traversal stays within dialog actions', (
      final WidgetTester tester,
    ) async {
      final backgroundFocusNode = FocusNode(debugLabel: 'background-focus');
      final openDialogFocusNode = FocusNode(debugLabel: 'open-dialog-focus');
      addTearDown(backgroundFocusNode.dispose);
      addTearDown(openDialogFocusNode.dispose);

      await tester.pumpWidget(
        buildScaffold(
          Column(
            children: [
              FilledButton(
                focusNode: backgroundFocusNode,
                onPressed: () {},
                child: const Text('Background action'),
              ),
              Builder(
                builder: (final context) {
                  return FilledButton(
                    focusNode: openDialogFocusNode,
                    onPressed: () {
                      BisonDialog.show(
                        context: context,
                        title: 'Dialog title',
                        body: 'Dialog body',
                        destructiveAction: BisonDialogAction(
                          label: 'Delete',
                          onPressed: () {},
                        ),
                        secondaryAction: BisonDialogAction(
                          label: 'Cancel',
                          onPressed: () {},
                        ),
                        primaryAction: BisonDialogAction(
                          label: 'Confirm',
                          onPressed: () {},
                        ),
                      );
                    },
                    child: const Text('Open dialog'),
                  );
                },
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Open dialog'));
      await tester.pump();

      for (int i = 0; i < 8; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }

      expect(backgroundFocusNode.hasFocus, isFalse);
      expect(openDialogFocusNode.hasFocus, isFalse);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();

      expect(backgroundFocusNode.hasFocus, isFalse);
      expect(openDialogFocusNode.hasFocus, isFalse);
      expect(find.byType(BisonDialog), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.byType(BisonDialog), findsNothing);
    });

    testWidgets(
      'does not stack multiple dialogs when show is called repeatedly',
      (final WidgetTester tester) async {
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
          find.byKey(const ValueKey<String>('bison-scrim')),
          findsOneWidget,
        );
      },
    );
  });

  group('BisonDialog buttons with null callbacks', () {
    testWidgets(
      'Primary action with null callback does not dissmiss and is disabled',
      (WidgetTester tester) async {
        final theme = BisonThemeTokens.light();

        await tester.pumpWidget(
          buildScaffold(
            Builder(
              builder: (final context) {
                return ElevatedButton(
                  onPressed: () {
                    BisonDialog.show(
                      context: context,
                      title: 'Dialog title',
                      body: 'Dialog body',
                      primaryAction: BisonDialogAction(
                        label: 'Okay',
                        onPressed: null,
                      ),
                    );
                  },
                  child: const Text('Open dialog'),
                );
              },
            ),
          ),
        );
        // open dialog
        final openButton = find.text('Open dialog');
        await tester.tap(openButton);
        await tester.pumpAndSettle();

        final primaryActionFinder = find.byType(FilledButton);
        // get state of primary button
        final primaryButton = tester.widget<FilledButton>(primaryActionFinder);
        final style = getButtonStyle(
          tester.element(primaryActionFinder),
          primaryButton,
        );
        final background = style.backgroundColor?.resolve(<WidgetState>{
          WidgetState.disabled,
        });
        expect(
          background,
          equals(theme.buttonGhostDisabled),
          reason: 'Primary action button should be disabled',
        );

        // tap disabled button
        await tester.tap(primaryActionFinder);
        await tester.pump();

        expect(
          find.byType(BisonDialog),
          findsOneWidget,
          reason: 'Dialog should still be visible',
        );
      },
    );

    testWidgets(
      'Destructive action with null callback does not dissmiss and is disabled',
      (WidgetTester tester) async {
        final theme = BisonThemeTokens.light();

        await tester.pumpWidget(
          buildScaffold(
            Builder(
              builder: (final context) {
                return ElevatedButton(
                  onPressed: () {
                    BisonDialog.show(
                      context: context,
                      title: 'Dialog title',
                      body: 'Dialog body',
                      primaryAction: BisonDialogAction(
                        label: 'Okay',
                        onPressed: null,
                      ),
                      destructiveAction: BisonDialogAction(
                        label: 'Delete',
                        onPressed: null,
                      ),
                    );
                  },
                  child: const Text('Open dialog'),
                );
              },
            ),
          ),
        );
        // open dialog
        final openButton = find.text('Open dialog');
        await tester.tap(openButton);
        await tester.pumpAndSettle();

        final destructiveActionFinder = find.descendant(
          of: find.byType(BisonDialog),
          matching: find.widgetWithText(FilledButton, 'Delete'),
        );
        // get state of destructive button
        final destructiveButton = tester.widget<FilledButton>(
          destructiveActionFinder,
        );
        final style = getButtonStyle(
          tester.element(destructiveActionFinder),
          destructiveButton,
        );
        final background = style.backgroundColor?.resolve(<WidgetState>{
          WidgetState.disabled,
        });
        expect(
          background,
          equals(theme.buttonGhostDisabled),
          reason: 'Destructive action button should be disabled',
        );

        // tap disabled button
        await tester.tap(destructiveActionFinder);
        await tester.pump();

        expect(
          find.byType(BisonDialog),
          findsOneWidget,
          reason: 'Dialog should still be visible',
        );
      },
    );
  });
}
