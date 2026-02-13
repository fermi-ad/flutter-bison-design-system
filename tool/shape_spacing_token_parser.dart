import 'dart:convert';
import 'dart:io';

import 'color_token_parser.dart';

void main() {
  const outputPath = 'lib/src/theme/shape_spacing_tokens.g.dart';

  // json paths
  const shapeJson = 'tokens/Shape.json';
  const spacingJson = 'tokens/Spacing.json';

  // json data
  final shapeData = jsonDecode(File(shapeJson).readAsStringSync());
  final spacingData = jsonDecode(File(spacingJson).readAsStringSync());

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'dart:ui';\n");

  final spacingMap = <String, int>{};
  final cornerMap = <String, int>{};

  // --------create spacing theme extension class------------
  buffer.writeln(
    "class BisonSpacingTokens extends ThemeExtension<BisonSpacingTokens>{",
  );

  _extractSpacingTokens(spacingData, '', spacingMap);
  spacingMap.forEach((key, spacing) {
    buffer.writeln("  final double ${toCamelCase("$key Spacing")};");
  });
  buffer.writeln();

  // build contstructor
  buffer.writeln("  const BisonSpacingTokens({");
  spacingMap.forEach((key, spacing) {
    buffer.writeln("    required this.${toCamelCase("$key Spacing")},");
  });
  buffer.writeln("  });\n");

  // TODO: build out getters that return EdgeInsets

  // Factory constructor
  buffer.writeln(
    "  factory BisonSpacingTokens.standard() => const BisonSpacingTokens (",
  );
  spacingMap.forEach((key, value) {
    buffer.writeln("    ${toCamelCase("$key Spacing")}: $value,");
  });
  buffer.writeln("  );\n");

  // copyWith
  buffer.writeln("  @override\n  BisonSpacingTokens copyWith({");
  spacingMap.forEach((key, value) {
    buffer.writeln("    double? ${toCamelCase("$key Spacing")},");
  });
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonSpacingTokens(");
  spacingMap.forEach((key, value) {
    final name = toCamelCase("$key Spacing");
    buffer.writeln("      $name: $name ?? this.$name,");
  });
  buffer.writeln("    );\n  }\n");

  // lerp
  buffer.writeln(
    "  @override\n  BisonSpacingTokens lerp(\n    covariant ThemeExtension<BisonSpacingTokens>? other,\n    double t,\n  ) {",
  );
  buffer.writeln("    if (other is! BisonSpacingTokens) return this;");
  buffer.writeln("    return BisonSpacingTokens(");
  spacingMap.forEach((key, value) {
    final name = toCamelCase("$key Spacing");
    buffer.writeln("      $name: lerpDouble($name, other.$name, t)!,");
  });
  buffer.writeln("    );\n  }");
  // end of class
  buffer.writeln("}\n");

  // create shape theme extension
  // buffer.writeln(
  //   "class BisonShapeTokens extends ThemeExtension<BisonShapeTokens>{",
  // );

  // buffer.write("}\n");

  // create file
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
}

void _extractSpacingTokens(Map json, String prefix, Map<String, int> target) {
  json.forEach((key, value) {
    if (key.startsWith('\$')) return;
    final newKey = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map) {
      if (value.containsKey('\$value')) {
        final val = value['\$value'];
        target[newKey] = val;
      }
    }
  });
}
