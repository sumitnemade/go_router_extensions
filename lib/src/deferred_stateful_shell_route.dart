import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on [StatefulShellRoute] to provide deferred loading capabilities.
///
/// This extension allows stateful shell routes to be loaded lazily, improving initial app startup time
/// by deferring the loading of stateful shell route-specific code until it's actually needed.
extension DeferredStatefulShellRoute on StatefulShellRoute {
  /// Creates a [StatefulShellRoute] with deferred loading capabilities.
  ///
  /// The [loadLibrary] function is called when the stateful shell route is first accessed,
  /// allowing for lazy loading of stateful shell route-specific dependencies.
  ///
  /// Example:
  /// ```dart
  /// import 'shell/app_shell.dart' deferred as app_shell;
  /// import 'screens/home_screen.dart' deferred as home_screen;
  ///
  /// DeferredStatefulShellRoute.setup(
  ///   parentNavigatorKey: _shellNavigatorKey,
  ///   loadLibrary: app_shell.loadLibrary,
  ///   builder: (context, state, navigationShell) => app_shell.AppShell(navigationShell: navigationShell),
  ///   branches: [
  ///     StatefulShellBranch(
  ///       routes: [GoRoute(path: '/home', builder: (context, state) => home_screen.HomeScreen())],
  ///     ),
  ///   ],
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [parentNavigatorKey]: Optional navigator key for the parent navigator.
  /// - [loadLibrary]: Optional function that loads the required library when the stateful shell route is accessed.
  /// - [builder]: Optional stateful shell route builder function.
  /// - [pageBuilder]: Optional stateful shell route page builder function.
  /// - [branches]: List of stateful shell branches.
  /// - [redirect]: Optional redirect function.
  /// - [restorationScopeId]: Optional restoration scope ID.
  /// - [key]: Optional key for the stateful navigation shell state.
  static StatefulShellRoute setup({
    final GlobalKey<NavigatorState>? parentNavigatorKey,
    final Future<void> Function()? loadLibrary,
    final StatefulShellRouteBuilder? builder,
    final StatefulShellRoutePageBuilder? pageBuilder,
    final List<StatefulShellBranch> branches = const <StatefulShellBranch>[],
    final Future<String?> Function(GoRouterState)? redirect,
    final String? restorationScopeId,
    final GlobalKey<StatefulNavigationShellState>? key,
  }) {
    return StatefulShellRoute.indexedStack(
      parentNavigatorKey: parentNavigatorKey,
      builder: builder,
      pageBuilder: pageBuilder,
      branches: branches,
      restorationScopeId: restorationScopeId,
      key: key,
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
