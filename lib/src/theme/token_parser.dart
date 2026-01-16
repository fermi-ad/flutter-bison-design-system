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
  _extractTokens(baseData, '', baseMap);
  baseMap.forEach((key, hex) {
    buffer.writeln(
      "  static const Color ${toCammelCase(key)} = Color(${formatHex(hex)});",
    );
  });
  buffer.writeln("}\n");

  // create alias tokens
  buffer.writeln("abstract class AliasTokens {");
  final aliasMap = <String, String>{};
  _extractTokens(aliasData, '', aliasMap);
  aliasMap.forEach((key, hex) {
    buffer.writeln(
      "  static const Color ${toCammelCase(key)} = Color(${formatHex(hex)});",
    );
  });
  buffer.writeln("}\n");

  // create file
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
}

void _extractTokens(Map json, String prefix, Map<String, String> target) {
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
        _extractTokens(value, newKey, target);
      }
    }
  });
}

String toCammelCase(String input) {
  final words = input
      .replaceAll(RegExp(r'[\.\-\s]'), ' ')
      .split(' ')
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'unknown';
  var result = words[0].toLowerCase();
  for (var i = 1; i < words.length; i++) {
    result += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
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
