import 'package:fastyle_animation/fastyle_animation.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

class FastTyrcordLoader extends StatelessWidget {
  const FastTyrcordLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FastTyrcordAnimatedLogo(),
        kFastVerticalSizedBox32,
        FastSecondaryBody(
          text: CoreLocaleKeys.core_message_loading_text.tr(),
        ),
      ],
    );
  }
}
