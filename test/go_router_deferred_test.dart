import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deferred/go_router_deferred.dart';

void main() {
  group('DeferredRoute', () {
    test('should create route with correct path', () {
      final route = DeferredRoute.setup(
        path: '/test',
        loadLibrary: () async {},
        builder: (context, state) => const TestScreen(),
      );

      expect(route.path, '/test');
    });

    test('should create route with name', () {
      final route = DeferredRoute.setup(
        path: '/test',
        name: 'test',
        loadLibrary: () async {},
        builder: (context, state) => const TestScreen(),
      );

      expect(route.name, 'test');
    });

    test('should handle redirect logic', () {
      bool redirectCalled = false;

      final route = DeferredRoute.setup(
        path: '/admin',
        loadLibrary: () async {},
        builder: (context, state) => const TestScreen(),
        redirect: (state) async {
          redirectCalled = true;
          return null;
        },
      );

      expect(route.redirect, isNotNull);
    });
  });

  group('DeferredShellRoute', () {
    test('should create shell route', () {
      final navigatorKey = GlobalKey<NavigatorState>();

      final route = DeferredShellRoute.setup(
        parentNavigatorKey: navigatorKey,
        builder: (context, state, child) => TestShell(child: child),
        routes: [
          GoRoute(
              path: '/home', builder: (context, state) => const TestScreen()),
        ],
      );

      expect(route, isA<ShellRoute>());
    });

    test('should handle optional loadLibrary', () {
      final navigatorKey = GlobalKey<NavigatorState>();

      final route = DeferredShellRoute.setup(
        parentNavigatorKey: navigatorKey,
        builder: (context, state, child) => TestShell(child: child),
        routes: [
          GoRoute(
              path: '/home', builder: (context, state) => const TestScreen()),
        ],
      );

      expect(route, isA<ShellRoute>());
    });
  });
}

// Test widgets
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Test Screen')),
    );
  }
}

class TestShell extends StatelessWidget {
  final Widget child;

  const TestShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
