import 'package:flutter/material.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonCornerTokens,
        BisonSpacingTokens,
        BisonThemeTokens,
        BisonTypographyTokens;

/// Represents a single item in a [BisonMenu].
class BisonMenuItem {
  /// The text label for the menu item.
  final String label;

  /// Optional icon for the menu item.
  final Icon? icon;

  /// Callback function called when the menu item is selected.
  /// If null, the menu item will be disabled.
  final VoidCallback? onSelect;

  /// Creates a new [BisonMenuItem].
  const BisonMenuItem({required this.label, this.icon, this.onSelect});
}

/// A customizable menu component that displays a list of items in a dropdown using MenuAnchor.
class BisonMenu extends StatefulWidget {
  /// The Widget that should anchor and trigger the menu.
  final Widget anchor;

  /// The list of menu items to display.
  final List<BisonMenuItem> items;

  /// The label text for the menu button.
  final String menuLabel;

  /// Creates a new [BisonMenu].
  const BisonMenu({
    super.key,
    required this.anchor,
    required this.items,
    required this.menuLabel,
  });

  @override
  State<BisonMenu> createState() => _BisonMenuState();
}

class _BisonMenuState extends State<BisonMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final padding = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typo = Theme.of(context).extension<BisonTypographyTokens>()!;

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(theme.surfaceDefault),
      ),
      childFocusNode: _buttonFocusNode,
      menuChildren: widget.items.map((final item) {
        return MenuItemButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((
              final Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return theme.navigationSelectedActive;
              }
              if (states.any(
                (final state) =>
                    state == WidgetState.hovered ||
                    state == WidgetState.focused,
              )) {
                return theme.surfaceHovered;
              }
              return theme.surfaceTransparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((
              final Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.disabled)) {
                return theme.textDisabled;
              }
              return theme.textPlain;
            }),
            iconColor: WidgetStateProperty.resolveWith<Color?>((
              final Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.disabled)) {
                return theme.iconDisabled;
              }
              return theme.iconPlain;
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(corners.cornerExtraSmall),
                ),
              ),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: padding.smallSpacing,
                vertical: padding.tinySpacing,
              ),
            ),
            textStyle: WidgetStatePropertyAll(typo.bodyLarge),
          ),
          onPressed: item.onSelect,
          child: Row(
            children: [
              if (item.icon != null) ...[
                item.icon!,
                SizedBox(width: padding.tinySpacing),
              ],
              Text(item.label),
            ],
          ),
        );
      }).toList(),
      builder:
          (
            final BuildContext context,
            final MenuController controller,
            final Widget? child,
          ) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                child: child,
              ),
            );
          },
      child: widget.anchor,
    );
  }
}
