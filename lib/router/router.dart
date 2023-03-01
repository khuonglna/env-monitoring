import 'package:go_router/go_router.dart';

import '../constants/path.dart';
import '../pages/home/map_page.dart';
import '../pages/home/setting_page.dart';
import '../pages/home/station_list_page.dart';
// import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../widgets/base_scaffold.dart';
import 'router_key_manager.dart';

class AppRouter {
  static final router = GoRouter(
    
    initialLocation: AppPath.login,
    navigatorKey: RouterKeyManager.instance.rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: AppPath.login,
        builder: (
          context,
          state,
        ) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppPath.register,
        builder: (
          context,
          state,
        ) =>
            const RegisterPage(),
      ),
      ShellRoute(
        navigatorKey: RouterKeyManager.instance.shellNavigatorKey,
        builder: (
          context,
          state,
          child,
        ) =>
            BaseScaffold(
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppPath.map,
            builder: (
              context,
              state,
            ) =>
                const MapPage(),
          ),
          // GoRoute(
          //   path: AppPath.favorite,
          //   builder: (
          //     context,
          //     state,
          //   ) =>
          //       const FavoritePage(),
          // ),
          GoRoute(
            path: AppPath.list,
            builder: (
              context,
              state,
            ) =>
                const StationListPage(),
          ),
          GoRoute(
            path: AppPath.setting,
            builder: (
              context,
              state,
            ) =>
                const SettingPage(),
          ),
        ],
      ),
    ],
    debugLogDiagnostics: true,
  );
}
