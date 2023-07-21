// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastShare {
  static Future<void> shareApp(
    BuildContext context, {
    String? message,
    String? subject,
  }) {
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final appInfo = appInfoBloc.currentState;
    final box = context.findRenderObject() as RenderBox?;

    if (box == null) {
      debugPrint('The context has no render object');

      return Future.value();
    }

    if (appInfo.shareAppUrl == null) {
      debugPrint('The app url is not defined');
    }

    message ??= CoreLocaleKeys.core_message_share_invite.tr();

    return Share.share(
      '$message\n\n${appInfo.shareAppUrl ?? appInfo.appName}',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      subject: subject ?? appInfo.appName,
    );
  }
}
