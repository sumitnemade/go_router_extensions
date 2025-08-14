import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TabShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Navigation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
