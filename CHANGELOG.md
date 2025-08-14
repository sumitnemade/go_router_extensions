# Changelog

## [1.0.1] - 2024-03-19

### Changed
- Updated documentation and license for pub.dev publication
- Improved package metadata and descriptions

## [1.0.0] - 2024-03-19

### Added
- Initial release of go_router_deferred package
- `DeferredRoute` extension for lazy loading of regular routes with full parameter support
- `DeferredShellRoute` extension for lazy loading of shell routes with full parameter support
- `DeferredStatefulShellRoute` extension for lazy loading of stateful shell routes with full parameter support
- Comprehensive documentation and examples
- Full test coverage for all extensions
- Example application demonstrating all features

### Features
- Deferred loading of route-specific code
- Support for redirect logic in deferred routes
- Optional library loading for shell routes
- Type-safe extensions with full null safety
- Easy integration with existing go_router configurations
- Complete parameter support for all route types:
  - GoRoute: path, name, parentNavigatorKey, builder, pageBuilder, routes, redirect, onExit, caseSensitive
  - ShellRoute: parentNavigatorKey, builder, pageBuilder, routes, redirect, navigatorKey, observers, restorationScopeId
  - StatefulShellRoute: parentNavigatorKey, builder, pageBuilder, branches, redirect, restorationScopeId, key

### Documentation
- Comprehensive README with usage examples
- API documentation for all public methods
- Best practices and project structure recommendations
- Example application with real-world scenarios
- Proper deferred import pattern examples

### Technical Details
- Built with Flutter SDK >=3.10.0
- Compatible with go_router ^13.0.0
- Full null safety support
- Comprehensive test coverage
- Production-ready code quality
