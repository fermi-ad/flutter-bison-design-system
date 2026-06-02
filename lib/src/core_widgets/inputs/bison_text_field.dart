import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart'
    show BisonContext, BisonThemeTokens;

/// A text field widget for the Bison design system.
///
/// Built on [EditableText] with no dependency on the Material library.
///
/// Supports an optional [label] displayed above the input and optional
/// [helperText] displayed below. Visual state (border color, background)
/// adapts to disabled, error, warning, focused, hovered, and default states.
///
/// ```dart
/// BisonTextField(
///   label: 'Email',
///   placeholder: 'you@example.com',
///   helperText: 'We will never share your email.',
/// )
/// ```
class BisonTextField extends StatefulWidget {
  /// Optional label displayed above the input field.
  ///
  /// Rendered using the `capitalizedLabel` typography token.
  final String? label;

  /// Optional helper text displayed below the input field.
  ///
  /// Color adapts to the current state:
  /// - Error → `textError`
  /// - Warning → `textPlain`
  /// - Disabled → `textDisabled`
  /// - Default → `textMuted`
  final String? helperText;

  /// Placeholder text shown inside the field when it is empty.
  final String? placeholder;

  /// Controls the text being edited.
  ///
  /// If not provided, an internal controller is created and managed by the
  /// widget.
  final TextEditingController? controller;

  /// Controls whether this widget has keyboard focus.
  ///
  /// If not provided, an internal [FocusNode] is created and managed by the
  /// widget.
  final FocusNode? focusNode;

  /// Whether the text field is interactive.
  ///
  /// Defaults to `true`. When `false`, the field ignores pointer events and
  /// renders with disabled styling.
  final bool enabled;

  /// Whether the field is in an error state.
  ///
  /// When `true`, the border uses `borderError` and [helperText] (if any) is
  /// rendered in `textError`. Takes precedence over [hasWarning].
  final bool hasError;

  /// Whether the field is in a warning state.
  ///
  /// When `true`, the border uses `borderWarning`. Ignored when [hasError] is
  /// also `true`.
  final bool hasWarning;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether the field should request focus as soon as it is mounted.
  final bool autofocus;

  /// The type of keyboard to display for editing.
  final TextInputType? keyboardType;

  /// Whether to obscure the text, e.g. for password fields.
  final bool obscureText;

  const BisonTextField({
    super.key,
    this.label,
    this.helperText,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.hasError = false,
    this.hasWarning = false,
    this.onChanged,
    this.autofocus = false,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  State<BisonTextField> createState() => _BisonTextFieldState();
}

class _BisonTextFieldState extends State<BisonTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _ownsController = false;
  bool _ownsFocusNode = false;

  bool _isHovered = false;
  bool _isFocused = false;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
    }

    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }

    _isEmpty = _controller.text.isEmpty;
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant BisonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Controller swap
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onTextChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      if (widget.controller == null) {
        _controller = TextEditingController();
        _ownsController = true;
      } else {
        _controller = widget.controller!;
        _ownsController = false;
      }
      _controller.addListener(_onTextChanged);
      _isEmpty = _controller.text.isEmpty;
    }

    // FocusNode swap
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      } else {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      }
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final empty = _controller.text.isEmpty;
    if (empty != _isEmpty) {
      setState(() => _isEmpty = empty);
    }
  }

  void _onFocusChanged() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  // ── Color resolution ──────────────────────────────────────────────────────

  /// State priority: disabled > error > warning > focused > hovered > default
  Color _backgroundColor(BisonThemeTokens theme) {
    if (!widget.enabled) return theme.inputFieldFieldDisabled;
    if (widget.hasError) return theme.inputFieldField;
    if (widget.hasWarning) return theme.inputFieldField;
    if (_isFocused) return theme.inputFieldField;
    if (_isHovered) return theme.inputFieldFieldHovered;
    return theme.inputFieldField;
  }

  Color _borderColor(BisonThemeTokens theme) {
    if (!widget.enabled) return theme.borderDisabled;
    if (widget.hasError) return theme.borderError;
    if (widget.hasWarning) return theme.borderWarning;
    if (_isFocused) return theme.borderPrimary;
    return theme.borderPlain;
  }

  Color _textColor(BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    return theme.textPlain;
  }

  Color _placeholderColor(BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    return theme.textMuted;
  }

  Color _helperTextColor(BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    if (widget.hasError) return theme.textError;
    if (widget.hasWarning) return theme.textPlain;
    return theme.textMuted;
  }

  Color _labelColor(BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    return theme.textMuted;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bison = context.bison;
    final theme = bison.theme;
    final spacing = bison.spacing;
    final corners = bison.corners;
    final typography = bison.typography;

    final TextStyle textStyle = typography.bodyLarge.copyWith(
      color: _textColor(theme),
    );

    final Widget inputArea = Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (widget.placeholder != null && _isEmpty)
          IgnorePointer(
            child: Text(
              widget.placeholder!,
              style: typography.bodyLarge.copyWith(
                color: _placeholderColor(theme),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        IgnorePointer(
          ignoring: !widget.enabled,
          child: EditableText(
            controller: _controller,
            focusNode: _focusNode,
            style: textStyle,
            cursorColor: theme.borderPrimary,
            backgroundCursorColor: theme.textDisabled,
            selectionColor: theme.borderPrimary.withValues(alpha: 0.3),
            autofocus: widget.autofocus,
            readOnly: !widget.enabled,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            cursorWidth: 2.0,
            cursorRadius: const Radius.circular(1.0),
          ),
        ),
      ],
    );

    final Widget inputContainer = Container(
      decoration: BoxDecoration(
        color: _backgroundColor(theme),
        border: Border.all(color: _borderColor(theme)),
        borderRadius: BorderRadius.circular(corners.cornerSmall),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.tinySpacing,
        vertical: spacing.xSmallSpacing,
      ),
      child: inputArea,
    );

    final Widget interactiveContainer = MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.text
          : SystemMouseCursors.basic,
      onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
        child: inputContainer,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typography.capitalizedLabel.copyWith(
              color: _labelColor(theme),
            ),
          ),
          SizedBox(height: spacing.microSpacing),
        ],
        interactiveContainer,
        if (widget.helperText != null) ...[
          SizedBox(height: spacing.microSpacing),
          Text(
            widget.helperText!,
            style: typography.bodySmall.copyWith(
              color: _helperTextColor(theme),
            ),
          ),
        ],
      ],
    );
  }
}
