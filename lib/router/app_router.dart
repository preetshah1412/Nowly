import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/intro/splash_screen.dart';
import '../features/requests/presentation/screens/request_configuration_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/request',
        builder: (context, state) => const RequestConfigurationScreen(),
      ),
    ],
  );
}
