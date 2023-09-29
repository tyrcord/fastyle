// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Represents a dialog page that is responsive to different screen types.
///
/// It provides a custom transition for the dialog as it's being presented
/// or dismissed. The width and height of the dialog can vary depending
/// on the media type (i.e. mobile, tablet, desktop).
/// FIXME: https://github.com/flutter/flutter/issues/116333
class FastDialogPage<T> extends Page<T> {
  /// The main content of the dialog.
  final Widget child;

  /// Creates a dialog page.
  ///
  /// The [child] argument must not be null.
  const FastDialogPage({required this.child, super.key});

  @override

  /// Creates the route for the dialog page.
  ///
  /// It uses [RawDialogRoute] to provide a custom transition and look
  /// for the dialog page based on the media type of the device.
  Route<T> createRoute(BuildContext context) {
    final mediaLayoutBloc = FastMediaLayoutBloc.instance;
    final currentMediaType = mediaLayoutBloc.currentState.mediaType;

    if (currentMediaType == FastMediaType.handset) {
      return MaterialPageRoute<T>(
        builder: (context) => child,
        fullscreenDialog: true,
        settings: this,
      );
    }

    return RawDialogRoute<T>(
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: buildTransition,
      barrierDismissible: true,
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Dialog(
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: FastMediaLayoutBuilder(builder: (context, mediaType) {
              return LayoutBuilder(builder: (context, constraints) {
                return FractionallySizedBox(
                  heightFactor: _getDialogHeight(mediaType, constraints),
                  widthFactor: _getDialogWidth(mediaType),
                  child: child,
                );
              });
            }),
          ),
        );
      },
    );
  }

  /// Determines the dialog width based on the [mediaType].
  ///
  /// For tablets, the width is set to 75% of the screen width, for desktops
  /// it's 65%, and for other device types it's 100%.
  double _getDialogWidth(FastMediaType mediaType) {
    if (mediaType == FastMediaType.tablet) {
      return 0.75;
    } else if (mediaType >= FastMediaType.desktop) {
      return 0.65;
    }

    return 1;
  }

  /// Determines the dialog height based on the [mediaType] and constraints.
  ///
  /// Depending on the constraints and device type, the height of the dialog
  /// may vary. This is particularly useful for making sure the dialog looks
  /// great on both smaller and larger screens.
  double _getDialogHeight(FastMediaType mediaType, BoxConstraints constraints) {
    if (mediaType >= FastMediaType.tablet) {
      if (constraints.maxHeight > 1200) {
        return 0.65;
      } else if (constraints.maxHeight > 1000) {
        return 0.75;
      } else if (constraints.maxHeight > 800) {
        return 0.85;
      } else if (constraints.maxHeight > 600) {
        return 0.9;
      } else if (constraints.maxHeight > 400) {
        return 0.95;
      }
    }

    return 1;
  }

  /// Builds the transition for the dialog page.
  ///
  /// This provides a slide transition with an ease curve for the dialog as
  /// it's being presented or dismissed.
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;
    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}
