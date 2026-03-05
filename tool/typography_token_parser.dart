import 'dart:convert' show jsonDecode;
import 'dart:io' show File;

void main() {
  const typescalePath = 'tokens/TypescaleTokens.json';
  const baselinePath = 'tokens/Baseline.tokens.json';
  const outputPath = 'lib/src/theme/typography_tokens.g.dart';

  final typescaleData =
      jsonDecode(File(typescalePath).readAsStringSync())
          as Map<dynamic, dynamic>;
  final baselineData =
      jsonDecode(File(baselinePath).readAsStringSync())
          as Map<dynamic, dynamic>;

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'color_tokens.g.dart';\n");

  buffer.writeln(
    "class BisonTypographyTokens extends ThemeExtension<BisonTypographyTokens> {",
  );

  final styles = typescaleData.keys
      .where((final k) => !(k as String).startsWith('\$'))
      .cast<String>()
      .toList();

  // Fields
  for (final String style in styles) {
    buffer.writeln("  final TextStyle ${_toCamelCase(style)};");
  }

  // Constructor
  buffer.writeln("\n  const BisonTypographyTokens({");
  for (final style in styles) {
    buffer.writeln("    required this.${_toCamelCase(style)},");
  }
  buffer.writeln("  });\n");

  // Factory: The logic that links Baseline and Typescale
  buffer.writeln(
    "  factory BisonTypographyTokens.fromTokens(final BisonThemeTokens colors) {",
  );
  buffer.writeln("    return BisonTypographyTokens(");

  for (final style in styles) {
    final node = typescaleData[style];
    final double fontSize = (node['Size']['\$value'] as num).toDouble();
    final double lineHeight = (node['Line Height']['\$value'] as num)
        .toDouble();
    final double tracking = (node['Tracking']['\$value'] as num).toDouble();

    // Resolve Font and Weight by looking up the Alias path in Baseline
    final String fontAlias =
        node['Font']['\$extensions']['com.figma.aliasData']['targetVariableName']
            as String;
    final String weightAlias =
        node['Weight']['\$extensions']['com.figma.aliasData']['targetVariableName']
            as String;

    final fontFamily = _resolveBaselineValue(baselineData, fontAlias);
    final weightString = _resolveBaselineValue(baselineData, weightAlias);

    buffer.writeln("      ${_toCamelCase(style)}: TextStyle(");
    buffer.writeln("        fontFamily: '$fontFamily',");
    buffer.writeln("        package: 'bison_design_system',");
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
String _resolveBaselineValue(
  final Map<dynamic, dynamic> data,
  final String path,
) {
  final parts = path.split('/');
  dynamic current = data;
  for (final part in parts) {
    current = current[part];
  }
  return current['\$value'].toString();
}

String _mapWeight(final String weight) {
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

String _toCamelCase(final String input) {
  final words = input
      .split(RegExp(r'[\s\-\.]'))
      .where((final w) => w.isNotEmpty)
      .toList();
  var result = words[0].toLowerCase();
  for (var i = 1; i < words.length; i++) {
    result += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
  }
  return result;
}

void _writeExtensionMethods(
  final StringBuffer buffer,
  final List<String> styles,
) {
  buffer.writeln("  @override");
  buffer.writeln("  BisonTypographyTokens copyWith({");
  for (final style in styles) {
    buffer.writeln("    final TextStyle? ${_toCamelCase(style)},");
  }
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonTypographyTokens(");
  for (final style in styles) {
    final name = _toCamelCase(style);
    buffer.writeln("      $name: $name ?? this.$name,");
  }
  buffer.writeln("    );\n  }\n");

  buffer.writeln("  @override");
  buffer.writeln(
    "  BisonTypographyTokens lerp(covariant final ThemeExtension<BisonTypographyTokens>? other, final double t) {",
  );
  buffer.writeln("    if (other is! BisonTypographyTokens) return this;");
  buffer.writeln("    return BisonTypographyTokens(");
  for (final style in styles) {
    final name = _toCamelCase(style);
    buffer.writeln("      $name: TextStyle.lerp($name, other.$name, t)!,");
  }
  buffer.writeln("    );\n  }");
}
