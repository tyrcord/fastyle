// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

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
  /// Bloc responsible for controlling the app loading logic.
  final FastAppLoaderBloc _bloc = FastAppLoaderBloc();

  /// Timer used to delay the display of the loader.
  late final Timer _delayTimer;

  /// Determines if the loader can be shown.
  bool _canShowLoader = false;

  @override
  void initState() {
    super.initState();
    _initializeAppLoaderBloc();
  }

  /// Initializes the bloc and sets up listeners.
  void _initializeAppLoaderBloc() {
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      _bloc.addEvent(FastAppLoaderBlocEvent.init(
        context,
        errorReporter: widget.errorReporter,
        jobs: widget.loaderJobs,
      ));

      _delayTimer = Timer(widget.delayBeforeShowingLoader, _checkLoaderStatus);
    });
  }

  /// Checks the loader's status and updates the display state if needed.
  void _checkLoaderStatus() {
    if (_bloc.currentState.isLoading) {
      setState(() => _canShowLoader = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: BlocBuilderWidget(
        loadingBuilder: (_) => buildPlaceholderApp(),
        builder: _decideAppDisplay,
        waitForData: true,
        bloc: _bloc,
      ),
    );
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
  Widget buildPlaceholderApp() {
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
  void _cancelDelayTimer() => _delayTimer.cancel();

  /// Decides which app to display based on the [FastAppLoaderBlocState].
  Widget _decideAppDisplay(BuildContext context, FastAppLoaderBlocState state) {
    if (state.isLoading && widget.loaderBuilder != null && _canShowLoader) {
      return buildLoadingApp(progress: state.progress);
    } else if (state.isLoaded) {
      _cancelDelayTimer();

      return Builder(builder: widget.appBuilder);
    } else if (state.hasError && widget.errorBuilder != null) {
      _cancelDelayTimer();

      return _buildErrorApp(state.error);
    }

    return buildPlaceholderApp();
  }
}
