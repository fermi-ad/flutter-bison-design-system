import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

const _bisonScrimKey = ValueKey<String>('bison-scrim');

class BisonScrim extends StatelessWidget {
  final bool barrierDismissible;
  final String barrierLabel;
  final VoidCallback onDismiss;

  const BisonScrim({
    super.key,
    required this.barrierDismissible,
    required this.onDismiss,
    this.barrierLabel = 'Dismiss Dialog',
  });

  @override
  Widget build(final BuildContext context) {
    final currentTheme = Theme.of(context);
    final boxColor = currentTheme.brightness == Brightness.light
        ? const Color(0xFF000000).withValues(alpha: .24)
        : const Color(0xFF000000).withValues(alpha: .72);
    return Semantics(
      label: barrierLabel,
      button: barrierDismissible,
      child: GestureDetector(
        key: _bisonScrimKey,
        behavior: HitTestBehavior.opaque,
        onTap: barrierDismissible ? onDismiss : null,
        // TODO: Change to token once provided
        child: ColoredBox(color: boxColor),
      ),
    );
  }
}
