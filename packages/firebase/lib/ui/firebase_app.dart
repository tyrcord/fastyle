// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseApp extends FastApp {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// The default firebase options.
  final FirebaseOptions? firebaseOptions;

  /// The default remote config values.
  final Map<String, dynamic>? defaultRemoteConfig;

  FastFirebaseApp({
    super.key,
    super.delayBeforeShowingLoader = kFastDelayBeforeShowingLoader,
    super.debugShowCheckedModeBanner = false,
    super.forceOnboarding = false,
    super.routes = kFastDefaultRoutes,
    super.askForReview = true,
    super.onDatabaseVersionChanged,
    super.defaultAppDictEntries,
    super.onboardingBuilder,
    super.rootNavigatorKey,
    super.errorReporter,
    super.blocProviders,
    super.loaderBuilder,
    super.errorBuilder,
    super.initialRoute,
    super.homeBuilder,
    super.assetLoader,
    super.loaderJobs,
    super.lightTheme,
    super.darkTheme,
    super.appInformation,
    super.useProIcons,
    this.defaultRemoteConfig,
    this.firebaseOptions,
    String? localizationPath,
    Locale? fallbackLocale,
  }) : super(
          localizationPath: localizationPath ?? kFastLocalizationPath,
          fallbackLocale: fallbackLocale ?? kFastAppSettingsDefaultLocale,
        );

  @override
  State<FastFirebaseApp> createState() => _FastFirebaseAppState();
}

class _FastFirebaseAppState extends State<FastFirebaseApp> {
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
        defaultAppDictEntries: widget.defaultAppDictEntries,
        useProIcons: widget.useProIcons,
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
          FastFirebaseMessagingJob(),
          FastFirebaseRemoteConfigJob(
            defaultConfig: widget.defaultRemoteConfig,
          ),
          ...?widget.loaderJobs,
        ],
        appInformation: widget.appInfo,
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
