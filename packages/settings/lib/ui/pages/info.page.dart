import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

const _kFooterMargin = EdgeInsets.only(top: 16.0);

class FastAppInfoPage<T> extends StatelessWidget {
  final List<FastSettingsNavigationCategoryDescriptor<T>> categoryDescriptors;
  final void Function(FastItem<T>) onNavigationItemTap;
  final EdgeInsets? contentPadding;
  final EdgeInsets? footerPadding;
  final EdgeInsets? headerPadding;
  final List<Widget>? actions;
  final bool showAppVersion;
  final String? footerText;
  final String? titleText;
  final bool showAppBar;
  final Widget? header;

  const FastAppInfoPage({
    super.key,
    required this.onNavigationItemTap,
    this.headerPadding,
    this.contentPadding,
    this.footerPadding,
    this.footerText,
    this.titleText,
    this.actions,
    this.header,
    this.categoryDescriptors = const [],
    this.showAppVersion = true,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: titleText ?? SettingsLocaleKeys.settings_label_settings.tr(),
      contentPadding: contentPadding ?? EdgeInsets.zero,
      isViewScrollable: true,
      showAppBar: showAppBar,
      actions: actions,
      footer: buildFooter(context),
      child: Column(
        children: [
          if (header != null)
            Padding(padding: kFastEdgeInsets16, child: header),
          Column(children: buildNavigationCategories(context)),
        ],
      ),
    );
  }

  List<Widget> buildNavigationCategories(BuildContext context) {
    final List<Widget> categories = [];

    for (var navigationCategoryDescriptor in categoryDescriptors) {
      final items = navigationCategoryDescriptor.items;

      categories.add(FastListHeader(
        categoryText: navigationCategoryDescriptor.titleText,
        categoryColor: navigationCategoryDescriptor.titleColor,
        captionText: navigationCategoryDescriptor.captionText,
        captionColor: navigationCategoryDescriptor.captionColor,
      ));

      for (var paneDescriptor in items) {
        Widget listItem = buildNavigationListItem(context, paneDescriptor);
        categories.add(listItem);
      }
    }

    return categories;
  }

  FastNavigationListItem buildNavigationListItem(
    BuildContext context,
    FastItem<T> item,
  ) {
    return FastNavigationListItem<FastItem<T>>(
      onTap: () => onNavigationItemTap(item),
      item: item,
    );
  }

  /// Builds the footer of the setting page.
  Widget buildFooter(BuildContext context) {
    if (footerText != null) {
      return Container(
        padding: footerPadding ?? _kFooterMargin,
        alignment: Alignment.bottomCenter,
        child: FastSecondaryBody(text: footerText!),
      );
    }

    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final appInfo = appInfoBloc.currentState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FastAppCopyright(author: appInfo.appAuthor),
        FastAppVersion(
          buildNumber: appInfo.appBuildNumber!,
          margin: const EdgeInsets.only(top: 8.0),
          version: appInfo.appVersion!,
        ),
      ],
    );
  }
}
