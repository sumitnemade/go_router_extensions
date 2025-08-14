# go_router_extensions

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
  go_router_extensions: ^1.0.0
  go_router: ^13.0.0
```

## Usage

### Basic Deferred Route

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_extensions/go_router_extensions.dart';

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
import 'package:go_router_extensions/go_router_extensions.dart';

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
import 'package:go_router_extensions/go_router_extensions.dart';

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
