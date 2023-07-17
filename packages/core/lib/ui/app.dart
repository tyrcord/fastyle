// Flutter imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:fastyle_core/fastyle_core.dart';

/// The main entry point for a Fastyle Dart application.
class FastApp extends StatefulWidget {
  final List<BlocProviderSingleChildWidget>? blocProviders;
  final DatabaseVersionChanged? onDatabaseVersionChanged;
  final GlobalKey<NavigatorState>? rootNavigatorKey;
  final FastAppLoaderErrorBuilder? errorBuilder;
  final FastAppLoaderBuilder? loaderBuilder;
  final Duration delayBeforeShowingLoader;
  final IFastErrorReporter? errorReporter;
  final WidgetBuilder? onboardingBuilder;
  final bool debugShowCheckedModeBanner;
  final Iterable<FastJob>? loaderJobs;
  final FastAppInfoDocument appInfo;
  final bool forceOnboarding;
  final WidgetBuilder? homeBuilder;
  final String localizationPath;
  final List<RouteBase> routes;
  final Locale fallbackLocale;
  final ThemeData? lightTheme;
  final String? initialRoute;
  final ThemeData? darkTheme;
  final dynamic assetLoader;
  final bool askForReview;

  const FastApp({
    super.key,
    this.delayBeforeShowingLoader = kFastDelayBeforeShowingLoader,
    this.debugShowCheckedModeBanner = false,
    this.forceOnboarding = false,
    this.routes = kFastDefaultRoutes,
    this.askForReview = true,
    this.appInfo = kFastAppInfo,
    this.onDatabaseVersionChanged,
    this.onboardingBuilder,
    this.rootNavigatorKey,
    this.errorReporter,
    this.blocProviders,
    this.loaderBuilder,
    this.errorBuilder,
    this.initialRoute,
    this.homeBuilder,
    this.assetLoader,
    this.loaderJobs,
    this.lightTheme,
    this.darkTheme,
    String? localizationPath,
    Locale? fallbackLocale,
  })  : localizationPath = localizationPath ?? kFastLocalizationPath,
        fallbackLocale = fallbackLocale ?? kFastAppSettingsDefaultLocale;

  @override
  State<StatefulWidget> createState() => _FastAppState();
}

class _FastAppState extends State<FastApp> {
  late final GlobalKey<NavigatorState> _rootNavigatorKey;
  late final Future<dynamic> _initialization;
  late final FastThemeBloc _themeBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _rootNavigatorKey = widget.rootNavigatorKey ?? GlobalKey<NavigatorState>();
    _themeBloc = _buildAppThemeBloc();
    _router = _buildAppRouter();
    _initialization = _initApp();
  }

  @override
  void dispose() {
    super.dispose();
    _themeBloc.close();
  }

  /// Initializes the application.
  Future<dynamic> _initApp() {
    return EasyLocalization.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: hideKeyboard,
            child: FastMediaLayoutObserver(
              child: MultiBlocProvider(
                blocProviders: [
                  BlocProvider(bloc: FastAppSettingsBloc()),
                  BlocProvider(bloc: FastAppInfoBloc()),
                  BlocProvider(bloc: FastAppFeaturesBloc()),
                  BlocProvider(bloc: _themeBloc),
                  ...?widget.blocProviders,
                ],
                child: EasyLocalization(
                  supportedLocales: widget.appInfo.supportedLocales,
                  fallbackLocale: widget.fallbackLocale,
                  assetLoader: widget.assetLoader,
                  path: widget.localizationPath,
                  useOnlyLangCode: true,
                  child: buildAppLoader(context),
                ),
              ),
            ),
          );
        }

        return buildEmptyContainer(context);
      },
    );
  }

  /// Builds the app loader widget that displays a loading screen while the app
  /// is being initialized.
  Widget buildAppLoader(BuildContext context) {
    return FastSettingsThemeListener(
      child: FastAppLoader(
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        delayBeforeShowingLoader: widget.delayBeforeShowingLoader,
        supportedLocales: widget.appInfo.supportedLocales,
        errorReporter: widget.errorReporter,
        loaderBuilder: widget.loaderBuilder,
        errorBuilder: widget.errorBuilder,
        appBuilder: buildAppOrOnboarding,
        loaderJobs: [
          // FIXME:  onDatabaseVersionChanged should be called once the app
          // has been initialized.
          FastAppInfoJob(
            widget.appInfo,
            onDatabaseVersionChanged: widget.onDatabaseVersionChanged,
          ),
          FastAppSettingsJob(),
          FastAppFeaturesJob(),
          ...?widget.loaderJobs,
        ],
        lightTheme: widget.lightTheme,
        darkTheme: widget.darkTheme,
      ),
    );
  }

  /// Builds the app or onboarding widget depending on the app state.
  Widget buildAppOrOnboarding(BuildContext context) {
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final appInfo = appInfoBloc.currentState;

    if (appInfo.isFirstLaunch || widget.forceOnboarding) {
      // FIXME: add a property to the Fast app info to define
      // if has been already initialized or not.
      if (widget.onboardingBuilder != null) {
        return Builder(builder: widget.onboardingBuilder!);
      }
    } else {
      _askForAppReviewIfNeeded(context);
    }

    return buildApp(context);
  }

  /// Builds the main app widget.
  Widget buildApp(BuildContext context) {
    return FastAppSettingsThemeBuilder(
      builder: (context, state) {
        final easyLocalization = EasyLocalization.of(context)!;

        return MaterialApp.router(
          debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          localizationsDelegates: easyLocalization.delegates,
          supportedLocales: widget.appInfo.supportedLocales,
          darkTheme: widget.darkTheme ?? FastTheme.dark.blue,
          theme: widget.lightTheme ?? FastTheme.light.blue,
          locale: easyLocalization.locale,
          title: widget.appInfo.appName,
          themeMode: state.themeMode,
          routerConfig: _router,
        );
      },
    );
  }

  /// Builds the home widget.
  Widget buildHome(BuildContext context) {
    if (widget.initialRoute != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        context.go(widget.initialRoute!);
      });

      return buildEmptyContainer(context);
    }

    if (widget.homeBuilder != null) {
      return Builder(builder: widget.homeBuilder!);
    }

    return buildEmptyContainer(context);
  }

  /// Builds the GoRouter instance.
  GoRouter _buildAppRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => buildHome(context),
          routes: widget.routes,
        ),
      ],
    );
  }

  /// Builds an empty container with the primary background color.
  Widget buildEmptyContainer(BuildContext context) {
    // TODO: move to fastyle_ui
    final colors = ThemeHelper.colors;
    final backgroundColor = colors.getPrimaryBackgroundColor(context);

    return Container(color: backgroundColor);
  }

  /// Builds the FastThemeBloc instance.
  FastThemeBloc _buildAppThemeBloc() {
    return FastThemeBloc(
      initialState: FastThemeBlocState(
        brightness: getPlatformBrightness(),
        themeMode: ThemeMode.system,
      ),
    );
  }

  /// Asks for app review if needed.
  void _askForAppReviewIfNeeded(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.askForReview) {
        final rateService = FusexAppRatingService(widget.appInfo);
        rateService.askForAppReviewIfNeeded(context);
      }
    });
  }
}
