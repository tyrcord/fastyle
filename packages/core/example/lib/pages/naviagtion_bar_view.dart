import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class NavigationBarViewPage extends StatelessWidget {
  final Widget? child;

  const NavigationBarViewPage({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastNavigationBarView(
        indicatorColor: ThemeHelper.getPaletteColors(context).mint.mid,
        showAppBar: false,
        destinations: const <FastNavigationDestination>[
          FastNavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Explore',
            path: '/navigation-bar-view/explore',
          ),
          FastNavigationDestination(
            icon: Icon(Icons.commute),
            label: 'Commute',
            path: '/navigation-bar-view/commute',
          ),
          FastNavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
            path: '/navigation-bar-view/saved',
          ),
        ],
        child: child,
      ),
    );
  }
}
