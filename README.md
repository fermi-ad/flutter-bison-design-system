<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Beautiful Interactive System Of desigN

### A good and nice design system for Flutter apps.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

Get Dart package dependencies:

```
$ flutter pub get
```

Set up the [pre-commit hook](https://pub.dev/packages/dart_pre_commit):

```
$ dart tool/setup_git_hooks.dart
```

### Generated Design Tokens

Design tokens are handed over from Figma through json files. Parsing files can be found in `tool/` that will generate the appropriate classes. To create the color tokens, for example, run

```
$ dart run tool/color_token_parser.dart
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

This will automatically apply all the design tokens to Flutter's built-in widgets, ensuring consistent styling throughout your application.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

🦬
