import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/go_router_refresh_stream.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/gallery/presentation/gallery_page.dart';
import '../features/landing/presentation/landing_page.dart';
import '../features/auth/presentation/login_page.dart';

class AppRouter {
  AppRouter() {
    _authRefresh = GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());

    router = GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: false,
      refreshListenable: _authRefresh,
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'landing',
          builder: (context, state) => const LandingPage(),
          routes: [
            GoRoute(
              path: 'gallery',
              name: 'gallery',
              builder: (context, state) => const GalleryPage(),
            ),
            GoRoute(
              path: 'login',
              name: 'login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: 'dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final bool loggedIn = FirebaseAuth.instance.currentUser != null;
        final String location = state.matchedLocation;
        final bool loggingIn = location == '/login';
        final bool goingToDashboard = location == '/dashboard';

        if (!loggedIn && goingToDashboard) {
          return '/login';
        }

        if (loggedIn && loggingIn) {
          return '/dashboard';
        }

        return null;
      },
    );
  }

  late final GoRouter router;
  late final GoRouterRefreshStream _authRefresh;

  void dispose() {
    _authRefresh.dispose();
    router.dispose();
  }
}

