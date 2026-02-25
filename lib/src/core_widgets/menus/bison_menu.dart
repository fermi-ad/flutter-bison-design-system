import 'package:flutter/material.dart';
import 'package:disable_web_context_menu/disable_web_context_menu.dart'
    show DisableWebContextMenu;
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonCornerTokens,
        BisonSpacingTokens,
        BisonThemeTokens,
        BisonTypographyTokens;

typedef BisonMenuBuilder =
    Widget Function(
      BuildContext context,
      FocusNode focusNode, {
      required VoidCallback toggleMenu,
      required bool isOpen,
    });

/// Specifies the type of action that triggers the menu.
enum BisonMenuTriggerAction {
  /// Defer to the builder widget to trigger the menu. Use this if the widget
  /// already has a built-in handler like `onPressed` to ensure proper
  /// accessibility.
  defer,

  /// Primary (left click on web).
  primary,

  /// Secondary (right click on web).
  secondary,
}

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
  final BisonMenuBuilder builder;

  /// The list of menu items to display.
  final List<BisonMenuItem> items;

  /// Specifies what type of action triggers the menu.
  final BisonMenuTriggerAction triggerAction;

  /// Creates a new [BisonMenu].
  const BisonMenu({
    super.key,
    required this.builder,
    required this.items,
    this.triggerAction = BisonMenuTriggerAction.defer,
  });

  @override
  State<BisonMenu> createState() => _BisonMenuState();
}

class _BisonMenuState extends State<BisonMenu> {
  final FocusNode _childFocusNode = FocusNode(debugLabel: 'Menu Trigger');

  @override
  void dispose() {
    _childFocusNode.dispose();
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
      childFocusNode: _childFocusNode,
      menuChildren: widget.items.indexed.map((final element) {
        final (index, item) = element;

        return MenuItemButton(
          autofocus: index == 0,
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
      builder: (final context, final controller, _) {
        void toggleMenu() =>
            controller.isOpen ? controller.close() : controller.open();

        final child = widget.builder(
          context,
          _childFocusNode,
          toggleMenu: toggleMenu,
          isOpen: controller.isOpen,
        );

        if (widget.triggerAction == BisonMenuTriggerAction.primary) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(onTap: toggleMenu, child: child),
          );
        }
        // For secondary (right-click) trigger, we want to display "context
        // menu" style, positioning menu at cursor location.
        else if (widget.triggerAction == BisonMenuTriggerAction.secondary) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onSecondaryTapDown: (final tapDetails) =>
                  controller.open(position: tapDetails.localPosition),
              onTapDown: (_) => controller.close(),
              child: DisableWebContextMenu(child: child),
            ),
          );
        } else {
          return child;
        }
      },
    );
  }
}
