// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastSettingsSupportLink extends StatelessWidget {
  final String emailText;
  final String prefixText;

  const FastSettingsSupportLink({
    super.key,
    required this.emailText,
    required this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return FastRichTextLink(
      onTap: () => handleAskForSupport(context),
      prefixText: prefixText,
      linkText: emailText,
    );
  }

  void handleAskForSupport(BuildContext context) {
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;

    FastMessenger.writeEmail(appInfo.supportEmail!, subject: appInfo.appName);
  }
}
