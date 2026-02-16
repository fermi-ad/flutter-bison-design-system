import 'dart:convert';
import 'dart:io';

void main() {
  const typescalePath = 'tokens/TypescaleTokens.json';
  const baselinePath = 'tokens/Baseline.tokens.json';
  const outputPath = 'lib/src/theme/typography_tokens.g.dart';

  final typescaleData = jsonDecode(File(typescalePath).readAsStringSync());
  final baselineData = jsonDecode(File(baselinePath).readAsStringSync());

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'color_tokens.g.dart';\n");

  buffer.writeln(
    "class BisonTypographyTokens extends ThemeExtension<BisonTypographyTokens> {",
  );

  final styles = typescaleData.keys.where((k) => !k.startsWith('\$')).toList();

  // Fields
  for (var style in styles) {
    buffer.writeln("  final TextStyle ${_toCamelCase(style)};");
  }

  // Constructor
  buffer.writeln("\n  const BisonTypographyTokens({");
  for (var style in styles) {
    buffer.writeln("    required this.${_toCamelCase(style)},");
  }
  buffer.writeln("  });\n");

  // Factory: The logic that links Baseline and Typescale
  buffer.writeln(
    "  factory BisonTypographyTokens.fromTokens(BisonThemeTokens colors) {",
  );
  buffer.writeln("    return BisonTypographyTokens(");

  for (var style in styles) {
    final node = typescaleData[style];
    final double fontSize = node['Size']['\$value'].toDouble();
    final double lineHeight = node['Line Height']['\$value'].toDouble();
    final double tracking = node['Tracking']['\$value'].toDouble();

    // Resolve Font and Weight by looking up the Alias path in Baseline
    final fontAlias =
        node['Font']['\$extensions']['com.figma.aliasData']['targetVariableName'];
    final weightAlias =
        node['Weight']['\$extensions']['com.figma.aliasData']['targetVariableName'];

    final fontFamily = _resolveBaselineValue(baselineData, fontAlias);
    final weightString = _resolveBaselineValue(baselineData, weightAlias);

    buffer.writeln("      ${_toCamelCase(style)}: TextStyle(");
    buffer.writeln("        fontFamily: '$fontFamily',");
    buffer.writeln("        package: 'design_system',");
    buffer.writeln("        fontSize: $fontSize,");
    buffer.writeln("        fontWeight: ${_mapWeight(weightString)},");
    buffer.writeln(
      "        height: ${lineHeight / fontSize}, // Multiplier: $lineHeight / $fontSize",
    );
    buffer.writeln("        letterSpacing: $tracking,");
    buffer.writeln("        color: colors.textPrimary,");
    buffer.writeln("      ),");
  }
  buffer.writeln("    );\n  }\n");

  _writeExtensionMethods(buffer, styles);

  buffer.writeln("}");

  File(outputPath).parent.createSync(recursive: true);
  File(outputPath).writeAsStringSync(buffer.toString());
}

/// Navigates the Baseline JSON using the slash-delimited path (e.g. "Weight/Bold")
String _resolveBaselineValue(Map data, String path) {
  final parts = path.split('/');
  dynamic current = data;
  for (var part in parts) {
    current = current[part];
  }
  return current['\$value'].toString();
}

String _mapWeight(String weight) {
  switch (weight.toLowerCase()) {
    case 'extralight':
      return 'FontWeight.w200';
    case 'light':
      return 'FontWeight.w300';
    case 'medium':
      return 'FontWeight.w500';
    case 'semibold':
      return 'FontWeight.w600';
    case 'bold':
      return 'FontWeight.w700';
    case 'extrabold':
      return 'FontWeight.w800';
    default:
      return 'FontWeight.w400'; // Regular
  }
}

String _toCamelCase(String input) {
  final words = input
      .split(RegExp(r'[\s\-\.]'))
      .where((w) => w.isNotEmpty)
      .toList();
  var result = words[0].toLowerCase();
  for (var i = 1; i < words.length; i++) {
    result += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
  }
  return result;
}

void _writeExtensionMethods(StringBuffer buffer, List<String> styles) {
  buffer.writeln("  @override");
  buffer.writeln("  BisonTypographyTokens copyWith({");
  for (var style in styles) {
    buffer.writeln("    TextStyle? ${_toCamelCase(style)},");
  }
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonTypographyTokens(");
  for (var style in styles) {
    final name = _toCamelCase(style);
    buffer.writeln("      $name: $name ?? this.$name,");
  }
  buffer.writeln("    );\n  }\n");

  buffer.writeln("  @override");
  buffer.writeln(
    "  BisonTypographyTokens lerp(covariant ThemeExtension<BisonTypographyTokens>? other, double t) {",
  );
  buffer.writeln("    if (other is! BisonTypographyTokens) return this;");
  buffer.writeln("    return BisonTypographyTokens(");
  for (var style in styles) {
    final name = _toCamelCase(style);
    buffer.writeln("      $name: TextStyle.lerp($name, other.$name, t)!,");
  }
  buffer.writeln("    );\n  }");
}
