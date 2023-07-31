// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

const _kFooterMargin = EdgeInsets.only(top: 16.0);

class FastAppInfoPage<T> extends StatelessWidget {
  final List<FastNavigationCategoryDescriptor<T>> categoryDescriptors;
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
      titleText: titleText ?? 'App Info',
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

      for (var item in items) {
        Widget listItem = buildNavigationListItem(context, item);
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
