import 'package:test/test.dart';
import '../lib/src/theme/token_parser.dart' as parser;

void main() {
  test('Hex format returns black if hex is not 6 or 8 chars', () {
    const hexInput = '#1234';
    expect(parser.formatHex(hexInput), '0xFF000000');
  });
}
