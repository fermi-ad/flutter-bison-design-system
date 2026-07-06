import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart' show BisonContext;

/// The available visual and semantic states for a [BisonCheckbox].
enum BisonCheckboxValue {
  /// The checkbox is checked.
  selected,

  /// The checkbox is unchecked.
  unselected,

  /// The checkbox represents a partially selected state.
  indeterminate,
}

/// A tri-state checkbox that follows the Bison design system.
///
/// The widget supports the following states through [value]:
/// - [BisonCheckboxValue.selected]
/// - [BisonCheckboxValue.unselected]
/// - [BisonCheckboxValue.indeterminate]
///
/// Interaction is controlled by [onChanged]:
/// - Non-null: interactive checkbox with mouse and keyboard support.
/// - `null`: non-interactive checkbox with disabled styling.
///
/// ## Basic usage
/// ```dart
/// BisonCheckbox(
///   value: isChecked
///       ? BisonCheckboxValue.selected
///       : BisonCheckboxValue.unselected,
///   onChanged: (_) {
///     setState(() {
///       isChecked = !isChecked;
///     });
///   },
/// )
/// ```
///
/// ## Indeterminate state
/// ```dart
/// BisonCheckbox(
///   value: BisonCheckboxValue.indeterminate,
///   onChanged: (currentValue) {
///     // Resolve to your next state in parent state management.
///   },
/// )
/// ```
///
/// ## Disabled (pass null to onChanged)
/// ```dart
/// BisonCheckbox(
///   value: BisonCheckboxValue.unselected,
///   onChanged: null,
/// )
/// ```
class BisonCheckbox extends StatefulWidget {
  /// The current checkbox state.
  final BisonCheckboxValue value;

  /// Called when the checkbox is tapped or activated via keyboard.
  ///
  /// The callback receives the current [value]. The parent widget is
  /// responsible for resolving and applying the next state.
  ///
  /// Pass `null` to render a disabled, non-interactive checkbox.
  final ValueChanged<BisonCheckboxValue>? onChanged;

  /// Optional [FocusNode] for external focus management.
  final FocusNode? focusNode;

  /// Whether this checkbox should request focus automatically.
  final bool autofocus;

  /// Creates a Bison checkbox.
  ///
  /// By default, the checkbox starts in [BisonCheckboxValue.unselected].
  const BisonCheckbox({
    super.key,
    this.value = BisonCheckboxValue.unselected,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<BisonCheckbox> createState() => _BisonCheckboxState();
}

class _BisonCheckboxState extends State<BisonCheckbox> {
  static const _containerKey = Key('bison_checkbox_container');
  static const _stateLayerKey = Key('bison_checkbox_state_layer');
  static const _focusLayerKey = Key('bison_checkbox_focus_layer');

  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  bool get _isInteractive => widget.onChanged != null;

  void _setPressed(final bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  void _handleTap() {
    widget.onChanged?.call(widget.value);
  }

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final theme = bison.theme;

    final isSelected = widget.value == BisonCheckboxValue.selected;
    final isUnselected = widget.value == BisonCheckboxValue.unselected;
    final isIndeterminate = widget.value == BisonCheckboxValue.indeterminate;

    final showFocusRing = _isFocused;
    final showHoverLayer = _isHovered && !_isPressed;

    final containerColor = isUnselected
        ? theme.surfaceTransparent
        : _isInteractive
        ? theme.selectorSelectorPlain
        : theme.selectorSelectorDisabled;

    final containerBorder = isUnselected
        ? Border.all(
            color: _isInteractive
                ? theme.selectorSelectorPlain
                : theme.selectorSelectorDisabled,
            width: 2,
          )
        : null;

    final stateLayerDecoration = BoxDecoration(
      color: _isPressed
          ? theme.selectorSelectorPressed
          : showHoverLayer
          ? theme.selectorSelectorHover
          : theme.surfaceTransparent,
      borderRadius: BorderRadius.circular(bison.corners.cornerExtraSmall),
    );

    final focusRingDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(bison.corners.cornerExtraSmall),
      border: showFocusRing
          ? Border.all(color: theme.borderPrimary, width: 2)
          : null,
    );

    return Semantics(
      checked: isSelected,
      mixed: isIndeterminate,
      enabled: _isInteractive,
      child: FocusableActionDetector(
        enabled: _isInteractive,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: _isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (final ActivateIntent intent) {
              _handleTap();
              return null;
            },
          ),
        },
        onShowHoverHighlight: (final value) {
          if (_isHovered == value) return;
          setState(() => _isHovered = value);
        },
        onFocusChange: (final value) {
          if (_isFocused == value) return;
          setState(() => _isFocused = value);
        },
        child: Padding(
          padding: EdgeInsets.all(bison.spacing.tinySpacing),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
            onTapUp: _isInteractive ? (_) => _setPressed(false) : null,
            onTapCancel: _isInteractive ? () => _setPressed(false) : null,
            onTap: _isInteractive ? _handleTap : null,
            child: Container(
              key: _stateLayerKey,
              decoration: stateLayerDecoration,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Container(
                      key: _focusLayerKey,
                      decoration: focusRingDecoration,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(bison.spacing.microSpacing),
                    child: Container(
                      key: _containerKey,
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: containerColor,
                        border: containerBorder,
                        borderRadius: BorderRadius.circular(
                          bison.corners.cornerExtraSmall / 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: theme.selectorSelectorCheckboxCheck,
                            )
                          : isIndeterminate
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: theme.selectorSelectorCheckboxCheck,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
