import 'package:bison_design_system/bison_design_system.dart';
import 'package:flutter/material.dart';

/// Represents a single item in a [BisonMenu].
///
/// Example usage:
/// ```dart
/// final menuItems = [
///   BisonMenuItem(
///     label: 'Settings',
///     icon: Icon(Icons.settings),
///     onSelect: () => print('Settings selected'),
///   ),
///   BisonMenuItem(
///     label: 'Help',
///     icon: Icon(Icons.help),
///     onSelect: () => print('Help selected'),
///   ),
/// ];
/// ```
class BisonMenuItem {
  /// The text label for the menu item.
  final String label;

  /// Optional icon for the menu item.
  final Icon? icon;

  /// Callback function called when the menu item is selected.
  final VoidCallback? onSelect;

  /// Whether the menu item is enabled or disabled.
  /// Disabled items appear visually different and don't trigger onSelect.
  final bool enabled;

  /// Creates a new [BisonMenuItem].
  const BisonMenuItem({
    required this.label,
    this.icon,
    this.onSelect,
    this.enabled = true,
  });
}

/// A customizable menu component that displays a list of items in a dropdown.
///
/// This component provides a consistent look and feel with the rest of the design system
/// by using theme tokens for styling.
///
/// Example usage:
/// ```dart
/// final menuItems = [
///   BisonMenuItem(
///     label: 'Save',
///     onSelect: () => print('Save clicked'),
///   ),
///   BisonMenuItem(
///     label: 'Delete',
///     icon: Icon(Icons.delete),
///     onSelect: () => print('Delete clicked'),
///   ),
/// ];
///
/// BisonMenu(
///   menuLabel: 'Actions',
///   items: menuItems,
/// )
/// ```
class BisonMenu extends StatelessWidget {
  /// The list of menu items to display.
  final List<BisonMenuItem> items;

  /// The label text for the menu button.
  final String menuLabel;

  /// Optional icon for the menu button.
  final Icon? icon;

  /// Whether the menu is enabled or disabled.
  /// When disabled, the menu button appears visually different and doesn't open.
  final bool enabled;

  /// Creates a new [BisonMenu].
  const BisonMenu({
    super.key,
    required this.items,
    required this.menuLabel,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final padding = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typo = Theme.of(context).extension<BisonTypographyTokens>()!;

    return PopupMenuTheme(
      data: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(corners.cornerExtraSmall),
          ),
        ),
        surfaceTintColor: theme.surfaceDefault,
        elevation: 0,
        textStyle: typo.bodyLarge.copyWith(color: theme.textPrimary),
        iconColor: theme.textPrimary,
        color: theme.surfaceDefault,
      ),
      child: PopupMenuButton<BisonMenuItem>(
        enabled: enabled,
        itemBuilder: (context) => items
            .map(
              (item) => PopupMenuItem<BisonMenuItem>(
                value: item,
                enabled: item.enabled,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      item.icon!,
                      SizedBox(width: padding.tinySpacing),
                    ],
                    Text(item.label),
                  ],
                ),
              ),
            )
            .toList(),
        onSelected: (item) {
          if (item.enabled && item.onSelect != null) {
            item.onSelect!();
          }
        },
        tooltip: menuLabel,
        child: _buildMenuButton(theme, padding, corners, typo),
      ),
    );
  }

  /// Builds the menu button widget that triggers the dropdown.
  Widget _buildMenuButton(
    final BisonThemeTokens theme,
    final BisonSpacingTokens padding,
    final BisonCornerTokens corners,
    final BisonTypographyTokens typo,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding.smallSpacing,
        vertical: padding.tinySpacing,
      ),
      decoration: BoxDecoration(
        color: theme.surfaceDefault,
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
        border: Border.all(color: theme.borderPlain),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            menuLabel,
            style: typo.bodyLarge.copyWith(color: theme.textPrimary),
          ),
          SizedBox(width: padding.tinySpacing),
          Icon(Icons.arrow_drop_down, color: theme.textPrimary),
        ],
      ),
    );
  }

  /// Creates a [PopupMenuThemeData] that matches the design system styling.
  PopupMenuThemeData _popupMenuTheme(
    final BisonThemeTokens theme,
    final BisonSpacingTokens padding,
    final BisonCornerTokens corners,
    final BisonTypographyTokens typo,
  ) {
    return PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
      surfaceTintColor: theme.surfaceDefault,
      elevation: 0,
      textStyle: typo.bodyLarge.copyWith(color: theme.textPrimary),
      iconColor: theme.textPrimary,
      color: theme.surfaceDefault,
    );
  }
}
