// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseApp extends FastApp {
  /// The default firebase options.
  final FirebaseOptions? firebaseOptions;

  /// The default remote config values.
  final Map<String, dynamic>? defaultRemoteConfig;

  FastFirebaseApp({
    super.key,
    required super.routesForMediaType,
    super.delayBeforeShowingLoader = kFastDelayBeforeShowingLoader,
    super.debugShowCheckedModeBanner = false,
    super.forceOnboarding = false,
    super.askForReview = true,
    super.onDatabaseVersionChanged,
    super.defaultAppDictEntries,
    super.onboardingBuilder,
    super.rootNavigatorKey,
    super.errorReporter,
    super.blocProviders,
    super.loaderBuilder,
    super.errorBuilder,
    super.assetLoader,
    super.loaderJobs,
    super.lightTheme,
    super.darkTheme,
    super.appInformation,
    super.useProIcons,
    super.isInternetConnectionRequired,
    super.initialLocation,
    this.defaultRemoteConfig,
    this.firebaseOptions,
    super.onWillRestartApp,
    super.onAppReady,
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

        return const FastPrimaryBackgroundContainer();
      },
    );
  }

  Widget buildApp() {
    return BlocProvider(
      bloc: _remoteConfigBloc,
      child: FastApp(
        defaultAppDictEntries: widget.defaultAppDictEntries,
        useProIcons: widget.useProIcons,
        errorReporter: FastFirebaseAppErrorReporter(),
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
        routesForMediaType: widget.routesForMediaType,
        isInternetConnectionRequired: widget.isInternetConnectionRequired,
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
        askForReview: widget.askForReview,
        initialLocation: widget.initialLocation,
        onWillRestartApp: _handleRestartApp,
        onAppReady: widget.onAppReady,
      ),
    );
  }

  void _handleRestartApp() {
    FastFirebaseRemoteConfigBloc.reset();

    widget.onWillRestartApp?.call();
  }
}
