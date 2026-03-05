import 'package:flutter_test/flutter_test.dart';
import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';
import '../common.dart';

void main() {
  group("Testing callback function", () {
    testWidgets("Disabled BisonIconButton should not call function", (
      final WidgetTester tester,
    ) async {
      final bool callbackCalled = false;

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: null),
        ),
      );

      final buttonFinder = find.byType(BisonIconButton);
      await tester.tap(buttonFinder);

      expect(callbackCalled, isFalse);
    });

    testWidgets("tapping button will trigger callback", (
      final WidgetTester tester,
    ) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(
            icon: Icon(Icons.add),
            onPressed: () => callbackCalled = true,
          ),
        ),
      );

      final buttonFinder = find.byType(BisonIconButton);
      await tester.tap(buttonFinder);

      expect(callbackCalled, isTrue);
    });
  });

  group("Testing BisonIconButton default state styling - light mode", () {
    testWidgets("Styling test for BisonIconButton.filled", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{});
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{});

      expect(background, equals(theme.buttonPrimary));
      expect(foreground, equals(theme.iconInverse));
    });
    testWidgets("Styling test for BisonIconButton.outlined", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.outlined(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{});
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{});
      final outline = buttonStyle.side?.resolve(<WidgetState>{});

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPrimary));
      expect(outline!.color, equals(theme.borderPlain));
    });
    testWidgets("Styling test for BisonIconButton.ghost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.ghost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{});
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{});

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPlain));
    });
    testWidgets("Styling test for BisonIconButton.whiteGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.whiteGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{});
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{});

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconWhiteFixed));
    });
    testWidgets("Styling test for BisonIconButton.smallGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.smallGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{});
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{});

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPlain));
    });
    testWidgets("padding test for BisonIconButton.filled", (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final padding = buttonStyle.padding?.resolve(<WidgetState>{});

      expect(padding, equals(EdgeInsets.all(spacing.tinySpacing)));
    });
    testWidgets("padding test for BisonIconButton.smallGhost", (
      final WidgetTester tester,
    ) async {
      final spacing = BisonSpacingTokens.standard();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.smallGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final padding = buttonStyle.padding?.resolve(<WidgetState>{});

      expect(padding, equals(EdgeInsets.all(spacing.noneSpacing)));
    });
  });
  group("Testing BisonIconButton hover state styling - light mode", () {
    testWidgets("Styling test for BisonIconButton.filled", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );
      final cursor = TestPointer();
      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.sendEventToBinding(
        cursor.hover(tester.getCenter(iconWidget)),
      );

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });

      expect(background, equals(theme.buttonPrimaryHovered));
      expect(foreground, equals(theme.iconInverse));
    });
    testWidgets("Styling test for BisonIconButton.outlined", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.outlined(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );
      final cursor = TestPointer();
      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.sendEventToBinding(
        cursor.hover(tester.getCenter(iconWidget)),
      );

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.hovered,
      });

      expect(background, equals(theme.buttonGhostHovered));
      expect(foreground, equals(theme.iconPrimary));
      expect(outline!.color, equals(theme.borderPlain));
    });
    testWidgets("Styling test for BisonIconButton.ghost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.ghost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );
      final cursor = TestPointer();
      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.sendEventToBinding(
        cursor.hover(tester.getCenter(iconWidget)),
      );

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });

      expect(background, equals(theme.buttonGhostHovered));
      expect(foreground, equals(theme.iconPlain));
    });
    testWidgets("Styling test for BisonIconButton.whiteGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.whiteGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );
      final cursor = TestPointer();
      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.sendEventToBinding(
        cursor.hover(tester.getCenter(iconWidget)),
      );

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });

      expect(background, equals(theme.buttonGhostWhiteFixedHovered));
      expect(foreground, equals(theme.iconWhiteFixed));
    });
    testWidgets("Styling test for BisonIconButton.smallGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.smallGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );
      final cursor = TestPointer();
      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.sendEventToBinding(
        cursor.hover(tester.getCenter(iconWidget)),
      );

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.hovered,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPrimary));
    });
  });
  group("Testing BisonIconButton focused state styling - light mode", () {
    testWidgets("Styling test for BisonIconButton.filled", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.focused,
      });

      expect(background, equals(theme.buttonPrimaryFocusedPressed));
      expect(foreground, equals(theme.iconPrimary));
      expect(outline!.color, equals(theme.borderPrimary));
    });
    testWidgets("Styling test for BisonIconButton.outlined", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.outlined(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.focused,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPrimary));
      expect(outline!.color, equals(theme.borderPrimary));
    });
    testWidgets("Styling test for BisonIconButton.ghost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.ghost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.focused,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPlain));
      expect(outline!.color, equals(theme.borderPrimary));
    });
    testWidgets("Styling test for BisonIconButton.whiteGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.whiteGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.focused,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconWhiteFixed));
      expect(outline!.color, equals(theme.borderPrimary));
    });
    testWidgets("Styling test for BisonIconButton.smallGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.smallGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.focused,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.focused,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconPlain));
      expect(outline!.color, equals(theme.borderPrimary));
    });
  });
  group("Testing BisonIconButton pressed state styling - light mode", () {
    testWidgets("Styling test for BisonIconButton.filled", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });

      expect(background, equals(theme.buttonPrimaryFocusedPressed));
      expect(foreground, equals(theme.iconPrimary));
    });
    testWidgets("Styling test for BisonIconButton.outlined", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.outlined(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.pressed,
      });

      expect(background, equals(theme.buttonGhostPressed));
      expect(foreground, equals(theme.iconPrimary));
      expect(outline!.color, equals(theme.borderPlain));
    });
    testWidgets("Styling test for BisonIconButton.ghost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.ghost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });

      expect(background, equals(theme.buttonGhostPressed));
      expect(foreground, equals(theme.iconPlain));
    });
    testWidgets("Styling test for BisonIconButton.whiteGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.whiteGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });

      expect(background, equals(theme.buttonGhostWhiteFixedPressed));
      expect(foreground, equals(theme.iconWhiteFixed));
    });
    testWidgets("Styling test for BisonIconButton.smallGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.smallGhost(icon: Icon(Icons.add), onPressed: () {}),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = find.byType(IconButton);
      await tester.tap(iconWidget);

      final buttonStyle = (tester.widget<IconButton>(iconWidget)).style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.pressed,
      });

      expect(background, equals(theme.buttonGhostPressed));
      expect(foreground, equals(theme.iconPlain));
    });
  });
  group("Testing BisonIconButton disabled state styling - light mode", () {
    testWidgets("Styling test for BisonIconButton.filled", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.filled(icon: Icon(Icons.add), onPressed: null),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.disabled,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconDisabled));
      expect(outline!.color, equals(theme.borderDisabled));
    });
    testWidgets("Styling test for BisonIconButton.outlined", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.outlined(icon: Icon(Icons.add), onPressed: null),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final outline = buttonStyle.side?.resolve(<WidgetState>{
        WidgetState.disabled,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconDisabled));
      expect(outline!.color, equals(theme.borderDisabled));
    });
    testWidgets("Styling test for BisonIconButton.ghost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.ghost(icon: Icon(Icons.add), onPressed: null),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconDisabled));
    });
    testWidgets("Styling test for BisonIconButton.whiteGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.whiteGhost(icon: Icon(Icons.add), onPressed: null),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconDisabled));
    });
    testWidgets("Styling test for BisonIconButton.smallGhost", (
      final WidgetTester tester,
    ) async {
      final theme = BisonThemeTokens.light();

      await tester.pumpWidget(
        buildScaffold(
          BisonIconButton.smallGhost(icon: Icon(Icons.add), onPressed: null),
        ),
      );

      // BisonIconButton builds off of [IconButton]
      // finding [IconButton] allows use of style getters
      final iconWidget = tester.widget<IconButton>(find.byType(IconButton));

      final buttonStyle = iconWidget.style!;

      final background = buttonStyle.backgroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });
      final foreground = buttonStyle.foregroundColor?.resolve(<WidgetState>{
        WidgetState.disabled,
      });

      expect(background, equals(theme.surfaceTransparent));
      expect(foreground, equals(theme.iconDisabled));
    });
  });
}
