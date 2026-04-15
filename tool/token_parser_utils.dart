import 'dart:convert' show jsonDecode;
import 'dart:io' show File, Process, stderr, stdout;

String toCamelCase(final String input) {
  final words = input
      .split(RegExp(r'[\.\-\s\/]'))
      .where((final w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'unknown';
  var result = words[0].toLowerCase();
  for (var i = 1; i < words.length; i++) {
    result += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
  }
  return result;
}

String formatHex(String hex, num? alpha) {
  final rgbHex = hex.toUpperCase().replaceAll("#", '');

  // calculate alpha (default: 1.0.FF)
  final double a = (alpha ?? 1.0).toDouble();
  final int alphaInt = (a * 255).round().clamp(0, 255);
  final String alphaHex = alphaInt
      .toRadixString(16)
      .padLeft(2, '0')
      .toUpperCase();

  return '0x$alphaHex$rgbHex';
}

/// Load and parse a JSON file from the tokens directory.
/// Example: loadJson('tokens/ColorBaseTokens.json')
Map<String, dynamic> loadJson(final String path) {
  return jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
}

/// Run `dart format` on the file at [path] after generation.
void formatFile(final String path) {
  final result = Process.runSync('dart', <String>['format', path]);
  stdout.write(result.stdout);
  if (result.stderr.toString().isNotEmpty) stderr.write(result.stderr);
}
