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

  /// The path to the localization assets directory.
  final String localizationPath;

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
    this.askForReview = true,
    this.onDatabaseVersionChanged,
    this.onboardingBuilder,
    this.rootNavigatorKey,
    this.errorReporter,
    this.initialLocation,
    this.blocProviders,
    this.loaderBuilder,
    this.errorBuilder,
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
  static const String _noConnectionAvailableRouteName = 'noConnectionAvailable';
  static const String _noConnectionAvailableRoute = '/no-connection-available';
  static const String _noServiceAvailableRouteName = 'noServiceAvailable';
  static const String _noServiceAvailableRoute = '/no-service-available';
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
  List<RouteBase>? _currentRoutes;
  final _subxMap = SubxMap();
  Key _key = UniqueKey();
  GoRouter? _router;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    _rootNavigatorKey = widget.rootNavigatorKey ?? GlobalKey<NavigatorState>();
    _appConnectivityBloc = FastConnectivityStatusBloc();
    _mediaLayoutBloc = FastMediaLayoutBloc();
    _themeBloc = _buildAppThemeBloc();
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

  String _getInitialLocation() => widget.initialLocation ?? _defaultRoute;

  /// Builds the GoRouter instance.
  /// FIXME: Workaround: https://github.com/flutter/flutter/issues/99100
  GoRouter _buildAppRouter(List<RouteBase> routes) {
    String initialLocation = _getInitialLocation();

    if (_router != null) {
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
            child: _buildNoConnectionAvailablePage(context),
          ),
          parentNavigatorKey: _rootNavigatorKey,
          name: _noConnectionAvailableRouteName,
          path: _noConnectionAvailableRoute,
        ),
        GoRoute(
          pageBuilder: (context, state) => NoTransitionPage(
            child: _buildNoServiceAvailablePage(context),
          ),
          parentNavigatorKey: _rootNavigatorKey,
          name: _noServiceAvailableRouteName,
          path: _noServiceAvailableRoute,
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

  Widget _buildNoConnectionAvailablePage(BuildContext context) {
    return FastAppSkeleton(
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      child: FastConnectivityStatusPage(
        cancelButtonText: CoreLocaleKeys.core_label_contact_support.tr(),
        onRetryTap: () => FastApp.restart(context),
        onCancelTap: () => contactSupport(),
      ),
    );
  }

  Widget _buildNoServiceAvailablePage(BuildContext context) {
    return FastAppSkeleton(
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      child: FastServiceStatusPage(
        cancelButtonText: CoreLocaleKeys.core_label_contact_support.tr(),
        onRetryTap: () => FastApp.restart(context),
        onCancelTap: () => contactSupport(),
      ),
    );
  }

  Widget buildOnboarding(BuildContext context) {
    if (widget.onboardingBuilder != null) {
      return widget.onboardingBuilder!(context);
    }

    return buildEmptyContainer();
  }

  /// Builds an empty container with the primary background color.
  Widget buildEmptyContainer() => const FastPrimaryBackgroundContainer();

  /// Handles the app error.
  Widget handleAppError(BuildContext context, dynamic error) {
    debugLog('error: $error', debugLabel: debugLabel);

    final canContactSupport = _canContactSupport();
    VoidCallback? contactCallback;
    String? contactLabel;

    if (canContactSupport) {
      contactLabel = CoreLocaleKeys.core_label_contact_support.tr();
      contactCallback = () => contactSupport(error: error);
    }

    if (widget.isInternetConnectionRequired &&
        error is FastConnectivityStatusBlocState &&
        error.isInitialized) {
      final connectivityState = error;

      if (!connectivityState.isConnected) {
        return FastConnectivityStatusPage(
          onRetryTap: () => FastApp.restart(context),
          cancelButtonText: contactLabel,
          onCancelTap: contactCallback,
        );
      } else if (!connectivityState.isServiceAvailable) {
        return FastServiceStatusPage(
          onRetryTap: () => FastApp.restart(context),
          cancelButtonText: contactLabel,
          onCancelTap: contactCallback,
        );
      }
    }

    return FastErrorStatusPage(
      onRetryTap: () => FastApp.restart(context),
      cancelButtonText: contactLabel,
      onCancelTap: contactCallback,
    );
  }

  bool _canContactSupport() {
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;

    return appInfo.supportEmail != null;
  }

  void contactSupport({dynamic error}) {
    if (_canContactSupport()) {
      final appInfoBloc = FastAppInfoBloc.instance;
      final appInfo = appInfoBloc.currentState;

      FastMessenger.writeEmail(
        appInfo.supportEmail!,
        subject: appInfo.appName,
        body: error?.toString(),
      );
    }
  }

  Iterable<FastJob>? _getLoaderJobs() {
    if (widget.overrideLoaderJobs) widget.loaderJobs;

    return [
      FastAppInfoJob(widget.appInfo),
      if (widget.isInternetConnectionRequired) FastAppConnectivityJob(),
      FastAppPermissionsJob(),
      FastAppSettingsJob(),
      FastAppDictJob(defaultEntries: widget.defaultAppDictEntries),
      FastAppFeaturesJob(),
      FastAppOnboardingJob(),
      ...?widget.loaderJobs,
      FastAppFinalizeJob(
        callbacks: [
          _handleDatabaseVersionChange,
          _listenOnConnectivityStatusChanges,
          _intializeRoutesForMediaType,
          _askForAppReviewIfNeeded,
        ],
      ),
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

  Future<void> _intializeRoutesForMediaType(BuildContext context) async {
    _routesStream = _mediaLayoutBloc.onData.distinct((previous, next) {
      final previousRoutes = widget.routesForMediaType(previous.mediaType);
      final nextRoutes = widget.routesForMediaType(next.mediaType);

      return previousRoutes == nextRoutes;
    }).map((state) => widget.routesForMediaType(state.mediaType));
  }

  Future<void> _handleDatabaseVersionChange(BuildContext context) async {
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfoState = appInfoBloc.currentState;
    final appInfoDocument = widget.appInfo;
    final nextVersion = appInfoDocument.databaseVersion;
    final previousVersion = appInfoState.previousDatabaseVersion;
    final hasDatabaseVersionChanged = nextVersion != previousVersion;

    if (hasDatabaseVersionChanged && widget.onDatabaseVersionChanged != null) {
      return widget.onDatabaseVersionChanged!(previousVersion, nextVersion);
    }
  }

  Future<void> _listenOnConnectivityStatusChanges(BuildContext context) async {
    _subxMap
      ..cancelForKey(_noConnectionAvailableRouteName)
      ..add(
          _noConnectionAvailableRouteName,
          _appConnectivityBloc.onData.distinct((previous, next) {
            return previous.isConnected == next.isConnected &&
                previous.isServiceAvailable == next.isServiceAvailable;
          }).listen((state) {
            if (!widget.isInternetConnectionRequired || _router == null) {
              return;
            }

            if (!state.isConnected) {
              _scheduleFrameCallback(() {
                _router?.replace(_noConnectionAvailableRoute);
              });
            } else if (!state.isServiceAvailable) {
              _scheduleFrameCallback(() {
                _router?.replace(_noServiceAvailableRoute);
              });
            }
          }));
  }

  /// Asks for app review if needed.
  Future<void> _askForAppReviewIfNeeded(BuildContext context) async {
    _scheduleFrameCallback(() {
      if (widget.askForReview) {
        FastAppRatingService(widget.appInfo).askForAppReviewIfNeeded(context);
      }
    });
  }

  void _scheduleFrameCallback(VoidCallback callback) {
    SchedulerBinding.instance.scheduleFrameCallback((_) => callback());
  }
}
