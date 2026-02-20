// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bison_design_system_catalog/bison_button.dart'
    as _bison_design_system_catalog_bison_button;
import 'package:bison_design_system_catalog/bison_menu.dart'
    as _bison_design_system_catalog_bison_menu;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'core_widgets',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'buttons',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_button
                    .buildBisonButtonUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'menus',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonMenu',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_menu
                    .buildBisonMenuUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
