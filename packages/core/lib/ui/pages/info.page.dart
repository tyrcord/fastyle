// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Package imports:

class FastAppInfoPage<T> extends StatelessWidget {
  final List<FastNavigationCategoryDescriptor<T>> categoryDescriptors;
  final void Function(BuildContext context, FastItem<T>)? onNavigationItemTap;
  final bool showEraseContentSettingsButton;
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
    this.showEraseContentSettingsButton = true,
    this.categoryDescriptors = const [],
    this.showAppVersion = true,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ThemeHelper.spacing.getSpacing(context);

    return FastSectionPage(
      contentPadding: EdgeInsets.zero,
      footer: _buildFooter(context),
      isViewScrollable: true,
      showAppBar: showAppBar,
      titleText: titleText,
      actions: actions,
      child: Column(
        children: [
          if (header != null) _buildHeader(context),
          Column(children: buildNavigationCategories(context)),
          if (showEraseContentSettingsButton)
            Container(
              padding: EdgeInsets.only(top: spacing),
              alignment: Alignment.bottomCenter,
              child: _buildEraseContentSettingsButton(context),
            ),
        ],
      ),
    );
  }

  Widget _buildEraseContentSettingsButton(BuildContext context) {
    final redColor = ThemeHelper.getPaletteColors(context).red.mid;

    return FastTextButton2(
      labelText: CoreLocaleKeys.core_label_erase_all_content_and_settings.tr(),
      textStyle: TextStyle(color: redColor),
      upperCase: false,
      onTap: () async {
        showAnimatedFastAlertDialog(
          messageText: CoreLocaleKeys
              .core_message_erase_all_content_and_settings_explanation
              .tr(),
          titleText:
              CoreLocaleKeys.core_question_erase_all_content_and_settings.tr(),
          context: context,
          showCancel: true,
          onValid: () async {
            await clearFastAppData();

            if (context.mounted) FastApp.restart(context);
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final padding = ThemeHelper.spacing.getPadding(context);

    return Container(
      alignment: Alignment.topCenter,
      padding: padding,
      child: header!,
    );
  }

  List<Widget> buildNavigationCategories(BuildContext context) {
    final spacing = ThemeHelper.spacing.getSpacing(context);
    final List<Widget> categories = [];

    for (final navigationCategoryDescriptor in categoryDescriptors) {
      final items = navigationCategoryDescriptor.items;

      categories.add(FastListHeader(
        categoryText: navigationCategoryDescriptor.titleText,
        categoryColor: navigationCategoryDescriptor.titleColor,
        captionText: navigationCategoryDescriptor.captionText,
        captionColor: navigationCategoryDescriptor.captionColor,
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: spacing),
      ));

      for (final item in items) {
        final listItem = buildNavigationListItem(context, item, spacing);
        categories.add(listItem);
      }
    }

    return categories;
  }

  FastNavigationListItem buildNavigationListItem(
    BuildContext context,
    FastItem<T> item,
    double spacing,
  ) {
    return FastNavigationListItem<FastItem<T>>(
      contentPadding: EdgeInsets.symmetric(horizontal: spacing),
      onTap: () {
        if (item.onTap != null) {
          item.onTap!(item);
          return;
        }

        handleNavigationItemTap(context, item);
      },
      item: item,
    );
  }

  /// Builds the footer of the setting page.
  Widget _buildFooter(BuildContext context) {
    if (footerText != null) {
      return Container(
        padding: footerPadding ??
            EdgeInsets.only(top: ThemeHelper.spacing.getSpacing(context)),
        alignment: Alignment.bottomCenter,
        child: FastSecondaryBody(text: footerText!),
      );
    }

    final appInfoBloc = FastAppInfoBloc.instance;
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
        final appInfoBloc = FastAppInfoBloc.instance;
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
            if (appInfo.bugReportEmail != null) {
              FastMessenger.writeErrorEmail(
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
        GoRouter.of(context).push(value);
      }
    }
  }
}
