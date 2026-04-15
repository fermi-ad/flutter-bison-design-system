import 'color_token_parser.dart' as color_parser;
import 'shape_spacing_token_parser.dart' as shape_spacing_parser;
import 'typography_token_parser.dart' as typography_parser;
import 'dart:developer' show log;

void main() {
  log('Generating color tokens...');
  color_parser.main();
  log('Generating shape & spacing tokens...');
  shape_spacing_parser.main();
  log('Generating typography tokens...');
  typography_parser.main();
  log('Done. ');
}
