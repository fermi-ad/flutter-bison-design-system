import 'dart:async' show Completer;

import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonButton, BisonScrim, BisonContext;

class BisonDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool dismissDialog;

  /// Builds an action button for a BisonDialog.
  ///
  /// This takes a [label], [onPressed], and [dismissDialog].
  ///
  /// [label] is shown on the button, and [onPressed] is called when the
  /// button is pressed.
  /// When [onPressed] is not given, the button will be in a disabled state.
  /// [dismissDialog] determines whether the dialog should be closed after the
  /// button is pressed. This is true by default.
  const BisonDialogAction({
    required this.label,
    this.onPressed,
    this.dismissDialog = true,
  });
}

class BisonDialog extends StatelessWidget {
  static const _surfaceKey = ValueKey<String>('bison-dialog-surface');
  static Future<void>? _activeDialogFuture;
  static GlobalKey? _activeDialogKey;
  static bool _isDialogOpening = false;

  final String title;
  final Widget body;
  final BisonDialogAction primaryAction;
  final BisonDialogAction? secondaryAction;
  final BisonDialogAction? destructiveAction;
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
    required this.primaryAction,
    this.secondaryAction,
    this.destructiveAction,
    this.minWidth = 280.0,
    this.maxWidth = 560.0,
  });

  /// Displays a BisonDialog as an overlay.
  ///
  /// Takes a [BuildContext] and the properties needed for a [BisonDialog]
  /// (see [BisonDialog()]). By default, the dialog can be dismissed by tapping
  /// outside of it or pressing the 'ESC' key.
  ///  To disable this, set [barrierDismissible] to false.
  static Future<void> show({
    required final BuildContext context,
    required final String title,
    required final Widget body,
    required final BisonDialogAction primaryAction,
    final BisonDialogAction? secondaryAction,
    final BisonDialogAction? destructiveAction,
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

    final currentDialog = _activeDialogFuture;
    final currentDialogKey = _activeDialogKey;
    if (_isDialogOpening) {
      return currentDialog ?? Future<void>.value();
    }
    if (currentDialog != null && currentDialogKey?.currentContext != null) {
      return currentDialog;
    }

    final completer = Completer<void>();
    final dialogKey = GlobalKey();
    late final OverlayEntry entry;

    void closeDialog() {
      _isDialogOpening = false;
      if (entry.mounted) {
        entry.remove();
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
      _activeDialogKey = null;
    }

    final capturedThemes = InheritedTheme.capture(
      from: context,
      to: overlay.context,
    );

    entry = OverlayEntry(
      builder: (final overlayContext) => capturedThemes.wrap(
        KeyedSubtree(
          key: dialogKey,
          child: _BisonDialogOverlay(
            title: title,
            body: body,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            destructiveAction: destructiveAction,
            barrierDismissible: barrierDismissible,
            minWidth: minWidth,
            maxWidth: maxWidth,
            onDismiss: closeDialog,
          ),
        ),
      ),
    );

    _activeDialogFuture = completer.future.whenComplete(() {
      _isDialogOpening = false;
      _activeDialogFuture = null;
      _activeDialogKey = null;
    });

    _isDialogOpening = true;
    overlay.insert(entry);
    _activeDialogKey = dialogKey;
    return _activeDialogFuture!;
  }

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    final primary = primaryAction;
    final secondary = secondaryAction;
    final destructive = destructiveAction;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: DecoratedBox(
        key: _surfaceKey,
        decoration: BoxDecoration(
          color: bison.theme.surfaceDefault,
          borderRadius: BorderRadius.circular(bison.corners.cornerSmall),
          border: Border.all(style: BorderStyle.none),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, bison.spacing.tinySpacing),
              blurRadius: bison.spacing.xSmallSpacing,
              spreadRadius: 6.0,
              color: const Color(0xFF000000).withValues(alpha: 0.15),
            ),
            BoxShadow(
              offset: Offset(0, bison.spacing.microSpacing),
              blurRadius: bison.spacing.microSpacing,
              spreadRadius: 0,
              color: const Color(0xFF000000).withValues(alpha: .30),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(bison.spacing.mediumSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: bison.typography.h3),
              SizedBox(height: bison.spacing.smallSpacing),
              body,
              SizedBox(height: bison.spacing.standardSpacing),
              FocusScope(
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Row(
                    children: [
                      if (destructive != null)
                        FocusTraversalOrder(
                          order: NumericFocusOrder(3.0),
                          child: BisonButton.destructive(
                            buttonLabel: destructive.label,
                            onPressed: destructive.onPressed,
                          ),
                        ),
                      const Spacer(),
                      if (secondary != null)
                        FocusTraversalOrder(
                          order: NumericFocusOrder(2.0),
                          child: BisonButton.outlined(
                            buttonLabel: secondary.label,
                            onPressed: secondary.onPressed,
                          ),
                        ),
                      if (secondary != null)
                        SizedBox(width: bison.spacing.tinySpacing),
                      FocusTraversalOrder(
                        order: NumericFocusOrder(1.0),
                        child: BisonButton.filled(
                          buttonLabel: primary.label,
                          onPressed: primary.onPressed,
                          autofocus: true,
                        ),
                      ),
                    ],
                  ),
                ),
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
  final Widget body;
  final BisonDialogAction primaryAction;
  final BisonDialogAction? secondaryAction;
  final BisonDialogAction? destructiveAction;
  final bool barrierDismissible;
  final double minWidth;
  final double maxWidth;
  final VoidCallback onDismiss;

  const _BisonDialogOverlay({
    required this.title,
    required this.body,
    required this.primaryAction,
    required this.secondaryAction,
    required this.destructiveAction,
    required this.barrierDismissible,
    required this.minWidth,
    required this.maxWidth,
    required this.onDismiss,
  });

  BisonDialogAction _wrapAction(final BisonDialogAction action) {
    return BisonDialogAction(
      label: action.label,
      dismissDialog: action.dismissDialog,
      onPressed: action.onPressed == null
          ? null
          : () {
              action.onPressed!();
              if (action.dismissDialog) onDismiss();
            },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return CallbackShortcuts(
      bindings: {
        if (barrierDismissible)
          const SingleActivator(LogicalKeyboardKey.escape): onDismiss,
      },
      child: Focus(
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
                minimum: EdgeInsets.all(bison.spacing.mediumSpacing),
                child: Center(
                  child: BisonDialog(
                    title: title,
                    body: body,
                    minWidth: minWidth,
                    maxWidth: maxWidth,
                    destructiveAction: destructiveAction == null
                        ? null
                        : _wrapAction(destructiveAction!),
                    secondaryAction: secondaryAction == null
                        ? null
                        : _wrapAction(secondaryAction!),
                    primaryAction: _wrapAction(primaryAction),
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
