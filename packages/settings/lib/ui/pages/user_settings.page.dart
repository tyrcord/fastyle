import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';
import 'package:matex_financial/financial.dart';

class FastUserSettingsPage extends FastSettingPageLayout {
  const FastUserSettingsPage({
    super.key,
    super.headerDescriptionText,
    super.contentPadding,
    super.iconHeight,
    super.headerIcon,
    super.titleText,
    super.actions,
  });

  @override
  Widget buildSettingsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...buildUserInputCategory(context),
        kFastVerticalSizedBox16,
        ...buildUserDefaultValuesCategory(context),
      ],
    );
  }

  List<Widget> buildUserInputCategory(BuildContext context) {
    return [
      const FastListHeader(categoryText: 'USER INPUT'),
      FastUserSettingsSaveEntryBuilder(
        builder: (BuildContext context, FastUserSettingsBlocState state) {
          return FastToggleListItem(
            isEnabled: state.isInitialized,
            labelText: 'Auto-save',
            isChecked: state.saveEntry,
            onValueChanged: (bool saveEntry) {
              dispatchEvent(
                context,
                FastUserSettingsBlocEvent.saveEntryChanged(saveEntry),
              );
            },
          );
        },
      ),
    ];
  }

  List<Widget> buildUserDefaultValuesCategory(BuildContext context) {
    return [
      const FastListHeader(categoryText: 'DEFAULT VALUES'),
      FastUserSettingsPrimaryCurrencyBuilder(builder: (_, state) {
        return MatexSelectInstrumentField(
          selection: state.primaryCurrencyCode,
        );
      }),
    ];
  }

  @override
  Widget buildSettingsHeaderIcon(BuildContext context) {
    return const FastSettingPageHeaderRoundedDuotoneIconLayout(
      icon: FaIcon(FontAwesomeIcons.solidUser),
    );
  }

  void dispatchEvent(BuildContext context, FastUserSettingsBlocEvent event) {
    final bloc = BlocProvider.of<FastUserSettingsBloc>(context);

    bloc.addEvent(event);
  }
}
