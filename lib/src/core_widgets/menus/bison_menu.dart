import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:disable_web_context_menu/disable_web_context_menu.dart'
    show DisableWebContextMenu;
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonContext,
        BisonThemeTokens,
        BisonSpacingTokens,
        BisonCornerTokens,
        BisonTypographyTokens;

/// A function type that builds the menu trigger widget.
///
/// This function is responsible for creating the widget that will trigger the
/// menu to open. It receives the [BuildContext], a [FocusNode] for the trigger
/// element, a callback [toggleMenu] to control the menu state, and a bool
/// [isOpen] that conveys whether the menu is currently open.
///
/// Example usage:
/// ```dart
/// builder: (context, focusNode, {required toggleMenu, required isOpen}) {
///   return IconButton(
///     icon: Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
///     onPressed: toggleMenu,
///     focusNode: focusNode,
///   );
/// }
/// ```
typedef BisonMenuBuilder =
    Widget Function(
      BuildContext context,
      FocusNode focusNode, {
      required VoidCallback toggleMenu,
      required bool isOpen,
    });

/// Specifies the type of action that triggers the menu.
///
/// This enum determines how the menu is triggered:
/// - [defer]: Defer to the builder widget to trigger the menu. Use this if the
///   widget already has a built-in handler like `onPressed` to ensure proper
///   accessibility. This is the most common use case.
/// - [primary]: Triggered by a primary action (left click on web) handled by
///   the menu widget. This is a relatively rare use case. Make sure the builder
///   widget can receive focus to improve accessibilty.
/// - [secondary]: Triggered by a secondary action (right click on web) handled
///   by the menu widget. Use this for context menus.
enum BisonMenuTriggerAction { defer, primary, secondary }

/// Represents a single item in a [BisonMenu].
///
/// Each menu item consists of a label, an optional icon, and a callback function
/// that is executed when the item is selected. If [onSelect] is null, the menu
/// item will be disabled.
///
/// Example usage:
/// ```dart
/// BisonMenuItem(
///   label: 'Settings',
///   icon: Icon(Icons.settings),
///   onSelect: () => print('Settings selected'),
/// )
/// ```
class BisonMenuItem {
  final String label;
  final VoidCallback? onSelect;
  final Icon? icon;

  const BisonMenuItem({required this.label, required this.onSelect, this.icon});
}

/// A customizable menu component that displays a list of items in a dropdown.
///
/// This widget provides a flexible menu solution that can be triggered by different
/// actions and supports keyboard navigation.
///
/// Example usage:
/// ```dart
/// BisonMenu(
///   builder: (context, focusNode, {required toggleMenu, required isOpen}) {
///     return IconButton(
///       icon: Icon(Icons.menu),
///       onPressed: toggleMenu,
///       focusNode: focusNode,
///     );
///   },
///   items: [
///     BisonMenuItem(
///       label: 'Settings',
///       icon: Icon(Icons.settings),
///       onSelect: () => print('Settings selected'),
///     ),
///   ],
/// )
/// ```
class BisonMenu extends StatefulWidget {
  /// The builder function that creates the menu trigger widget.
  final BisonMenuBuilder builder;

  /// The list of menu items to display.
  final List<BisonMenuItem> items;

  /// Specifies what type of action triggers the menu.
  final BisonMenuTriggerAction triggerAction;

  /// Creates a new [BisonMenu].
  ///
  /// [builder] is required and defines the widget that will trigger the menu.
  /// [items] is required and defines the list of menu items to display.
  /// [triggerAction] is optional and defaults to [BisonMenuTriggerAction.defer].
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
  /// Focus node for the menu trigger element.
  final FocusNode _childFocusNode = FocusNode(debugLabel: 'Menu Trigger');

  /// Controller for managing the menu's open/closed state.
  final MenuController _controller = MenuController();

  /// Focus nodes for each menu item, one per item in [widget.items].
  ///
  /// This list is managed by [_syncFocusNodes] to ensure it matches the number
  /// of items in the menu.
  final List<FocusNode> _itemFocusNodes = [];

  /// Synchronizes the number of focus nodes with the current number of menu items.
  void _syncFocusNodes() {
    // Ensure we have exactly N nodes for current items.
    final n = widget.items.length;

    // Add nodes if needed.
    while (_itemFocusNodes.length < n) {
      _itemFocusNodes.add(
        FocusNode(debugLabel: 'menuItem${_itemFocusNodes.length}'),
      );
    }

    // Remove extras (and dispose them).
    while (_itemFocusNodes.length > n) {
      final node = _itemFocusNodes.removeLast();
      node.dispose();
    }
  }

  FocusNode? _firstFocusable() {
    for (final n in _itemFocusNodes) {
      if (n.canRequestFocus) return n;
    }
    return null;
  }

  FocusNode? _lastFocusable() {
    for (final n in _itemFocusNodes.reversed) {
      if (n.canRequestFocus) return n;
    }
    return null;
  }

  /// Requests focus on the first focusable menu item.
  void _focusFirst() => _firstFocusable()?.requestFocus();

  /// Requests focus on the last focusable menu item.
  void _focusLast() => _lastFocusable()?.requestFocus();

  @override
  void dispose() {
    _childFocusNode.dispose();
    for (final n in _itemFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    // Make sure nodes are synced before building menu children.
    _syncFocusNodes();

    return MenuAnchor(
      style: getBisonMenuStyle(bison.theme, bison.spacing, bison.corners),
      childFocusNode: _childFocusNode,
      controller: _controller,
      menuChildren: [
        CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.home): _focusFirst,
            const SingleActivator(LogicalKeyboardKey.end): _focusLast,
            const SingleActivator(LogicalKeyboardKey.tab): () =>
                _controller.close(),
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.indexed.map((final element) {
              final (index, item) = element;
              final focusNode = _itemFocusNodes[index];

              return MenuItemButton(
                focusNode: focusNode,
                autofocus: index == 0 && focusNode.canRequestFocus,
                style: getBisonMenuButtonStyle(
                  bison.theme,
                  bison.spacing,
                  bison.typography,
                ),
                onPressed: item.onSelect,
                leadingIcon: item.icon,
                child: Text(item.label),
              );
            }).toList(),
          ),
        ),
      ],
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

MenuStyle getBisonMenuStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
) {
  return MenuStyle(
    backgroundColor: WidgetStatePropertyAll(theme.surfaceDefault),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(vertical: padding.tinySpacing),
    ),
  );
}

/// Builds the button style for menu items.
///
/// [theme] The theme tokens for styling.
/// [padding] The spacing tokens for padding.
/// [typo] The typography tokens for text styling.
///
/// Returns a [ButtonStyle] object that defines the visual appearance of menu
/// items.
ButtonStyle getBisonMenuButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(theme.surfaceTransparent),
    overlayColor: WidgetStateProperty.resolveWith<Color>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return theme.navigationSelectedActive;
      }
      if (states.any(
        (final state) =>
            state == WidgetState.hovered || state == WidgetState.focused,
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
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        horizontal: padding.xSmallSpacing,
        vertical: padding.tinySpacing,
      ),
    ),
    textStyle: WidgetStatePropertyAll(typo.bodyLarge),
  );
}
