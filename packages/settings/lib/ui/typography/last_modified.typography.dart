// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

class FastSettingsLastModified extends StatelessWidget {
  final DateTime lastModifiedAt;

  const FastSettingsLastModified({super.key, required this.lastModifiedAt});

  @override
  Widget build(BuildContext context) {
    final appSettingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    final appSettings = appSettingsBloc.currentState;
    final pendingDate = formatDateTime(
      lastModifiedAt,
      languageCode: appSettings.languageCode,
      countryCode: appSettings.countryCode,
      showTime: false,
    );

    return FastParagraph(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: FutureBuilder(
        future: pendingDate,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FastSecondaryBody(
              text: SettingsLocaleKeys.settings_message_last_modified
                  .tr(namedArgs: {'date': snapshot.data.toString()}),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
