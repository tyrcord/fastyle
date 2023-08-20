// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

typedef FastAppLoaderBuilder = Widget Function(
  BuildContext context,
  double progress,
);

typedef FastAppLoaderErrorBuilder = Widget Function(
  BuildContext context,
  dynamic error,
);

class FastAppLoader extends StatefulWidget {
  final Iterable<LocalizationsDelegate>? localizationsDelegates;
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
  final Locale? locale;

  const FastAppLoader({
    super.key,
    required this.appBuilder,
    this.delayBeforeShowingLoader = const Duration(seconds: 1),
    this.supportedLocales = kFastSupportedLocales,
    this.debugShowCheckedModeBanner = false,
    this.localizationsDelegates,
    this.loaderBuilder,
    this.errorReporter,
    this.errorBuilder,
    this.loaderJobs,
    this.lightTheme,
    this.darkTheme,
    this.locale,
  });

  @override
  FastAppLoaderState createState() => FastAppLoaderState();
}

class FastAppLoaderState extends State<FastAppLoader> {
  final _bloc = FastAppLoaderBloc();
  late final Timer _delayTimer;
  bool _canShowLoader = false;

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return <LocalizationsDelegate<dynamic>>[
      if (widget.localizationsDelegates != null)
        ...widget.localizationsDelegates!,
      DefaultWidgetsLocalizations.delegate,
    ];
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.addEvent(FastAppLoaderBlocEvent.init(
        context,
        errorReporter: widget.errorReporter,
        jobs: widget.loaderJobs,
      ));

      _delayTimer = Timer(widget.delayBeforeShowingLoader, () {
        if (_bloc.currentState.isLoading) {
          setState(() => _canShowLoader = true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: BlocBuilderWidget(
        bloc: _bloc,
        waitForData: true,
        loadingBuilder: (BuildContext context) => buildPlaceholderApp(context),
        builder: (BuildContext context, FastAppLoaderBlocState state) {
          if (state.isLoading &&
              widget.loaderBuilder != null &&
              _canShowLoader) {
            return buildLoadingApp(progress: state.progress);
          } else if (state.isLoaded) {
            _delayTimer.cancel();

            return Builder(builder: widget.appBuilder);
          } else if (state.hasError && widget.errorBuilder != null) {
            _delayTimer.cancel();

            return buildErrorApp(state.error);
          }

          return buildPlaceholderApp(context);
        },
      ),
    );
  }

  Widget buildErrorApp(dynamic error) {
    return buildEmptyApp(
      child: Builder(
        builder: (BuildContext context) {
          return widget.errorBuilder!(context, error);
        },
      ),
    );
  }

  Widget buildLoadingApp({double progress = 0}) {
    return buildEmptyApp(
      child: Builder(
        builder: (BuildContext context) {
          return widget.loaderBuilder!(context, progress);
        },
      ),
    );
  }

  Widget buildPlaceholderApp(BuildContext context) {
    return Container(
      color: ThemeHelper.colors.getPrimaryBackgroundColor(context),
    );
  }

  Widget buildEmptyApp({required Widget child}) {
    return BlocBuilderWidget(
      bloc: FastThemeBloc.instance,
      builder: (BuildContext context, state) {
        final appLocale = widget.locale ?? kFastAppSettingsDefaultLocale;
        final useDarkTheme = state.brightness == Brightness.dark;
        var theme = widget.lightTheme ?? FastTheme.light.blue;

        if (useDarkTheme && widget.darkTheme != null) {
          theme = widget.darkTheme ?? FastTheme.dark.blue;
        }

        return Localizations(
          delegates: _localizationsDelegates.toList(),
          locale: appLocale,
          child: MediaQuery.fromView(
            view: View.of(context),
            child: AnimatedTheme(
              data: theme,
              child: Builder(
                builder: (context) {
                  final colors = ThemeHelper.colors;
                  final backgroundColor = colors.getPrimaryBackgroundColor(
                    context,
                  );

                  return ColoredBox(
                    color: backgroundColor,
                    child: FastPageLayout(child: child),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
