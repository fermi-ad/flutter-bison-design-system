import 'dart:io' show File;
import 'token_parser_utils.dart' show toCamelCase, loadJson, formatFile;

void main() {
  const typescalePath = 'tokens/TypescaleTokens.json';
  const baselinePath = 'tokens/Baseline.tokens.json';
  const outputPath = 'lib/src/theme/typography_tokens.g.dart';

  final typescaleData = loadJson(typescalePath);
  final baselineData = loadJson(baselinePath);

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'color_tokens.g.dart';\n");

  buffer.writeln(
    "class BisonTypographyTokens extends ThemeExtension<BisonTypographyTokens> {",
  );

  final styles = typescaleData.keys
      .where((final k) => !(k).startsWith('\$'))
      .cast<String>()
      .toList();

  // Fields
  for (final String style in styles) {
    buffer.writeln("  final TextStyle ${toCamelCase(style)};");
  }

  // Constructor
  buffer.writeln("\n  const BisonTypographyTokens({");
  for (final style in styles) {
    buffer.writeln("    required this.${toCamelCase(style)},");
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

    final fontFamily = resolveBaselineValue(baselineData, fontAlias);
    final weightString = resolveBaselineValue(baselineData, weightAlias);

    buffer.writeln("      ${toCamelCase(style)}: TextStyle(");
    buffer.writeln("        fontFamily: '$fontFamily',");
    buffer.writeln("        package: 'bison_design_system',");
    buffer.writeln("        fontSize: $fontSize,");
    buffer.writeln("        fontWeight: ${mapWeight(weightString)},");
    buffer.writeln(
      "        height: ${lineHeight / fontSize}, // Multiplier: $lineHeight / $fontSize",
    );
    buffer.writeln("        letterSpacing: $tracking,");
    buffer.writeln("        color: colors.textPlain,");
    buffer.writeln("      ),");
  }
  buffer.writeln("    );\n  }\n");

  _writeExtensionMethods(buffer, styles);

  buffer.writeln("}");

  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
  formatFile(outputPath);
}

/// Navigates the Baseline JSON using the slash-delimited path (e.g. "Weight/Bold")
String resolveBaselineValue(
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

String mapWeight(final String weight) {
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

void _writeExtensionMethods(
  final StringBuffer buffer,
  final List<String> styles,
) {
  buffer.writeln("  @override");
  buffer.writeln("  BisonTypographyTokens copyWith({");
  for (final style in styles) {
    buffer.writeln("    final TextStyle? ${toCamelCase(style)},");
  }
  buffer.writeln("  }) {");
  buffer.writeln("    return BisonTypographyTokens(");
  for (final style in styles) {
    final name = toCamelCase(style);
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
    final name = toCamelCase(style);
    buffer.writeln("      $name: TextStyle.lerp($name, other.$name, t)!,");
  }
  buffer.writeln("    );\n  }");
}
