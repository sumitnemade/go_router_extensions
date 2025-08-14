import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on [ShellRoute] to provide deferred loading capabilities.
///
/// This extension allows shell routes to be loaded lazily, improving initial app startup time
/// by deferring the loading of shell route-specific code until it's actually needed.
extension DeferredShellRoute on ShellRoute {
  /// Creates a [ShellRoute] with deferred loading capabilities.
  ///
  /// The [loadLibrary] function is called when the shell route is first accessed,
  /// allowing for lazy loading of shell route-specific dependencies.
  ///
  /// Example:
  /// ```dart
  /// import 'shell/app_shell.dart' deferred as app_shell;
  /// import 'screens/home_screen.dart' deferred as home_screen;
  ///
  /// DeferredShellRoute.setup(
  ///   parentNavigatorKey: _shellNavigatorKey,
  ///   loadLibrary: app_shell.loadLibrary,
  ///   builder: (context, state, child) => app_shell.AppShell(child: child),
  ///   routes: [
  ///     GoRoute(path: '/home', builder: (context, state) => home_screen.HomeScreen()),
  ///   ],
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [parentNavigatorKey]: The navigator key for the parent navigator.
  /// - [loadLibrary]: Optional function that loads the required library when the shell route is accessed.
  /// - [builder]: Optional shell route builder function.
  /// - [pageBuilder]: Optional shell route page builder function.
  /// - [routes]: List of routes within this shell route.
  /// - [redirect]: Optional redirect function.
  /// - [navigatorKey]: Optional navigator key for this shell route.
  /// - [observers]: Optional list of navigator observers.
  /// - [restorationScopeId]: Optional restoration scope ID.
  static ShellRoute setup({
    required final GlobalKey<NavigatorState> parentNavigatorKey,
    final Future<void> Function()? loadLibrary,
    final ShellRouteBuilder? builder,
    final ShellRoutePageBuilder? pageBuilder,
    final List<RouteBase> routes = const <RouteBase>[],
    final Future<String?> Function(GoRouterState)? redirect,
    final GlobalKey<NavigatorState>? navigatorKey,
    final List<NavigatorObserver>? observers,
    final String? restorationScopeId,
  }) {
    return ShellRoute(
      parentNavigatorKey: parentNavigatorKey,
      navigatorKey: navigatorKey,
      builder: builder,
      pageBuilder: pageBuilder,
      routes: routes,
      observers: observers,
      restorationScopeId: restorationScopeId,
      redirect: (context, state) async {
        if (loadLibrary != null) {
          await loadLibrary();
        }
        if (redirect != null) {
          return await redirect(state);
        }
        return null;
      },
    );
  }
}
