import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_extensions/go_router_extensions.dart';

// Import screens with deferred loading
import 'screens/home_screen.dart' deferred as home_screen;
import 'screens/user_profile_screen.dart' deferred as user_profile_screen;
import 'screens/admin_screen.dart' deferred as admin_screen;
import 'screens/dashboard_screen.dart' deferred as dashboard_screen;
import 'screens/analytics_screen.dart' deferred as analytics_screen;
import 'screens/reports_screen.dart' deferred as reports_screen;
import 'shell/app_shell.dart' deferred as app_shell;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go Router Extensions Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// Global navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Router configuration with deferred routes
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Basic deferred route
    DeferredRoute.setup(
      path: '/',
      loadLibrary: home_screen.loadLibrary,
      builder: (context, state) => home_screen.HomeScreen(),
    ),

    // Deferred route with parameters
    DeferredRoute.setup(
      path: '/user/:id',
      loadLibrary: user_profile_screen.loadLibrary,
      builder: (context, state) => user_profile_screen.UserProfileScreen(
        userId: state.pathParameters['id']!,
      ),
    ),

    // Deferred route with redirect
    DeferredRoute.setup(
      path: '/admin',
      loadLibrary: admin_screen.loadLibrary,
      builder: (context, state) => admin_screen.AdminScreen(),
      redirect: (state) async {
        // Simulate admin check
        await Future.delayed(const Duration(milliseconds: 100));
        return null; // Allow access
      },
    ),

    // Deferred shell route
    DeferredShellRoute.setup(
      parentNavigatorKey: _shellNavigatorKey,
      loadLibrary: app_shell.loadLibrary,
      builder: (context, state, child) => app_shell.AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => dashboard_screen.DashboardScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => analytics_screen.AnalyticsScreen(),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => reports_screen.ReportsScreen(),
        ),
      ],
    ),
  ],
);
