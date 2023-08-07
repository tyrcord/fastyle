// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Package imports:

const _kFooterMargin = EdgeInsets.only(top: 16.0);

class FastAppInfoPage<T> extends StatelessWidget {
  final List<FastNavigationCategoryDescriptor<T>> categoryDescriptors;
  final void Function(BuildContext context, FastItem<T>)? onNavigationItemTap;
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
    this.onNavigationItemTap,
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

    for (final navigationCategoryDescriptor in categoryDescriptors) {
      final items = navigationCategoryDescriptor.items;

      categories.add(FastListHeader(
        categoryText: navigationCategoryDescriptor.titleText,
        categoryColor: navigationCategoryDescriptor.titleColor,
        captionText: navigationCategoryDescriptor.captionText,
        captionColor: navigationCategoryDescriptor.captionColor,
      ));

      for (final item in items) {
        final listItem = buildNavigationListItem(context, item);
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
      onTap: () => handleNavigationItemTap(context, item),
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

  void handleNavigationItemTap(BuildContext context, FastItem<T> item) {
    if (onNavigationItemTap != null) {
      onNavigationItemTap!(context, item);
    } else if (item.value != null && item.value is String) {
      final value = item.value as String;

      if (value.startsWith('action://')) {
        final action = value.replaceFirst('action://', '');
        final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
        final appInfo = appInfoBloc.currentState;

        switch (action) {
          case 'contact-us':
            if (appInfo.supportEmail != null) {
              FastMessenger.writeEmail(
                appInfo.supportEmail!,
                subject: appInfo.appName,
              );
            }
          case 'bug-report':
            if (appInfo.supportEmail != null) {
              FastMessenger.writeEmail(
                appInfo.bugReportEmail!,
                subject: appInfo.appName,
              );
            }
          case 'rate-us':
            final rateService = FastAppRatingService(appInfo.toDocument());
            rateService.showAppRatingDialog(context);
          case 'share':
            FastShare.shareApp(context);
          case 'site':
            if (appInfo.homepageUrl != null) {
              FastMessenger.launchUrl(appInfo.homepageUrl!);
            }
          case 'facebook':
            if (appInfo.facebookUrl != null) {
              FastMessenger.launchUrl(
                appInfo.facebookUrl!,
                mode: LaunchMode.externalApplication,
              );
            }
          case 'twitter':
            if (appInfo.twitterUrl != null) {
              FastMessenger.launchUrl(
                appInfo.twitterUrl!,
                mode: LaunchMode.externalApplication,
              );
            }
          case 'instagram':
            if (appInfo.instagramUrl != null) {
              FastMessenger.launchUrl(
                appInfo.instagramUrl!,
                mode: LaunchMode.externalApplication,
              );
            }

          default:
            debugPrint('Unknown action: $action');
            break;
        }
      } else {
        GoRouter.of(context).go(value);
      }
    }
  }
}
