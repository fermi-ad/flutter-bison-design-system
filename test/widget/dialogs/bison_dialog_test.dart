import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonContext,
        BisonDialog,
        BisonDialogAction,
        BisonThemeData,
        BisonThemeTokens,
        BisonTokens;

import '../common.dart' show buildScaffold, getButtonStyle;

class _ThemeSwitchingDialogHost extends StatefulWidget {
  final String title;
  final String body;

  const _ThemeSwitchingDialogHost({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  State<_ThemeSwitchingDialogHost> createState() =>
      _ThemeSwitchingDialogHostState();
}

class _ThemeSwitchingDialogHostState extends State<_ThemeSwitchingDialogHost> {
  bool _isDarkTheme = false;

  void setDarkTheme(final bool isDarkTheme) {
    setState(() {
      _isDarkTheme = isDarkTheme;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      theme: BisonThemeData.light(),
      darkTheme: BisonThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (final dialogContext) {
              return FilledButton(
                onPressed: () {
                  BisonDialog.show(
                    context: dialogContext,
                    title: widget.title,
                    body: (_) => Text(widget.body),
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
      ),
    );
  }
}

Widget _buildWidgetbookLikeDialogBody(final BisonTokens bison) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            'Alarm Type:',
            style: TextStyle(color: bison.theme.textDisabled),
          ),
          const Spacer(),
          const Text('Normal', textAlign: TextAlign.end),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Text('Status:', style: TextStyle(color: bison.theme.textDisabled)),
          const Spacer(),
          const Text('Active', textAlign: TextAlign.end),
        ],
      ),
      const SizedBox(height: 8),
      Divider(thickness: 1.0, color: bison.theme.textDisabled),
      Row(
        children: [
          Text('Reading:', style: TextStyle(color: bison.theme.textDisabled)),
          const Spacer(),
          const Text('0.1240 mm', textAlign: TextAlign.end),
        ],
      ),
    ],
  );
}

class _WidgetbookLikeDialogHost extends StatefulWidget {
  const _WidgetbookLikeDialogHost({super.key});

  @override
  State<_WidgetbookLikeDialogHost> createState() =>
      _WidgetbookLikeDialogHostState();
}

class _WidgetbookLikeDialogHostState extends State<_WidgetbookLikeDialogHost> {
  bool _isDarkTheme = false;

  void setDarkTheme(final bool isDarkTheme) {
    setState(() {
      _isDarkTheme = isDarkTheme;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      theme: BisonThemeData.light(),
      darkTheme: BisonThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (final dialogContext) {
              return FilledButton(
                onPressed: () {
                  BisonDialog.show(
                    context: dialogContext,
                    title: 'Dialog title',
                    body: (context) =>
                        _buildWidgetbookLikeDialogBody(context.bison),
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
      ),
    );
  }
}

class _NestedThemeDialogHost extends StatefulWidget {
  const _NestedThemeDialogHost({super.key});

  @override
  State<_NestedThemeDialogHost> createState() => _NestedThemeDialogHostState();
}

class _NestedThemeDialogHostState extends State<_NestedThemeDialogHost> {
  bool _isDarkTheme = false;

  void setDarkTheme(final bool isDarkTheme) {
    setState(() {
      _isDarkTheme = isDarkTheme;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MaterialApp(
        theme: BisonThemeData.light(),
        darkTheme: BisonThemeData.dark(),
        themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (final dialogContext) {
                return FilledButton(
                  onPressed: () {
                    BisonDialog.show(
                      context: dialogContext,
                      title: 'Nested theme dialog',
                      body: (_) => Text('Nested body'),
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
        ),
      ),
    );
  }
}

void main() {
  group('BisonDialog widget', () {
    testWidgets('renders title, body, and all three typed action roles', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildScaffold(
          BisonDialog(
            title: 'Confirm delete',
            body: (context) => Text('This action cannot be undone.'),
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
            body: (context) => Text('Dialog body'),
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
                    body: (_) => Text('Dialog body'),
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
                    body: (_) => Text('Apply the pending updates?'),
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
                    body: (_) => Text('Dialog body'),
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

    testWidgets('updates dialog theme while open when app theme changes', (
      final WidgetTester tester,
    ) async {
      final hostKey = GlobalKey<_ThemeSwitchingDialogHostState>();
      const titleText = 'Theme test dialog title';
      const bodyText = 'Theme test dialog body';

      await tester.pumpWidget(
        _ThemeSwitchingDialogHost(
          key: hostKey,
          title: titleText,
          body: bodyText,
        ),
      );

      await tester.tap(find.text('Open dialog'));
      await tester.pumpAndSettle();

      final surfaceFinder = find.byKey(
        const ValueKey<String>('bison-dialog-surface'),
      );

      BoxDecoration getSurfaceDecoration() {
        return tester.widget<DecoratedBox>(surfaceFinder).decoration
            as BoxDecoration;
      }

      Color? getEffectiveTextColor(final String text) {
        final textFinder = find.text(text);
        final textWidget = tester.widget<Text>(textFinder);
        final textElement = tester.element(textFinder);
        return DefaultTextStyle.of(
          textElement,
        ).style.merge(textWidget.style).color;
      }

      expect(
        getSurfaceDecoration().color,
        equals(BisonThemeTokens.light().surfaceDefault),
      );
      expect(
        getEffectiveTextColor(titleText),
        equals(BisonThemeTokens.light().textPlain),
      );
      expect(
        getEffectiveTextColor(bodyText),
        equals(BisonThemeTokens.light().textPlain),
      );

      hostKey.currentState!.setDarkTheme(true);
      await tester.pumpAndSettle();

      expect(find.byType(BisonDialog), findsOneWidget);
      expect(
        getSurfaceDecoration().color,
        equals(BisonThemeTokens.dark().surfaceDefault),
      );
      expect(
        getEffectiveTextColor(titleText),
        equals(BisonThemeTokens.dark().textPlain),
      );
      expect(
        getEffectiveTextColor(bodyText),
        equals(BisonThemeTokens.dark().textPlain),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(BisonDialog), findsNothing);
    });

    testWidgets(
      'tracks inner themed subtree when nested material apps toggle',
      (final WidgetTester tester) async {
        final hostKey = GlobalKey<_NestedThemeDialogHostState>();

        await tester.pumpWidget(_NestedThemeDialogHost(key: hostKey));

        await tester.tap(find.text('Open dialog'));
        await tester.pumpAndSettle();

        final surfaceFinder = find.byKey(
          const ValueKey<String>('bison-dialog-surface'),
        );

        BoxDecoration getSurfaceDecoration() {
          return tester.widget<DecoratedBox>(surfaceFinder).decoration
              as BoxDecoration;
        }

        expect(
          getSurfaceDecoration().color,
          equals(BisonThemeTokens.light().surfaceDefault),
        );

        hostKey.currentState!.setDarkTheme(true);
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsOneWidget);
        expect(
          getSurfaceDecoration().color,
          equals(BisonThemeTokens.dark().surfaceDefault),
        );

        hostKey.currentState!.setDarkTheme(false);
        await tester.pumpAndSettle();

        expect(
          getSurfaceDecoration().color,
          equals(BisonThemeTokens.light().surfaceDefault),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsNothing);
      },
    );

    testWidgets(
      'widgetbook-like body with snapshot tokens now updates colors on theme change',
      (final WidgetTester tester) async {
        final hostKey = GlobalKey<_WidgetbookLikeDialogHostState>();

        await tester.pumpWidget(_WidgetbookLikeDialogHost(key: hostKey));

        await tester.tap(find.text('Open dialog'));
        await tester.pumpAndSettle();

        Color? getEffectiveTextColor(final String text) {
          final textFinder = find.text(text);
          final textWidget = tester.widget<Text>(textFinder);
          final textElement = tester.element(textFinder);
          return DefaultTextStyle.of(
            textElement,
          ).style.merge(textWidget.style).color;
        }

        expect(
          getEffectiveTextColor('Dialog title'),
          equals(BisonThemeTokens.light().textPlain),
        );
        expect(
          getEffectiveTextColor('Alarm Type:'),
          equals(BisonThemeTokens.light().textDisabled),
        );
        expect(
          getEffectiveTextColor('Normal'),
          equals(BisonThemeTokens.light().textPlain),
        );

        hostKey.currentState!.setDarkTheme(true);
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsOneWidget);
        expect(
          getEffectiveTextColor('Dialog title'),
          equals(BisonThemeTokens.dark().textPlain),
        );
        expect(
          getEffectiveTextColor('Normal'),
          equals(BisonThemeTokens.dark().textPlain),
        );

        expect(
          getEffectiveTextColor('Alarm Type:'),
          equals(BisonThemeTokens.dark().textDisabled),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsNothing);
      },
    );

    testWidgets('auto focuses primary action on open', (
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
                    body: (_) => Text('Dialog body'),
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
                        body: (_) => Text('Dialog body'),
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
                      body: (_) => Text('Dialog body'),
                      primaryAction: BisonDialogAction(
                        label: 'Okay',
                        onPressed: () {},
                      ),
                    );
                    BisonDialog.show(
                      context: context,
                      title: 'Dialog title',
                      body: (_) => Text('Dialog body'),
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

        // dismiss dialog
        await tester.tapAt(const Offset(16, 16));
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsNothing);
      },
    );
  });

  group('BisonDialog buttons with null callbacks', () {
    testWidgets(
      'Primary action with null callback does not dismiss and is disabled',
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
                      body: (_) => Text('Dialog body'),
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

        // Dismiss dialog
        await tester.tapAt(const Offset(16, 16));
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsNothing);
      },
    );

    testWidgets(
      'Destructive action with null callback does not dismiss and is disabled',
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
                      body: (_) => Text('Dialog body'),
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

        final destructiveActionFinder = find.ancestor(
          of: find.descendant(
            of: find.byType(BisonDialog),
            matching: find.text('Delete'),
          ),
          matching: find.byType(FilledButton),
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

        // dismiss dialog
        await tester.tapAt(const Offset(16, 16));
        await tester.pumpAndSettle();

        expect(find.byType(BisonDialog), findsNothing);
      },
    );
  });
}
