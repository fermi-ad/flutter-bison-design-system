import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonContext, BisonThemeTokens, BisonCornerTokens;

/// Provides different styling options for the `BisonButton` widget.
///
/// The different styling options included
/// - [BisonButtonType.filled] The most prominent styling option. This is the default option
/// - [BisonButtonType.outlined]
/// - [BisonButtonType.ghost]
/// - [BisonButtonType.destructive]
enum _BisonButtonType {
  /// The most prominent styling option. This is the default option
  filled,

  /// An outlined button with a transparent background.
  ghost,

  /// The least prominent option. It has no outline and a transparent background
  outlined,

  /// Used to signify a destructive action such as delete
  destructive,
}

/// Provides a set of button types
class BisonButton extends StatefulWidget {
  final String buttonLabel;
  final _BisonButtonType _buttonType;
  final Icon? icon;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;

  const BisonButton._({
    required this.buttonLabel,
    required this.onPressed,
    required _BisonButtonType buttonType,
    this.icon,
    this.focusNode,
    this.autofocus = false,
  }) : _buttonType = buttonType;

  /// A Filled button with the primary color. The most prominent styling option.
  factory BisonButton.filled({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.filled,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// A transparent button without an outline. The least prominent option
  factory BisonButton.ghost({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.ghost,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// A transparent button with an outline
  factory BisonButton.outlined({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.outlined,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// A button to signify a destructive action
  factory BisonButton.destructive({
    required String buttonLabel,
    required VoidCallback? onPressed,
    Icon? icon,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return BisonButton._(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      buttonType: _BisonButtonType.destructive,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  @override
  State<BisonButton> createState() => _BisonButtonState();
}

/// Class that holds the styling data for a button
class _BisonButtonResolvedStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide borderSide;
  final double borderRadius;

  const _BisonButtonResolvedStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderSide,
    required this.borderRadius,
  });
}

class _BisonButtonState extends State<BisonButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  FocusNode? _internalFocusNode;

  bool get _isEnabled => widget.onPressed != null;

  FocusNode get _effectiveFocusNode {
    return widget.focusNode ?? (_internalFocusNode ??= FocusNode());
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  Set<WidgetState> get _states {
    final states = <WidgetState>{};
    if (!_isEnabled) states.add(WidgetState.disabled);
    if (_isHovered) states.add(WidgetState.hovered);
    if (_isFocused) states.add(WidgetState.focused);
    if (_isPressed) states.add(WidgetState.pressed);
    return states;
  }

  _BisonButtonResolvedStyle _resolveStyle(
    final BisonThemeTokens theme,
    final BisonCornerTokens corners,
  ) {
    final states = _states;

    final borderSide = states.contains(WidgetState.focused)
        ? BorderSide(color: theme.borderPrimary, width: 2.0)
        : switch (widget._buttonType) {
            _BisonButtonType.outlined => BorderSide(color: theme.borderPlain),
            _ => BorderSide.none,
          };

    return switch (widget._buttonType) {
      _BisonButtonType.filled => _BisonButtonResolvedStyle(
        backgroundColor: _filledBackground(theme, states),
        foregroundColor: states.contains(WidgetState.disabled)
            ? theme.textDisabled
            : theme.textInverse,
        borderSide: borderSide,
        borderRadius: corners.cornerExtraSmall,
      ),
      _BisonButtonType.ghost => _BisonButtonResolvedStyle(
        backgroundColor: _ghostBackground(theme, states),
        foregroundColor: states.contains(WidgetState.disabled)
            ? theme.textDisabled
            : theme.textPrimary,
        borderSide: borderSide,
        borderRadius: corners.cornerExtraSmall,
      ),
      _BisonButtonType.outlined => _BisonButtonResolvedStyle(
        backgroundColor: _ghostBackground(theme, states),
        foregroundColor: states.contains(WidgetState.disabled)
            ? theme.textDisabled
            : theme.textPrimary,
        borderSide: borderSide,
        borderRadius: corners.cornerExtraSmall,
      ),
      _BisonButtonType.destructive => _BisonButtonResolvedStyle(
        backgroundColor: _destructiveBackground(theme, states),
        foregroundColor: states.contains(WidgetState.disabled)
            ? theme.textDisabled
            : theme.textInverse,
        borderSide: borderSide,
        borderRadius: corners.cornerExtraSmall,
      ),
    };
  }

  Color _filledBackground(
    final BisonThemeTokens theme,
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.buttonGhostDisabled;
    }
    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return theme.buttonPrimaryFocusedPressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonPrimaryHovered;
    }
    return theme.buttonPrimary;
  }

  Color _ghostBackground(
    final BisonThemeTokens theme,
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.pressed)) {
      return theme.buttonGhostPressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonGhostHovered;
    }
    return theme.surfaceTransparent;
  }

  Color _destructiveBackground(
    final BisonThemeTokens theme,
    final Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return theme.buttonGhostDisabled;
    }
    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return theme.buttonDangerFocusedPressed;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.buttonDangerHovered;
    }
    return theme.buttonDanger;
  }

  Future<void> _handleActivate() async {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final style = _resolveStyle(bison.theme, bison.corners);

    final buttonContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: bison.spacing.smallSpacing,
        vertical: bison.spacing.tinySpacing,
      ),
      child: widget.icon == null
          ? Text(widget.buttonLabel)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon!,
                SizedBox(width: bison.spacing.tinySpacing),
                Text(widget.buttonLabel),
              ],
            ),
    );

    final visual = DecoratedBox(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: Border.fromBorderSide(style.borderSide),
        borderRadius: BorderRadius.circular(style.borderRadius),
      ),
      child: IconTheme(
        data: IconThemeData(color: style.foregroundColor),
        child: DefaultTextStyle(
          style: bison.typography.bodyLarge.copyWith(
            color: style.foregroundColor,
          ),
          child: buttonContent,
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.buttonLabel,
      child: FocusableActionDetector(
        enabled: _isEnabled,
        focusNode: _effectiveFocusNode,
        autofocus: widget.autofocus,
        mouseCursor: _isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleActivate();
              return null;
            },
          ),
        },
        onShowFocusHighlight: (final value) {
          setState(() => _isFocused = value);
        },
        onFocusChange: (final isFocused) {
          if (!isFocused) {
            setState(() {
              _isFocused = false;
              _isHovered = false;
              _isPressed = false;
            });
          }
        },
        child: MouseRegion(
          onEnter: _isEnabled ? (_) => setState(() => _isHovered = true) : null,
          onExit: _isEnabled
              ? (_) => setState(() {
                  _isHovered = false;
                  _isPressed = false;
                })
              : null,
          child: GestureDetector(
            onTapDown: _isEnabled
                ? (_) => setState(() => _isPressed = true)
                : null,
            onTapUp: _isEnabled
                ? (_) => setState(() => _isPressed = false)
                : null,
            onTapCancel: _isEnabled
                ? () => setState(() => _isPressed = false)
                : null,
            onTap: _isEnabled ? widget.onPressed : null,
            behavior: HitTestBehavior.opaque,
            child: visual,
          ),
        ),
      ),
    );
  }
}
