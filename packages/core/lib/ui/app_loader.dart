import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_core/fastyle_core.dart';

typedef FastAppLoaderBuilder = Widget Function(
  BuildContext context,
  double progress,
);

typedef FastAppLoaderErrorBuilder = Widget Function(
  BuildContext context,
  dynamic error,
);

class FastAppLoader extends StatefulWidget {
  final FastAppLoaderErrorBuilder? errorBuilder;
  final FastAppLoaderBuilder? loaderBuilder;
  final IFastErrorReporter? errorReporter;
  final Iterable<Locale> supportedLocales;
  final Duration delayBeforeShowingLoader;
  final bool debugShowCheckedModeBanner;
  final Iterable<FastJob>? loaderJobs;
  final WidgetBuilder appBuilder;
  final ThemeData? lightTheme;
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

class FastAppLoaderState extends State<FastAppLoader> {
  final FastAppLoaderBloc _bloc = FastAppLoaderBloc();
  late final Timer _delayTimer;
  bool _canShowLoader = false;

  @override
  void initState() {
    super.initState();
    _initializeAppLoaderBloc();
  }

  void _initializeAppLoaderBloc() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.addEvent(FastAppLoaderBlocEvent.init(
        context,
        errorReporter: widget.errorReporter,
        jobs: widget.loaderJobs,
      ));

      _delayTimer = Timer(widget.delayBeforeShowingLoader, _checkLoaderStatus);
    });
  }

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

  Widget _buildErrorApp(dynamic error) {
    return buildAppSkeleton(
      child: Builder(
        builder: (BuildContext context) {
          return widget.errorBuilder!(context, error);
        },
      ),
    );
  }

  Widget buildLoadingApp({double progress = 0}) {
    return buildAppSkeleton(
      child: Builder(
        builder: (BuildContext context) {
          return widget.loaderBuilder!(context, progress);
        },
      ),
    );
  }

  Widget buildPlaceholderApp() {
    return const FastPrimaryBackgroundContainer();
  }

  Widget buildAppSkeleton({required Widget child}) {
    return FastEmptyApp(
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      child: child,
    );
  }

  void _cancelDelayTimer() => _delayTimer.cancel();

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
