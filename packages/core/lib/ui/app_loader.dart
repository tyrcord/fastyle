// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Type definition for a builder that generates a loading widget
/// given a [BuildContext] and a progress value.
typedef FastAppLoaderBuilder = Widget Function(
  BuildContext context,
  double progress,
);

/// Type definition for a builder that generates an error widget
/// given a [BuildContext] and an error.
typedef FastAppLoaderErrorBuilder = Widget Function(
  BuildContext context,
  dynamic error,
);

/// A widget that displays an application loading screen.
///
/// Displays either a loading, error, or the main app based on the current state.
class FastAppLoader extends StatefulWidget {
  /// Builder for generating error widgets.
  final FastAppLoaderErrorBuilder? errorBuilder;

  /// Builder for generating loader widgets.
  final FastAppLoaderBuilder? loaderBuilder;

  /// Optional error reporter.
  final IFastErrorReporter? errorReporter;

  /// List of supported locales.
  final Iterable<Locale> supportedLocales;

  /// Duration to wait before showing the loader.
  final Duration delayBeforeShowingLoader;

  /// Flag to show Flutter's checked mode banner.
  final bool debugShowCheckedModeBanner;

  /// List of loading jobs that the loader will execute.
  final Iterable<FastJob>? loaderJobs;

  /// Builder for the main application widget.
  final WidgetBuilder appBuilder;

  /// Theme data for light mode.
  final ThemeData? lightTheme;

  /// Theme data for dark mode.
  final ThemeData? darkTheme;

  const FastAppLoader({
    super.key,
    required this.appBuilder,
    this.delayBeforeShowingLoader = const Duration(seconds: 1),
    this.supportedLocales = kFastSupportedLocales,
    this.debugShowCheckedModeBanner = false,
    this.loaderBuilder,
    this.errorReporter,
    this.errorBuilder,
    this.loaderJobs,
    this.lightTheme,
    this.darkTheme,
  });

  @override
  FastAppLoaderState createState() => FastAppLoaderState();
}

/// Represents the state of the [FastAppLoader] widget.
class FastAppLoaderState extends State<FastAppLoader> {
  static const _debugLabel = 'FastAppLoader';
  static final _manager = TLoggerManager();

  late final TLogger _logger;

  /// Bloc responsible for controlling the app loading logic.
  final FastAppLoaderBloc _bloc = FastAppLoaderBloc();

  /// Timer used to delay the display of the loader.
  Timer? _delayTimer;

  /// Determines if the loader can be shown.
  bool _canShowLoader = false;

  late final Function init;

  FastAppLoaderState() {
    if (kDebugMode) {
      const duration = Duration(milliseconds: 300);
      init = throttle(_initializeAppLoaderBloc, duration);
    } else {
      init = _initializeAppLoaderBloc;
    }
  }

  @override
  void initState() {
    super.initState();
    _logger = _manager.getLogger(_debugLabel);
    init();
  }

  @override
  void dispose() {
    _cancelDelayTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: BlocBuilderWidget(
        loadingBuilder: buildPlaceholderApp,
        builder: _decideAppDisplay,
        buildWhen: buildWhen,
        waitForData: true,
        bloc: _bloc,
      ),
    );
  }

  bool buildWhen(FastAppLoaderBlocState previous, FastAppLoaderBlocState next) {
    bool hasProgressChanged = false;

    if (_canShowLoader) {
      hasProgressChanged = previous.progress != next.progress;
    }

    return hasProgressChanged ||
        previous.isLoading != next.isLoading ||
        previous.isLoaded != next.isLoaded ||
        previous.hasError != next.hasError;
  }

  /// Builds the app with an error state.
  Widget _buildErrorApp(dynamic error) {
    return buildAppSkeleton(
      child: Builder(
        builder: (BuildContext context) {
          return widget.errorBuilder!(context, error);
        },
      ),
    );
  }

  /// Builds the app with a loading state.
  Widget buildLoadingApp({double progress = 0}) {
    return buildAppSkeleton(
      child: Builder(
        builder: (BuildContext context) {
          return widget.loaderBuilder!(context, progress);
        },
      ),
    );
  }

  /// Builds a placeholder app.
  Widget buildPlaceholderApp(BuildContext context) {
    return const FastPrimaryBackgroundContainer();
  }

  /// Builds the app skeleton.
  Widget buildAppSkeleton({required Widget child}) {
    return FastAppSkeleton(
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      child: child,
    );
  }

  /// Cancels the delay timer.
  void _cancelDelayTimer() => _delayTimer?.cancel();

  /// Decides which app to display based on the [FastAppLoaderBlocState].
  Widget _decideAppDisplay(BuildContext context, FastAppLoaderBlocState state) {
    if (state.isLoading && widget.loaderBuilder != null && _canShowLoader) {
      _logger.debug('Building the loading app with progress ${state.progress}');

      return buildLoadingApp(progress: state.progress);
    } else if (state.isLoaded) {
      _logger.debug('Building the main app...');
      _cancelDelayTimer();

      return Builder(builder: widget.appBuilder);
    } else if (state.hasError && widget.errorBuilder != null) {
      _logger.debug('Building the error app...');
      _cancelDelayTimer();

      return _buildErrorApp(state.error);
    }

    _logger.debug('Building the placeholder app...');

    return buildPlaceholderApp(context);
  }

  /// Initializes the bloc and sets up listeners.
  void _initializeAppLoaderBloc() {
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      if (mounted) {
        _logger.debug('Initializing the app loader bloc...');

        _bloc.addEvent(FastAppLoaderBlocEvent.init(
          context,
          errorReporter: widget.errorReporter,
          jobs: widget.loaderJobs,
        ));

        _delayTimer = Timer(
          widget.delayBeforeShowingLoader,
          _showLoaderIfNeeded,
        );
      }
    });
  }

  void _showLoaderIfNeeded() {
    if (_bloc.currentState.isLoading && mounted) {
      _logger.debug('Showing the loader...');
      setState(() => _canShowLoader = true);
    }
  }
}
