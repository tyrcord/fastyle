// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:tbloc/tbloc.dart';
//FIXME: migrate away from fastyle_dart
import 'package:fastyle_dart/fastyle_dart.dart'
    hide
        FastApp,
        FastAppLoader,
        FastAppLoaderErrorBuilder,
        FastAppLoaderBuilder;

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

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

  /// The initial route to navigate to when the application starts.
  final String? initialRoute;

  /// The dark theme data for the application.
  final ThemeData? darkTheme;

  /// The dynamic asset loader for the localization assets.
  final AssetLoader assetLoader;

  /// A flag indicating whether to ask the user for an app review
  /// when certain conditions are met.
  final bool askForReview;

  FastApp({
    super.key,
    this.delayBeforeShowingLoader = kFastDelayBeforeShowingLoader,
    this.debugShowCheckedModeBanner = false,
    this.forceOnboarding = false,
    this.routes = kFastDefaultRoutes,
    this.askForReview = true,
    this.onDatabaseVersionChanged,
    this.onboardingBuilder,
    this.rootNavigatorKey,
    this.errorReporter,
    this.blocProviders,
    this.loaderBuilder,
    this.errorBuilder,
    this.initialRoute,
    this.homeBuilder,
    this.loaderJobs,
    this.lightTheme,
    this.darkTheme,
    FastAppInfoDocument? appInformation,
    AssetLoader? assetLoader,
    String? localizationPath,
    Locale? fallbackLocale,
  })  : assetLoader = assetLoader ?? const LinguaLoader(),
        localizationPath = localizationPath ?? kFastLocalizationPath,
        fallbackLocale = fallbackLocale ?? kFastAppSettingsDefaultLocale {
    appInfo = appInformation ?? kFastAppInfo;
  }

  @override
  State<StatefulWidget> createState() => _FastAppState();
}

class _FastAppState extends State<FastApp> {
  late final GlobalKey<NavigatorState> _rootNavigatorKey;
  late final FastThemeBloc _themeBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _rootNavigatorKey = widget.rootNavigatorKey ?? GlobalKey<NavigatorState>();
    _themeBloc = _buildAppThemeBloc();
    _router = _buildAppRouter();
  }

  @override
  void dispose() {
    super.dispose();
    _themeBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: FastMediaLayoutObserver(
        child: MultiBlocProvider(
          blocProviders: [
            BlocProvider(bloc: FastAppInfoBloc()),
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

                return buildEmptyContainer(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the app loader widget that displays a loading screen while the app
  /// is being initialized.
  Widget buildAppLoader(BuildContext context) {
    final easyLocalization = EasyLocalization.of(context)!;

    return FastAppSettingsThemeListener(
      child: FastAppLoader(
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        delayBeforeShowingLoader: widget.delayBeforeShowingLoader,
        supportedLocales: widget.appInfo.supportedLocales,
        localizationsDelegates: easyLocalization.delegates,
        errorReporter: widget.errorReporter,
        loaderBuilder: widget.loaderBuilder,
        locale: easyLocalization.locale,
        appBuilder: buildAppOrOnboarding,
        loaderJobs: [
          // FIXME: onDatabaseVersionChanged should be called once the app
          // has been initialized.
          FastAppInfoJob(
            widget.appInfo,
            onDatabaseVersionChanged: widget.onDatabaseVersionChanged,
          ),
          FastAppSettingsJob(),
          FastAppDictJob(),
          FastAppFeaturesJob(),
          FastAppOnboardingJob(),
          ...?widget.loaderJobs,
        ],
        lightTheme: widget.lightTheme,
        darkTheme: widget.darkTheme,
        errorBuilder: widget.errorBuilder ?? handleAppError,
      ),
    );
  }

  /// Builds the app or onboarding widget depending on the app state.
  Widget buildAppOrOnboarding(BuildContext context) {
    final bloc = BlocProvider.of<FastAppOnboardingBloc>(context);
    final onboardingState = bloc.currentState;

    if (!onboardingState.isCompleted || widget.forceOnboarding) {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
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

  /// Handles the app error.
  Widget handleAppError(context, error) {
    debugPrint('handleAppError: $error');

    return const FastErrorStatusPage();
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
        final rateService = FastAppRatingService(widget.appInfo);
        rateService.askForAppReviewIfNeeded(context);
      }
    });
  }
}