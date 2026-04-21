import 'package:test/test.dart' show group, test, expect;
import 'package:bison_design_system/src/token_parsers/token_parser_utils.dart'
    show toCamelCase, formatHex;
import 'package:bison_design_system/src/token_parsers/color_parser.dart'
    as color_parser;
import 'package:bison_design_system/src/token_parsers/shape_spacing_parser.dart'
    as shape_spacing_parser;
import 'package:bison_design_system/src/token_parsers/typography_parser.dart'
    as typography_parser;

void main() {
  group('toCamelCase', () {
    test('converts single word to lowercase', () {
      expect(toCamelCase('primary'), 'primary');
    });

    test('converts space-separated words to camelCase', () {
      expect(toCamelCase('primary color'), 'primaryColor');
    });

    test('converts dash-separated words to camelCase', () {
      expect(toCamelCase('extra-light'), 'extraLight');
    });

    test('converts dot-separated words to camelCase', () {
      expect(toCamelCase('color.primary'), 'colorPrimary');
    });

    test('converts slash-separated words to camelCase', () {
      expect(toCamelCase('Beam Blue/0'), 'beamBlue0');
    });

    test('handles mixed separators', () {
      expect(toCamelCase('color-primary.dark/100'), 'colorPrimaryDark100');
    });

    test('preserves case for multi-word middle parts', () {
      expect(toCamelCase('Font Weight'), 'fontWeight');
    });

    test('returns unknown for empty string', () {
      expect(toCamelCase(''), 'unknown');
    });
  });

  group('formatHex', () {
    test('formats hex with transparent alpha (0)', () {
      expect(formatHex('#f8f8f8', 0), '0x00F8F8F8');
    });

    test('formats hex with opaque alpha (1)', () {
      expect(formatHex('#f8f8f8', 1), '0xFFF8F8F8');
    });

    test('formats hex with half transparency (0.5)', () {
      final result = formatHex('#ffffff', 0.5);
      expect(result, '0x80FFFFFF');
    });

    test('handles missing alpha parameter (required)', () {
      // Note: alpha is required, so we pass null to test default behavior
      // The formatHex function treats null as 1.0 (opaque)
      expect(formatHex('#f8f8f8', null), '0xFFF8F8F8');
    });

    test('converts lowercase hex to uppercase', () {
      expect(formatHex('#abc123', 1), '0xFFABC123');
    });

    test('strips # prefix from input', () {
      final result = formatHex('#000000', 1);
      expect(result, '0xFF000000');
    });

    test('clamps alpha values between 0 and 1', () {
      expect(formatHex('#ffffff', -0.5), '0x00FFFFFF');
      expect(formatHex('#ffffff', 1.5), '0xFFFFFFFF');
    });
  });

  group('extractBaseTokens', () {
    test('extracts flat color tokens', () {
      final json = <String, dynamic>{
        'Red': <String, dynamic>{
          '\$value': {'hex': '#FF0000', 'alpha': 1},
        },
        'Blue': <String, dynamic>{
          '\$value': {'hex': '#0000FF', 'alpha': 1},
        },
      };
      final target = <String, String>{};

      color_parser.extractBaseTokens(json, '', target);

      expect(target.length, 2);
      expect(target['Red'], '0xFFFF0000');
      expect(target['Blue'], '0xFF0000FF');
    });

    test('extracts nested color tokens', () {
      final json = <String, dynamic>{
        'Primary': <String, dynamic>{
          '100': <String, dynamic>{
            '\$value': {'hex': '#FFE5E5', 'alpha': 1},
          },
          '200': <String, dynamic>{
            '\$value': {'hex': '#FFCCCC', 'alpha': 1},
          },
        },
      };
      final target = <String, String>{};

      color_parser.extractBaseTokens(json, '', target);

      expect(target.length, 2);
      expect(target['Primary.100'], '0xFFFFE5E5');
      expect(target['Primary.200'], '0xFFFFCCCC');
    });

    test('skips keys starting with \$', () {
      final json = <String, dynamic>{
        '\$metadata': <String, dynamic>{},
        'Red': <String, dynamic>{
          '\$value': {'hex': '#FF0000', 'alpha': 1},
        },
      };
      final target = <String, String>{};

      color_parser.extractBaseTokens(json, '', target);

      expect(target.length, 1);
      expect(target['Red'], '0xFFFF0000');
    });

    test('handles alpha values', () {
      final json = <String, dynamic>{
        'Transparent': <String, dynamic>{
          '\$value': {'hex': '#000000', 'alpha': 0},
        },
      };
      final target = <String, String>{};

      color_parser.extractBaseTokens(json, '', target);

      expect(target['Transparent'], '0x00000000');
    });
  });

  group('extractAliasTokens', () {
    test('extracts simple aliases', () {
      final json = <String, dynamic>{
        'Primary': <String, dynamic>{
          '\$extensions': <String, dynamic>{
            'com.figma.aliasData': <String, String>{
              'targetVariableName': 'Red/100',
            },
          },
        },
        'Secondary': <String, dynamic>{
          '\$extensions': <String, dynamic>{
            'com.figma.aliasData': <String, String>{
              'targetVariableName': 'Blue/100',
            },
          },
        },
      };

      final result = color_parser.extractAliasTokens(json);

      expect(result.length, 2);
      expect(result['Primary'], 'Red/100');
      expect(result['Secondary'], 'Blue/100');
    });

    test('extracts nested aliases', () {
      final json = <String, dynamic>{
        'Color': <String, dynamic>{
          'Primary': <String, dynamic>{
            '\$extensions': <String, dynamic>{
              'com.figma.aliasData': <String, String>{
                'targetVariableName': 'Red/100',
              },
            },
          },
        },
      };

      final result = color_parser.extractAliasTokens(json);

      expect(result.length, 1);
      expect(result['Color.Primary'], 'Red/100');
    });
  });

  group('extractComponentTokens', () {
    test('extracts component tokens', () {
      final json = <String, dynamic>{
        'Button': <String, dynamic>{
          'Primary': <String, dynamic>{
            '\$extensions': <String, dynamic>{
              'com.figma.aliasData': <String, String>{
                'targetVariableName': 'Primary/Default',
              },
            },
          },
        },
      };
      final target = <String, String>{};

      color_parser.extractComponentTokens(json, '', target);

      expect(target['Button.Primary'], 'Primary/Default');
    });
  });

  group('extractSpacingTokens', () {
    test('extracts flat spacing tokens', () {
      final json = <String, dynamic>{
        'Small': <String, dynamic>{'\$value': 4},
        'Medium': <String, dynamic>{'\$value': 8},
        'Large': <String, dynamic>{'\$value': 16},
      };
      final target = <String, int>{};

      shape_spacing_parser.extractSpacingTokens(json, '', target);

      expect(target.length, 3);
      expect(target['Small'], 4);
      expect(target['Medium'], 8);
      expect(target['Large'], 16);
    });

    test('skips keys starting with \$', () {
      final json = <String, dynamic>{
        '\$metadata': <String, dynamic>{},
        'Small': <String, dynamic>{'\$value': 4},
      };
      final target = <String, int>{};

      shape_spacing_parser.extractSpacingTokens(json, '', target);

      expect(target.length, 1);
      expect(target['Small'], 4);
    });
  });

  group('extractCornerTokens', () {
    test('extracts nested corner tokens', () {
      final json = <String, dynamic>{
        'Corner': <String, dynamic>{
          'None': <String, dynamic>{'\$value': 0},
          'Small': <String, dynamic>{'\$value': 4},
        },
      };
      final target = <String, int>{};

      shape_spacing_parser.extractCornerTokens(json, '', target);

      expect(target.length, 2);
      expect(target['Corner.None'], 0);
      expect(target['Corner.Small'], 4);
    });

    test('handles deeply nested structure', () {
      final json = <String, dynamic>{
        'Shape': <String, dynamic>{
          'Border': <String, dynamic>{
            'Radius': <String, dynamic>{'\$value': 8},
          },
        },
      };
      final target = <String, int>{};

      shape_spacing_parser.extractCornerTokens(json, '', target);

      expect(target['Shape.Border.Radius'], 8);
    });
  });

  group('resolveBaselineValue', () {
    test('resolves root-level value', () {
      final json = <String, dynamic>{
        'Brand': <String, dynamic>{'\$value': 'Atkinson'},
      };

      final result = typography_parser.resolveBaselineValue(json, 'Brand');

      expect(result, 'Atkinson');
    });

    test('resolves slash-delimited path', () {
      final json = <String, dynamic>{
        'Weight': <String, dynamic>{
          'Bold': <String, dynamic>{'\$value': 'SemiBold'},
        },
      };

      final result = typography_parser.resolveBaselineValue(
        json,
        'Weight/Bold',
      );

      expect(result, 'SemiBold');
    });

    test('resolves deeply nested path', () {
      final json = <String, dynamic>{
        'Typography': <String, dynamic>{
          'Font': <String, dynamic>{
            'Family': <String, dynamic>{'\$value': 'Roboto'},
          },
        },
      };

      final result = typography_parser.resolveBaselineValue(
        json,
        'Typography/Font/Family',
      );

      expect(result, 'Roboto');
    });
  });

  group('mapWeight', () {
    test('maps extralight to w200', () {
      expect(typography_parser.mapWeight('ExtraLight'), 'FontWeight.w200');
    });

    test('maps light to w300', () {
      expect(typography_parser.mapWeight('Light'), 'FontWeight.w300');
    });

    test('maps regular (default) to w400', () {
      expect(typography_parser.mapWeight('Regular'), 'FontWeight.w400');
    });

    test('maps medium to w500', () {
      expect(typography_parser.mapWeight('Medium'), 'FontWeight.w500');
    });

    test('maps semibold to w600', () {
      expect(typography_parser.mapWeight('SemiBold'), 'FontWeight.w600');
    });

    test('maps bold to w700', () {
      expect(typography_parser.mapWeight('Bold'), 'FontWeight.w700');
    });

    test('maps extrabold to w800', () {
      expect(typography_parser.mapWeight('ExtraBold'), 'FontWeight.w800');
    });

    test('handles case insensitivity', () {
      expect(typography_parser.mapWeight('BOLD'), 'FontWeight.w700');
      expect(typography_parser.mapWeight('semibold'), 'FontWeight.w600');
    });

    test('returns w400 for unknown weight', () {
      expect(typography_parser.mapWeight('Unknown'), 'FontWeight.w400');
    });
  });

  group('Testing Alpha values (legacy tests)', () {
    test('Hex format returns transparent hex value', () {
      final hexInput = '#f8f8f8';
      expect(formatHex(hexInput, 0), '0x00F8F8F8');
    });

    test('Hex format returns opaque hex value', () {
      final hexInput = '#f8f8f8';
      expect(formatHex(hexInput, 1), '0xFFF8F8F8');
    });
  });
}
