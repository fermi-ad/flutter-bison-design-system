import 'dart:convert';
import 'dart:io';

void main() {
  const outputPath = 'lib/src/theme/tokens.g.dart';

  // json paths
  const baseJson = 'ColorBaseTokens.json';
  const aliasJson = 'ColorAliasTokens.json';
  const lightJson = 'Light.tokens.json';
  const darkJson = 'Dark.tokens.json';

  // json data
  final baseData = jsonDecode(File(baseJson).readAsStringSync());
  final aliasData = jsonDecode(File(aliasJson).readAsStringSync());
  final lightData = jsonDecode(File(lightJson).readAsStringSync());
  final darkData = jsonDecode(File(darkJson).readAsStringSync());

  final buffer = StringBuffer();
  buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND\n");
  buffer.writeln("import 'package:flutter/material.dart';\n");

  // Create base tokens
  buffer.writeln("abstract class BaseTokens {");
  final baseMap = <String, String>{};
  _extractBaseTokens(baseData, '', baseMap);
  baseMap.forEach((key, hex) {
    buffer.writeln(
      "  static const Color ${toCamelCase(key)} = Color(${formatHex(hex)});",
    );
  });
  buffer.writeln("}\n");

  // create alias tokens
  buffer.writeln("abstract class AliasTokens {");
  final aliasMap = <String, String>{};
  _extractAliasTokens(aliasData, buffer, 'BaseTokens');
  aliasMap.forEach((key, hex) {
    buffer.writeln(
      "  static const Color ${toCamelCase(key)} = Color(${formatHex(hex)});",
    );
  });
  buffer.writeln("}\n");

  // create file
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
}

void _extractBaseTokens(Map json, String prefix, Map<String, String> target) {
  json.forEach((key, value) {
    if (key.startsWith('\$')) return;
    final newKey = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map) {
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

void _extractAliasTokens(Map json, StringBuffer buffer, String targetClass) {
  void recurse(Map node, String prefix) {
    node.forEach((key, value) {
      if (key.startsWith('\$')) return;
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map) {
        final extensions = value['\$extensions'];
        if (extensions != null && extensions['com.figma.aliasData'] != null) {
          final targetVar =
              extensions['com.figma.aliasData']['targetVariableName'];
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

String toCamelCase(String input) {
  // Regex handles slashes, spaces, dots, and dashes from Figma
  final parts = input
      .split(RegExp(r'[\.\-\s\/]'))
      .where((p) => p.isNotEmpty)
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
