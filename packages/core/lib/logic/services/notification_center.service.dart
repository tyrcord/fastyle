// Dart imports:
import 'dart:collection';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const _kDefaultErrorOptions = FastNotificationCenterOptions(
  leadingIcon: FaIcon(FontAwesomeIcons.circleXmark),
);

const _kDefaultWarnOptions = FastNotificationCenterOptions(
  leadingIcon: FaIcon(FontAwesomeIcons.triangleExclamation),
);

const _kDefaultInfoOptions = FastNotificationCenterOptions(
  leadingIcon: FaIcon(FontAwesomeIcons.circleInfo),
);
const _kDefaultSuccessOptions = FastNotificationCenterOptions(
  leadingIcon: FaIcon(FontAwesomeIcons.circleCheck),
);

class FastNotificationCenter {
  static const Duration _animationDuration = Duration(milliseconds: 750);
  static const Duration _notificationDuration = Duration(seconds: 2);
  static final ListQueue<Flushbar> _queue = ListQueue<Flushbar>();
  static bool _isShowingNotification = false;
  static const int _maxNotification = 2;
  static const double _maxNoticationWidth = 400;

  ///
  /// Displays an error notification.
  ///
  static void error(
    BuildContext context,
    String message, {
    Key? key,
    FastNotificationCenterOptions options = _kDefaultErrorOptions,
  }) {
    final palette = ThemeHelper.getPaletteColors(context);
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      options = options.copyWith(
        leadingIcon: const FaIcon(FastFontAwesomeIcons.lightCircleXmark),
      );
    }

    _buildNotification(
      context,
      message,
      options: _mergeIconColors(options, palette.red.mid),
    );
  }

  ///
  /// Displays an warn notification.
  ///
  static void warn(
    BuildContext context,
    String message, {
    Key? key,
    FastNotificationCenterOptions options = _kDefaultWarnOptions,
  }) {
    final palette = ThemeHelper.getPaletteColors(context);
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      options = options.copyWith(
        leadingIcon: const FaIcon(
          FastFontAwesomeIcons.lightTriangleExclamation,
        ),
      );
    }

    _buildNotification(
      context,
      message,
      options: _mergeIconColors(options, palette.orange.mid),
    );
  }

  ///
  /// Displays an info notification.
  ///
  static void info(
    BuildContext context,
    String message, {
    Key? key,
    FastNotificationCenterOptions options = _kDefaultInfoOptions,
  }) {
    final palette = ThemeHelper.getPaletteColors(context);
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      options = options.copyWith(
        leadingIcon: const FaIcon(FastFontAwesomeIcons.lightCircleInfo),
      );
    }

    _buildNotification(
      context,
      message,
      options: _mergeIconColors(options, palette.blueGray.mid),
    );
  }

  ///
  /// Displays an success notification.
  ///
  static void success(
    BuildContext context,
    String message, {
    Key? key,
    FastNotificationCenterOptions options = _kDefaultSuccessOptions,
  }) {
    final palette = ThemeHelper.getPaletteColors(context);
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      options = options.copyWith(
        leadingIcon: const FaIcon(FastFontAwesomeIcons.lightCircleCheck),
      );
    }

    _buildNotification(
      context,
      message,
      options: _mergeIconColors(options, palette.green.mid),
    );
  }

  static FastNotificationCenterOptions? _mergeIconColors(
    FastNotificationCenterOptions? options,
    Color color,
  ) {
    return options?.copyWith(iconColor: options.iconColor ?? color);
  }

  static void _buildNotification(
    BuildContext context,
    String message, {
    Key? key,
    FastNotificationCenterOptions? options,
  }) {
    final colorHelper = ThemeHelper.colors;
    final backgroundColor = colorHelper.getSecondaryBackgroundColor(context);

    _addNotification(
      context,
      Flushbar(
        boxShadows: [ThemeHelper.getDefaultBoxShadow(context)],
        onStatusChanged: (status) {
          if (status == FlushbarStatus.DISMISSED) {
            _nextNotification(context);
          }
        },
        flushbarPosition: FlushbarPosition.TOP,
        animationDuration: _animationDuration,
        messageText: FastBody(text: message),
        backgroundColor: backgroundColor,
        duration: _notificationDuration,
        maxWidth: _maxNoticationWidth,
        icon: _buildIcon(options),
        margin: kFastEdgeInsets8,
        key: key,
        borderRadius: const BorderRadius.all(
          Radius.circular(FastSpacing.xl),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: FastSpacing.xs,
          horizontal: FastSpacing.small,
        ),
      ),
    );
  }

  static Widget? _buildIcon(FastNotificationCenterOptions? options) {
    if (options != null && options.leadingIcon != null) {
      return IconTheme.merge(
        data: IconThemeData(
          size: options.iconSize ?? kFastIconSizeMedium,
          color: options.iconColor,
        ),
        child: Center(child: options.leadingIcon!),
      );
    }

    return null;
  }

  static void _addNotification(BuildContext context, Flushbar notification) {
    if (_queue.length == _maxNotification) {
      _queue.removeFirst();
    }

    _queue.addLast(notification);

    if (!_isShowingNotification) {
      _nextNotification(context);
    }
  }

  static void _nextNotification(BuildContext context) {
    if (_queue.isNotEmpty) {
      _isShowingNotification = true;

      final notification = _queue.removeFirst();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notification.show(context);
      });
    } else {
      _isShowingNotification = false;
    }
  }
}
