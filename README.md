# Beautiful Interactive System Of desigN

### A good and nice design system for Flutter apps.

## Features

This design system provides a centralized library for reusable Flutter UI widgets and design tokens.

## Getting started

Get Dart package dependencies:

```
$ flutter pub get
```

Set up the [pre-commit hook](https://pub.dev/packages/dart_pre_commit):

```
$ dart tool/setup_git_hooks.dart
```

### Design Tokens

Design tokens are predefined values that ensure consistent theming across applications.

The provided design tokens are grouped into 4 categories:

- theme: Defines the color palette.
- typography: Defines the text styles.
- spacing: Defines margins, padding, and gaps.
- corners: Defines border radius values.

### Generated Design Tokens

Design tokens are exported from Figma as JSON files and can be found in `tokens/`. Parsing scripts in `tool/` generate the corresponding Dart classes.

There are 3 scripts to handle importing the provided tokens.

- `color_token_parser.dart` will generate the theme tokens
- `typography_token_parser.dart` will generate the typography tokens
- `shape_spacing_token_parser.dart` will generate the corners and spacing tokens

Each script can be run independently, or to run together run

```shell
dart run tool/generate_tokens.dart
```

## Usage

To use the Bison design system's master theme, simply pass the ThemeData returned by `BisonThemeData.light()` or `BisonThemeData.dark()` to your MaterialApp's theme property.

```dart
import 'package:bison_design_system/bison_design_system.dart';

MaterialApp(
  theme: BisonThemeData.light(),
  darkTheme: BisonThemeData.dark(),
  home: MyHomePage(),
);
```

Applying the Bison theme ensures Flutter’s built-in widgets use the design system by default. It also makes the design tokens available from the build context, so you can access them inside your widgets through context.bison. For example, to use a theme token inside a widget's build method:

```dart
Widget build(final BuildContext context) {
  final bison = context.bison;

  return Container(color: bison.theme.borderPlain);
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

🦬
