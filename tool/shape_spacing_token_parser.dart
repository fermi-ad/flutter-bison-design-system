import 'dart:convert';
import 'dart:io';

import 'color_token_parser.dart';

void main() {
  const outputPath = 'lib/src/theme/shape_spacing_tokens.g.dart';

  // json paths
  const shapeJson = 'tokens/Shape.json';
  const spacingJson = 'tokens/Spacing.json';

  // json data
  final shapeData =
      jsonDecode(File(shapeJson).readAsStringSync()) as Map<String, dynamic>;
  final spacingData =
      jsonDecode(File(spacingJson).readAsStringSync()) as Map<String, dynamic>;

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
  spacingMap.forEach((final key, final spacing) {
    buffer.writeln("  final double ${toCamelCase("$key Spacing")};");
  });
  buffer.writeln();

  // build contstructor
  buffer.writeln("  const BisonSpacingTokens({");
  spacingMap.forEach((final key, final spacing) {
    buffer.writeln("    required this.${toCamelCase("$key Spacing")},");
  });
  buffer.writeln("  });\n");

  // Factory constructor
  buffer.writeln(
    "  factory BisonSpacingTokens.standard() => const BisonSpacingTokens (",
  );
  spacingMap.forEach((final key, final value) {
    buffer.writeln("    ${toCamelCase("$key Spacing")}: $value,");
  });
  buffer.writeln("  );\n");

  // copyWith
  buffer.writeln("  @override\n  BisonSpacingTokens copyWith({");
  spacingMap.forEach((final key, final value) {
    buffer.writeln("    final double? ${toCamelCase("$key Spacing")},");
  });
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonSpacingTokens(");
  spacingMap.forEach((final key, final value) {
    final name = toCamelCase("$key Spacing");
    buffer.writeln("      $name: $name ?? this.$name,");
  });
  buffer.writeln("    );\n  }\n");

  // lerp
  buffer.writeln(
    "  @override\n  BisonSpacingTokens lerp(\n    covariant final ThemeExtension<BisonSpacingTokens>? other,\n    final double t,\n  ) {",
  );
  buffer.writeln("    if (other is! BisonSpacingTokens) return this;");
  buffer.writeln("    return BisonSpacingTokens(");
  spacingMap.forEach((final key, final value) {
    final name = toCamelCase("$key Spacing");
    buffer.writeln("      $name: lerpDouble($name, other.$name, t)!,");
  });
  buffer.writeln("    );\n  }");
  //----------- end of class
  buffer.writeln("}\n");

  // --------create corner theme extension class------------
  buffer.writeln(
    "class BisonCornerTokens extends ThemeExtension<BisonCornerTokens>{",
  );
  _extractCornerTokens(shapeData, '', cornerMap);
  cornerMap.forEach((final key, final value) {
    buffer.writeln("  final double ${toCamelCase(key)};");
  });
  buffer.writeln();

  // build contstructor
  buffer.writeln("  const BisonCornerTokens({");
  cornerMap.forEach((final key, final value) {
    buffer.writeln("    required this.${toCamelCase(key)},");
  });
  buffer.writeln("  });\n");

  // Factory constructor
  buffer.writeln(
    "  factory BisonCornerTokens.standard() => const BisonCornerTokens (",
  );
  cornerMap.forEach((final key, final value) {
    buffer.writeln("    ${toCamelCase(key)}: $value,");
  });
  buffer.writeln("  );\n");

  // copyWith
  buffer.writeln("  @override\n  BisonCornerTokens copyWith({");
  cornerMap.forEach((final key, final value) {
    buffer.writeln("    final double? ${toCamelCase(key)},");
  });
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonCornerTokens(");
  cornerMap.forEach((final key, final value) {
    final name = toCamelCase(key);
    buffer.writeln("      $name: $name ?? this.$name,");
  });
  buffer.writeln("    );\n  }\n");

  // lerp
  buffer.writeln(
    "  @override\n  BisonCornerTokens lerp(\n    covariant final ThemeExtension<BisonCornerTokens>? other,\n    final double t,\n  ) {",
  );
  buffer.writeln("    if (other is! BisonCornerTokens) return this;");
  buffer.writeln("    return BisonCornerTokens(");
  cornerMap.forEach((final key, final value) {
    final name = toCamelCase(key);
    buffer.writeln("      $name: lerpDouble($name, other.$name, t)!,");
  });
  buffer.writeln("    );\n  }");

  //------------ end of class
  buffer.writeln("}");

  // create file
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
}

void _extractSpacingTokens(
  final Map<String, dynamic> json,
  final String prefix,
  final Map<String, int> target,
) {
  json.forEach((final key, final value) {
    if (key.startsWith('\$')) return;
    final newKey = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map) {
      if (value.containsKey('\$value')) {
        final val = value['\$value'];
        target[newKey] = val as int;
      }
    }
  });
}

void _extractCornerTokens(
  final Map<String, dynamic> json,
  final String prefix,
  final Map<String, int> target,
) {
  json.forEach((final key, final value) {
    if (key.startsWith('\$')) return;
    final newKey = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map) {
      if (value.containsKey('\$value')) {
        final val = value['\$value'];
        target[newKey] = val as int;
      } else {
        _extractCornerTokens(value as Map<String, dynamic>, newKey, target);
      }
    }
  });
}
