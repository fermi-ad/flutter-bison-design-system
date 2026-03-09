import 'package:test/test.dart' show group, test, expect;
import '../../tool/color_token_parser.dart' as parser;

void main() {
  group('Testing Alpha values', () {
    test('Hex format returns transparent hex value', () {
      final hexInput = '#f8f8f8';
      expect(parser.formatHex(hexInput, 0), '0x00F8F8F8');
    });

    test('Hex format returns opaque hex value', () {
      final hexInput = '#f8f8f8';
      expect(parser.formatHex(hexInput, 1), '0xFFF8F8F8');
    });
  });
}
