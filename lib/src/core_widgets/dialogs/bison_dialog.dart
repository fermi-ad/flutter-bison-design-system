import 'dart:async' show Completer;

import 'package:flutter/material.dart' show Theme;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonButton,
        BisonCornerTokens,
        BisonScrim,
        BisonSpacingTokens,
        BisonThemeTokens,
        BisonTypographyTokens;

const _bisonDialogSurfaceKey = ValueKey<String>('bison-dialog-surface');

class BisonDialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool dismissDialog;

  /// Builds an action button for a BisonDialog.
  ///
  /// This takes a [label], [onPressed], and [dismissDialog].
  ///
  /// [label] is shown on the button, and [onPressed] is called when the
  /// button is pressed. Both are required.
  /// [dismissDialog] determines whether the dialog should be closed after the
  /// button is pressed. This is true by default.
  const BisonDialogAction({
    required this.label,
    required this.onPressed,
    this.dismissDialog = true,
  });
}

class BisonDialog extends StatelessWidget {
  final String title;
  final String body;
  final BisonDialogAction? destructiveAction;
  final BisonDialogAction? secondaryAction;
  final BisonDialogAction primaryAction;
  final double minWidth;
  final double maxWidth;

  /// Builds an instance of BisonDialog.
  ///
  /// Requires a dialog [title], [body], and one [primaryAction] button.
  /// A dialog can have up to 3 buttons and at minimum 1 button, the [primaryAction].
  /// [primaryAction] is right aligned and has a higher visual prominence than the [secondaryAction]
  /// which will be left of the [primaryAction].
  /// A [destructiveAction] can also be passed to the dialog, and will be stylized to give a warning to users.
  /// This button will be left aligned.
  const BisonDialog({
    super.key,
    required this.title,
    required this.body,
    this.destructiveAction,
    this.secondaryAction,
    required this.primaryAction,
    this.minWidth = 280.0,
    this.maxWidth = 560.0,
  });

  /// Displays a BisonDialog as an overlay.
  ///
  /// Takes a [BuildContext] and the properties needed for a [BisonDialog]
  /// (see [BisonDialog()]). By default, the dialog can be dismissed by tapping
  /// outside of it. To disable this, set [barrierDismissible] to false.
  static Future<void> show({
    required final BuildContext context,
    required final String title,
    required final String body,
    final BisonDialogAction? destructiveAction,
    final BisonDialogAction? secondaryAction,
    required final BisonDialogAction primaryAction,
    final bool barrierDismissible = true,
    final double minWidth = 280.0,
    final double maxWidth = 560.0,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return Future<void>.error(
        StateError('BisonDialog.show requires an Overlay in the widget tree.'),
      );
    }

    final completer = Completer<void>();
    late final OverlayEntry entry;

    void closeDialog() {
      if (entry.mounted) {
        entry.remove();
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    entry = OverlayEntry(
      builder: (final overlayContext) => _BisonDialogOverlay(
        title: title,
        body: body,
        destructiveAction: destructiveAction,
        secondaryAction: secondaryAction,
        primaryAction: primaryAction,
        barrierDismissible: barrierDismissible,
        minWidth: minWidth,
        maxWidth: maxWidth,
        onDismiss: closeDialog,
      ),
    );

    overlay.insert(entry);
    return completer.future;
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final spacing = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typography = Theme.of(context).extension<BisonTypographyTokens>()!;

    final destructive = destructiveAction;
    final secondary = secondaryAction;
    final primary = primaryAction;

    return DefaultTextStyle(
      // Added to prevent yellow warning lines.
      // could potentially be removed as Scaffold defines a DefaultTextStyle
      style: TextStyle(decoration: TextDecoration.none),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
        child: DecoratedBox(
          key: _bisonDialogSurfaceKey,
          decoration: BoxDecoration(
            color: theme.surfaceDefault,
            borderRadius: BorderRadius.circular(corners.cornerSmall),
            border: Border.all(style: BorderStyle.none),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, spacing.tinySpacing),
                blurRadius: spacing.xSmallSpacing,
                spreadRadius: 6.0,
                color: const Color(0xFF000000).withValues(alpha: 0.15),
              ),
              BoxShadow(
                offset: Offset(0, spacing.microSpacing),
                blurRadius: spacing.microSpacing,
                spreadRadius: 0,
                color: const Color(0xFF000000).withValues(alpha: .30),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.mediumSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: typography.h3),
                SizedBox(height: spacing.smallSpacing),
                Text(body, style: typography.bodyLarge),
                SizedBox(height: spacing.standardSpacing),
                Row(
                  children: [
                    if (destructive != null)
                      BisonButton.destructive(
                        buttonLabel: destructive.label,
                        onPressed: destructive.onPressed,
                      ),
                    const Spacer(),
                    if (secondary != null)
                      BisonButton.outlined(
                        buttonLabel: secondary.label,
                        onPressed: secondary.onPressed,
                      ),
                    if (secondary != null) SizedBox(width: spacing.tinySpacing),
                    BisonButton.filled(
                      buttonLabel: primary.label,
                      onPressed: primary.onPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BisonDialogOverlay extends StatelessWidget {
  final String title;
  final String body;
  final BisonDialogAction? destructiveAction;
  final BisonDialogAction? secondaryAction;
  final BisonDialogAction primaryAction;
  final bool barrierDismissible;
  final double minWidth;
  final double maxWidth;
  final VoidCallback onDismiss;

  const _BisonDialogOverlay({
    required this.title,
    required this.body,
    required this.destructiveAction,
    required this.secondaryAction,
    required this.primaryAction,
    required this.barrierDismissible,
    required this.minWidth,
    required this.maxWidth,
    required this.onDismiss,
  });

  BisonDialogAction? _wrapAction(final BisonDialogAction? action) {
    if (action == null) return null;
    return BisonDialogAction(
      label: action.label,
      dismissDialog: action.dismissDialog,
      onPressed: () {
        action.onPressed();
        if (action.dismissDialog) onDismiss();
      },
    );
  }

  BisonDialogAction _wrapRequiredAction(final BisonDialogAction action) {
    return BisonDialogAction(
      label: action.label,
      dismissDialog: action.dismissDialog,
      onPressed: () {
        action.onPressed();
        if (action.dismissDialog) onDismiss();
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final spacing = Theme.of(context).extension<BisonSpacingTokens>()!;

    return CallbackShortcuts(
      bindings: {
        if (barrierDismissible)
          const SingleActivator(LogicalKeyboardKey.escape): onDismiss,
      },
      child: FocusScope(
        autofocus: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: BisonScrim(
                barrierDismissible: barrierDismissible,
                onDismiss: onDismiss,
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                minimum: EdgeInsets.all(spacing.mediumSpacing),
                child: Center(
                  child: BisonDialog(
                    title: title,
                    body: body,
                    minWidth: minWidth,
                    maxWidth: maxWidth,
                    destructiveAction: _wrapAction(destructiveAction),
                    secondaryAction: _wrapAction(secondaryAction),
                    primaryAction: _wrapRequiredAction(primaryAction),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

