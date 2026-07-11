import 'package:go_router/go_router.dart';
import 'package:movieapp/features/home/screens/main_shell.dart';
import 'package:movieapp/features/home/screens/splash_screen.dart';
import 'package:movieapp/features/username/domain/models/profile.dart';
import 'package:movieapp/features/username/screens/username_screen.dart';
import 'package:movieapp/shared/routes/routes.dart';

class RouteGenerator {
  static GoRouter generateRoute() {
    return GoRouter(
      initialLocation: routeSplashScreen,
      routes: [
        GoRoute(
          path: routeSplashScreen,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: routeUserName,
          builder: (context, state) => const UsernameScreen(),
        ),
        GoRoute(
          path: routeHomeScreen,
          builder: (context, state) {
            final profile = state.extra as Profile?;
            final tab = int.tryParse(
                  state.uri.queryParameters['tab'] ?? '',
                ) ??
                0;
            return MainShell(
              profileName: profile?.name ??
                  state.uri.queryParameters['profile'] ??
                  'User',
              profileImage: profile?.image,
              initialIndex: tab.clamp(0, 4),
            );
          },
        ),
      ],
    );
  }
}
