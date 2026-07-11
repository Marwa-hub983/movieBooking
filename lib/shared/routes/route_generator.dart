import 'package:go_router/go_router.dart';
import 'package:movieapp/features/coming_soon/screens/coming_soon_screen.dart';
import 'package:movieapp/features/home/screens/home_screen.dart';
import 'package:movieapp/features/home/screens/search_screen.dart';
import 'package:movieapp/features/home/screens/splash_screen.dart';
import 'package:movieapp/features/username/models/profile.dart';
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
            return HomeScreen(
              profileName: profile?.name ??
                  state.uri.queryParameters['profile'] ??
                  'User',
              profileImage: profile?.image,
            );
          },
        ),
        GoRoute(
          path: routeSearchScreen,
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: routeComingSoonScreen,
          builder: (context, state) => const ComingSoonScreen(),
        ),
      ],
    );
  }
}
