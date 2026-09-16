# AGENTS.md — Bison Design System

> Authoritative reference for AI agents working in this Flutter design system repo. Covers architecture, token system, component patterns, and Figma ↔ code mapping for MCP integration.

---

## 1. Stack & Constraints

- **Flutter-only** package. No React, Vue, CSS, or Sass.
- All styling uses Flutter `ThemeData` + `ThemeExtension` APIs.
- Component docs live in `example/` (Widgetbook). CI enforces 100% Widgetbook coverage.

---

## 2. Token System (Three Layers)

```
tokens/ColorBaseTokens.json   →  BaseTokens      (primitive palette: beamBlue40, etc.)
tokens/ColorAliasTokens.json  →  AliasTokens     (semantic: primaryDefault, errorDefault)
tokens/Light.tokens.json      →  BisonThemeTokens.light()   (component-scoped)
tokens/Dark.tokens.json       →  BisonThemeTokens.dark()
tokens/Spacing.json           →  BisonSpacingTokens
tokens/Shape.json             →  BisonCornerTokens
tokens/TypescaleTokens.json   →  BisonTypographyTokens
```

All generated into `lib/src/theme/*.g.dart`. **Never edit `.g.dart` files by hand.**

Regenerate after any token JSON change:
```bash
dart run tool/generate_tokens.dart
```

### Figma variable name → Dart token name

`toCamelCase()` splits on `.` `/` `-` ` ` — first segment lowercase, rest title-cased:

| Figma name | Dart token |
|---|---|
| `Border/Plain` | `borderPlain` |
| `Button/Primary` | `buttonPrimary` |
| `Surface/Default` | `surfaceDefault` |
| `Corner/Extra-small` | `cornerExtraSmall` |
| `X-Small` (spacing) | `xSmallSpacing` |
| `Color Coded/Danger Signal` | `colorCodedDangerSignal` |

### Spacing scale

| Figma | Dart field | px |
|---|---|---|
| None | `noneSpacing` | 0 |
| Micro | `microSpacing` | 4 |
| Tiny | `tinySpacing` | 8 |
| X-Small | `xSmallSpacing` | 12 |
| Small | `smallSpacing` | 16 |
| Standard | `standardSpacing` | 24 |
| Medium | `mediumSpacing` | 36 |
| Large | `largeSpacing` | 48 |
| X-Large | `xLargeSpacing` | 64 |

### Corner radius scale

| Figma | Dart field | px |
|---|---|---|
| None | `cornerNone` | 0 |
| Extra-small | `cornerExtraSmall` | 4 |
| Small | `cornerSmall` | 8 |
| Medium | `cornerMedium` | 12 |
| Large | `cornerLarge` | 16 |

### Typography scale

| Figma | Dart field | Size | Weight | lh |
|---|---|---|---|---|
| H1 | `h1` | 20 | 400 | 1.0 |
| H2 | `h2` | 18 | 400 | 1.111 |
| H3 | `h3` | 16 | 500 | 1.125 |
| Body Large | `bodyLarge` | 14 | 500 | 1.143 |
| Body Small | `bodySmall` | 13 | 400 | 1.231 |
| Capitalized Label | `capitalizedLabel` | 12 | 400 | 1.333, ls 0.25 |

---

## 3. Theme Architecture

`BisonThemeData.light()` / `.dark()` are the only entry points. They register four `ThemeExtension`s and pre-configure Material widget themes.

**Token accessor — use in every widget:**
```dart
@override
Widget build(BuildContext context) {
  final bison = context.bison; // BisonContext extension on BuildContext

  return Container(
    color: bison.theme.surfaceDefault,
    padding: EdgeInsets.all(bison.spacing.smallSpacing),
    child: Text('Hello', style: bison.typography.bodyLarge),
  );
}
```

`context.bison` returns a `BisonTokens` snapshot with four fields:
- `bison.theme` — `BisonThemeTokens` (semantic colors)
- `bison.spacing` — `BisonSpacingTokens`
- `bison.typography` — `BisonTypographyTokens`
- `bison.corners` — `BisonCornerTokens`

---

## 4. Component Architecture Pattern

All components follow these rules:

1. **`StatelessWidget`** if no internal state; **`StatefulWidget`** if hover/focus/press state is needed.
2. **Factory constructor pattern**: private `._()` constructor + private `_Type` enum + public named factories.
3. Call `context.bison` once at the top of `build()`, store in `final bison`.
4. Use `WidgetStateProperty.resolveWith` for state-dependent colors.
5. Wrap interactive widgets in `Semantics` for accessibility.
6. Use `FocusableActionDetector` with `Space`/`Enter` shortcuts for keyboard support.

```dart
enum _BisonButtonType { filled, ghost, outlined, destructive }

class BisonButton extends StatelessWidget {
  const BisonButton._({required _BisonButtonType buttonType, ...})
      : _buttonType = buttonType;

  factory BisonButton.filled({required String buttonLabel, ...}) =>
      BisonButton._(buttonType: _BisonButtonType.filled, ...);
}
```

State-dependent color example:
```dart
backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
  if (states.contains(WidgetState.disabled)) return theme.buttonGhostDisabled;
  if (states.contains(WidgetState.focused) ||
      states.contains(WidgetState.pressed)) return theme.buttonPrimaryFocusedPressed;
  if (states.contains(WidgetState.hovered)) return theme.buttonPrimaryHovered;
  return theme.buttonPrimary;
}),
```

### State → token suffix mapping

| Figma state | `WidgetState` | Token suffix |
|---|---|---|
| Default | — | base token |
| Hover | `hovered` | `*Hovered` |
| Pressed | `pressed` | `*Pressed` |
| Focused | `focused` | `*Focused` / `*FocusedPressed` |
| Disabled | `disabled` | `*Disabled` |
| Selected | `selected` | `*Active` / `*Primary` |

---

## 5. Figma → Dart Code Patterns

```dart
// Fill = "Surface/Default"
Container(color: context.bison.theme.surfaceDefault)

// Fill = "Button/Primary"
Container(color: context.bison.theme.buttonPrimary)

// Padding = "Small" (16px)
Padding(padding: EdgeInsets.all(context.bison.spacing.smallSpacing))

// Gap = "Tiny" (8px)
SizedBox(width: context.bison.spacing.tinySpacing)

// Corner radius = "Extra-small" (4px)
BorderRadius.circular(context.bison.corners.cornerExtraSmall)

// Text style = "Body Large"
Text('Hello', style: context.bison.typography.bodyLarge)

// Text color override
Text('Hi', style: context.bison.typography.h2.copyWith(
  color: context.bison.theme.textPrimary,
))
```

### Figma component → Bison widget

| Figma component | Bison widget |
|---|---|
| Button / Filled | `BisonButton.filled()` |
| Button / Ghost | `BisonButton.ghost()` |
| Button / Outlined | `BisonButton.outlined()` |
| Button / Destructive | `BisonButton.destructive()` |
| Icon Button / Filled | `BisonIconButton.filled()` |
| Icon Button / Ghost | `BisonIconButton.ghost()` |
| Checkbox | `BisonCheckbox(value: BisonCheckboxValue.selected)` |
| Switch / Medium | `BisonSwitch(size: BisonSwitchSize.medium)` |
| Switch / Small | `BisonSwitch(size: BisonSwitchSize.small)` |
| Switch / Read-only | `BisonSwitch.readOnly()` |
| Chip / Filter | `BisonChip.filter()` |
| Chip / Input | `BisonChip.input()` |
| Chip / Suggestion | `BisonChip.suggestion()` |
| Chip / Object | `BisonChip.object()` |
| Text Field | `BisonTextField` |
| Dialog | `BisonDialog` |
| Menu | `BisonMenu` |
| Scrim / Overlay | `BisonScrim` |

### Figma modes → theme

| Figma mode | Dart |
|---|---|
| Light | `BisonThemeData.light()` |
| Dark | `BisonThemeData.dark()` |
| Baseline / Wireframe | Use light as default |

---

## 6. Code Style Rules

1. `final` for all locals and parameters that are not reassigned.
2. Explicit `show` on every import — no bare `import 'package:foo/foo.dart'`.
3. Strict types: `strict-casts`, `strict-inference`, `strict-raw-types` are all enabled.
4. `*.g.dart` files are excluded from analysis — do not add lint suppressions to them.

---

## 7. Icons

Icons use Flutter's built-in Material Icons font (`Icons.*`). No custom SVG set. Icons are passed as `Icon` widget instances, not `IconData`:

```dart
BisonButton.filled(
  buttonLabel: 'Save',
  onPressed: () {},
  leftIcon: Icon(Icons.save),
)
```

---

## 8. New Component Checklist

- [ ] `lib/src/core_widgets/<category>/bison_<name>.dart` — implement widget
- [ ] Export in `lib/core_widgets.dart` with explicit `show`
- [ ] `example/lib/bison_<name>.dart` — add `@widgetbook.UseCase`
- [ ] Run `dart run build_runner build` in `example/`
- [ ] `test/widget/<category>/bison_<name>_test.dart` — widget tests
- [ ] `flutter test` passes, `dart analyze` clean

## 9. Token Update Checklist

- [ ] Replace `tokens/*.json` with new Figma export
- [ ] `dart run tool/generate_tokens.dart`
- [ ] `dart analyze` + `flutter test`
- [ ] Search for renamed tokens: `grep -r "oldName" lib/`
- [ ] Update `CHANGELOG.md`
