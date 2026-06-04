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
  /// Label displayed above the input field.
  final String? label;

  /// Helper text displayed below the input field. It can be used
  /// for more information on error/warning states
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
  ///
  /// `false` by default.
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

/// Holds the hover + focus interaction state and notifies listeners on change.
///
/// Using a dedicated [ChangeNotifier] lets us rebuild only the container
/// decoration without touching [_InputArea], which would cause [EditableText]
/// to lose focus.
class _InteractionState extends ChangeNotifier {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get isHovered => _isHovered;
  bool get isFocused => _isFocused;

  set isHovered(final bool value) {
    if (_isHovered == value) return;
    _isHovered = value;
    notifyListeners();
  }

  set isFocused(final bool value) {
    if (_isFocused == value) return;
    _isFocused = value;
    notifyListeners();
  }
}

class _BisonTextFieldState extends State<BisonTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final _InteractionState _interaction = _InteractionState();

  bool _ownsController = false;
  bool _ownsFocusNode = false;

  /// Returns the storage identifier used for [PageStorage] persistence.
  ///
  /// Uses the widget's [Key] when one is provided so that multiple
  /// [BisonTextField] instances on the same page each get their own slot.
  /// Falls back to a fixed symbol when no key is set — safe for the common
  /// single-field-per-page case (e.g. widgetbook use-cases).
  Object get _storageIdentifier => widget.key ?? #BisonTextField_text;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      // Restore any previously saved text so that remounts (e.g. caused by
      // widgetbook's ValueKey(uri)-based use-case rebuilds) do not clear the
      // field.
      final String? savedText =
          PageStorage.maybeOf(
                context,
              )?.readState(context, identifier: _storageIdentifier)
              as String?;
      _controller = TextEditingController(text: savedText ?? '');
      _controller.addListener(_saveTextToPageStorage);
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

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant BisonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Controller swap
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.removeListener(_saveTextToPageStorage);
        _controller.dispose();
      }
      if (widget.controller == null) {
        final String? savedText =
            PageStorage.maybeOf(
                  context,
                )?.readState(context, identifier: _storageIdentifier)
                as String?;
        _controller = TextEditingController(text: savedText ?? '');
        _controller.addListener(_saveTextToPageStorage);
        _ownsController = true;
      } else {
        _controller = widget.controller!;
        _ownsController = false;
      }
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
    _focusNode.removeListener(_onFocusChanged);
    _interaction.dispose();
    if (_ownsController) {
      _controller.removeListener(_saveTextToPageStorage);
      _controller.dispose();
    }
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    _interaction.isFocused = _focusNode.hasFocus;
  }

  /// Persists the current text to [PageStorage] so it survives remounts.
  ///
  /// Only called when [_ownsController] is `true` (i.e. no external controller
  /// was provided). External controllers are the caller's responsibility.
  ///
  /// The storage slot is keyed by [_storageIdentifier], which is the widget's
  /// [Key] when provided, or a fixed fallback symbol otherwise.
  void _saveTextToPageStorage() {
    PageStorage.maybeOf(
      context,
    )?.writeState(context, _controller.text, identifier: _storageIdentifier);
  }

  // ── Color resolution ──────────────────────────────────────────────────────

  /// State priority: disabled > error > warning > focused > hovered > default
  Color _backgroundColor(final BisonThemeTokens theme) {
    if (!widget.enabled) return theme.inputFieldFieldDisabled;
    if (_interaction.isHovered && !_interaction.isFocused) {
      return theme.inputFieldFieldHovered;
    }
    return theme.inputFieldField;
  }

  /// Returns the appropriate [Border] for the current state.
  ///
  /// Focused and warning states show a full border on all sides.
  /// All other states show only a bottom border.
  Border _border(final BisonThemeTokens theme) {
    if (!widget.enabled) {
      return Border(bottom: BorderSide(color: theme.borderDisabled));
    }
    if (widget.hasError) {
      return Border.all(color: theme.borderError);
    }
    if (widget.hasWarning) {
      return Border.all(color: theme.borderWarning);
    }
    if (_interaction.isFocused) {
      return Border.all(color: theme.borderPrimary);
    }
    return Border(bottom: BorderSide(color: theme.borderPlain));
  }

  Color _helperTextColor(final BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    if (widget.hasError) return theme.textError;
    if (widget.hasWarning) return theme.textPlain;
    return theme.textMuted;
  }

  Color _labelColor(final BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    return theme.textMuted;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final theme = bison.theme;
    final spacing = bison.spacing;
    final corners = bison.corners;
    final typography = bison.typography;

    // _InputArea is a StatefulWidget so its element — and the EditableText
    // element inside it — survive rebuilds of _BisonTextFieldState triggered
    // by _interaction notifications.
    //
    // Theme and typography are NOT passed as props to avoid triggering
    // _InputAreaState rebuilds on every parent build (theme objects are
    // recreated each time). Instead _InputAreaState resolves them from context.
    final Widget inputArea = _InputArea(
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
    );

    // ListenableBuilder watches only _interaction so the Container decoration
    // updates on hover/focus without rebuilding inputArea.
    final Widget inputContainer = ListenableBuilder(
      listenable: _interaction,
      builder: (final BuildContext ctx, final Widget? child) {
        return Container(
          decoration: BoxDecoration(
            color: _backgroundColor(theme),
            border: _border(theme),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(corners.cornerExtraSmall),
              topRight: Radius.circular(corners.cornerExtraSmall),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.smallSpacing,
            vertical: spacing.smallSpacing,
          ),
          child: child,
        );
      },
      child: inputArea,
    );

    // TapRegion at the BisonTextField level handles tap-outside reliably.
    // The GestureDetector inside the TapRegion focuses the field when the
    // padding area (outside EditableText's hit area) is tapped.
    final Widget interactiveContainer = TapRegion(
      onTapOutside: widget.enabled ? (_) => _focusNode.unfocus() : null,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.text
            : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => _interaction.isHovered = true : null,
        onExit: widget.enabled ? (_) => _interaction.isHovered = false : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
          child: inputContainer,
        ),
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

// ── Private input area widget ─────────────────────────────────────────────────

/// Owns the [EditableText] and placeholder overlay.
///
/// This must be a [StatefulWidget] so that Flutter preserves its element
/// across rebuilds of the parent [_BisonTextFieldState].
///
/// Theme and typography tokens are resolved from [BuildContext] inside
/// [_InputAreaState.build] rather than passed as constructor props. This
/// prevents [_InputAreaState] from rebuilding [EditableText] every time the
/// parent rebuilds (which would happen because token objects are recreated on
/// each parent [build] call, making them always "new" by identity).
class _InputArea extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? placeholder;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const _InputArea({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.enabled,
    required this.autofocus,
    required this.keyboardType,
    required this.obscureText,
    required this.onChanged,
  });

  @override
  State<_InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<_InputArea> {
  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final theme = bison.theme;
    final typography = bison.typography;

    final Color textColor = widget.enabled
        ? theme.textPlain
        : theme.textDisabled;
    final Color placeholderColor = widget.enabled
        ? theme.textMuted
        : theme.textDisabled;

    final Widget editableText = IgnorePointer(
      ignoring: !widget.enabled,
      child: EditableText(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: typography.bodyLarge.copyWith(color: textColor),
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
    );

    if (widget.placeholder == null) return editableText;

    // Placeholder: ValueListenableBuilder watches the controller so only the
    // Visibility widget updates. The Stack always has exactly two children at
    // fixed indices so EditableText is never remounted when the placeholder
    // toggles.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder:
          (
            final BuildContext ctx,
            final TextEditingValue value,
            final Widget? child,
          ) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                Visibility(
                  visible: value.text.isEmpty,
                  child: IgnorePointer(
                    child: Text(
                      widget.placeholder!,
                      style: typography.bodyLarge.copyWith(
                        color: placeholderColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
      child: editableText,
    );
  }
}
