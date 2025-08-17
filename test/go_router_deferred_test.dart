import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deferred/go_router_deferred.dart';

void main() {
  group('DeferredRoute', () {
    group('setup method', () {
      test('should create route with minimal required parameters', () {
        final route = DeferredRoute.setup(
          path: '/test',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(), // Required for basic route
        );

        expect(route.path, '/test');
        expect(route.name, isNull);
        expect(route.parentNavigatorKey, isNull);
        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNull);
        expect(route.routes, isEmpty);
        expect(route.redirect, isNotNull);
        expect(route.onExit, isNull);
        expect(route.caseSensitive, isTrue);
      });

      test('should create route with all optional parameters', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        final onExit = (BuildContext context, GoRouterState state) => true;
        final routes = [GoRoute(path: '/sub', builder: (context, state) => const TestScreen())];

        final route = DeferredRoute.setup(
          path: '/test',
          name: 'test_route',
          parentNavigatorKey: navigatorKey,
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          pageBuilder: (context, state) => const MaterialPage(child: TestScreen()),
          routes: routes,
          redirect: (state) async => '/redirect',
          onExit: onExit,
          caseSensitive: false,
        );

        expect(route.path, '/test');
        expect(route.name, 'test_route');
        expect(route.parentNavigatorKey, navigatorKey);
        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNotNull);
        expect(route.routes, routes);
        expect(route.redirect, isNotNull);
        expect(route.onExit, onExit);
        expect(route.caseSensitive, isFalse);
      });

      test('should create route with custom redirect function', () {
        bool redirectCalled = false;
        String? redirectResult;

        final route = DeferredRoute.setup(
          path: '/admin',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          redirect: (state) async {
            redirectCalled = true;
            redirectResult = '/dashboard';
            return '/dashboard';
          },
        );

        expect(route.redirect, isNotNull);
        
        // Test the redirect function
        final mockContext = MockBuildContext();
        final mockState = MockGoRouterState();
        
        // This would normally be called by GoRouter, but we can test the logic
        expect(redirectCalled, isFalse);
      });

      test('should handle redirect function that returns null', () {
        final route = DeferredRoute.setup(
          path: '/public',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          redirect: (state) async => null,
        );

        expect(route.redirect, isNotNull);
      });

      test('should handle redirect function that throws exception', () {
        final route = DeferredRoute.setup(
          path: '/error',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          redirect: (state) async {
            throw Exception('Redirect error');
          },
        );

        expect(route.redirect, isNotNull);
      });

      test('should create route with sub-routes', () {
        final subRoutes = [
          GoRoute(path: '/sub1', builder: (context, state) => const TestScreen()),
          GoRoute(path: '/sub2', builder: (context, state) => const TestScreen()),
        ];

        final route = DeferredRoute.setup(
          path: '/parent',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          routes: subRoutes,
        );

        expect(route.routes, subRoutes);
        expect(route.routes.length, 2);
      });

      test('should create route with case insensitive path matching', () {
        final route = DeferredRoute.setup(
          path: '/CaseSensitive',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          caseSensitive: false,
        );

        expect(route.caseSensitive, isFalse);
      });

      test('should create route with default case sensitive path matching', () {
        final route = DeferredRoute.setup(
          path: '/default',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
        );

        expect(route.caseSensitive, isTrue);
      });

      test('should handle loadLibrary function that throws exception', () {
        final route = DeferredRoute.setup(
          path: '/error',
          loadLibrary: () async {
            throw Exception('Library loading failed');
          },
          builder: (context, state) => const TestScreen(),
        );

        expect(route.redirect, isNotNull);
      });

      test('should handle loadLibrary function that completes successfully', () {
        bool libraryLoaded = false;
        
        final route = DeferredRoute.setup(
          path: '/success',
          loadLibrary: () async {
            libraryLoaded = true;
          },
          builder: (context, state) => const TestScreen(),
        );

        expect(route.redirect, isNotNull);
        expect(libraryLoaded, isFalse); // loadLibrary is not called yet
      });

      test('should create route with only pageBuilder (no builder)', () {
        final route = DeferredRoute.setup(
          path: '/page-only',
          loadLibrary: () async {},
          pageBuilder: (context, state) => const MaterialPage(child: TestScreen()),
        );

        expect(route.builder, isNull);
        expect(route.pageBuilder, isNotNull);
      });

      test('should create route with only builder (no pageBuilder)', () {
        final route = DeferredRoute.setup(
          path: '/builder-only',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
        );

        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNull);
      });

      test('should create route with both builder and pageBuilder', () {
        final route = DeferredRoute.setup(
          path: '/both',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          pageBuilder: (context, state) => const MaterialPage(child: TestScreen()),
        );

        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNotNull);
      });

      test('should create route with empty routes list', () {
        final route = DeferredRoute.setup(
          path: '/empty-routes',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
          routes: const [],
        );

        expect(route.routes, isEmpty);
      });

      test('should create route with onExit callback', () {
        bool exitCalled = false;
        
        final route = DeferredRoute.setup(
          path: '/with-exit',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(), // Required when onExit is provided
          onExit: (context, state) {
            exitCalled = true;
            return true;
          },
        );

        expect(route.onExit, isNotNull);
        expect(exitCalled, isFalse); // onExit is not called yet
      });
    });

    group('route properties', () {
      test('should have correct path property', () {
        final route = DeferredRoute.setup(
          path: '/custom-path',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
        );

        expect(route.path, '/custom-path');
      });

      test('should have correct name property', () {
        final route = DeferredRoute.setup(
          path: '/named-route',
          name: 'custom_name',
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
        );

        expect(route.name, 'custom_name');
      });

      test('should have correct parentNavigatorKey property', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        
        final route = DeferredRoute.setup(
          path: '/with-navigator',
          parentNavigatorKey: navigatorKey,
          loadLibrary: () async {},
          builder: (context, state) => const TestScreen(),
        );

        expect(route.parentNavigatorKey, navigatorKey);
      });
    });
  });

  group('DeferredShellRoute', () {
    group('setup method', () {
      test('should create shell route with minimal required parameters', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())], // At least one route required
        );

        expect(route, isA<ShellRoute>());
        expect(route.parentNavigatorKey, navigatorKey);
        expect(route.routes, isNotEmpty);
        expect(route.builder, isNull);
        expect(route.pageBuilder, isNull);
        expect(route.redirect, isNotNull);
        expect(route.navigatorKey, isNotNull); // ShellRoute automatically creates a navigator key when routes are provided
        expect(route.observers, isNull);
        expect(route.restorationScopeId, isNull);
      });

      test('should create shell route with all optional parameters', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        final shellNavigatorKey = GlobalKey<NavigatorState>();
        final observers = [MockNavigatorObserver()];
        final routes = [GoRoute(path: '/home', builder: (context, state) => const TestScreen())];

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          loadLibrary: () async {},
          builder: (context, state, child) => TestShell(child: child),
          pageBuilder: (context, state, child) => MaterialPage(child: TestShell(child: child)),
          routes: routes,
          redirect: (state) async => '/redirect',
          navigatorKey: shellNavigatorKey,
          observers: observers,
          restorationScopeId: 'test_scope',
        );

        expect(route, isA<ShellRoute>());
        expect(route.parentNavigatorKey, navigatorKey);
        expect(route.navigatorKey, shellNavigatorKey);
        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNotNull);
        expect(route.routes, routes);
        expect(route.redirect, isNotNull);
        expect(route.observers, observers);
        expect(route.restorationScopeId, 'test_scope');
      });

      test('should create shell route with loadLibrary function', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        bool libraryLoaded = false;

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          loadLibrary: () async {
            libraryLoaded = true;
          },
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route, isA<ShellRoute>());
        expect(route.redirect, isNotNull);
        expect(libraryLoaded, isFalse); // loadLibrary is not called yet
      });

      test('should create shell route without loadLibrary function', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route, isA<ShellRoute>());
        expect(route.redirect, isNotNull);
      });

      test('should create shell route with custom redirect function', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        bool redirectCalled = false;

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          redirect: (state) async {
            redirectCalled = true;
            return '/custom-redirect';
          },
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.redirect, isNotNull);
        expect(redirectCalled, isFalse); // redirect is not called yet
      });

      test('should create shell route with redirect function that returns null', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          redirect: (state) async => null,
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.redirect, isNotNull);
      });

      test('should create shell route with redirect function that throws exception', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          redirect: (state) async {
            throw Exception('Redirect error');
          },
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.redirect, isNotNull);
      });

      test('should create shell route with loadLibrary that throws exception', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          loadLibrary: () async {
            throw Exception('Library loading failed');
          },
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.redirect, isNotNull);
      });

      test('should create shell route with multiple routes', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        final routes = [
          GoRoute(path: '/home', builder: (context, state) => const TestScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const TestScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const TestScreen()),
        ];

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          routes: routes,
        );

        expect(route.routes, routes);
        expect(route.routes.length, 3);
      });

      test('should create shell route with only builder (no pageBuilder)', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          builder: (context, state, child) => TestShell(child: child),
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNull);
      });

      test('should create shell route with only pageBuilder (no builder)', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          pageBuilder: (context, state, child) => MaterialPage(child: TestShell(child: child)),
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.builder, isNull);
        expect(route.pageBuilder, isNotNull);
      });

      test('should create shell route with both builder and pageBuilder', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          builder: (context, state, child) => TestShell(child: child),
          pageBuilder: (context, state, child) => MaterialPage(child: TestShell(child: child)),
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNotNull);
      });

      test('should create shell route with observers', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        final observers = [MockNavigatorObserver()];

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          observers: observers,
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.observers, observers);
      });

      test('should create shell route with restoration scope ID', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          restorationScopeId: 'test_restoration_scope',
          routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        );

        expect(route.restorationScopeId, 'test_restoration_scope');
      });
    });
  });

  group('DeferredStatefulShellRoute', () {
    group('setup method', () {
      test('should create stateful shell route with minimal required parameters', () {
        final route = DeferredStatefulShellRoute.setup(
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell), // Required
        );

        expect(route, isA<StatefulShellRoute>());
        expect(route.parentNavigatorKey, isNull);
        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNull);
        expect(route.branches, isNotEmpty);
        expect(route.redirect, isNotNull);
        expect(route.restorationScopeId, isNull);
      });

      test('should create stateful shell route with all optional parameters', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        final branches = [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
          ),
        ];

        final route = DeferredStatefulShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          loadLibrary: () async {},
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
          pageBuilder: (context, state, navigationShell) => MaterialPage(child: TestStatefulShell(navigationShell: navigationShell)),
          branches: branches,
          redirect: (state) async => '/redirect',
          restorationScopeId: 'test_scope',
        );

        expect(route, isA<StatefulShellRoute>());
        expect(route.parentNavigatorKey, navigatorKey);
        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNotNull);
        expect(route.branches, branches);
        expect(route.redirect, isNotNull);
        expect(route.restorationScopeId, 'test_scope');
      });

      test('should create stateful shell route with loadLibrary function', () {
        bool libraryLoaded = false;

        final route = DeferredStatefulShellRoute.setup(
          loadLibrary: () async {
            libraryLoaded = true;
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route, isA<StatefulShellRoute>());
        expect(route.redirect, isNotNull);
        expect(libraryLoaded, isFalse); // loadLibrary is not called yet
      });

      test('should create stateful shell route without loadLibrary function', () {
        final route = DeferredStatefulShellRoute.setup(
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route, isA<StatefulShellRoute>());
        expect(route.redirect, isNotNull);
      });

      test('should create stateful shell route with custom redirect function', () {
        bool redirectCalled = false;

        final route = DeferredStatefulShellRoute.setup(
          redirect: (state) async {
            redirectCalled = true;
            return '/custom-redirect';
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.redirect, isNotNull);
        expect(redirectCalled, isFalse); // redirect is not called yet
      });

      test('should create stateful shell route with redirect function that returns null', () {
        final route = DeferredStatefulShellRoute.setup(
          redirect: (state) async => null,
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.redirect, isNotNull);
      });

      test('should create stateful shell route with redirect function that throws exception', () {
        final route = DeferredStatefulShellRoute.setup(
          redirect: (state) async {
            throw Exception('Redirect error');
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.redirect, isNotNull);
      });

      test('should create stateful shell route with loadLibrary that throws exception', () {
        final route = DeferredStatefulShellRoute.setup(
          loadLibrary: () async {
            throw Exception('Library loading failed');
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.redirect, isNotNull);
      });

      test('should create stateful shell route with multiple branches', () {
        final branches = [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (context, state) => const TestScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/settings', builder: (context, state) => const TestScreen())],
          ),
        ];

        final route = DeferredStatefulShellRoute.setup(
          branches: branches,
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.branches, branches);
        expect(route.branches.length, 3);
      });

      test('should create stateful shell route with only builder (no pageBuilder)', () {
        final route = DeferredStatefulShellRoute.setup(
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
        );

        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNull);
      });

      test('should create stateful shell route with only pageBuilder (no builder)', () {
        final route = DeferredStatefulShellRoute.setup(
          pageBuilder: (context, state, navigationShell) => MaterialPage(child: TestStatefulShell(navigationShell: navigationShell)),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
        );

        expect(route.builder, isNull);
        expect(route.pageBuilder, isNotNull);
      });

      test('should create stateful shell route with both builder and pageBuilder', () {
        final route = DeferredStatefulShellRoute.setup(
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
          pageBuilder: (context, state, navigationShell) => MaterialPage(child: TestStatefulShell(navigationShell: navigationShell)),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
        );

        expect(route.builder, isNotNull);
        expect(route.pageBuilder, isNotNull);
      });

      test('should create stateful shell route with parent navigator key', () {
        final navigatorKey = GlobalKey<NavigatorState>();

        final route = DeferredStatefulShellRoute.setup(
          parentNavigatorKey: navigatorKey,
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.parentNavigatorKey, navigatorKey);
      });

      test('should create stateful shell route with restoration scope ID', () {
        final route = DeferredStatefulShellRoute.setup(
          restorationScopeId: 'test_restoration_scope',
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
            ),
          ],
          builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        );

        expect(route.restorationScopeId, 'test_restoration_scope');
      });
    });
  });

  group('Integration tests', () {
    test('should create complex nested route structure', () {
      final navigatorKey = GlobalKey<NavigatorState>();
      
      final route = DeferredRoute.setup(
        path: '/admin',
        name: 'admin',
        parentNavigatorKey: navigatorKey,
        loadLibrary: () async {},
        builder: (context, state) => const TestScreen(),
        routes: [
          DeferredRoute.setup(
            path: 'dashboard',
            loadLibrary: () async {},
            builder: (context, state) => const TestScreen(),
          ),
          DeferredRoute.setup(
            path: 'users',
            loadLibrary: () async {},
            builder: (context, state) => const TestScreen(),
          ),
        ],
      );

      expect(route.path, '/admin');
      expect(route.name, 'admin');
      expect(route.parentNavigatorKey, navigatorKey);
      expect(route.routes.length, 2);
      expect((route.routes[0] as GoRoute).path, 'dashboard');
      expect((route.routes[1] as GoRoute).path, 'users');
    });

    test('should create shell route with deferred routes', () {
      final navigatorKey = GlobalKey<NavigatorState>();
      
      final shellRoute = DeferredShellRoute.setup(
        parentNavigatorKey: navigatorKey,
        loadLibrary: () async {},
        builder: (context, state, child) => TestShell(child: child),
        routes: [
          DeferredRoute.setup(
            path: '/home',
            loadLibrary: () async {},
            builder: (context, state) => const TestScreen(),
          ),
          DeferredRoute.setup(
            path: '/profile',
            loadLibrary: () async {},
            builder: (context, state) => const TestScreen(),
          ),
        ],
      );

      expect(shellRoute, isA<ShellRoute>());
      expect(shellRoute.parentNavigatorKey, navigatorKey);
      expect(shellRoute.routes.length, 2);
      expect((shellRoute.routes[0] as GoRoute).path, '/home');
      expect((shellRoute.routes[1] as GoRoute).path, '/profile');
    });

    test('should create stateful shell route with deferred routes', () {
      final navigatorKey = GlobalKey<NavigatorState>();
      
      final statefulShellRoute = DeferredStatefulShellRoute.setup(
        parentNavigatorKey: navigatorKey,
        loadLibrary: () async {},
        builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              DeferredRoute.setup(
                path: '/home',
                loadLibrary: () async {},
                builder: (context, state) => const TestScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              DeferredRoute.setup(
                path: '/profile',
                loadLibrary: () async {},
                builder: (context, state) => const TestScreen(),
              ),
            ],
          ),
        ],
      );

      expect(statefulShellRoute, isA<StatefulShellRoute>());
      expect(statefulShellRoute.parentNavigatorKey, navigatorKey);
      expect(statefulShellRoute.branches.length, 2);
      expect((statefulShellRoute.branches[0].routes[0] as GoRoute).path, '/home');
      expect((statefulShellRoute.branches[1].routes[0] as GoRoute).path, '/profile');
    });
  });

  group('Redirect function execution tests', () {
    test('should execute DeferredRoute redirect function with loadLibrary and custom redirect', () async {
      bool loadLibraryCalled = false;
      bool customRedirectCalled = false;
      
      final route = DeferredRoute.setup(
        path: '/test',
        loadLibrary: () async {
          loadLibraryCalled = true;
        },
        builder: (context, state) => const TestScreen(),
        redirect: (state) async {
          customRedirectCalled = true;
          return '/redirected';
        },
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(loadLibraryCalled, isTrue);
      expect(customRedirectCalled, isTrue);
      expect(result, '/redirected');
    });

    test('should execute DeferredRoute redirect function with loadLibrary only', () async {
      bool loadLibraryCalled = false;
      
      final route = DeferredRoute.setup(
        path: '/test',
        loadLibrary: () async {
          loadLibraryCalled = true;
        },
        builder: (context, state) => const TestScreen(),
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(loadLibraryCalled, isTrue);
      expect(result, isNull);
    });

    test('should execute DeferredShellRoute redirect function with loadLibrary and custom redirect', () async {
      bool loadLibraryCalled = false;
      bool customRedirectCalled = false;
      
      final route = DeferredShellRoute.setup(
        parentNavigatorKey: GlobalKey<NavigatorState>(),
        loadLibrary: () async {
          loadLibraryCalled = true;
        },
        builder: (context, state, child) => TestShell(child: child),
        routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
        redirect: (state) async {
          customRedirectCalled = true;
          return '/redirected';
        },
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(loadLibraryCalled, isTrue);
      expect(customRedirectCalled, isTrue);
      expect(result, '/redirected');
    });

    test('should execute DeferredShellRoute redirect function with loadLibrary only', () async {
      bool loadLibraryCalled = false;
      
      final route = DeferredShellRoute.setup(
        parentNavigatorKey: GlobalKey<NavigatorState>(),
        loadLibrary: () async {
          loadLibraryCalled = true;
        },
        builder: (context, state, child) => TestShell(child: child),
        routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(loadLibraryCalled, isTrue);
      expect(result, isNull);
    });

    test('should execute DeferredShellRoute redirect function without loadLibrary', () async {
      final route = DeferredShellRoute.setup(
        parentNavigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) => TestShell(child: child),
        routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(result, isNull);
    });

    test('should execute DeferredStatefulShellRoute redirect function with loadLibrary and custom redirect', () async {
      bool loadLibraryCalled = false;
      bool customRedirectCalled = false;
      
      final route = DeferredStatefulShellRoute.setup(
        loadLibrary: () async {
          loadLibraryCalled = true;
        },
        builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
          ),
        ],
        redirect: (state) async {
          customRedirectCalled = true;
          return '/redirected';
        },
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(loadLibraryCalled, isTrue);
      expect(customRedirectCalled, true);
      expect(result, '/redirected');
    });

    test('should execute DeferredStatefulShellRoute redirect function with loadLibrary only', () async {
      bool loadLibraryCalled = false;
      
      final route = DeferredStatefulShellRoute.setup(
        loadLibrary: () async {
          loadLibraryCalled = true;
        },
        builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
          ),
        ],
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(loadLibraryCalled, isTrue);
      expect(result, isNull);
    });

    test('should execute DeferredStatefulShellRoute redirect function without loadLibrary', () async {
      final route = DeferredStatefulShellRoute.setup(
        builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
          ),
        ],
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      final result = await route.redirect!(mockContext, mockState);
      
      expect(result, isNull);
    });

    test('should handle loadLibrary exceptions in DeferredRoute redirect', () async {
      final route = DeferredRoute.setup(
        path: '/test',
        loadLibrary: () async {
          throw Exception('Library loading failed');
        },
        builder: (context, state) => const TestScreen(),
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function and expect it to throw
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      
      expect(
        () => route.redirect!(mockContext, mockState),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle loadLibrary exceptions in DeferredShellRoute redirect', () async {
      final route = DeferredShellRoute.setup(
        parentNavigatorKey: GlobalKey<NavigatorState>(),
        loadLibrary: () async {
          throw Exception('Library loading failed');
        },
        builder: (context, state, child) => TestShell(child: child),
        routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function and expect it to throw
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      
      expect(
        () => route.redirect!(mockContext, mockState),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle loadLibrary exceptions in DeferredStatefulShellRoute redirect', () async {
      final route = DeferredStatefulShellRoute.setup(
        loadLibrary: () async {
          throw Exception('Library loading failed');
        },
        builder: (context, state, navigationShell) => TestStatefulShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const TestScreen())],
          ),
        ],
      );

      expect(route.redirect, isNotNull);
      
      // Execute the redirect function and expect it to throw
      final mockContext = MockBuildContext();
      final mockState = MockGoRouterState();
      
      expect(
        () => route.redirect!(mockContext, mockState),
        throwsA(isA<Exception>()),
      );
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

class TestStatefulShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TestStatefulShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: navigationShell);
  }
}

// Mock classes for testing
class MockBuildContext extends Mock implements BuildContext {}

class MockGoRouterState extends Mock implements GoRouterState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Mock implementation
class Mock {
  const Mock();
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
