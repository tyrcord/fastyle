// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:subx/subx.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

typedef RoutesForMediaTypeCallback = List<RouteBase> Function(
  FastMediaType mediaType,
);

/// The main entry point for a Fastyle Dart application.
class FastApp extends StatefulWidget {
  /// A list of [BlocProviderSingleChildWidget] to provide the [Bloc] instances
  /// to the application.
  final List<BlocProviderSingleChildWidget>? blocProviders;

  /// A callback function that is invoked when the database version is changed.
  final DatabaseVersionChanged? onDatabaseVersionChanged;

  /// A key to the root navigator state that can be used to perform
  /// navigation actions from anywhere in the application.
  final GlobalKey<NavigatorState>? rootNavigatorKey;

  /// A builder function that builds an error widget for displaying errors
  /// during the loading process of the application.
  final FastAppLoaderErrorBuilder? errorBuilder;

  /// A builder function that builds the loading widget that is shown
  /// during the initialization of the application.
  final FastAppLoaderBuilder? loaderBuilder;

  /// The duration to delay before showing the loading widget during
  /// the initialization of the application.
  final Duration delayBeforeShowingLoader;

  /// An error reporter implementation for reporting errors that occur
  /// during the application lifecycle.
  final IFastErrorReporter? errorReporter;

  /// A builder function that builds the onboarding widget that is shown
  /// to the user when the application is launched for the first time.
  final WidgetBuilder? onboardingBuilder;

  /// A flag indicating whether to show the debug banner on the top
  /// right corner of the screen.
  final bool debugShowCheckedModeBanner;

  /// A list of [FastJob] instances to be executed during the
  /// loading process of the application.
  final Iterable<FastJob>? loaderJobs;

  /// An [FastAppInfoDocument] instance that contains information about the
  /// application such as name, version, supported locales, etc.
  late final FastAppInfoDocument appInfo;

  /// A flag indicating whether to force the onboarding process even
  /// if the application has been launched before.
  final bool forceOnboarding;

  /// A builder function that builds the home widget that is shown to the
  /// user when the application finishes loading.
  final WidgetBuilder? homeBuilder;

  /// The path to the localization assets directory.
  final String localizationPath;

  /// A list of custom routes for the application.
  final List<RouteBase> routes;

  /// The fallback locale to use if the system locale is not supported.
  final Locale fallbackLocale;

  /// The light theme data for the application.
  final ThemeData? lightTheme;

  final String? initialLocation;

  /// The dark theme data for the application.
  final ThemeData? darkTheme;

  /// The dynamic asset loader for the localization assets.
  final AssetLoader assetLoader;

  /// A flag indicating whether to ask the user for an app review
  /// when certain conditions are met.
  final bool askForReview;

  /// A flag indicating whether to use the pro icons.
  final bool useProIcons;

  final bool overrideLoaderJobs;

  final List<FastDictEntryEntity>? defaultAppDictEntries;

  final bool isInternetConnectionRequired;

  final RoutesForMediaTypeCallback routesForMediaType;

  FastApp({
    super.key,
    required this.routesForMediaType,
    this.delayBeforeShowingLoader = kFastDelayBeforeShowingLoader,
    this.debugShowCheckedModeBanner = false,
    this.forceOnboarding = false,
    this.routes = kFastDefaultRoutes,
    this.askForReview = true,
    this.onDatabaseVersionChanged,
    this.onboardingBuilder,
    this.rootNavigatorKey,
    this.errorReporter,
    this.initialLocation,
    this.blocProviders,
    this.loaderBuilder,
    this.errorBuilder,
    this.homeBuilder,
    this.loaderJobs,
    this.lightTheme,
    this.darkTheme,
    FastAppInfoDocument? appInformation,
    AssetLoader? assetLoader,
    String? localizationPath,
    Locale? fallbackLocale,
    bool? useProIcons,
    bool? overrideLoaderJobs,
    bool? isInternetConnectionRequired,
    this.defaultAppDictEntries,
  })  : useProIcons = useProIcons ?? false,
        overrideLoaderJobs = overrideLoaderJobs ?? false,
        assetLoader = assetLoader ?? const LinguaLoader(),
        localizationPath = localizationPath ?? kFastLocalizationPath,
        isInternetConnectionRequired = isInternetConnectionRequired ?? true,
        fallbackLocale = fallbackLocale ?? kFastAppSettingsDefaultLocale {
    appInfo = appInformation ?? kFastAppInfo;
  }

  @override
  State<StatefulWidget> createState() => _FastAppState();

  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_FastAppState>()!.restartApp();
  }
}

class _FastAppState extends State<FastApp> {
  static const String _connectivityStatusRoute = '/connection-status';
  static const String _connectionStatusRouteName = 'connectionStatus';
  static const String _connectivityStatusKey = 'connectivityStatus';
  static const String _onboardingRouteName = 'onboarding';
  static const String _onboardingRoute = '/onboarding';
  static const String _defaultRoute = '/';
  static const String debugLabel = 'FastApp';

  late final FastConnectivityStatusBloc _appConnectivityBloc;
  late final GlobalKey<NavigatorState> _rootNavigatorKey;
  late Stream<List<RouteBase>> _routesStream;
  late FastMediaLayoutBloc _mediaLayoutBloc;
  late final FastThemeBloc _themeBloc;
  bool _hasForcedOnboarding = false;
  final _subxMap = SubxMap();
  Key _key = UniqueKey();
  List<RouteBase>? _currentRoutes;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _rootNavigatorKey = widget.rootNavigatorKey ?? GlobalKey<NavigatorState>();
    _appConnectivityBloc = FastConnectivityStatusBloc();
    _mediaLayoutBloc = FastMediaLayoutBloc();
    _themeBloc = _buildAppThemeBloc();

    _routesStream = _mediaLayoutBloc.onData.distinct((previous, next) {
      final previousRoutes = widget.routesForMediaType(previous.mediaType);
      final nextRoutes = widget.routesForMediaType(next.mediaType);

      return previousRoutes == nextRoutes;
    }).map((state) => widget.routesForMediaType(state.mediaType));
  }

  @override
  void dispose() {
    _themeBloc.close();
    _subxMap.cancelAll();
    super.dispose();
  }

  void restartApp() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: GestureDetector(
        onTap: hideKeyboard,
        child: FastMediaLayoutObserver(
          child: MultiBlocProvider(
            blocProviders: [
              if (widget.isInternetConnectionRequired)
                BlocProvider(bloc: FastConnectivityStatusBloc()),
              BlocProvider(bloc: FastAppInfoBloc()),
              BlocProvider(bloc: FastAppPermissionsBloc()),
              BlocProvider(bloc: FastAppSettingsBloc()),
              BlocProvider(bloc: FastAppDictBloc()),
              BlocProvider(bloc: FastAppFeaturesBloc()),
              BlocProvider(bloc: FastAppOnboardingBloc()),
              BlocProvider(bloc: _themeBloc),
              ...?widget.blocProviders,
            ],
            child: EasyLocalization(
              supportedLocales: widget.appInfo.supportedLocales,
              fallbackLocale: widget.fallbackLocale,
              startLocale: widget.fallbackLocale,
              assetLoader: widget.assetLoader,
              path: widget.localizationPath,
              useOnlyLangCode: true,
              saveLocale: false,
              child: FutureBuilder(
                future: EasyLocalization.ensureInitialized(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return buildAppLoader(context);
                  }

                  return buildEmptyContainer();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the app loader widget that displays a loading screen while the app
  /// is being initialized.
  Widget buildAppLoader(BuildContext context) {
    return FastIconHelper(
      useProIcons: widget.useProIcons,
      child: FastAppSettingsThemeListener(
        child: FastAppLoader(
          debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          delayBeforeShowingLoader: widget.delayBeforeShowingLoader,
          supportedLocales: widget.appInfo.supportedLocales,
          errorBuilder: widget.errorBuilder ?? handleAppError,
          errorReporter: widget.errorReporter,
          loaderBuilder: widget.loaderBuilder,
          loaderJobs: _getLoaderJobs(),
          lightTheme: widget.lightTheme,
          darkTheme: widget.darkTheme,
          appBuilder: buildApp,
        ),
      ),
    );
  }

  /// Builds the main app widget.
  Widget buildApp(BuildContext context) {
    return FastAppSettingsThemeBuilder(
      builder: (context, state) {
        final easyLocalization = EasyLocalization.of(context)!;

        return StreamBuilder(
          stream: _routesStream,
          builder: (context, snapshot) {
            final connectionState = snapshot.connectionState;

            if (connectionState == ConnectionState.active ||
                connectionState == ConnectionState.done) {
              _listenOnConnectivityStatusChanges();

              return MaterialApp.router(
                debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
                localizationsDelegates: easyLocalization.delegates,
                supportedLocales: widget.appInfo.supportedLocales,
                darkTheme: widget.darkTheme ?? FastTheme.dark.blue,
                theme: widget.lightTheme ?? FastTheme.light.blue,
                routerConfig: _buildAppRouter(snapshot.data!),
                locale: easyLocalization.locale,
                title: widget.appInfo.appName,
                themeMode: state.themeMode,
              );
            }

            return buildEmptyContainer();
          },
        );
      },
    );
  }

  void _listenOnConnectivityStatusChanges() {
    _subxMap
      ..cancelForKey(_connectivityStatusKey)
      ..add(
          _connectivityStatusKey,
          _appConnectivityBloc.onData.distinct((previous, next) {
            return previous.isConnected == next.isConnected &&
                previous.isServiceAvailable == next.isServiceAvailable;
          }).listen((state) {
            if (!state.isConnected && widget.isInternetConnectionRequired) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _router?.pushReplacement(_connectivityStatusRoute);
              });
            }
          }));
  }

  /// Builds the GoRouter instance.
  GoRouter _buildAppRouter(List<RouteBase> routes) {
    String initialLocation = widget.initialLocation ?? _defaultRoute;

    if (_router != null) {
      // FIXME: this is a workaround:
      // https://github.com/flutter/flutter/issues/99100
      final configuration = _router!.routerDelegate.currentConfiguration;

      if (_currentRoutes == routes) return _router!;

      _router!.dispose();
      initialLocation = configuration.uri.toString();
    }

    _currentRoutes = routes;
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation,
      redirect: handleRedirect,
      routes: [
        ...routes,
        GoRoute(
          builder: (context, state) => buildOnboarding(context),
          parentNavigatorKey: _rootNavigatorKey,
          name: _onboardingRouteName,
          path: _onboardingRoute,
        ),
        GoRoute(
          pageBuilder: (context, state) => NoTransitionPage(
            child: buildConnectivityStatusApp(context),
          ),
          parentNavigatorKey: _rootNavigatorKey,
          name: _connectionStatusRouteName,
          path: _connectivityStatusRoute,
        ),
      ],
    );

    return _router!;
  }

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) {
    final isOnboarding = state.fullPath == _onboardingRoute;
    final bloc = FastAppOnboardingBloc.instance;
    final onboardingState = bloc.currentState;

    if (isOnboarding) return null;

    final forceOnboarding = widget.forceOnboarding && !_hasForcedOnboarding;

    if (!onboardingState.isCompleted || forceOnboarding) {
      _hasForcedOnboarding = true;
      debugLog('onboarding is not completed', debugLabel: debugLabel);

      return _onboardingRoute;
    }

    return null;
  }

  Widget buildConnectivityStatusApp(BuildContext context) {
    return FastAppSkeleton(
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      child: FastConnectivityStatusPage(
        onRetryTap: () => FastApp.restart(context),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    if (widget.homeBuilder != null) {
      _askForAppReviewIfNeeded(context);

      return widget.homeBuilder!(context);
    }

    return buildEmptyContainer();
  }

  Widget buildOnboarding(BuildContext context) {
    if (widget.onboardingBuilder != null) {
      return widget.onboardingBuilder!(context);
    }

    return buildEmptyContainer();
  }

  /// Builds an empty container with the primary background color.
  Widget buildEmptyContainer() {
    return const FastPrimaryBackgroundContainer();
  }

  /// Handles the app error.
  Widget handleAppError(BuildContext context, dynamic error) {
    debugLog('error: $error', debugLabel: debugLabel);

    if (widget.isInternetConnectionRequired &&
        error is FastConnectivityStatusBlocState &&
        error.isInitialized) {
      final connectivityState = error;

      if (!connectivityState.isConnected) {
        return FastConnectivityStatusPage(
          onRetryTap: () => FastApp.restart(context),
          onCancelTap: () => contactSupport(error),
        );
      } else if (!connectivityState.isServiceAvailable) {
        return FastServiceStatusPage(
          onRetryTap: () => FastApp.restart(context),
          onCancelTap: () => contactSupport(error),
        );
      }
    }

    return FastErrorStatusPage(
      cancelButtonText: CoreLocaleKeys.core_label_contact_support.tr(),
      onRetryTap: () => FastApp.restart(context),
      onCancelTap: () => contactSupport(error),
    );
  }

  void contactSupport(dynamic error) {
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;

    if (appInfo.supportEmail != null) {
      FastMessenger.writeEmail(
        appInfo.supportEmail!,
        subject: appInfo.appName,
        body: error?.toString(),
      );
    }
  }

  Iterable<FastJob>? _getLoaderJobs() {
    if (widget.overrideLoaderJobs) {
      return widget.loaderJobs;
    }

    return [
      // FIXME: onDatabaseVersionChanged should be called once the app
      // has been initialized.
      FastAppInfoJob(
        widget.appInfo,
        onDatabaseVersionChanged: widget.onDatabaseVersionChanged,
      ),
      if (widget.isInternetConnectionRequired) FastAppConnectivityJob(),
      FastAppPermissionsJob(),
      FastAppSettingsJob(),
      FastAppDictJob(defaultEntries: widget.defaultAppDictEntries),
      FastAppFeaturesJob(),
      FastAppOnboardingJob(),
      ...?widget.loaderJobs,
    ];
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.askForReview) {
        FastAppRatingService(widget.appInfo).askForAppReviewIfNeeded(context);
      }
    });
  }
}
