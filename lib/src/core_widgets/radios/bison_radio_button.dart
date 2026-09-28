import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart' show BisonContext;

/// A radio button control that follows the Bison design system.
///
/// The parent is responsible for storing and updating selection state.
///
/// ## Basic usage
/// ```dart
/// BisonRadioButton(
///   selected: isSelected,
///   onChanged: (_) {
///     setState(() {
///       isSelected = true;
///     });
///   },
/// )
/// ```
///
/// ## Disabled (pass null to onChanged)
/// ```dart
/// BisonRadioButton(
///   selected: false,
///   onChanged: null,
/// )
/// ```
class BisonRadioButton extends StatefulWidget {
  /// Whether the radio is currently selected.
  final bool selected;

  /// Called when the radio is activated.
  ///
  /// The callback receives the current [selected] value. Consumers should use
  /// that value to resolve and apply the next state.
  ///
  /// Pass `null` to render a disabled, non-interactive radio.
  final ValueChanged<bool>? onChanged;

  /// Optional [FocusNode] for external focus management.
  final FocusNode? focusNode;

  /// Whether this radio should request focus automatically.
  final bool autofocus;

  /// Creates a Bison radio button.
  const BisonRadioButton({
    super.key,
    this.selected = false,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<BisonRadioButton> createState() => _BisonRadioButtonState();
}

class _BisonRadioButtonState extends State<BisonRadioButton> {
  static const _focusLayerKey = Key('bison_radio_focus_layer');
  static const _stateLayerKey = Key('bison_radio_state_layer');
  static const _outerCircleKey = Key('bison_radio_outer_circle');
  static const _innerDotKey = Key('bison_radio_inner_dot');

  static const double _tapTargetSize = 48.0;
  static const double _focusLayerSize = 32.0;
  static const double _outerCircleSize = 20.0;
  static const double _outerCircleStroke = 2.0;
  static const double _innerDotSize = 10.0;

  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  bool get _isInteractive => widget.onChanged != null;

  void _setPressed(final bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  void _activate() {
    if (!_isInteractive || widget.selected) return;
    widget.onChanged!.call(widget.selected);
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.bison.theme;
    final showHoverLayer = _isHovered && !_isPressed;

    final indicatorColor = _isInteractive
        ? theme.selectorSelectorPlain
        : theme.selectorSelectorDisabled;
    final stateLayerColor = _isPressed
        ? theme.selectorSelectorPressed
        : showHoverLayer
        ? theme.selectorSelectorHover
        : theme.surfaceTransparent;

    return Semantics(
      checked: widget.selected,
      inMutuallyExclusiveGroup: true,
      enabled: _isInteractive,
      child: FocusableActionDetector(
        enabled: _isInteractive,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: _isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter):
              DoNothingAndStopPropagationIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (final ActivateIntent intent) {
              _activate();
              return null;
            },
          ),
          DoNothingAndStopPropagationIntent: DoNothingAction(consumesKey: true),
        },
        onShowHoverHighlight: (final value) {
          if (_isHovered == value) return;
          setState(() => _isHovered = value);
        },
        onFocusChange: (final value) {
          if (_isFocused == value) return;
          setState(() => _isFocused = value);
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
          onTapUp: _isInteractive ? (_) => _setPressed(false) : null,
          onTapCancel: _isInteractive ? () => _setPressed(false) : null,
          onTap: _isInteractive ? _activate : null,
          child: SizedBox(
            width: _tapTargetSize,
            height: _tapTargetSize,
            child: Center(
              child: Container(
                key: _focusLayerKey,
                width: _focusLayerSize,
                height: _focusLayerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _isFocused
                      ? Border.all(color: theme.borderPrimary, width: 2)
                      : null,
                ),
                child: Center(
                  child: Container(
                    key: _stateLayerKey,
                    width: _focusLayerSize,
                    height: _focusLayerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stateLayerColor,
                    ),
                    child: Center(
                      child: Container(
                        key: _outerCircleKey,
                        width: _outerCircleSize,
                        height: _outerCircleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: indicatorColor,
                            width: _outerCircleStroke,
                          ),
                        ),
                        child: widget.selected
                            ? Center(
                                child: Container(
                                  key: _innerDotKey,
                                  width: _innerDotSize,
                                  height: _innerDotSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: indicatorColor,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
