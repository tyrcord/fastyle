// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FusexFirebaseApp extends StatefulWidget {
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
  final FastAppInfoDocument appInfo;

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
  final dynamic assetLoader;

  /// A flag indicating whether to ask the user for an app review
  /// when certain conditions are met.
  final bool askForReview;

  /// The default firebase options.
  final FirebaseOptions? firebaseOptions;

  /// The default remote config values.
  final Map<String, dynamic>? defaultRemoteConfig;

  const FusexFirebaseApp({
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
    this.defaultRemoteConfig,
    String? localizationPath,
    Locale? fallbackLocale,
    this.firebaseOptions,
  })  : localizationPath = localizationPath ?? kFastLocalizationPath,
        fallbackLocale = fallbackLocale ?? kFastAppSettingsDefaultLocale;

  @override
  State<FusexFirebaseApp> createState() => _FusexFirebaseAppState();
}

class _FusexFirebaseAppState extends State<FusexFirebaseApp> {
  final _remoteConfigBloc = FastFirebaseRemoteConfigBloc();
  late final Future<FirebaseApp> _initialization;

  @override
  void initState() {
    super.initState();

    _initialization = Firebase.initializeApp(
      options: widget.firebaseOptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          // TODO: log error with analytics (generic property) 3.1
          // throw snapshot.error;
          return buildApp();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return buildApp();
        }

        return buildEmptyContainer(context);
      },
    );
  }

  Widget buildApp() {
    return BlocProvider(
      bloc: _remoteConfigBloc,
      child: FastApp(
        routes: widget.routes,
        errorReporter: FastFirebaseAppErrorReporter(),
        homeBuilder: widget.homeBuilder,
        localizationPath: widget.localizationPath,
        lightTheme: widget.lightTheme,
        darkTheme: widget.darkTheme,
        fallbackLocale: widget.fallbackLocale,
        assetLoader: widget.assetLoader,
        loaderJobs: [
          FastFirebaseCrashlyticsJob(),
          FastFirebasePerformanceJob(),
          FastFirebaseRemoteConfigJob(
            defaultConfig: widget.defaultRemoteConfig,
          ),
          ...?widget.loaderJobs,
          FastFirebaseMessagingJob(),
        ],
        appInfo: widget.appInfo,
        onDatabaseVersionChanged: widget.onDatabaseVersionChanged,
        onboardingBuilder: widget.onboardingBuilder,
        blocProviders: widget.blocProviders,
        forceOnboarding: widget.forceOnboarding,
        errorBuilder: widget.errorBuilder,
        loaderBuilder: widget.loaderBuilder,
        delayBeforeShowingLoader: widget.delayBeforeShowingLoader,
        rootNavigatorKey: widget.rootNavigatorKey,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        initialRoute: widget.initialRoute,
        askForReview: widget.askForReview,
      ),
    );
  }

  /// Builds an empty container with the primary background color.
  Widget buildEmptyContainer(BuildContext context) {
    // TODO: move to fastyle_ui
    final colors = ThemeHelper.colors;
    final backgroundColor = colors.getPrimaryBackgroundColor(context);

    return Container(color: backgroundColor);
  }
}
