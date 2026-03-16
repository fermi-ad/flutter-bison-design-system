import 'dart:async' show Completer;

import 'package:flutter/material.dart' show Theme;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonButton,
        BisonCornerTokens,
        BisonSpacingTokens,
        BisonThemeTokens,
        BisonTypographyTokens;

const _bisonDialogBarrierKey = ValueKey<String>('bison-dialog-barrier');
const _bisonDialogSurfaceKey = ValueKey<String>('bison-dialog-surface');

class BisonDialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool dismissDialog;

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

  static Future<void> show({
    required final BuildContext context,
    required final String title,
    required final String body,
    final BisonDialogAction? destructiveAction,
    final BisonDialogAction? secondaryAction,
    required final BisonDialogAction primaryAction,
    final bool barrierDismissible = true,
    final String barrierLabel = 'Dismiss dialog',
    final double minWidth = 280.0,
    final double maxWidth = 560.0,
    final EdgeInsets? insetPadding,
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
        barrierLabel: barrierLabel,
        minWidth: minWidth,
        maxWidth: maxWidth,
        insetPadding: insetPadding,
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

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: DecoratedBox(
        key: _bisonDialogSurfaceKey,
        decoration: BoxDecoration(
          color: theme.surfaceDefault,
          borderRadius: BorderRadius.circular(corners.cornerSmall),
          border: Border.all(color: theme.borderPlain),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.24),
              blurRadius: spacing.smallSpacing,
              offset: Offset(0, spacing.tinySpacing),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.standardSpacing),
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
                  if (secondary != null)
                    SizedBox(width: spacing.tinySpacing),
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
  final String barrierLabel;
  final double minWidth;
  final double maxWidth;
  final EdgeInsets? insetPadding;
  final VoidCallback onDismiss;

  const _BisonDialogOverlay({
    required this.title,
    required this.body,
    required this.destructiveAction,
    required this.secondaryAction,
    required this.primaryAction,
    required this.barrierDismissible,
    required this.barrierLabel,
    required this.minWidth,
    required this.maxWidth,
    required this.insetPadding,
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
    final resolvedInsetPadding =
        insetPadding ?? EdgeInsets.all(spacing.standardSpacing);

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
              child: _BisonDialogScrim(
                barrierDismissible: barrierDismissible,
                barrierLabel: barrierLabel,
                onDismiss: onDismiss,
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                minimum: resolvedInsetPadding,
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

class _BisonDialogScrim extends StatelessWidget {
  final bool barrierDismissible;
  final String barrierLabel;
  final VoidCallback onDismiss;

  const _BisonDialogScrim({
    required this.barrierDismissible,
    required this.barrierLabel,
    required this.onDismiss,
  });

  @override
  Widget build(final BuildContext context) {
    final currentTheme = Theme.of(context);
    final boxColor = currentTheme.brightness == Brightness.light
        ? Color(0x00000000).withValues(alpha: 24.0)
        : Color(0x00000000).withValues(alpha: 72.0);
    return Semantics(
      label: barrierLabel,
      button: barrierDismissible,
      child: GestureDetector(
        key: _bisonDialogBarrierKey,
        behavior: HitTestBehavior.opaque,
        onTap: barrierDismissible ? onDismiss : null,
        // TODO: Change to token once provided
        child: ColoredBox(color: boxColor),
      ),
    );
  }
}
