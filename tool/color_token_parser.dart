import 'dart:convert';
import 'dart:io';

void main() {
  const outputPath = 'lib/src/theme/color_tokens.g.dart';

  // json paths
  const baseJson = 'tokens/ColorBaseTokens.json';
  const aliasJson = 'tokens/ColorAliasTokens.json';
  const lightJson = 'tokens/Light.tokens.json';
  const darkJson = 'tokens/Dark.tokens.json';

  // json data
  final baseData =
      jsonDecode(File(baseJson).readAsStringSync()) as Map<String, dynamic>;
  final aliasData =
      jsonDecode(File(aliasJson).readAsStringSync()) as Map<String, dynamic>;
  final lightData =
      jsonDecode(File(lightJson).readAsStringSync()) as Map<String, dynamic>;
  final darkData =
      jsonDecode(File(darkJson).readAsStringSync()) as Map<String, dynamic>;

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';\n");

  // Create base tokens
  buffer.writeln("abstract class BaseTokens {");
  final baseMap = <String, String>{};
  _extractBaseTokens(baseData, '', baseMap);
  baseMap.forEach((final key, final hex) {
    buffer.writeln(
      "  static const Color ${toCamelCase(key)} = Color(${formatHex(hex)});",
    );
  });
  buffer.writeln("}\n");

  // create alias tokens
  buffer.writeln("abstract class AliasTokens {");
  final aliasMap = <String, String>{};
  _extractAliasTokens(aliasData, buffer, 'BaseTokens');
  aliasMap.forEach((final key, final hex) {
    buffer.writeln(
      "  static const Color ${toCamelCase(key)} = Color(${formatHex(hex)});",
    );
  });
  buffer.writeln("}\n");

  // create component tokens (and ThemeExtension)
  buffer.writeln(
    "class BisonThemeTokens extends ThemeExtension<BisonThemeTokens>{",
  );

  final componentKeys = <String>{};
  final lightMap = <String, String>{};
  final darkMap = <String, String>{};

  _extractComponentTokens(lightData, '', lightMap);
  _extractComponentTokens(darkData, '', darkMap);
  componentKeys.addAll(lightMap.keys);

  final sortedKeys = componentKeys.toList()..sort();

  // build out fiels
  for (final key in sortedKeys) {
    buffer.writeln("  final Color ${toCamelCase(key)};");
  }

  // constructor
  buffer.writeln("\n const BisonThemeTokens({");
  for (final key in sortedKeys) {
    buffer.writeln("  required this.${toCamelCase(key)},");
  }
  buffer.writeln(" });\n");

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

  // ColorScheme
  _writeToColorScheme(buffer);

  buffer.writeln("}");

  // create file
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
}

void _extractBaseTokens(
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
        if (val is Map && val.containsKey('hex')) {
          target[newKey] = val['hex'].toString();
        } else if (val is String) {
          target[newKey] = val;
        }
      } else {
        _extractBaseTokens(value, newKey, target);
      }
    }
  });
}

void _extractAliasTokens(
  final Map<String, dynamic> json,
  final StringBuffer buffer,
  final String targetClass,
) {
  void recurse(final Map<String, dynamic> node, final String prefix) {
    node.forEach((final key, final value) {
      if (key.startsWith('\$')) return;
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        final extensions = value['\$extensions'];
        if (extensions != null && extensions['com.figma.aliasData'] != null) {
          final targetVar =
              extensions['com.figma.aliasData']['targetVariableName'] as String;
          buffer.writeln(
            "  static const Color ${toCamelCase(newKey)} = $targetClass.${toCamelCase(targetVar)};",
          );
        } else {
          recurse(value, newKey);
        }
      }
    });
  }

  recurse(json, '');
}

void _extractComponentTokens(
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
        _extractComponentTokens(value, newKey, target);
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
    buffer.writeln("    Color? ${toCamelCase(key)},");
  }
  buffer.writeln("  }) {");
  buffer.writeln("  return BisonThemeTokens(");
  for (final key in keys) {
    final name = toCamelCase(key);
    buffer.writeln("    $name: $name ?? this.$name,");
  }
  buffer.writeln("  );");
  buffer.writeln("  }\n");

  // lerp
  buffer.writeln("  @override");
  buffer.writeln(
    "  BisonThemeTokens lerp(covariant ThemeExtension<BisonThemeTokens>? other, double t) {",
  );
  buffer.writeln("    if (other is! BisonThemeTokens) return this;");
  buffer.writeln("    return BisonThemeTokens(");
  for (final key in keys) {
    final name = toCamelCase(key);
    buffer.writeln("      $name: Color.lerp($name, other.$name, t)!,");
  }
  buffer.writeln("    );\n  }");
}

void _writeToColorScheme(final StringBuffer buffer) {
  buffer.writeln('''
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: borderPrimary,
      onPrimary: textInverse,
      secondary: borderSecondary,
      onSecondary: textInverse,
      error: borderError,
      onError: textInverse,
      surface: surfaceDefault,
      onSurface: textPlain,
    );
  }
  ''');
}

String toCamelCase(final String input) {
  // Regex handles slashes, spaces, dots, and dashes from Figma
  final parts = input
      .split(RegExp(r'[\.\-\s\/]'))
      .where((final p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return 'unknown';
  var result = parts[0].toLowerCase();
  for (var i = 1; i < parts.length; i++) {
    result += parts[i][0].toUpperCase() + parts[i].substring(1).toLowerCase();
  }
  return result;
}

// format Figma hex value (#XXXXXX) for the Color function (0xXXXXXXXX)
String formatHex(String hex) {
  hex = hex.replaceAll("#", '');
  if (hex.length == 6) return '0xFF${hex.toUpperCase()}';
  if (hex.length == 8) return '0x${hex.toUpperCase()}';
  // Return black if length is incorrect
  return '0xFF000000';
}
