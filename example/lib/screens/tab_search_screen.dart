import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabSearchScreen extends StatefulWidget {
  const TabSearchScreen({super.key});

  @override
  State<TabSearchScreen> createState() => _TabSearchScreenState();
}

class _TabSearchScreenState extends State<TabSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Simulate some search results
    _searchResults.addAll([
      'Flutter Development',
      'Go Router Tutorial',
      'Deferred Loading',
      'Stateful Shell Routes',
      'Navigation Patterns',
    ]);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          const Text(
            'This is the search tab loaded with deferred stateful shell routing.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search for topics...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                // Simulate search functionality
              });
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Popular Topics:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.topic),
                    title: Text(_searchResults[index]),
                    subtitle:
                        Text('Tap to search for "${_searchResults[index]}"'),
                    onTap: () {
                      _searchController.text = _searchResults[index];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Searching for: ${_searchResults[index]}'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
