// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;

  const BaseScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: SizedBox(
        height: 90,
        child: CurvedNavigationBar(
          color: theme.scaffoldBackgroundColor,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: theme.colorScheme.secondary,
          items: const [
            Icon(
              Icons.location_on_sharp,
            ),
            // Icon(
            //   Icons.star,
            // ),
            Icon(
              Icons.list,
            ),
            Icon(
              Icons.settings,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/map');
        break;
      // case 1:
      //   GoRouter.of(context).go('/favorite');
      //   break;
      case 1:
        GoRouter.of(context).go('/list');
        break;
      case 2:
        GoRouter.of(context).go('/setting');
        break;
    }
  }
}
