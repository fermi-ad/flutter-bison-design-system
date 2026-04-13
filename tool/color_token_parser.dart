import 'dart:io' show File;
import 'token_parser_utils.dart' show toCamelCase, formatHex, loadJson;

void main() {
  const outputPath = 'lib/src/theme/color_tokens.g.dart';

  // json paths
  const baseJson = 'tokens/ColorBaseTokens.json';
  const aliasJson = 'tokens/ColorAliasTokens.json';
  const lightJson = 'tokens/Light.tokens.json';
  const darkJson = 'tokens/Dark.tokens.json';

  // json data
  final baseData = loadJson(baseJson);
  final aliasData = loadJson(aliasJson);
  final lightData = loadJson(lightJson);
  final darkData = loadJson(darkJson);

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';\n");

  // Create base tokens
  buffer.writeln("abstract class BaseTokens {");
  final baseMap = <String, String>{};
  extractBaseTokens(baseData, '', baseMap);
  baseMap.forEach((final key, final hex) {
    buffer.writeln("  static const Color ${toCamelCase(key)} = Color($hex);");
  });
  buffer.writeln("}\n");

  // create alias tokens
  buffer.writeln("abstract class AliasTokens {");
  final aliasMap = extractAliasTokens(aliasData);
  aliasMap.forEach((final key, final targetVar) {
    buffer.writeln(
      "  static const Color ${toCamelCase(key)} = BaseTokens.${toCamelCase(targetVar)};",
    );
  });
  buffer.writeln("}\n");

  // create component tokens (and ThemeExtension)
  buffer.writeln(
    "class BisonThemeTokens extends ThemeExtension<BisonThemeTokens> {",
  );

  final componentKeys = <String>{};
  final lightMap = <String, String>{};
  final darkMap = <String, String>{};
  extractComponentTokens(lightData, '', lightMap);
  extractComponentTokens(darkData, '', darkMap);
  componentKeys.addAll(lightMap.keys);

  final sortedKeys = componentKeys.toList()..sort();

  // build out fields
  for (final key in sortedKeys) {
    buffer.writeln("  final Color ${toCamelCase(key)};");
  }

  // constructor
  buffer.writeln("\n  const BisonThemeTokens({");
  for (final key in sortedKeys) {
    buffer.writeln("    required this.${toCamelCase(key)},");
  }
  buffer.writeln("  });\n");

  // Light Factory
  buffer.writeln(
    "  factory BisonThemeTokens.light() => const BisonThemeTokens(",
  );
  for (final key in sortedKeys) {
    final aliasToken = lightMap[key]!;
    buffer.writeln(
      "    ${toCamelCase(key)}: AliasTokens.${toCamelCase(aliasToken)},",
    );
  }
  buffer.writeln("  );\n");

  // Dark Factory
  buffer.writeln(
    "  factory BisonThemeTokens.dark() => const BisonThemeTokens(",
  );
  for (final key in sortedKeys) {
    final aliasToken = darkMap[key] ?? lightMap[key]!;
    buffer.writeln(
      "    ${toCamelCase(key)}: AliasTokens.${toCamelCase(aliasToken)},",
    );
  }
  buffer.writeln("  );\n");

  // Overrides
  _writeOverrides(buffer, sortedKeys);

  buffer.writeln("}");

  // create file
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
}

void extractBaseTokens(
  final Map<String, dynamic> json,
  final String prefix,
  final Map<String, String> target,
) {
  json.forEach((final key, final value) {
    if (key.startsWith('\$')) return;
    final newKey = prefix.isEmpty ? key : '$prefix.$key';

    if (value is Map<String, dynamic>) {
      if (value.containsKey('\$value')) {
        final val = value['\$value'];
        final hex = val['hex'].toString();
        final alpha = val['alpha'];

        target[newKey] = formatHex(hex, alpha is num ? alpha : null);
      } else {
        extractBaseTokens(value, newKey, target);
      }
    }
  });
}

Map<String, String> extractAliasTokens(final Map<String, dynamic> json) {
  final result = <String, String>{};
  void recurse(final Map<String, dynamic> node, final String prefix) {
    node.forEach((final key, final value) {
      if (key.startsWith('\$')) return;
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        final extensions = value['\$extensions'];
        if (extensions != null && extensions['com.figma.aliasData'] != null) {
          final targetVar =
              extensions['com.figma.aliasData']['targetVariableName'] as String;
          result[newKey] = targetVar;
        } else {
          recurse(value, newKey);
        }
      }
    });
  }

  recurse(json, '');
  return result;
}

void extractComponentTokens(
  final Map<String, dynamic> json,
  final String prefix,
  final Map<String, String> target,
) {
  json.forEach((final key, final value) {
    if (key.startsWith('\$')) return;
    final newKey = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map<String, dynamic>) {
      final extensions = value['\$extensions'];
      if (extensions != null && extensions['com.figma.aliasData'] != null) {
        target[newKey] =
            extensions['com.figma.aliasData']['targetVariableName'] as String;
      } else {
        extractComponentTokens(value, newKey, target);
      }
    }
  });
}

// function that creates overwritten functions copyWith and lerp
void _writeOverrides(final StringBuffer buffer, final List<String> keys) {
  // copyWith
  buffer.writeln("  @override");
  buffer.writeln("  BisonThemeTokens copyWith({");
  for (final key in keys) {
    buffer.writeln("    final Color? ${toCamelCase(key)},");
  }
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonThemeTokens(");
  for (final key in keys) {
    final name = toCamelCase(key);
    buffer.writeln("      $name: $name ?? this.$name,");
  }
  buffer.writeln("    );");
  buffer.writeln("  }\n");

  // lerp
  buffer.writeln("  @override");
  buffer.writeln(
    "  BisonThemeTokens lerp(covariant final ThemeExtension<BisonThemeTokens>? other, final double t) {",
  );
  buffer.writeln("    if (other is! BisonThemeTokens) return this;");
  buffer.writeln("    return BisonThemeTokens(");
  for (final key in keys) {
    final name = toCamelCase(key);
    buffer.writeln("      $name: Color.lerp($name, other.$name, t)!,");
  }
  buffer.writeln("    );\n  }");
}
