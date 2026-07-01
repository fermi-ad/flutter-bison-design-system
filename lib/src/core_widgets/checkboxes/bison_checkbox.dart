import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart' show BisonContext;

enum BisonCheckboxValue { selected, unselected, indeterminate }

class BisonCheckbox extends StatefulWidget {
  final BisonCheckboxValue value;
  final ValueChanged<BisonCheckboxValue>? onChanged;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;

  const BisonCheckbox({
    super.key,
    this.value = BisonCheckboxValue.unselected,
    this.onChanged,
    this.enabled = true,
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

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  void _setPressed(final bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  BisonCheckboxValue _nextValue() {
    switch (widget.value) {
      case BisonCheckboxValue.selected:
        return BisonCheckboxValue.unselected;
      case BisonCheckboxValue.unselected:
        return BisonCheckboxValue.selected;
      case BisonCheckboxValue.indeterminate:
        return BisonCheckboxValue.selected;
    }
  }

  void _toggle() {
    if (!_isInteractive) return;
    widget.onChanged?.call(_nextValue());
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
        : widget.enabled
        ? theme.selectorSelectorPlain
        : theme.selectorSelectorDisabled;

    final containerBorder = isUnselected
        ? Border.all(
            color: widget.enabled
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
              _toggle();
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
            onTap: _toggle,
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
                        borderRadius: BorderRadius.circular(2),
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
                                width: 10,
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
