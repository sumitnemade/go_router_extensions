import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on [GoRoute] to provide deferred loading capabilities.
///
/// This extension allows routes to be loaded lazily, improving initial app startup time
/// by deferring the loading of route-specific code until it's actually needed.
extension DeferredRoute on GoRoute {
  /// Creates a [GoRoute] with deferred loading capabilities.
  ///
  /// The [loadLibrary] function is called when the route is first accessed,
  /// allowing for lazy loading of route-specific dependencies.
  ///
  /// Example:
  /// ```dart
  /// import 'screens/settings_screen.dart' deferred as settings_screen;
  ///
  /// DeferredRoute.setup(
  ///   path: '/settings',
  ///   loadLibrary: settings_screen.loadLibrary,
  ///   builder: (context, state) => settings_screen.SettingsScreen(),
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [path]: The path pattern for this route.
  /// - [name]: Optional name for this route.
  /// - [parentNavigatorKey]: Optional navigator key for the parent navigator.
  /// - [loadLibrary]: Function that loads the required library when the route is accessed.
  /// - [builder]: Optional builder function for the route.
  /// - [pageBuilder]: Optional page builder function for the route.
  /// - [routes]: Optional list of sub-routes.
  /// - [redirect]: Optional redirect function.
  /// - [onExit]: Optional callback when exiting the route.
  /// - [caseSensitive]: Whether the path matching is case sensitive.
  static GoRoute setup({
    required final String path,
    final String? name,
    final GlobalKey<NavigatorState>? parentNavigatorKey,
    required final Future<void> Function() loadLibrary,
    final GoRouterWidgetBuilder? builder,
    final GoRouterPageBuilder? pageBuilder,
    final List<RouteBase> routes = const <RouteBase>[],
    final Future<String?> Function(GoRouterState)? redirect,
    final ExitCallback? onExit,
    final bool caseSensitive = true,
  }) {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: parentNavigatorKey,
      builder: builder,
      pageBuilder: pageBuilder,
      routes: routes,
      onExit: onExit,
      caseSensitive: caseSensitive,
      redirect: (context, state) async {
        await loadLibrary();

        if (redirect != null) {
          return await redirect(state);
        }

        return null;
      },
    );
  }
}
