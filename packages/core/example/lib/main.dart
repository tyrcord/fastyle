// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core_example/data/items.dart';
import 'package:fastyle_core_example/routes.dart';

class DummyLoaderJob extends FastJob {
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) {
    return Future.delayed(const Duration(milliseconds: 500));
  }
}

class DummyCrashLoaderJob extends FastJob {
  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    throw ErrorDescription('Demo');
  }
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      lightTheme: FastTheme.light.blue,
      darkTheme: FastTheme.dark.blue,
      routesForMediaType: (mediaType) => [
        ...kAppRoutes,
        GoRoute(path: '/', builder: (_, __) => const MyHomePage()),
      ],
      loaderJobs: [
        DummyLoaderJob(),
        DummyLoaderJob(),
        DummyLoaderJob(),
        // DummyCrashLoaderJob(),
        DummyLoaderJob(),
      ],
      errorBuilder: (context, error) {
        final palette = ThemeHelper.getPaletteColors(context);

        return Center(
          child: FastBody(
            textColor: palette.red.mid,
            text: 'Oops! An error occured while launching the app',
          ),
        );
      },
      loaderBuilder: (context, progress) {
        debugPrint(progress.toString());

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FastLinearProgressBarIndicator(
              showProgressLabel: true,
              showAsPercentage: true,
              fractionDigits: 0,
              minBarHeight: 20,
              value: progress,
              barRadius: 10,
              maxValue: 1,
            ),
            kFastSizedBox16,
            const FastBody(
                text: 'Please wait while the application is loading...'),
          ],
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FastHomePage(
      leading: FastIconButton(
        onTap: () => context.go('/onboarding'),
        icon: const Icon(Icons.account_circle),
        iconColor: palette.whiteColor,
        iconSize: kFastIconSizeMedium,
      ),
      actions: [
        FastIconButton(
          onTap: () async {
            final response = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const FastSearchPage(
                  items: demoItems,
                  categories: demoCategories,
                  groupByCategory: true,
                  useFuzzySearch: true,
                ),
                fullscreenDialog: true,
              ),
            );

            if (response != null) {
              debugPrint(response.value.toString());
            }
          },
          icon: const Icon(Icons.search),
          iconColor: palette.whiteColor,
          iconSize: kFastIconSizeMedium,
        ),
      ],
      titleText: 'Fastyle Demo',
      subtitleText: 'Hello stranger! Have a wonderful day! :)',
      floatingActionButton: const FloatingActionButton(
        onPressed: noop,
        tooltip: 'Settings',
        child: Icon(Icons.settings),
      ),
      children: _buildList(context),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;
    final palette = ThemeHelper.getPaletteColors(context);

    return [
      const FastListHeader(
        categoryText: 'options',
        captionText: 'Favorites',
      ),
      FastToggleListItem(
        leading: const Icon(Icons.brightness_2),
        labelText: 'Dark Mode',
        isChecked: themeBloc.currentState.brightness == Brightness.dark,
        onValueChanged: (bool shouldSwitchToDarkMode) {
          if (shouldSwitchToDarkMode) {
            themeBloc.addEvent(const FastThemeBlocEvent.dark());
          } else {
            themeBloc.addEvent(const FastThemeBlocEvent.light());
          }
        },
      ),
      const FastListHeader(
        categoryText: 'ui categories',
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.radio_button_checked),
          palette: palette.purple,
        ),
        labelText: 'Buttons',
        descriptionText: 'Raised, icon buttons',
        onTap: () => context.go('/buttons'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.text_fields),
          palette: palette.green,
        ),
        labelText: 'Typography',
        descriptionText: 'Title, subhead...',
        onTap: () => context.go('/typography'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.table_chart),
          palette: palette.blue,
        ),
        labelText: 'Tabs',
        onTap: () => context.go('/tabs'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.view_agenda),
          palette: palette.blueGray,
        ),
        labelText: 'Cards',
        onTap: () => context.go('/cards'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.view_list),
          palette: palette.pink,
        ),
        labelText: 'List',
        onTap: () => context.go('/list'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.edit),
          palette: palette.teal,
        ),
        labelText: 'Fields',
        onTap: () => context.go('/fields'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.message),
          palette: palette.orange,
        ),
        labelText: 'Notifications',
        onTap: () => context.go('/notifications'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.colorize),
          palette: palette.red,
        ),
        labelText: 'Colors',
        onTap: () => context.go('/colors'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.description),
          palette: palette.brown,
        ),
        labelText: 'Page',
        onTap: () => context.go('/page'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const Icon(Icons.dashboard),
          palette: palette.yellow,
        ),
        labelText: 'responsive',
        onTap: () => context.go('/responsive'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const FaIcon(FontAwesomeIcons.tableColumns),
          palette: palette.blue,
        ),
        labelText: 'Split View',
        onTap: () => context.go('/split-view'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const FaIcon(FontAwesomeIcons.tablet),
          palette: palette.green,
        ),
        labelText: 'Navigation Bar View',
        onTap: () => context.go('/navigation-bar-view/explore'),
      ),
      FastNavigationListItem(
        leading: FastRoundedDuotoneIcon(
          icon: const FaIcon(FontAwesomeIcons.spinner),
          palette: palette.blue,
        ),
        labelText: 'Indicators',
        onTap: () => context.go('/indicators'),
      ),
    ];
  }
}
