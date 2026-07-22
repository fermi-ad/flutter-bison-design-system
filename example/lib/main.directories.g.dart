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
import 'package:bison_design_system_catalog/bison_checkbox.dart'
    as _bison_design_system_catalog_bison_checkbox;
import 'package:bison_design_system_catalog/bison_chip.dart'
    as _bison_design_system_catalog_bison_chip;
import 'package:bison_design_system_catalog/bison_dialog.dart'
    as _bison_design_system_catalog_bison_dialog;
import 'package:bison_design_system_catalog/bison_divider.dart'
    as _bison_design_system_catalog_bison_divider;
import 'package:bison_design_system_catalog/bison_icon_button.dart'
    as _bison_design_system_catalog_bison_icon_button;
import 'package:bison_design_system_catalog/bison_menu.dart'
    as _bison_design_system_catalog_bison_menu;
import 'package:bison_design_system_catalog/bison_radio_button.dart'
    as _bison_design_system_catalog_bison_radio_button;
import 'package:bison_design_system_catalog/bison_scrim.dart'
    as _bison_design_system_catalog_bison_scrim;
import 'package:bison_design_system_catalog/bison_switch.dart'
    as _bison_design_system_catalog_bison_switch;
import 'package:bison_design_system_catalog/bison_text_field.dart'
    as _bison_design_system_catalog_bison_text_field;
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
          _widgetbook.WidgetbookComponent(
            name: 'BisonIconButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Filled',
                builder: _bison_design_system_catalog_bison_icon_button
                    .buildBisonIconButtonFilledUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Ghost',
                builder: _bison_design_system_catalog_bison_icon_button
                    .buildBisonIconButtonGhostUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined',
                builder: _bison_design_system_catalog_bison_icon_button
                    .buildBisonIconButtonOutlinedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Small Ghost',
                builder: _bison_design_system_catalog_bison_icon_button
                    .buildBisonIconButtonSmallGhostUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'White Ghost',
                builder: _bison_design_system_catalog_bison_icon_button
                    .buildBisonIconButtonWhiteGhostUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'checkboxes',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonCheckbox',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All States',
                builder: _bison_design_system_catalog_bison_checkbox
                    .buildBisonCheckboxAllStatesUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_checkbox
                    .buildBisonCheckboxUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _bison_design_system_catalog_bison_checkbox
                    .buildBisonCheckboxInteractiveUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'chips',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonChip',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_chip
                    .buildBisonChipUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Device',
                builder: _bison_design_system_catalog_bison_chip
                    .buildBisonChipDeviceUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Grouping Navigation',
                builder: _bison_design_system_catalog_bison_chip
                    .buildBisonChiGroupUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'dialogs',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Dialog with Text',
                builder: _bison_design_system_catalog_bison_dialog
                    .buildBisonDialogText,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Trigger Dialog',
                builder: _bison_design_system_catalog_bison_dialog
                    .buildBisonDialogTrigger,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'dividers',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonDivider',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_divider
                    .buildBisonDivider,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'inputs',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonTextField',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Text Field',
                builder: _bison_design_system_catalog_bison_text_field
                    .buildBisonTextField,
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
              _widgetbook.WidgetbookUseCase(
                name: 'Right Click (Context Menu)',
                builder: _bison_design_system_catalog_bison_menu
                    .buildRightClickContextMenuUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'overlays',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonScrim',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_scrim
                    .buildBisonScrimUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'radios',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonRadioButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All States',
                builder: _bison_design_system_catalog_bison_radio_button
                    .buildBisonRadioButtonAllStatesUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _bison_design_system_catalog_bison_radio_button
                    .buildBisonRadioButtonUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'switches',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BisonSwitch',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Switch',
                builder:
                    _bison_design_system_catalog_bison_switch.buildBisonSwitch,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
