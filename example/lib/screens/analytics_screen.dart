import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          const Text(
            'This is the analytics screen loaded with deferred shell routing.',
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const _AnalyticsItem(
                    label: 'Page Views',
                    value: '12,345',
                    trend: '+15%',
                    isPositive: true,
                  ),
                  const SizedBox(height: 12),
                  const _AnalyticsItem(
                    label: 'Unique Visitors',
                    value: '8,901',
                    trend: '+8%',
                    isPositive: true,
                  ),
                  const SizedBox(height: 12),
                  const _AnalyticsItem(
                    label: 'Bounce Rate',
                    value: '23%',
                    trend: '-5%',
                    isPositive: true,
                  ),
                  const SizedBox(height: 12),
                  const _AnalyticsItem(
                    label: 'Conversion Rate',
                    value: '2.4%',
                    trend: '-1%',
                    isPositive: false,
                  ),
                ],
              ),
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

class _AnalyticsItem extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final bool isPositive;

  const _AnalyticsItem({
    required this.label,
    required this.value,
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                trend,
                style: TextStyle(
                  color:
                      isPositive ? Colors.green.shade800 : Colors.red.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
