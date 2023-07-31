// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;

  const FastBackButton({super.key, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return FastIconButton(
      icon: const BackButtonIcon(),
      iconColor: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          if (context.canPop()) {
            context.pop();
          }
        }
      },
    );
  }
}
