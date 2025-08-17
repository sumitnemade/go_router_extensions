# go_router_deferred

[![Pub Version](https://img.shields.io/pub/v/go_router_deferred.svg)](https://pub.dev/packages/go_router_deferred)
[![Pub Points](https://img.shields.io/pub/points/go_router_deferred)](https://pub.dev/packages/go_router_deferred/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/go_router_deferred)](https://pub.dev/packages/go_router_deferred)
[![Pub Likes](https://img.shields.io/pub/likes/go_router_deferred)](https://pub.dev/packages/go_router_deferred)
[![License](https://img.shields.io/github/license/sumitnemade/go_router_extensions.svg)](https://github.com/sumitnemade/go_router_extensions/blob/master/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/sumitnemade/go_router_extensions.svg)](https://github.com/sumitnemade/go_router_extensions)
[![GitHub Forks](https://img.shields.io/github/forks/sumitnemade/go_router_extensions.svg)](https://github.com/sumitnemade/go_router_extensions)
[![GitHub Issues](https://img.shields.io/github/issues/sumitnemade/go_router_extensions.svg)](https://github.com/sumitnemade/go_router_extensions/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/sumitnemade/go_router_extensions.svg)](https://github.com/sumitnemade/go_router_extensions/pulls)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/sumitnemade/go_router_extensions/dart.yml?branch=master)](https://github.com/sumitnemade/go_router_extensions/actions/workflows/dart.yml)
[![Code Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)](https://github.com/sumitnemade/go_router_extensions)
[![Flutter Version](https://img.shields.io/badge/flutter-3.35.1+-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/dart-3.9.0+-blue.svg)](https://dart.dev)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-lightgrey.svg)](https://flutter.dev/multi-platform)

A Flutter package that provides extensions for [go_router](https://pub.dev/packages/go_router) to support deferred loading and lazy initialization of routes.

## Features

- **Deferred Route Loading**: Load routes lazily to improve initial app startup time
- **Shell Route Support**: Deferred loading for shell routes
- **Stateful Shell Route Support**: Deferred loading for stateful shell routes
- **Type Safety**: Full type safety with Dart's null safety
- **Easy Integration**: Simple setup with existing go_router configurations

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  go_router_deferred: ^1.0.1
  go_router: ^16.1.0
```

## Usage

### Basic Deferred Route

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deferred/go_router_deferred.dart';

// Import with deferred loading
import 'screens/settings_screen.dart' deferred as settings_screen;

final router = GoRouter(
  routes: [
    DeferredRoute.setup(
      path: '/settings',
      loadLibrary: settings_screen.loadLibrary,
      builder: (context, state) => settings_screen.SettingsScreen(),
    ),
  ],
);
```

### Deferred Shell Route

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deferred/go_router_deferred.dart';

// Import with deferred loading
import 'shell/app_shell.dart' deferred as app_shell;
import 'screens/home_screen.dart' deferred as home_screen;
import 'screens/profile_screen.dart' deferred as profile_screen;

final router = GoRouter(
  routes: [
    DeferredShellRoute.setup(
      parentNavigatorKey: _shellNavigatorKey,
      loadLibrary: app_shell.loadLibrary,
      builder: (context, state, child) => app_shell.AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home', 
          builder: (context, state) => home_screen.HomeScreen()
        ),
        GoRoute(
          path: '/profile', 
          builder: (context, state) => profile_screen.ProfileScreen()
        ),
      ],
    ),
  ],
);
```

### Deferred Stateful Shell Route

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deferred/go_router_deferred.dart';

// Import with deferred loading
import 'shell/app_shell.dart' deferred as app_shell;
import 'screens/home_screen.dart' deferred as home_screen;
import 'screens/profile_screen.dart' deferred as profile_screen;

final router = GoRouter(
  routes: [
    DeferredStatefulShellRoute.setup(
      parentNavigatorKey: _shellNavigatorKey,
      loadLibrary: app_shell.loadLibrary,
      builder: (context, state, navigationShell) => app_shell.AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home', 
              builder: (context, state) => home_screen.HomeScreen()
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile', 
              builder: (context, state) => profile_screen.ProfileScreen()
            ),
          ],
        ),
      ],
    ),
  ],
);
```

## Advanced Usage

### With Redirect Logic

```dart
import 'screens/admin_screen.dart' deferred as admin_screen;

DeferredRoute.setup(
  path: '/admin',
  loadLibrary: admin_screen.loadLibrary,
  builder: (context, state) => admin_screen.AdminScreen(),
  redirect: (state) async {
    // Check if user has admin access
    if (!await AuthService.isAdmin()) {
      return '/unauthorized';
    }
    return null;
  },
);
```

### With Custom Page Builder

```dart
import 'screens/modal_screen.dart' deferred as modal_screen;

DeferredRoute.setup(
  path: '/modal',
  loadLibrary: modal_screen.loadLibrary,
  pageBuilder: (context, state) => MaterialPage(
    child: modal_screen.ModalScreen(),
    fullscreenDialog: true,
  ),
);
```

## Quality & Testing

- **100% Code Coverage**: Comprehensive test suite with 60+ test cases
- **CI/CD Pipeline**: Automated testing and quality checks via GitHub Actions
- **Type Safety**: Full null safety and type checking
- **Documentation**: Complete API documentation and examples
- **Cross-Platform**: Supports all Flutter platforms

## Benefits

1. **Faster Startup**: Routes are loaded only when needed
2. **Reduced Memory Usage**: Unused route code is not loaded into memory
3. **Better Performance**: Smaller initial bundle size
4. **Modular Architecture**: Easier to organize code into feature modules

## Best Practices

1. **Use Deferred Imports**: Always use `import 'file.dart' deferred as alias;` pattern
2. **Group Related Routes**: Use deferred loading for feature modules
3. **Minimize Dependencies**: Keep deferred imports minimal
4. **Error Handling**: Handle import failures gracefully
5. **Testing**: Test deferred routes thoroughly

## Example Project Structure

```
lib/
├── main.dart
├── router/
│   └── app_router.dart
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── home_module.dart
│   ├── settings/
│   │   ├── settings_screen.dart
│   │   └── settings_module.dart
│   └── admin/
│       ├── admin_screen.dart
│       └── admin_module.dart
└── shell/
    └── app_shell.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
